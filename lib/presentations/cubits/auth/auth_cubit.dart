import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:recipia/data/models/user_model.dart';
import 'package:recipia/data/remote_datasources/auth_remote_datasource.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDatasource _auth;

  late StreamSubscription<fb.User?> _authSubscription;
  AuthCubit(this._auth) : super(const AuthState()) {
    _authSubscription = _auth.authStateChange.listen((fbUser) {
      if (fbUser != null) {
        final myUser = UserModel(uid: fbUser.uid, email: fbUser.email);
        emit(state.copyWith(user: myUser, status: AuthStatus.authenticated));
      } else {
        emit(state.copyWith(user: null, status: AuthStatus.unauthenticated));
      }
    });
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _auth.login(email, password);
    } catch (e) {
      emit(
        state.copyWith(errorMessage: e.toString(), status: AuthStatus.failure),
      );
      log(e.toString());
    }
  }

  Future<void> register(String email, String password, String fullName) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _auth.register(email, password, fullName);
    } catch (e) {
      emit(
        state.copyWith(errorMessage: e.toString(), status: AuthStatus.failure),
      );
      log(e.toString());
    }
  }

  Future<void> getUser() async {
    emit(state.copyWith(status: AuthStatus.loading));

    _auth.getUser().listen(
      (users) {
        emit(state.copyWith(status: AuthStatus.authenticated, users: users));
      },
      onError: (error) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            errorMessage: error.toString(),
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    await _auth.logout();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
