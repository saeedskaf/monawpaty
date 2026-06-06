part of 'shifts_changes_cubit.dart';

@immutable
abstract class ShiftsChangesState {}

class ShiftsChangesInitial extends ShiftsChangesState {}

class ShiftsChangesLoading extends ShiftsChangesState {}

class ShiftsChangesSuccess extends ShiftsChangesState {
  final String type;

  ShiftsChangesSuccess(this.type);
}

class ShiftsChangesFailure extends ShiftsChangesState {
  final String error;

  ShiftsChangesFailure(this.error);
}

class ShiftsChangeNotifier extends ShiftsChangesState {}
