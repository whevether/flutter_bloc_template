abstract class BaseEvent<B, S> {
  ///event transform to state
  ///[bloc] 事件的Bloc
  ///[currentState] 当前的状态
  Future<S?> on(B bloc, S currentState);
}
