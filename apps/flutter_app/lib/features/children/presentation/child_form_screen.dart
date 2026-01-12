import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/child.dart';
import '../../../core/api/children_api.dart';

class ChildFormScreen extends ConsumerStatefulWidget {
  final String? childId; // null for create, non-null for edit

  const ChildFormScreen({
    super.key,
    this.childId,
  });

  @override
  ConsumerState<ChildFormScreen> createState() => _ChildFormScreenState();
}

class _ChildFormScreenState extends ConsumerState<ChildFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Child? _existingChild;

  // Form controllers
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  DateTime? _dateOfBirth;
  String _gender = 'Male';
  final _raceEthnicityController = TextEditingController();
  final _preferredLanguageController = TextEditingController();
  String _status = 'Active';
  final _custodyStatusController = TextEditingController();
  final _legalStatusController = TextEditingController();
  final _referralSourceController = TextEditingController();
  final _referralReasonController = TextEditingController();
  final _presentingIssuesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.childId != null) {
      _loadChild();
    }
  }

  Future<void> _loadChild() async {
    setState(() => _isLoading = true);
    try {
      final api = ref.read(childrenApiProvider);
      final child = await api.getChild(widget.childId!);
      setState(() {
        _existingChild = child;
        _populateForm(child);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading child: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateForm(Child child) {
    _firstNameController.text = child.firstName;
    _middleNameController.text = child.middleName ?? '';
    _lastNameController.text = child.lastName;
    _nicknameController.text = child.nickname ?? '';
    _dateOfBirth = child.dateOfBirth;
    _gender = child.gender;
    _raceEthnicityController.text = child.raceEthnicity ?? '';
    _preferredLanguageController.text = child.preferredLanguage ?? '';
    _status = child.status ?? 'Active';
    _custodyStatusController.text = child.custodyStatus ?? '';
    _legalStatusController.text = child.legalStatus ?? '';
    _referralSourceController.text = child.referralSource ?? '';
    _referralReasonController.text = child.referralReason ?? '';
    _presentingIssuesController.text = child.presentingIssues ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _raceEthnicityController.dispose();
    _preferredLanguageController.dispose();
    _custodyStatusController.dispose();
    _legalStatusController.dispose();
    _referralSourceController.dispose();
    _referralReasonController.dispose();
    _presentingIssuesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
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
  }

  Future<void> _saveChild() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date of birth')),
      );
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
        'dateOfBirth': _dateOfBirth!.toIso8601String(),
        'gender': _gender,
        'raceEthnicity': _raceEthnicityController.text.trim().isEmpty
            ? null
            : _raceEthnicityController.text.trim(),
        'preferredLanguage': _preferredLanguageController.text.trim().isEmpty
            ? null
            : _preferredLanguageController.text.trim(),
        'status': _status,
        'custodyStatus': _custodyStatusController.text.trim().isEmpty
            ? null
            : _custodyStatusController.text.trim(),
        'legalStatus': _legalStatusController.text.trim().isEmpty
            ? null
            : _legalStatusController.text.trim(),
        'referralSource': _referralSourceController.text.trim().isEmpty
            ? null
            : _referralSourceController.text.trim(),
        'referralReason': _referralReasonController.text.trim().isEmpty
            ? null
            : _referralReasonController.text.trim(),
        'presentingIssues': _presentingIssuesController.text.trim().isEmpty
            ? null
            : _presentingIssuesController.text.trim(),
      };

      if (widget.childId != null) {
        // Update existing child
        await api.updateChild(widget.childId!, data);
      } else {
        // Create new child
        await api.createChild(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(widget.childId != null
                  ? 'Child updated successfully'
                  : 'Child created successfully',),),
        );
        context.pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error saving child: $e'),
              backgroundColor: Colors.red,),
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
        title: Text(widget.childId != null ? 'Edit Child' : 'Add New Child'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _saveChild,
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Basic Information Section
                  _buildSectionHeader('Basic Information'),
                  const SizedBox(height: 16),

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

                  // Date of Birth
                  InkWell(
                    onTap: _selectDate,
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
                          color:
                              _dateOfBirth != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gender
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
                  const SizedBox(height: 24),

                  // Status Information Section
                  _buildSectionHeader('Status Information'),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 24),

                  // Referral Information Section
                  _buildSectionHeader('Referral Information'),
                  const SizedBox(height: 16),

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
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _presentingIssuesController,
                    decoration: const InputDecoration(
                      labelText: 'Presenting Issues',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveChild,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.childId != null
                            ? 'Update Child'
                            : 'Create Child',),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
