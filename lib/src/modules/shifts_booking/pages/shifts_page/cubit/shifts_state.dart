part of 'shifts_cubit.dart';

@immutable
abstract class ShiftsState {}

class ShiftsInitial extends ShiftsState {}

class ShiftsLoading extends ShiftsState {}

class ShiftsSuccess extends ShiftsState {}

class ShiftsFailure extends ShiftsState {
  final String error;

  ShiftsFailure(this.error);
}

class ShiftsChangeNotifier extends ShiftsState {}
