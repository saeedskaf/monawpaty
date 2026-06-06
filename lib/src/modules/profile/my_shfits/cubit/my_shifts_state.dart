part of 'my_shifts_cubit.dart';

@immutable
abstract class MyShiftsState {}

class MyShiftsInitial extends MyShiftsState {}

class MyShiftsLoading extends MyShiftsState {}

class MyShiftsSuccess extends MyShiftsState {}

class MyShiftsFailure extends MyShiftsState {
  final String error;

  MyShiftsFailure(this.error);
}

class MyShiftsChangeNotifier extends MyShiftsState {}
