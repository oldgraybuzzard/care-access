import 'package:flutter/material.dart';
import '../constants/app_strings.dart';

/// Governance and compliance dialogs for CareAccess
///
/// These dialogs ensure users understand their responsibilities when
/// accessing sensitive information about children and families.

class GovernanceDialogs {
  /// Show first-login data access acknowledgement dialog
  ///
  /// This should be shown on first login or when policy is updated.
  /// Returns true if user acknowledges, false if dismissed.
  static Future<bool> showFirstLoginAcknowledgement(
    BuildContext context,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must acknowledge
      builder: (context) => const _FirstLoginAcknowledgementDialog(),
    );
    return result ?? false;
  }

  /// Show export warning dialog before allowing data export
  ///
  /// Returns true if user wants to continue, false if cancelled.
  static Future<bool> showExportWarning(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const _ExportWarningDialog(),
    );
    return result ?? false;
  }

  /// Show unauthorized access message
  static Future<void> showUnauthorizedAccess(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const _UnauthorizedAccessDialog(),
    );
  }

  /// Show read-only banner as a snackbar
  static void showReadOnlyBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.visibility, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.readOnlyBannerTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.readOnlyBannerMessage,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue[700],
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ============================================================================
// Private Dialog Widgets
// ============================================================================

class _FirstLoginAcknowledgementDialog extends StatelessWidget {
  const _FirstLoginAcknowledgementDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      icon: Icon(
        Icons.policy,
        size: 48,
        color: colorScheme.primary,
      ),
      title: Text(
        AppStrings.firstLoginTitle,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          AppStrings.firstLoginMessage,
          style: theme.textTheme.bodyMedium,
        ),
      ),
      actions: [
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.check_circle),
          label: Text(AppStrings.acknowledgeButton),
        ),
      ],
    );
  }
}

class _ExportWarningDialog extends StatelessWidget {
  const _ExportWarningDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(
        Icons.warning_amber,
        size: 48,
        color: Colors.orange[700],
      ),
      title: Text(
        AppStrings.exportWarningTitle,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          AppStrings.exportWarningMessage,
          style: theme.textTheme.bodyMedium,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppStrings.exportCancelButton),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.download),
          label: Text(AppStrings.exportContinueButton),
        ),
      ],
    );
  }
}

class _UnauthorizedAccessDialog extends StatelessWidget {
  const _UnauthorizedAccessDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(
        Icons.block,
        size: 48,
        color: Colors.red[700],
      ),
      title: Text(
        AppStrings.unauthorizedAccessTitle,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          AppStrings.unauthorizedAccessMessage,
          style: theme.textTheme.bodyMedium,
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

