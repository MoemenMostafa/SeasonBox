import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:seasonbox/core/enums/user_role.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:seasonbox/core/services/permission_service.dart';
import 'package:seasonbox/core/constants/size_constants.dart';
import 'package:seasonbox/app/providers/user_profile_provider.dart';
import 'package:seasonbox/core/enums/gender.dart';
import 'package:seasonbox/data/services/posthog_service.dart';

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
  final _inviteEmailController = TextEditingController();

  Gender _gender = Gender.unisex;
  String _role = 'member';
  DateTime _birthdate = DateTime.now();

  // Sizes
  String? _clothesSize;
  String? _shoeSize;

  String? _inviteStatus;
  bool _isLoading = false;
  bool _isDirty = false;
  List<FamilyMember> _allMembers = [];
  String? _currentUserId;
  String? _familyId;

  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.member != null) {
      _nameController.text = widget.member!.name;
      _notesController.text = widget.member!.notes ?? '';
      _gender = widget.member!.gender;
      _birthdate = widget.member!.birthdate;
      _clothesSize = widget.member!.clothingSize;
      _shoeSize = widget.member!.shoeSize;
      _clothingSizeController.text = _clothesSize ?? '';
      _shoeSizeController.text = _shoeSize ?? '';
      _inviteStatus = widget.member!.inviteStatus;
      _inviteEmailController.text = widget.member!.inviteEmail ?? '';
      _role = widget.member!.role;
    }

    _nameController.addListener(() => _isDirty = true);
    _notesController.addListener(() => _isDirty = true);
    _clothingSizeController.addListener(() => _isDirty = true);
    _shoeSizeController.addListener(() => _isDirty = true);
    _inviteEmailController.addListener(() => _isDirty = true);
  }

  Future<void> _loadData() async {
    try {
      final authService = context.read<AuthService>();
      final familyId = await authService.getCurrentUserFamilyId();
      final userId = authService.currentUser?.uid;

      if (familyId == null || userId == null) return;

      if (!mounted) return;
      final members = await context
          .read<FamilyMemberRepository>()
          .getFamilyMembers(familyId);

      if (mounted) {
        setState(() {
          _currentUserId = userId;
          _familyId = familyId;
          _allMembers = members;
        });
      }
    } catch (e) {
      // Silently handle error - permissions will default to restricted
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    _clothingSizeController.dispose();
    _shoeSizeController.dispose();
    _inviteEmailController.dispose();
    super.dispose();
  }

  Future<void> _saveMember({bool resendingInvite = false}) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;
      final authService = context.read<AuthService>();
      final familyId = await authService.getCurrentUserFamilyId();
      if (familyId == null) {
        throw Exception('User not authenticated');
      }

      final currentUser = authService.currentUser;
      final inviterName = currentUser?.displayName ?? 'Admin';

      final List<Map<String, dynamic>> updatedHistory =
          List<Map<String, dynamic>>.from(widget.member?.sizeHistory ?? []);

      if (widget.member == null) {
        // New member: add initial sizes to history if they exist
        if (_clothesSize != null) {
          updatedHistory.add({
            'date': Timestamp.now(),
            'size': _clothesSize,
            'category': 'clothes',
          });
        }
        if (_shoeSize != null) {
          updatedHistory.add({
            'date': Timestamp.now(),
            'size': _shoeSize,
            'category': 'shoes',
          });
        }
      } else {
        // Existing member: record a new history entry if size has changed
        if (_clothesSize != widget.member!.clothingSize &&
            _clothesSize != null) {
          updatedHistory.add({
            'date': Timestamp.now(),
            'size': _clothesSize,
            'category': 'clothes',
          });
        }
        if (_shoeSize != widget.member!.shoeSize && _shoeSize != null) {
          updatedHistory.add({
            'date': Timestamp.now(),
            'size': _shoeSize,
            'category': 'shoes',
          });
        }
      }

      final member = FamilyMember(
        id: widget.member?.id ?? const Uuid().v4(),
        familyId: familyId,
        name: _nameController.text.trim(),
        birthdate: _birthdate,
        gender: _gender,
        role: _role,
        clothingSize: _clothesSize,
        shoeSize: _shoeSize,
        sizeHistory: updatedHistory,
        notes: _notesController.text.trim(),
        inviteEmail: _inviteEmailController.text.trim().isNotEmpty
            ? _inviteEmailController.text.trim()
            : null,
        inviteStatus: _inviteStatus,
        lastInviteSent:
            resendingInvite ? DateTime.now() : widget.member?.lastInviteSent,
        inviterName: resendingInvite
            ? inviterName
            : (widget.member?.inviterName ??
                (_inviteStatus == 'pending' ? inviterName : null)),
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

  Future<void> _sendInvite() async {
    final email = _inviteEmailController.text.trim();
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.addMember_error_invalidEmail)),
      );
      return;
    }

    setState(() {
      _inviteStatus = 'pending';
    });

    await _saveMember(resendingInvite: true);
  }

  Future<void> _cancelInvite() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)!.addMember_dialog_cancelInvite_title),
        content: Text(AppLocalizations.of(context)!
            .addMember_dialog_cancelInvite_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
                AppLocalizations.of(context)!.addMember_button_cancelInvite),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _inviteStatus = null;
      _inviteEmailController.clear();
    });

    await _saveMember();
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

  Future<void> _shareInvite() async {
    final authService = context.read<AuthService>();
    final familyId = await authService.getCurrentUserFamilyId();
    if (familyId != null && mounted) {
      final message =
          AppLocalizations.of(context)!.addMember_share_message(familyId);
      await SharePlus.instance.share(ShareParams(text: message));
    }
  }

  Future<void> _copyInviteCode() async {
    final familyId = await context.read<AuthService>().getCurrentUserFamilyId();
    if (familyId != null && mounted) {
      await Clipboard.setData(ClipboardData(text: familyId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.addMember_snack_copied)),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdate,
      firstDate: DateTime(1900),
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
    final isMetric = context.watch<UserProfileProvider>().isMetric;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop && _isDirty && !_isLoading) {
          PostHogService.log('ui_abandonment', level: LogLevel.info, context: {
            'screen': 'AddFamilyMemberScreen',
            'name_length': _nameController.text.length,
            'has_email': _inviteEmailController.text.isNotEmpty,
          });
        }
      },
      child: Scaffold(
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
                          style: theme.textTheme.titleMedium),
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
                      Text(
                          AppLocalizations.of(context)!.addMember_section_sizes,
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSizeInputSection(
                              context: context,
                              label: AppLocalizations.of(context)!
                                  .addMember_field_clothingSize,
                              hintText: AppLocalizations.of(context)!
                                  .addMember_field_clothingSizeHint,
                              controller: _clothingSizeController,
                              sizes: isMetric
                                  ? SizeConstants.clothesSizesMetric
                                  : SizeConstants.clothesSizesImperial,
                              currentValue: _clothesSize,
                              onChanged: (val) {
                                setState(() {
                                  _clothesSize = val;
                                  _clothingSizeController.text = val ?? '';
                                });
                              },
                              isMetric: isMetric,
                              unit: isMetric ? 'cm (EU)' : 'US',
                            ),
                            const SizedBox(height: 24),
                            _buildSizeInputSection(
                              context: context,
                              label: AppLocalizations.of(context)!
                                  .addMember_field_shoeSize,
                              hintText: AppLocalizations.of(context)!
                                  .addMember_field_shoeSizeHint,
                              controller: _shoeSizeController,
                              sizes: isMetric
                                  ? SizeConstants.shoeSizesMetric
                                  : SizeConstants.shoeSizesImperial,
                              currentValue: _shoeSize,
                              onChanged: (val) {
                                setState(() {
                                  _shoeSize = val;
                                  _shoeSizeController.text = val ?? '';
                                });
                              },
                              isMetric: isMetric,
                              unit: isMetric ? 'EU' : 'US',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Additional Notes Section
                      Text(
                          AppLocalizations.of(context)!.addMember_section_notes,
                          style: theme.textTheme.titleMedium),
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

                      const SizedBox(height: 24),

                      // Account Access Section
                      Text(
                          AppLocalizations.of(context)!
                              .addMember_section_accountAccess,
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!
                            .addMember_invite_description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildAccountAccessSection(theme),
                      const SizedBox(height: 32),

                      // Action Buttons
                      ActionButtons(
                        primaryLabel: widget.member != null
                            ? AppLocalizations.of(context)!
                                .addMember_button_update
                            : AppLocalizations.of(context)!
                                .addMember_button_add,
                        secondaryLabel:
                            AppLocalizations.of(context)!.common_cancel,
                        onPrimaryPressed: _saveMember,
                        onSecondaryPressed: () => context.pop(),
                        isLoading: _isLoading,
                      ),
                      if (widget.member != null &&
                          PermissionService.canDeleteMember(
                            _currentUserId,
                            widget.member!,
                            _familyId,
                            _allMembers,
                          )) ...[
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
      ),
    );
  }

  Widget _buildGenderSelector(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: Gender.values.map((gender) {
        final isSelected = _gender == gender;
        IconData icon;
        String label;

        switch (gender) {
          case Gender.male:
            icon = Icons.male;
            label = l10n.gender_male;
            break;
          case Gender.female:
            icon = Icons.female;
            label = l10n.gender_female;
            break;
          case Gender.unisex:
            icon = Icons.transgender;
            label = l10n.gender_unisex;
            break;
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
                      label,
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

  Widget _buildAccountAccessSection(ThemeData theme) {
    if (_inviteStatus == 'accepted') {
      return AppCard(
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.addMember_status_accountLinked(
                    _inviteEmailController.text),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else if (_inviteStatus == 'pending') {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mark_email_read, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.addMember_status_inviteSent(
                        _inviteEmailController.text),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.addMember_field_inviteEmail,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _inviteEmailController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!
                    .addMember_field_inviteEmailHint,
                prefixIcon: const Icon(Icons.edit),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _sendInvite,
                child: Text(AppLocalizations.of(context)!
                    .addMember_button_resendInvite),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _shareInvite,
                    icon: const Icon(Icons.share, size: 18),
                    label: Text(
                        AppLocalizations.of(context)!.addMember_action_share),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copyInviteCode,
                    icon: const Icon(Icons.copy, size: 18),
                    label: Text(
                        AppLocalizations.of(context)!.addMember_action_copy),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _cancelInvite,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(AppLocalizations.of(context)!
                    .addMember_button_cancelInvite),
              ),
            ),
            const SizedBox(height: 16),
            _buildRoleSelector(),
          ],
        ),
      );
    } else {
      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.addMember_field_inviteEmail,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _inviteEmailController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!
                    .addMember_field_inviteEmailHint,
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildRoleSelector(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendInvite,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                ),
                child: Text(
                    AppLocalizations.of(context)!.addMember_button_sendInvite),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.addMember_field_role,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: _role,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.security),
          ),
          items: UserRole.values.map((role) {
            return DropdownMenuItem(
              value: role.toShortString(),
              child: Text(role.getLocalizedName(context)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null &&
                PermissionService.canChangeRole(
                  _currentUserId,
                  _familyId,
                  _allMembers,
                )) {
              setState(() {
                _role = value;
              });
            }
          },
          disabledHint: Text(
            UserRole.fromString(_role).getLocalizedName(context),
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeInputSection({
    required BuildContext context,
    required String label,
    required String hintText,
    required TextEditingController controller,
    required List<String> sizes,
    required String? currentValue,
    required ValueChanged<String?> onChanged,
    required bool isMetric,
    required String unit,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text(unit,
                style: TextStyle(
                    fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        if (sizes.isNotEmpty) ...[
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 8,
              children: sizes.map((size) {
                final isSelected = size == currentValue;
                return ChoiceChip(
                  label: Text(size, style: const TextStyle(fontSize: 12)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onChanged(size);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            suffixText: unit,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            onChanged(value.trim().isEmpty ? null : value.trim());
          },
        ),
      ],
    );
  }
}
