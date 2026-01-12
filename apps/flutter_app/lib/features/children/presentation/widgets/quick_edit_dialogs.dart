import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/child.dart';
import '../../../../core/api/children_api.dart';

/// Quick edit dialog for Basic Information
class QuickEditBasicInfoDialog extends ConsumerStatefulWidget {
  final Child child;

  const QuickEditBasicInfoDialog({super.key, required this.child});

  @override
  ConsumerState<QuickEditBasicInfoDialog> createState() =>
      _QuickEditBasicInfoDialogState();
}

class _QuickEditBasicInfoDialogState
    extends ConsumerState<QuickEditBasicInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nicknameController;
  late TextEditingController _raceEthnicityController;
  late TextEditingController _preferredLanguageController;
  DateTime? _dateOfBirth;
  String? _gender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.child.firstName);
    _middleNameController =
        TextEditingController(text: widget.child.middleName ?? '');
    _lastNameController = TextEditingController(text: widget.child.lastName);
    _nicknameController =
        TextEditingController(text: widget.child.nickname ?? '');
    _raceEthnicityController =
        TextEditingController(text: widget.child.raceEthnicity ?? '');
    _preferredLanguageController =
        TextEditingController(text: widget.child.preferredLanguage ?? '');
    _dateOfBirth = widget.child.dateOfBirth;
    _gender = widget.child.gender;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _raceEthnicityController.dispose();
    _preferredLanguageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updateData = <String, dynamic>{
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
      };

      if (_middleNameController.text.trim().isNotEmpty) {
        updateData['middleName'] = _middleNameController.text.trim();
      }
      if (_nicknameController.text.trim().isNotEmpty) {
        updateData['nickname'] = _nicknameController.text.trim();
      }
      if (_dateOfBirth != null) {
        updateData['dateOfBirth'] = _dateOfBirth!.toIso8601String();
      }
      if (_gender != null) {
        updateData['gender'] = _gender;
      }
      if (_raceEthnicityController.text.trim().isNotEmpty) {
        updateData['raceEthnicity'] = _raceEthnicityController.text.trim();
      }
      if (_preferredLanguageController.text.trim().isNotEmpty) {
        updateData['preferredLanguage'] =
            _preferredLanguageController.text.trim();
      }

      final api = ref.read(childrenApiProvider);
      await api.updateChild(widget.child.id, updateData);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Basic information updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Basic Information'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _middleNameController,
                decoration: const InputDecoration(
                  labelText: 'Middle Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

/// Quick edit dialog for Medical Information
class QuickEditMedicalDialog extends ConsumerStatefulWidget {
  final Child child;

  const QuickEditMedicalDialog({super.key, required this.child});

  @override
  ConsumerState<QuickEditMedicalDialog> createState() =>
      _QuickEditMedicalDialogState();
}

class _QuickEditMedicalDialogState
    extends ConsumerState<QuickEditMedicalDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _medicationsController;
  late TextEditingController _allergiesController;
  late TextEditingController _medicalConditionsController;
  late TextEditingController _mentalHealthDxController;
  late TextEditingController _medicaidIdController;
  late TextEditingController _ssnController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _medicationsController =
        TextEditingController(text: _joinList(widget.child.medications));
    _allergiesController =
        TextEditingController(text: _joinList(widget.child.allergies));
    _medicalConditionsController =
        TextEditingController(text: _joinList(widget.child.medicalConditions));
    _mentalHealthDxController =
        TextEditingController(text: _joinList(widget.child.mentalHealthDx));
    _medicaidIdController =
        TextEditingController(text: widget.child.medicaidId ?? '');
    _ssnController = TextEditingController(text: widget.child.ssn ?? '');
  }

  @override
  void dispose() {
    _medicationsController.dispose();
    _allergiesController.dispose();
    _medicalConditionsController.dispose();
    _mentalHealthDxController.dispose();
    _medicaidIdController.dispose();
    _ssnController.dispose();
    super.dispose();
  }

  String _joinList(List<dynamic>? list) {
    if (list == null || list.isEmpty) return '';
    return list.map((e) => e.toString()).join(', ');
  }

  List<String> _splitList(String text) {
    if (text.trim().isEmpty) return [];
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updateData = <String, dynamic>{
        'medications': _splitList(_medicationsController.text),
        'allergies': _splitList(_allergiesController.text),
        'medicalConditions': _splitList(_medicalConditionsController.text),
        'mentalHealthDx': _splitList(_mentalHealthDxController.text),
      };

      if (_medicaidIdController.text.trim().isNotEmpty) {
        updateData['medicaidId'] = _medicaidIdController.text.trim();
      }
      if (_ssnController.text.trim().isNotEmpty) {
        updateData['ssn'] = _ssnController.text.trim();
      }

      final api = ref.read(childrenApiProvider);
      await api.updateChild(widget.child.id, updateData);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medical information updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Medical Information'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter items separated by commas',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _medicationsController,
                decoration: const InputDecoration(
                  labelText: 'Medications',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Aspirin, Ibuprofen',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(
                  labelText: 'Allergies',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Peanuts, Penicillin',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _medicalConditionsController,
                decoration: const InputDecoration(
                  labelText: 'Medical Conditions',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Asthma, Diabetes',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}

/// Quick edit dialog for Behavioral & Personal Information
class QuickEditBehavioralDialog extends ConsumerStatefulWidget {
  final Child child;

  const QuickEditBehavioralDialog({super.key, required this.child});

  @override
  ConsumerState<QuickEditBehavioralDialog> createState() =>
      _QuickEditBehavioralDialogState();
}

class _QuickEditBehavioralDialogState
    extends ConsumerState<QuickEditBehavioralDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _traumaHistoryController;
  late TextEditingController _attachmentStyleController;
  late TextEditingController _triggersController;
  late TextEditingController _copingMechanismsController;
  late TextEditingController _interestsController;
  late TextEditingController _strengthsController;
  late TextEditingController _likesController;
  late TextEditingController _dislikesController;
  late TextEditingController _fearsController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _traumaHistoryController =
        TextEditingController(text: widget.child.traumaHistory ?? '');
    _attachmentStyleController =
        TextEditingController(text: widget.child.attachmentStyle ?? '');
    _triggersController =
        TextEditingController(text: _joinList(widget.child.triggers));
    _copingMechanismsController =
        TextEditingController(text: _joinList(widget.child.copingMechanisms));
    _interestsController =
        TextEditingController(text: _joinList(widget.child.interests));
    _strengthsController =
        TextEditingController(text: _joinList(widget.child.strengths));
    _likesController =
        TextEditingController(text: _joinList(widget.child.likes));
    _dislikesController =
        TextEditingController(text: _joinList(widget.child.dislikes));
    _fearsController =
        TextEditingController(text: _joinList(widget.child.fears));
  }

  @override
  void dispose() {
    _traumaHistoryController.dispose();
    _attachmentStyleController.dispose();
    _triggersController.dispose();
    _copingMechanismsController.dispose();
    _interestsController.dispose();
    _strengthsController.dispose();
    _likesController.dispose();
    _dislikesController.dispose();
    _fearsController.dispose();
    super.dispose();
  }

  String _joinList(List<dynamic>? list) {
    if (list == null || list.isEmpty) return '';
    return list.map((e) => e.toString()).join(', ');
  }

  List<String> _splitList(String text) {
    if (text.trim().isEmpty) return [];
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updateData = <String, dynamic>{
        'triggers': _splitList(_triggersController.text),
        'copingMechanisms': _splitList(_copingMechanismsController.text),
        'interests': _splitList(_interestsController.text),
        'strengths': _splitList(_strengthsController.text),
        'likes': _splitList(_likesController.text),
        'dislikes': _splitList(_dislikesController.text),
        'fears': _splitList(_fearsController.text),
      };

      if (_traumaHistoryController.text.trim().isNotEmpty) {
        updateData['traumaHistory'] = _traumaHistoryController.text.trim();
      }
      if (_attachmentStyleController.text.trim().isNotEmpty) {
        updateData['attachmentStyle'] = _attachmentStyleController.text.trim();
      }

      final api = ref.read(childrenApiProvider);
      await api.updateChild(widget.child.id, updateData);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Behavioral information updated!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Behavioral & Personal Info'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _traumaHistoryController,
                decoration: const InputDecoration(
                  labelText: 'Trauma History',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _attachmentStyleController,
                decoration: const InputDecoration(
                  labelText: 'Attachment Style',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter items separated by commas',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _triggersController,
                decoration: const InputDecoration(
                  labelText: 'Triggers',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
