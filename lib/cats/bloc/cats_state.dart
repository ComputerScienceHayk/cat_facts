part of 'cats_bloc.dart';

@immutable
abstract class CatsState {
  const CatsState();
}

class CatsInitial extends CatsState {}

class CatsLoading extends CatsState {}

class CatsLoaded extends CatsState {
  final CatModel? cat;

  const CatsLoaded({required this.cat});
}

class HistoryInitial extends CatsState {}

class CatsHistoryLoaded extends CatsState {
  final List<CatModel>? cats;

  const CatsHistoryLoaded({required this.cats});
}

class CatsError extends CatsState {
  final String message;

  const CatsError({required this.message});
}
