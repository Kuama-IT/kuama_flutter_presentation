import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kuama_dart_domain/kuama_dart_domain.dart';
import 'package:kuama_dart_domain/positioner.dart';
import 'package:kuama_flutter_presentation/src/utils/lg.dart';

Future<void> showPositionServiceDialog({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final theme = Theme.of(context);

  switch (theme.platform) {
    case TargetPlatform.android:
      final res = await GetIt.I<OpenPositionServicePage>().call(NoParams()).single;
      res.fold((failure) {
        lg.severe('The page to enable the position service could not be opened', failure);
      }, (wasOpened) {
        // TODO: open a dialog
        if (!wasOpened) lg.severe('The page to enable the position service could not be opened');
      });
      break;
    case TargetPlatform.fuchsia:
    case TargetPlatform.iOS:
    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      await showDialog(
        context: context,
        builder: builder,
      );
      break;
  }
}
