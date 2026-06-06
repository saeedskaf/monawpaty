import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:monawpaty/src/models/shift.dart';
import '../../../../../core/locator.dart';
import '../../../../../core/shared_prefrence_repository.dart';
import '../../../../shared/end_points.dart';

part 'my_shifts_state.dart';

class MyShiftsCubit extends Cubit<MyShiftsState> {
  MyShiftsCubit() : super(MyShiftsInitial());

  static MyShiftsCubit get(context) => BlocProvider.of(context);

  List<Shift> myReservations = [];
  String? selectedDate;

  Future<void> getMyReservations() async {
    try {
      emit(MyShiftsLoading());
      myReservations = [];
      String token =
          locator<SharedPreferencesRepository>().getUserInfo().token!;

      var url = Uri.parse(ConstantsService.baseUrl +
          ConstantsService.getMyReservationsEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"date": selectedDate}));
      var responseBody = jsonDecode(response.body);

      for (var x in responseBody["اسعاف"]) {
        Shift temp = Shift.fromJson(x);
        temp.id = 1;
        myReservations.add(temp);
      }
      for (var x in responseBody["عمليات"]) {
        Shift temp = Shift.fromJson(x);
        temp.id = 2;
        myReservations.add(temp);
      }
      emit(MyShiftsSuccess());
    } catch (e) {
      emit(MyShiftsFailure(e.toString()));
    }
  }

  Future<void> getMyShiftsInitial() async {
    await Future.delayed(const Duration(milliseconds: 10));
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    selectedDate = "$year-$month";
    getMyReservations();
  }
}
