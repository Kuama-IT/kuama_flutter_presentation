import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';

/// I allow to execute code whenever the value changes
class ValueChangeHandler<T> extends SingleChildStatefulWidget {
  final T value;

  /// It is called whenever the value is acquired
  final void Function(BuildContext context, T value)? onAcquired;

  /// It is called whenever the old value is lost
  final void Function(BuildContext context, T value)? onLost;

  const ValueChangeHandler({
    Key? key,
    required this.value,
    this.onAcquired,
    this.onLost,
    Widget? child,
  }) : super(key: key, child: child);

  @override
  _HandlerState<T> createState() => _HandlerState();
}

class _HandlerState<T> extends SingleChildState<ValueChangeHandler<T>> {
  @override
  void initState() {
    super.initState();
    widget.onAcquired?.call(context, widget.value);
  }

  @override
  void didUpdateWidget(covariant ValueChangeHandler<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      widget.onLost?.call(context, oldWidget.value);
      widget.onAcquired?.call(context, widget.value);
    }
  }

  @override
  void dispose() {
    widget.onLost?.call(context, widget.value);
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => child!;
}

/// [ValueChangeHandler]
class BlocChangeHandler<TBloc extends Bloc<dynamic, TState>, TState>
    extends ValueChangeHandler<TBloc> {
  BlocChangeHandler({
    Key? key,
    required TBloc bloc,
    void Function(BuildContext context, TState state)? onAcquired,
    void Function(BuildContext context, TState state)? onLost,
    Widget? child,
  }) : super(
          key: key,
          value: bloc,
          onAcquired:
              onAcquired != null ? (context, bloc) => onAcquired(context, bloc.state) : null,
          onLost: onLost != null ? (context, bloc) => onLost(context, bloc.state) : null,
          child: child,
        );
}
