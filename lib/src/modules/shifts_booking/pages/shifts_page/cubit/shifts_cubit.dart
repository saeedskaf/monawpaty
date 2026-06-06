import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:monawpaty/src/layout/cubit/layout_cubit.dart';
import 'package:monawpaty/src/modules/shifts_booking/pages/booking_page/cubit/booking_cubit.dart';
import '../../../../../../core/locator.dart';
import '../../../../../../core/shared_prefrence_repository.dart';
import '../../../../../shared/end_points.dart';

part 'shifts_state.dart';

class ShiftsCubit extends Cubit<ShiftsState> {
  ShiftsCubit() : super(ShiftsInitial());

  static ShiftsCubit get(context) => BlocProvider.of(context);

  Future<void> sendShifts(BuildContext context) async {
    try {
      emit(ShiftsLoading());

      String token =
          locator<SharedPreferencesRepository>().getUserInfo().token!;
      List<int> rIdList = [];
      List<String> dateList = [];

      for (var x in BookingCubit.get(context).shiftsList) {
        dateList.add(x.date!);
        for (var y in LayoutCubit.get(context).listResult) {
          if (x.dayInMonth == y.dayInMonth && x.shiftTime == y.shiftTime) {
            rIdList.add(y.id!);
          }
        }
      }

      var url = Uri.parse(
          ConstantsService.baseUrl + ConstantsService.bookShiftEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "rid": rIdList,
            "type": BookingCubit.get(context).choiceType,
            "location": BookingCubit.get(context).selectedLocation,
            "date": dateList
          }));
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        emit(ShiftsSuccess());
      } else if (response.statusCode == 400) {
        throw (responseBody["detail"]);
      }
    } catch (e) {
      emit(ShiftsFailure(e.toString()));
    }
  }

  Future<void> onCall(BuildContext context) async {
    try {
      emit(ShiftsLoading());

      String token =
          locator<SharedPreferencesRepository>().getUserInfo().token!;
      List<int> rIdList = [];
      List<String> dateList = [];

      for (var x in BookingCubit.get(context).shiftsList) {
        dateList.add(x.date!);
        for (var y in LayoutCubit.get(context).listResult) {
          if (x.dayInMonth == y.dayInMonth && x.shiftTime == y.shiftTime) {
            rIdList.add(y.id!);
          }
        }
      }

      var url =
          Uri.parse(ConstantsService.baseUrl + ConstantsService.onCallEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "rid": rIdList,
            "type": BookingCubit.get(context).choiceType,
            "location": BookingCubit.get(context).selectedLocation,
            "date": dateList
          }));
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(ShiftsSuccess());
      } else if (response.statusCode == 400) {
        throw (responseBody["detail"]);
      }
    } catch (e) {
      emit(ShiftsFailure(e.toString()));
    }
  }

  void changeNotifier() {
    emit(ShiftsChangeNotifier());
  }
}
