import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:uuid/uuid.dart';
import 'package:seasonbox/widgets/app_card.dart';
import 'package:seasonbox/widgets/season_box_app_bar.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:seasonbox/widgets/action_buttons.dart';

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
  final _clothingSizeController = TextEditingController();
  final _shoeSizeController = TextEditingController();

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
      _clothingSizeController.text = _clothesSize?.toString() ?? '';
      _shoeSizeController.text = _shoeSize?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _clothingSizeController.dispose();
    _shoeSizeController.dispose();
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
                  ? AppLocalizations.of(context)!.addMember_success_updated
                  : AppLocalizations.of(context)!.addMember_success_added)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .addMember_error_saving(e.toString()))),
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
        title:
            Text(AppLocalizations.of(context)!.addMember_dialog_delete_title),
        content:
            Text(AppLocalizations.of(context)!.addMember_dialog_delete_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.common_delete),
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
          SnackBar(
              content: Text(
                  AppLocalizations.of(context)!.addMember_success_deleted)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!
                  .addMember_error_deleting(e.toString()))),
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
        title: widget.member != null
            ? AppLocalizations.of(context)!.addMember_title_edit
            : AppLocalizations.of(context)!.addMember_title_add,
        actions: widget.member != null
            ? [
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  onPressed: () {},
                ),
              ]
            : null,
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
                    Text(
                        AppLocalizations.of(context)!
                            .addMember_section_basicInfo,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .addMember_field_name,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .addMember_field_nameHint,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .addMember_validation_nameRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                              AppLocalizations.of(context)!
                                  .addMember_field_gender,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          _buildGenderSelector(theme),
                          const SizedBox(height: 16),
                          Text(
                              AppLocalizations.of(context)!
                                  .addMember_field_birthdate,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .addMember_field_birthdateHint,
                                suffixIcon: const Icon(Icons.calendar_today),
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
                    Text(AppLocalizations.of(context)!.addMember_section_sizes,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              AppLocalizations.of(context)!
                                  .addMember_field_clothingSize,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _clothingSizeController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .addMember_field_clothingSizeHint,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _clothesSize = double.tryParse(value);
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                              AppLocalizations.of(context)!
                                  .addMember_field_shoeSize,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _shoeSizeController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .addMember_field_shoeSizeHint,
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
                    Text(AppLocalizations.of(context)!.addMember_section_notes,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AppCard(
                      child: TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .addMember_field_notesHint,
                          alignLabelWithHint: true,
                        ),
                        maxLines: 4,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    ActionButtons(
                      primaryLabel: widget.member != null
                          ? AppLocalizations.of(context)!
                              .addMember_button_update
                          : AppLocalizations.of(context)!.addMember_button_add,
                      secondaryLabel:
                          AppLocalizations.of(context)!.common_cancel,
                      onPrimaryPressed: _saveMember,
                      onSecondaryPressed: () => context.pop(),
                      isLoading: _isLoading,
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
                          child: Text(
                            AppLocalizations.of(context)!
                                .addMember_button_deleteMember,
                            style: const TextStyle(
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
