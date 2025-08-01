/* BaseEvent
 * 
 * This abstract class defines the structure for events in a Bloc architecture.
 * It requires implementing classes to define how an event transforms into a state.
 */
abstract class BaseEvent<B, S> {
  ///event transform to state
  ///[bloc] 事件的Bloc
  ///[currentState] 当前的状态
  Future<S?> on(B bloc, S currentState);
}