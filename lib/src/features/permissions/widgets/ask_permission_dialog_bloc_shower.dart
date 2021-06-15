import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuama_dart_domain/permissions.dart';
import 'package:kuama_flutter_presentation/src/features/permissions/bloc/permission_bloc.dart';
import 'package:kuama_flutter_presentation/src/features/permissions/widgets/ask_permission_dialog.dart';

/// Show the permission request dialog based on the bloc permission
class AskPermissionDialogBlocShower<TPermissionBloc extends PermissionBloc>
    extends StatelessWidget {
  final TPermissionBloc? permissionBloc;
  final Widget child;

  const AskPermissionDialogBlocShower({
    Key? key,
    this.permissionBloc,
    required this.child,
  }) : super(key: key);

  Future<void> show(BuildContext context, Permission permission) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AskPermissionsDialog(permission: permission),
    );
    (permissionBloc ?? context.read<TPermissionBloc>()).confirmRequest(result ?? false);
  }

  static AskPermissionDialogBlocShower<TPermissionBloc> of<TPermissionBloc extends PermissionBloc>(
    BuildContext context,
  ) {
    return context.findAncestorWidgetOfExactType<AskPermissionDialogBlocShower<TPermissionBloc>>()!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TPermissionBloc, PermissionBlocState>(
      bloc: permissionBloc,
      listener: (context, state) async {
        if (state is ConfirmRequestPermissionEvent) {
          await show(context, state.permission);
        }
      },
      child: child,
    );
  }
}
