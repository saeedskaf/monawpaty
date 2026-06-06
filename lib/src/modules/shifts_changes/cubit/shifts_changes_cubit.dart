import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../core/locator.dart';
import '../../../../core/shared_prefrence_repository.dart';
import '../../../layout/cubit/layout_cubit.dart';
import '../../../models/shift.dart';
import '../../../shared/end_points.dart';

part 'shifts_changes_state.dart';

class ShiftsChangesCubit extends Cubit<ShiftsChangesState> {
  ShiftsChangesCubit() : super(ShiftsChangesInitial());

  static ShiftsChangesCubit get(context) => BlocProvider.of(context);

  String? choiceType;
  String? shiftsType;
  String? selectedShiftTime;
  String? selectedLocation;
  DateTime? selectedDate;

  void changeNotifier() {
    emit(ShiftsChangeNotifier());
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Future<void> sendRequests(BuildContext context) async {
    try {
      emit(ShiftsChangesLoading());
      String token =
          locator<SharedPreferencesRepository>().getUserInfo().token!;
      String? endPoint;
      int? rId;

      for (var x in LayoutCubit.get(context).listResult) {
        if (x.dayInMonth == selectedDate?.day &&
            x.shiftTime == selectedShiftTime) {
          rId = x.id!;
        }
      }

      if (choiceType == "ترميم") {
        endPoint = ConstantsService.repairRequestEndpoint;
      } else {
        endPoint = ConstantsService.cancelRequestEndpoint;
      }
      var url = Uri.parse(ConstantsService.baseUrl + endPoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "rid": rId,
            "type": shiftsType,
            "location": selectedLocation,
            "date": convertDateTimeDisplay(selectedDate.toString()),
          }));
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        emit(ShiftsChangesSuccess("post"));
      } else if (response.statusCode == 400) {
        throw (responseBody["result"]);
      }
    } catch (e) {
      emit(ShiftsChangesFailure(e.toString()));
    }
  }

  Future<List<Shift>?> getStatus() async {
    try {
      emit(ShiftsChangesLoading());
      List<Shift> myRequests = [];
      String token =
          locator<SharedPreferencesRepository>().getUserInfo().token!;
      String? endPoint;

      if (choiceType == "ترميم") {
        endPoint = ConstantsService.getShiftRepairEndpoint;
      } else {
        endPoint = ConstantsService.getShiftCancelEndpoint;
      }
      var url = Uri.parse(ConstantsService.baseUrl + endPoint);
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });
      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        for (var x in responseBody) {
          Shift temp = Shift.fromJson(x);
          myRequests.add(temp);
        }
        emit(ShiftsChangesSuccess("get"));
        return myRequests;
      }
    } catch (e) {
      emit(ShiftsChangesFailure(e.toString()));
    }
    return null;
  }
}
