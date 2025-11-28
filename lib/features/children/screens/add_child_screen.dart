import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/child.dart';
import '../../../data/repositories/child_repository.dart';
import '../../../widgets/season_box_app_bar.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
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
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveChild() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Get actual family ID from auth/user context
      const familyId = 'test-family-id';
      final id = const Uuid().v4();

      final child = Child(
        id: id,
        familyId: familyId,
        name: _nameController.text.trim(),
        birthdate: _birthdate,
        gender: _gender,
        currentSizeByCategory: {
          if (_clothesSize != null) 'clothes': _clothesSize!,
          if (_shoeSize != null) 'shoes': _shoeSize!,
        },
        sizeHistory: [], // Initial empty history
      );

      await context.read<ChildRepository>().addChild(child);

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Child added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding child: $e')),
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const SeasonBoxAppBar(
        title: 'Add Child',
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
                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Child Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Gender
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Boy', 'Girl', 'Unisex']
                          .map((label) => DropdownMenuItem(
                                value: label,
                                child: Text(label),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Birthdate
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Birthdate',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          "${_birthdate.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text('Current Sizes',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    // Clothing Size
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Clothing Size',
                        border: OutlineInputBorder(),
                        helperText: 'e.g. 110 (cm) or 5 (age)',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _clothesSize = double.tryParse(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Shoe Size
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Shoe Size',
                        border: OutlineInputBorder(),
                        helperText: 'e.g. 28',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _shoeSize = double.tryParse(value);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveChild,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Add Child'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
