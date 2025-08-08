abstract class ListState<T> {
  List<T> data;

  ListState(this.data);
}

class InitialState<T> extends ListState<T> {
  InitialState(super.data);
}
