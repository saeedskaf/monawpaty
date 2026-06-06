import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_utils/date_utils.dart' as imp;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../../../core/locator.dart';
import '../../../../../../core/shared_prefrence_repository.dart';
import '../../../../../models/shift.dart';
import '../../../../../shared/end_points.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  static BookingCubit get(context) => BlocProvider.of(context);

  List<String> tableShifts = List<String>.generate(28, (i) {
    return "";
  });
  List<Shift> shiftsList = [];
  String? choiceType;
  String? selectedWeek;
  String? selectedShiftTime;
  String? selectedLocation;
  DateTime? selectedDate;

  int getDaysInMonth() {
    var date = DateTime(DateTime.now().year, DateTime.now().month + 1);
    var lastDay = imp.DateUtils.lastDayOfMonth(date);
    return (lastDay.day);
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  void changeNotifier() {
    emit(BookingChangeNotifier());
  }

  Future<void> loadTableShifts() async {
    try {
      emit(BookingLoading());
      String token =
          locator<SharedPreferencesRepository>().getUserInfo().token!;

      var url = Uri.parse(
          ConstantsService.baseUrl + ConstantsService.getTableShiftsEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"weekNumber": selectedWeek, "type": choiceType}));
      var responseBody = jsonDecode(response.body);
      tableShifts = (responseBody as List<dynamic>).cast<String>();
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}
