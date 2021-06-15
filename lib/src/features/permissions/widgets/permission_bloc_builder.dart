import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuama_flutter_presentation/src/features/permissions/bloc/permission_bloc.dart';

/// It asks for permission whenever possible and
/// allows you to build the child based on the state of the block
class PermissionBlocBuilder<TPermissionBloc extends PermissionBloc> extends StatefulWidget {
  final PermissionBloc? permissionBloc;
  final Widget Function(BuildContext context, PermissionBlocState state) builder;

  const PermissionBlocBuilder({
    Key? key,
    this.permissionBloc,
    required this.builder,
  }) : super(key: key);

  @override
  _PermissionBlocBuilderState createState() => _PermissionBlocBuilderState();
}

class _PermissionBlocBuilderState<TPermissionBloc extends PermissionBloc>
    extends State<PermissionBlocBuilder<TPermissionBloc>> {
  late PermissionBloc _permissionBloc;

  @override
  void initState() {
    super.initState();
    _permissionBloc = widget.permissionBloc ?? context.read<TPermissionBloc>();
    onStateChanges(context, _permissionBloc.state);
  }

  @override
  void didUpdateWidget(covariant PermissionBlocBuilder<TPermissionBloc> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final permissionBloc = widget.permissionBloc ?? context.read<TPermissionBloc>();
    if (_permissionBloc != permissionBloc) {
      _permissionBloc = permissionBloc;
      onStateChanges(context, _permissionBloc.state);
    }
  }

  void onStateChanges(BuildContext context, PermissionBlocState state) {
    if (state is PermissionBlocIdle) {
      _permissionBloc.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionBloc, PermissionBlocState>(
      bloc: _permissionBloc,
      listener: onStateChanges,
      builder: widget.builder,
    );
  }
}
