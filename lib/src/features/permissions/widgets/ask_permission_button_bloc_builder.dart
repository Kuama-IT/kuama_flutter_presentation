import 'package:flutter/material.dart';
import 'package:kuama_dart_domain/permissions.dart';
import 'package:kuama_flutter_presentation/src/features/permissions/bloc/permission_bloc.dart';
import 'package:kuama_flutter_presentation/src/features/permissions/widgets/permission_bloc_builder.dart';
import 'package:provider/provider.dart';

/// Show a button to request permission when it has been denied or permanently denied
/// The button is not shown if the permission has been granted
class AskPermissionButtonBlocBuilder<TPermissionBloc extends PermissionBloc>
    extends StatelessWidget {
  final Widget? child;
  final Widget Function(BuildContext context, VoidCallback? onTap, Widget child)? builder;

  const AskPermissionButtonBlocBuilder({
    Key? key,
    this.child,
    this.builder,
  }) : super(key: key);

  Widget _buildButton(BuildContext context, VoidCallback? onTap) {
    final child = this.child ?? Text('Allow permission');

    if (builder != null) {
      return builder!(context, onTap, child);
    }

    return ElevatedButton(
      onPressed: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PermissionBlocBuilder<TPermissionBloc>(
      builder: (context, state) {
        if (state is PermissionBlocIdle) {
          return _buildButton(context, () => context.read<PermissionBloc>().request());
        }
        if (state is PermissionBlocRequested) {
          switch (state.status) {
            case PermissionStatus.permanentlyDenied:
              // Todo: Show dialog to open app settings
              return _buildButton(context, () => print('Show dialog to open app settings'));
            case PermissionStatus.denied:
              return _buildButton(context, () => context.read<PermissionBloc>().reRequest());
            case PermissionStatus.granted:
              return const SizedBox.shrink();
          }
        }
        assert(state is PermissionBlocRequesting || state is PermissionBlocRequestConfirm);
        return _buildButton(context, null);
      },
    );
  }
}
