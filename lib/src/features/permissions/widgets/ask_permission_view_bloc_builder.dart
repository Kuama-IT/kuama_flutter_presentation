import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuama_dart_domain/permissions.dart';
import 'package:kuama_flutter_presentation/src/features/permissions/bloc/permission_bloc.dart';
import 'package:kuama_flutter_presentation/src/features/permissions/widgets/permission_bloc_builder.dart';

/// It builds the ui only when permission has been granted
/// If the permission is missing it displays a text asking to activate the permission
class AskPermissionViewBlocBuilder<TPermissionBloc extends PermissionBloc> extends StatelessWidget {
  final Widget? child;
  final BlocWidgetBuilder<PermissionBlocState> builder;

  const AskPermissionViewBlocBuilder({
    Key? key,
    this.child,
    required this.builder,
  }) : super(key: key);

  Widget _buildButtonView(BuildContext context, VoidCallback? onTap) {
    final child = this.child ?? Text('Allow permission');

    return Center(
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PermissionBlocBuilder<TPermissionBloc>(
      builder: (context, state) {
        if (state is PermissionBlocIdle) {
          return _buildButtonView(context, () => context.read<PermissionBloc>().request());
        }
        if (state is PermissionBlocRequested) {
          switch (state.status) {
            case PermissionStatus.permanentlyDenied:
              // Todo: Show dialog to open app settings
              return _buildButtonView(context, () => print('Show dialog to open app settings'));
            case PermissionStatus.denied:
              return _buildButtonView(context, () => context.read<PermissionBloc>().reRequest());
            case PermissionStatus.granted:
              return builder(context, state);
          }
        }
        assert(state is PermissionBlocRequesting || state is PermissionBlocRequestConfirm);
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
