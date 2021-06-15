import 'package:flutter/material.dart';
import 'package:kuama_dart_domain/permissions.dart';

/// Asks for permits to ask for permission
class AskPermissionsDialog extends StatelessWidget {
  final Permission permission;
  final Widget? title;
  final Widget? negativeLabel;
  final Widget? positiveLabel;

  AskPermissionsDialog({
    Key? key,
    required this.permission,
    this.title,
    this.negativeLabel,
    this.positiveLabel,
  }) : super(key: key);

  Widget _buildTitle(BuildContext context) {
    if (title != null) return title!;
    switch (permission) {
      case Permission.contacts:
        return Text('Allow to access your contacts?');
      case Permission.position:
        return Text('Allow to access your location while you are using the app?');
      case Permission.backgroundPosition:
        return Text('Allow to access your location in background?');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: _buildTitle(context),
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: negativeLabel ?? Text('Don\'t allow'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: positiveLabel ?? Text('Allow'),
            ),
          ],
        ),
      ],
    );
  }
}
