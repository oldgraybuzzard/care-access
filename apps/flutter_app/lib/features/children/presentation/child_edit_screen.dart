import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/children_api.dart';
import '../../../core/models/child.dart';

class ChildEditScreen extends ConsumerStatefulWidget {
  final Child child;

  const ChildEditScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ChildEditScreen> createState() => _ChildEditScreenState();
}

class _ChildEditScreenState extends ConsumerState<ChildEditScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers for all fields
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nicknameController;
  late TextEditingController _raceEthnicityController;
  late TextEditingController _preferredLanguageController;
  late TextEditingController _referralSourceController;
  late TextEditingController _referralReasonController;
  late TextEditingController _presentingIssuesController;
  late TextEditingController _custodyStatusController;
  late TextEditingController _legalStatusController;
  late TextEditingController _ssnController;
  late TextEditingController _medicaidIdController;
  late TextEditingController _medicationsController;
  late TextEditingController _allergiesController;
  late TextEditingController _medicalConditionsController;
  late TextEditingController _mentalHealthDxController;
  late TextEditingController _traumaHistoryController;
  late TextEditingController _attachmentStyleController;
  late TextEditingController _triggersController;
  late TextEditingController _copingMechanismsController;
  late TextEditingController _interestsController;
  late TextEditingController _strengthsController;
  late TextEditingController _likesController;
  late TextEditingController _dislikesController;
  late TextEditingController _fearsController;

  DateTime? _dateOfBirth;
  String? _gender;
  String? _status;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final child = widget.child;

    _firstNameController = TextEditingController(text: child.firstName);
    _middleNameController = TextEditingController(text: child.middleName ?? '');
    _lastNameController = TextEditingController(text: child.lastName);
    _nicknameController = TextEditingController(text: child.nickname ?? '');
    _raceEthnicityController =
        TextEditingController(text: child.raceEthnicity ?? '');
    _preferredLanguageController =
        TextEditingController(text: child.preferredLanguage ?? '');
    _referralSourceController =
        TextEditingController(text: child.referralSource ?? '');
    _referralReasonController =
        TextEditingController(text: child.referralReason ?? '');
    _presentingIssuesController =
        TextEditingController(text: child.presentingIssues ?? '');
    _custodyStatusController =
        TextEditingController(text: child.custodyStatus ?? '');
    _legalStatusController =
        TextEditingController(text: child.legalStatus ?? '');
    _ssnController = TextEditingController(text: child.ssn ?? '');
    _medicaidIdController = TextEditingController(text: child.medicaidId ?? '');
    _medicationsController =
        TextEditingController(text: _joinList(child.medications));
    _allergiesController =
        TextEditingController(text: _joinList(child.allergies));
    _medicalConditionsController =
        TextEditingController(text: _joinList(child.medicalConditions));
    _mentalHealthDxController =
        TextEditingController(text: _joinList(child.mentalHealthDx));
    _traumaHistoryController =
        TextEditingController(text: child.traumaHistory ?? '');
    _attachmentStyleController =
        TextEditingController(text: child.attachmentStyle ?? '');
    _triggersController =
        TextEditingController(text: _joinList(child.triggers));
    _copingMechanismsController =
        TextEditingController(text: _joinList(child.copingMechanisms));
    _interestsController =
        TextEditingController(text: _joinList(child.interests));
    _strengthsController =
        TextEditingController(text: _joinList(child.strengths));
    _likesController = TextEditingController(text: _joinList(child.likes));
    _dislikesController =
        TextEditingController(text: _joinList(child.dislikes));
    _fearsController = TextEditingController(text: _joinList(child.fears));

    _dateOfBirth = child.dateOfBirth;
    _gender = child.gender;
    _status = child.status;
  }

  String _joinList(List<dynamic>? list) {
    if (list == null || list.isEmpty) return '';
    return list.map((e) => e.toString()).join(', ');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _raceEthnicityController.dispose();
    _preferredLanguageController.dispose();
    _referralSourceController.dispose();
    _referralReasonController.dispose();
    _presentingIssuesController.dispose();
    _custodyStatusController.dispose();
    _legalStatusController.dispose();
    _ssnController.dispose();
    _medicaidIdController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _medicalConditionsController.dispose();
    _mentalHealthDxController.dispose();
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

  List<String> _parseCommaSeparated(String text) {
    if (text.trim().isEmpty) return [];
    return text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final api = ref.read(childrenApiProvider);

      final data = {
        'firstName': _firstNameController.text.trim(),
        'middleName': _middleNameController.text.trim().isEmpty
            ? null
            : _middleNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'nickname': _nicknameController.text.trim().isEmpty
            ? null
            : _nicknameController.text.trim(),
        'dateOfBirth': _dateOfBirth?.toIso8601String(),
        'gender': _gender,
        'raceEthnicity': _raceEthnicityController.text.trim().isEmpty
            ? null
            : _raceEthnicityController.text.trim(),
        'preferredLanguage': _preferredLanguageController.text.trim().isEmpty
            ? null
            : _preferredLanguageController.text.trim(),

        // Referral Information
        'referralSource': _referralSourceController.text.trim().isEmpty
            ? null
            : _referralSourceController.text.trim(),
        'referralReason': _referralReasonController.text.trim().isEmpty
            ? null
            : _referralReasonController.text.trim(),
        'presentingIssues': _presentingIssuesController.text.trim().isEmpty
            ? null
            : _presentingIssuesController.text.trim(),

        // Status & Legal
        'status': _status,
        'custodyStatus': _custodyStatusController.text.trim().isEmpty
            ? null
            : _custodyStatusController.text.trim(),
        'legalStatus': _legalStatusController.text.trim().isEmpty
            ? null
            : _legalStatusController.text.trim(),
        'ssn': _ssnController.text.trim().isEmpty
            ? null
            : _ssnController.text.trim(),
        'medicaidId': _medicaidIdController.text.trim().isEmpty
            ? null
            : _medicaidIdController.text.trim(),

        // Medical Information
        'medications': _parseCommaSeparated(_medicationsController.text),
        'allergies': _parseCommaSeparated(_allergiesController.text),
        'medicalConditions':
            _parseCommaSeparated(_medicalConditionsController.text),
        'mentalHealthDiagnoses':
            _parseCommaSeparated(_mentalHealthDxController.text),

        // Behavioral & Trauma
        'traumaHistory': _traumaHistoryController.text.trim().isEmpty
            ? null
            : _traumaHistoryController.text.trim(),
        'attachmentStyle': _attachmentStyleController.text.trim().isEmpty
            ? null
            : _attachmentStyleController.text.trim(),
        'triggers': _parseCommaSeparated(_triggersController.text),
        'copingMechanisms':
            _parseCommaSeparated(_copingMechanismsController.text),

        // Personal Information
        'interests': _parseCommaSeparated(_interestsController.text),
        'strengths': _parseCommaSeparated(_strengthsController.text),
        'likes': _parseCommaSeparated(_likesController.text),
        'dislikes': _parseCommaSeparated(_dislikesController.text),
        'fears': _parseCommaSeparated(_fearsController.text),
      };

      await api.updateChild(widget.child.id, data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Child updated successfully')),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating child: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.child.firstName}'),
        actions: [
          if (_currentStep == 5 && !_isLoading)
            TextButton(
              onPressed: _submitUpdate,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 5) {
                    setState(() => _currentStep++);
                  } else {
                    _submitUpdate();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() => _currentStep--);
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == 5 ? 'Save' : 'Continue'),
                        ),
                        const SizedBox(width: 12),
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  _buildBasicInfoStep(),
                  _buildReferralInfoStep(),
                  _buildStatusLegalStep(),
                  _buildMedicalInfoStep(),
                  _buildBehavioralStep(),
                  _buildPersonalInfoStep(),
                ],
              ),
            ),
    );
  }

  Step _buildBasicInfoStep() {
    return Step(
      title: const Text('Basic Information'),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _middleNameController,
            decoration: const InputDecoration(
              labelText: 'Middle Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: 'Nickname',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dateOfBirth ??
                    DateTime.now().subtract(const Duration(days: 365 * 5)),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _dateOfBirth = picked);
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Date of Birth *',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                _dateOfBirth != null
                    ? '${_dateOfBirth!.month}/${_dateOfBirth!.day}/${_dateOfBirth!.year}'
                    : 'Select date',
                style: TextStyle(
                  color: _dateOfBirth != null ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _gender,
            decoration: const InputDecoration(
              labelText: 'Gender *',
              border: OutlineInputBorder(),
            ),
            items: ['Male', 'Female', 'Non-binary', 'Other']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ),)
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _gender = value);
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _raceEthnicityController,
            decoration: const InputDecoration(
              labelText: 'Race/Ethnicity',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _preferredLanguageController,
            decoration: const InputDecoration(
              labelText: 'Preferred Language',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Step _buildReferralInfoStep() {
    return Step(
      title: const Text('Referral Information'),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          TextFormField(
            controller: _referralSourceController,
            decoration: const InputDecoration(
              labelText: 'Referral Source',
              border: OutlineInputBorder(),
              hintText: 'e.g., School, Court, Family',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _referralReasonController,
            decoration: const InputDecoration(
              labelText: 'Referral Reason',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _presentingIssuesController,
            decoration: const InputDecoration(
              labelText: 'Presenting Issues',
              border: OutlineInputBorder(),
              hintText: 'Describe the main concerns or issues',
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Step _buildStatusLegalStep() {
    return Step(
      title: const Text('Status & Legal'),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: ['Active', 'Inactive', 'Discharged']
                .map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    ),)
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _status = value);
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _custodyStatusController,
            decoration: const InputDecoration(
              labelText: 'Custody Status',
              border: OutlineInputBorder(),
              hintText: 'e.g., Foster Care, Kinship Care',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _legalStatusController,
            decoration: const InputDecoration(
              labelText: 'Legal Status',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ssnController,
            decoration: const InputDecoration(
              labelText: 'SSN',
              border: OutlineInputBorder(),
              hintText: 'XXX-XX-XXXX',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _medicaidIdController,
            decoration: const InputDecoration(
              labelText: 'Medicaid ID',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Step _buildMedicalInfoStep() {
    return Step(
      title: const Text('Medical Information'),
      isActive: _currentStep >= 3,
      state: _currentStep > 3 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          const Text(
            'Enter items separated by commas',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _medicationsController,
            decoration: const InputDecoration(
              labelText: 'Medications',
              border: OutlineInputBorder(),
              hintText: 'e.g., Medication A, Medication B',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _allergiesController,
            decoration: const InputDecoration(
              labelText: 'Allergies',
              border: OutlineInputBorder(),
              hintText: 'e.g., Peanuts, Penicillin',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _medicalConditionsController,
            decoration: const InputDecoration(
              labelText: 'Medical Conditions',
              border: OutlineInputBorder(),
              hintText: 'e.g., Asthma, Diabetes',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _mentalHealthDxController,
            decoration: const InputDecoration(
              labelText: 'Mental Health Diagnoses',
              border: OutlineInputBorder(),
              hintText: 'e.g., ADHD, Anxiety',
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Step _buildBehavioralStep() {
    return Step(
      title: const Text('Behavioral & Trauma'),
      isActive: _currentStep >= 4,
      state: _currentStep > 4 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          TextFormField(
            controller: _traumaHistoryController,
            decoration: const InputDecoration(
              labelText: 'Trauma History',
              border: OutlineInputBorder(),
              hintText: 'Describe any known trauma history',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _attachmentStyleController,
            decoration: const InputDecoration(
              labelText: 'Attachment Style',
              border: OutlineInputBorder(),
              hintText: 'e.g., Secure, Anxious, Avoidant',
            ),
          ),
          const SizedBox(height: 16),
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
              hintText: 'e.g., Loud noises, Crowds',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _copingMechanismsController,
            decoration: const InputDecoration(
              labelText: 'Coping Mechanisms',
              border: OutlineInputBorder(),
              hintText: 'e.g., Deep breathing, Drawing',
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Step _buildPersonalInfoStep() {
    return Step(
      title: const Text('Personal Information'),
      isActive: _currentStep >= 5,
      state: _currentStep > 5 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          const Text(
            'Enter items separated by commas',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _interestsController,
            decoration: const InputDecoration(
              labelText: 'Interests',
              border: OutlineInputBorder(),
              hintText: 'e.g., Sports, Music, Art',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _strengthsController,
            decoration: const InputDecoration(
              labelText: 'Strengths',
              border: OutlineInputBorder(),
              hintText: 'e.g., Creative, Resilient, Kind',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _likesController,
            decoration: const InputDecoration(
              labelText: 'Likes',
              border: OutlineInputBorder(),
              hintText: 'e.g., Pizza, Dogs, Video games',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _dislikesController,
            decoration: const InputDecoration(
              labelText: 'Dislikes',
              border: OutlineInputBorder(),
              hintText: 'e.g., Vegetables, Homework',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _fearsController,
            decoration: const InputDecoration(
              labelText: 'Fears',
              border: OutlineInputBorder(),
              hintText: 'e.g., Dark, Heights, Spiders',
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
