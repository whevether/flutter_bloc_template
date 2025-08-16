import 'package:replay_bloc/replay_bloc.dart';

abstract class BaseEvent<B, S>  extends ReplayEvent {
  ///event transform to state
  ///[bloc] 事件的Bloc
  ///[currentState] 当前的状态
  Future<S?> on(B bloc, S currentState);
}
