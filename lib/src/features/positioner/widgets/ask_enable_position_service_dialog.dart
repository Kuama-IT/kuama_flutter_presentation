import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuama_dart_domain/app_pages.dart';
import 'package:kuama_dart_domain/kuama_dart_domain.dart';
import 'package:kuama_flutter_presentation/src/features/positioner/bloc/positioner_bloc.dart';
import 'package:kuama_flutter_presentation/src/shared/widgets/dialogs/app_settings_dialog.dart';
import 'package:kuama_flutter_presentation/src/utils/lg.dart';

class AskEnablePositionServiceDialog extends StatelessWidget {
  const AskEnablePositionServiceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PositionerBloc, PositionerBlocState>(
      listenWhen: (prev, curr) =>
          prev.isServiceEnabled != curr.isServiceEnabled && curr.isServiceEnabled,
      // Auto closing of the dialog when the service has been enabled
      listener: (context, state) => Navigator.of(context).pop(true),
      child: AskOpenAppSettingsPageDialog(
        title: Text('Enable the GeoLocalization service'),
      ),
    );
  }
}

class OrderEnablePositionServiceDialog extends StatelessWidget {
  final Widget? title;
  final Widget? cancelLabel;
  final Widget? settingsLabel;

  const OrderEnablePositionServiceDialog({
    Key? key,
    this.title,
    this.cancelLabel,
    this.settingsLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PositionerBloc, PositionerBlocState>(
      listenWhen: (prev, curr) =>
          prev.isServiceEnabled != curr.isServiceEnabled && curr.isServiceEnabled,
      // Auto closing of the dialog when the service has been enabled
      listener: (context, state) => Navigator.of(context).pop(true),
      child: WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: title ?? Text('Position service required'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: cancelLabel ?? Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final result = await GetIt.I<OpenSettingsAppPage>().call(NoParams()).single;
                result.fold((failure) {
                  lg.warning('Open Settings app page failed!', failure);
                }, (isOpened) {
                  if (!isOpened) lg.warning('Open Settings app page failed!');
                });
              },
              child: settingsLabel ?? Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
