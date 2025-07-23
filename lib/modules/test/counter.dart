// 事件
abstract class CounterEvent {}
class IncrementEvent extends CounterEvent {}
class UpdateUserEvent extends CounterEvent {
  final User user;
  UpdateUserEvent(this.user);
}

// 状态
abstract class CounterState {}
class CounterInitial extends CounterState {}

// 模型
class User {
  final String name;
  User({required this.name});
}