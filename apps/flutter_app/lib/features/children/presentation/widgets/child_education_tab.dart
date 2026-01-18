import 'package:flutter/material.dart';
import '../../../../core/models/child.dart';

class ChildEducationTab extends StatelessWidget {
  final Child child;

  const ChildEducationTab({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final educationRecords = child.educationRecords ?? [];

    if (educationRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No Education Records',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'No education records have been added yet.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add education record
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Education Record'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: educationRecords
            .map((record) => _EducationRecordCard(record: record))
            .toList(),
      ),
    );
  }
}

class _EducationRecordCard extends StatelessWidget {
  final EducationRecord record;

  const _EducationRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getGradeColor(record.gpa),
          child: const Icon(Icons.school, color: Colors.white),
        ),
        title: Text(
          '${record.schoolYear} - ${record.gradeLevel}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(record.schoolName),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Academic Performance
                _buildSection(
                  'Academic Performance',
                  Icons.grade,
                  [
                    if (record.gpa != null)
                      _buildInfoRow('GPA', record.gpa!.toStringAsFixed(2)),
                    _buildInfoRow('Academic Status', record.academicStatus),
                    if (record.readingLevel != null)
                      _buildInfoRow('Reading Level', record.readingLevel!),
                    if (record.mathLevel != null)
                      _buildInfoRow('Math Level', record.mathLevel!),
                    if (record.strugglingSubjects != null &&
                        (record.strugglingSubjects as List).isNotEmpty)
                      _buildInfoRow(
                        'Struggling Subjects',
                        (record.strugglingSubjects as List).join(', '),
                      ),
                  ],
                ),
                const Divider(height: 32),

                // Attendance & Behavior
                _buildSection(
                  'Attendance & Behavior',
                  Icons.calendar_today,
                  [
                    if (record.daysPresent != null || record.daysAbsent != null)
                      _buildInfoRow(
                        'Attendance Rate',
                        '${record.attendanceRate.toStringAsFixed(1)}%',
                      ),
                    if (record.daysPresent != null)
                      _buildInfoRow('Days Present', '${record.daysPresent}'),
                    if (record.daysAbsent != null)
                      _buildInfoRow('Days Absent', '${record.daysAbsent}'),
                    if (record.tardies != null)
                      _buildInfoRow('Tardies', '${record.tardies}'),
                    if (record.suspensions != null)
                      _buildInfoRow('Suspensions', '${record.suspensions}'),
                    if (record.detentions != null)
                      _buildInfoRow('Detentions', '${record.detentions}'),
                  ],
                ),
                const Divider(height: 32),

                // Special Education
                if (record.hasSpecialEducation) ...[
                  _buildSection(
                    'Special Education',
                    Icons.accessibility_new,
                    [
                      if (record.hasIep)
                        _buildInfoRow('IEP', 'Yes', color: Colors.blue),
                      if (record.has504Plan)
                        _buildInfoRow('504 Plan', 'Yes', color: Colors.blue),
                      if (record.specialServices != null &&
                          (record.specialServices as List).isNotEmpty)
                        _buildInfoRow(
                          'Services',
                          (record.specialServices as List).join(', '),
                        ),
                    ],
                  ),
                  const Divider(height: 32),
                ],

                // Teacher Feedback
                if (record.teacherFeedback != null) ...[
                  _buildSection(
                    'Teacher Feedback',
                    Icons.comment,
                    [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          record.teacherFeedback!,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                ],

                // Extracurricular Activities
                if (record.extracurricular != null &&
                    (record.extracurricular as List).isNotEmpty) ...[
                  _buildSection(
                    'Extracurricular Activities',
                    Icons.sports,
                    [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (record.extracurricular as List)
                            .map((activity) => Chip(
                                  label: Text(activity.toString()),
                                  backgroundColor: Colors.green.shade50,
                                ),)
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: color != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(double? gpa) {
    if (gpa == null) return Colors.grey;
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 3.0) return Colors.blue;
    if (gpa >= 2.0) return Colors.orange;
    return Colors.red;
  }
}
