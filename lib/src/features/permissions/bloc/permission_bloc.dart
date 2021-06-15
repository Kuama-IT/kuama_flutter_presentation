import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:kuama_dart_domain/kuama_dart_domain.dart';
import 'package:kuama_dart_domain/permissions.dart';
import 'package:kuama_flutter_presentation/src/utils/lg.dart';

part '_permission_event.dart';
part '_permission_state.dart';

/// Request permission using [request].
/// After asking for permission the bloc can go to two states:
/// 1. [PermissionBlocRequestConfirm]
///   The Bloc requires a permit request confirmation. Use [confirmRequest] to confirm the request
/// 2. [PermissionBlocRequested]
///   The bloc has completed successfully, read the status of the permit and act accordingly
///
/// - If the permission has the status [PermissionStatus.denied]. You can request permission
///   using [reRequest].
/// - If the permission has the status [PermissionStatus.permanentlyDenied] the permission cannot
///   be requested by the bloc. Therefore you should ask the user to enable the permission.
class PermissionBloc extends Bloc<PermissionEvent, PermissionBlocState> {
  final CanAskPermission _canAsk = GetIt.I();
  final UpdateCanAskPermission _updateCanAsk = GetIt.I();
  final CheckPermission _check = GetIt.I();
  final RequestPermission _request = GetIt.I();

  PermissionBloc({
    required Permission permission,
  }) : super(PermissionBlocIdle(permission: permission));

  /// Request the permission managed by the bloc
  void request() => add(RequestPermissionEvent());

  /// Confirm the permit request
  void confirmRequest(bool canRequest) => add(ConfirmRequestPermissionEvent(canRequest));

  /// Request denied permission
  void reRequest() => add(ReRequestPermissionEvent());

  @override
  @protected
  Stream<PermissionBlocState> mapEventToState(PermissionEvent event) async* {
    final state = this.state;

    if (event is ConfirmRequestPermissionEvent) {
      if (state is! PermissionBlocRequestConfirm) return;

      yield state.toRequesting();

      await _callUpdateCanAsk(event.canRequest);
      yield* _mapRequest(false);
      return;
    }
    if (event is RequestPermissionEvent) {
      if (state is! PermissionBlocIdle) return;

      yield state.toRequesting();
      yield* _mapRequest(true);
      return;
    }
    if (event is ReRequestPermissionEvent) {
      if (state is! PermissionBlocRequested) return;

      yield state.toRequesting();
      await _callUpdateCanAsk(true);
      yield* _mapRequest(true);
      return;
    }
  }

  /// Update the se value of the permit request
  ///
  /// NB: If it fails or succeeds with a wrong outcome, the bloc is not affected by the malfunction
  /// TODO: It continues with the correct functioning even in case of success with wrong response
  Future<void> _callUpdateCanAsk(bool canAsk) async {
    final res =
        await _updateCanAsk.call(UpdateCanAskPermissionParams(state.permission, canAsk)).single;
    res.fold((failure) {
      // Todo: Show failure
      lg.warning(failure);
    }, (canAsk) {
      lg.finest('Update can ask permission: $canAsk');
    });
  }

  /// Update the state of the bloc based on the status of the permission (canAsk, status)
  ///
  /// - If the permit is not required, it will be emitted [PermissionBlocRequested]
  /// - If the permission is requestable but is denied, [PermissionBlocRequestConfirm] or
  ///   [PermissionBlocRequested] will be emitted, depending on whether
  ///   confirmation is required [isConfirmRequired]
  ///
  /// In other cases, [PermissionBlocRequested] will be issued with the status of the permit
  /// or [PermissionBlocRequestFailed] if the request for the permit fails
  Stream<PermissionBlocState> _mapRequest(bool isConfirmRequired) async* {
    final canRequireRes = await _canAsk.call(state.permission).single;

    yield await canRequireRes.fold((failure) {
      return state.toRequestFailed(failure: failure);
    }, (canRequest) async {
      if (!canRequest) {
        return state.toRequested(status: PermissionStatus.denied);
      }

      final statusRes = await (isConfirmRequired ? _check : _request).call(state.permission).single;

      return statusRes.fold((failure) {
        return state.toRequestFailed(failure: failure);
      }, (status) {
        switch (status) {
          case PermissionStatus.denied:
            if (isConfirmRequired) {
              return state.toRequestConfirm();
            } else {
              return state.toRequested(status: status);
            }
          case PermissionStatus.permanentlyDenied:
          case PermissionStatus.granted:
            return state.toRequested(status: status);
        }
      });
    });
  }
}

class PositionPermissionBloc extends PermissionBloc {
  PositionPermissionBloc() : super(permission: Permission.position);
}

class BackgroundPositionPermissionBloc extends PermissionBloc {
  BackgroundPositionPermissionBloc() : super(permission: Permission.backgroundPosition);
}

class ContactsPermissionBloc extends PermissionBloc {
  ContactsPermissionBloc() : super(permission: Permission.contacts);
}
