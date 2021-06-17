import 'package:flutter/material.dart';
import 'package:kuama_dart_domain/app_pages.dart';
import 'package:kuama_dart_domain/kuama_dart_domain.dart';
import 'package:kuama_flutter_presentation/src/utils/lg.dart';

class AskOpenAppSettingsPageDialog extends StatelessWidget {
  final Widget? title;
  final Widget? cancelLabel;
  final Widget? settingsLabel;

  const AskOpenAppSettingsPageDialog({
    Key? key,
    this.title,
    this.cancelLabel,
    this.settingsLabel,
  }) : super(key: key);

  void openSettingsPage() async {
    final res = await GetIt.I<OpenSettingsAppPage>().call(NoParams()).single;
    res.fold((failure) {
      lg.severe('The app settings page could not be opened', failure);
    }, (wasOpened) {
      if (!wasOpened) lg.severe('The app settings page could not be opened');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title ?? Text('Open app settings'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: cancelLabel ?? Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: openSettingsPage,
          child: settingsLabel ?? Text('Settings'),
        ),
      ],
    );
  }
}
