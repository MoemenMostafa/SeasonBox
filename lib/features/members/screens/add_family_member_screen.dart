import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/models/family_member.dart';
import '../../../data/repositories/family_member_repository.dart';
import '../../../features/auth/data/auth_service.dart';
import 'package:uuid/uuid.dart';
import '../../../widgets/season_box_app_bar.dart';
import '../../../widgets/app_card.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  final FamilyMember? member;

  const AddFamilyMemberScreen({super.key, this.member});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  String _gender = 'Unisex';
  DateTime _birthdate = DateTime.now();

  // Sizes
  double? _clothesSize;
  double? _shoeSize;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      _nameController.text = widget.member!.name;
      _notesController.text = widget.member!.notes ?? '';
      _gender = widget.member!.gender;
      _birthdate = widget.member!.birthdate;
      _clothesSize = widget.member!.clothingSize;
      _shoeSize = widget.member!.shoeSize;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      final member = FamilyMember(
        id: widget.member?.id ?? const Uuid().v4(),
        familyId: familyId,
        name: _nameController.text.trim(),
        birthdate: _birthdate,
        gender: _gender,
        clothingSize: _clothesSize,
        shoeSize: _shoeSize,
        notes: _notesController.text.trim(),
      );

      if (!mounted) return;
      if (widget.member != null) {
        await context.read<FamilyMemberRepository>().updateFamilyMember(member);
      } else {
        await context.read<FamilyMemberRepository>().addFamilyMember(member);
      }

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.member != null
                  ? 'Family member updated successfully'
                  : 'Family member added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving member: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteMember() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Member'),
        content: const Text(
            'Are you sure you want to delete this family member? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final familyId =
          await context.read<AuthService>().getCurrentUserFamilyId();
      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      if (!mounted) return;
      await context
          .read<FamilyMemberRepository>()
          .deleteFamilyMember(familyId, widget.member!.id);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Family member deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting member: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthdate) {
      setState(() {
        _birthdate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: SeasonBoxAppBar(
        title:
            widget.member != null ? 'Edit Family Member' : 'Add Family Member',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
                    const Text('Basic Information',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Child\'s Name',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter full name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Gender', style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          _buildGenderSelector(theme),
                          const SizedBox(height: 16),
                          const Text('Birth Date',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                hintText: 'mm/dd/yyyy',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                "${_birthdate.toLocal()}".split(' ')[0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Current Sizes Section
                    const Text('Current Sizes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Clothing Size',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: _clothesSize?.toString(),
                            decoration: const InputDecoration(
                              hintText: 'e.g. 110 (cm) or 5 (age)',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _clothesSize = double.tryParse(value);
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Shoe Size',
                              style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: _shoeSize?.toString(),
                            decoration: const InputDecoration(
                              hintText: 'e.g. 28',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _shoeSize = double.tryParse(value);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Additional Notes Section
                    const Text('Additional Notes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          hintText:
                              'Any special notes about this child\'s preferences, etc.',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade700),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6366F1),
                                  Color(0xFF8B5CF6)
                                ], // Indigo to Violet
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6366F1)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _saveMember,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                widget.member != null ? 'Update' : 'Add',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.member != null) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: _deleteMember,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete Member',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildGenderSelector(ThemeData theme) {
    return Row(
      children: ['Boy', 'Girl', 'Unisex'].map((gender) {
        final isSelected = _gender == gender;
        IconData icon;
        if (gender == 'Boy') {
          icon = Icons.male;
        } else if (gender == 'Girl') {
          icon = Icons.female;
        } else {
          icon = Icons.transgender;
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _gender = gender),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey.shade700,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon,
                        size: 18,
                        color:
                            isSelected ? Colors.white : Colors.grey.shade400),
                    const SizedBox(width: 8),
                    Text(
                      gender,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
