part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class LoginInitial extends AuthState {}

final class CreateLoading extends AuthState {}

final class CreateSuccess extends AuthState {}

final class CreateFailure extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

final class LoginFailure extends AuthState {}
