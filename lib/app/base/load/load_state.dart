/// createTime: 2021/10/21 on 14:57
/// desc:
///
/// @author azhon

abstract class LoadState {}

class InitialState extends LoadState {}

class LoadingState extends LoadState {}

class ErrorState extends LoadState {
  final Exception exception;

  ErrorState(this.exception);
}
