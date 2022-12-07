part of 'cats_bloc.dart';

@immutable
abstract class CatsEvent {
  const CatsEvent();
}

class GetRandomCat extends CatsEvent {}

class GetLastCat extends CatsEvent {}

class GetCatsHistory extends CatsEvent {}
