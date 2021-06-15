part of 'permission_bloc.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  bool? get stringify => true;
}

/// [PermissionBloc.confirmRequest]
class ConfirmRequestPermissionEvent extends PermissionEvent {
  final bool canRequest;

  ConfirmRequestPermissionEvent(this.canRequest);

  @override
  List<Object?> get props => const [];
}

/// [PermissionBloc.request]
class RequestPermissionEvent extends PermissionEvent {
  @override
  List<Object?> get props => const [];
}

/// [PermissionBloc.reRequest]
class ReRequestPermissionEvent extends PermissionEvent {
  @override
  List<Object?> get props => const [];
}
