import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/mfa_api.dart';
import '../models/mfa_setup_response.dart';

class MfaSetupScreen extends ConsumerStatefulWidget {
  const MfaSetupScreen({super.key});

  @override
  ConsumerState<MfaSetupScreen> createState() => _MfaSetupScreenState();
}

class _MfaSetupScreenState extends ConsumerState<MfaSetupScreen> {
  MfaSetupResponse? _setupData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _setupMfa();
  }

  Future<void> _setupMfa() async {
    try {
      final mfaApi = ref.read(mfaApiProvider);
      final response = await mfaApi.setupMfa();

      setState(() {
        _setupData = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _copyBackupCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup code copied to clipboard')),
    );
  }

  void _copyAllBackupCodes() {
    if (_setupData != null) {
      final allCodes = _setupData!.backupCodes.join('\n');
      Clipboard.setData(ClipboardData(text: allCodes));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All backup codes copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Two-Factor Authentication'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: colorScheme.error,),
                      const SizedBox(height: 16),
                      Text('Error: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Step 1: Scan QR Code
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Step 1: Scan QR Code',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Scan this QR code with your authenticator app:',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Google Authenticator\n• Authy\n• 1Password\n• Microsoft Authenticator',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 16),
                              if (_setupData != null)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.memory(
                                    Uri.parse(_setupData!.qrCode)
                                        .data!
                                        .contentAsBytes(),
                                    width: 250,
                                    height: 250,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Step 2: Save Backup Codes
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Step 2: Save Backup Codes',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy_all),
                                    onPressed: _copyAllBackupCodes,
                                    tooltip: 'Copy all codes',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Save these backup codes in a secure location. You can use them to access your account if you lose your authenticator device.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: _setupData?.backupCodes.map((code) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4,),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                code,
                                                style: const TextStyle(
                                                  fontFamily: 'monospace',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.copy,
                                                    size: 18,),
                                                onPressed: () =>
                                                    _copyBackupCode(code),
                                                tooltip: 'Copy code',
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList() ??
                                      [],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Warning
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber,
                                color: colorScheme.onErrorContainer,),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Important: Save your backup codes now. You won\'t be able to see them again!',
                                style: TextStyle(
                                  color: colorScheme.onErrorContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Continue Button
                      FilledButton.icon(
                        onPressed: () {
                          context.push('/mfa/verify');
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Continue to Verification'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
