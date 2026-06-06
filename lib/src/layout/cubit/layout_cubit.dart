import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monawpaty/src/modules/home/home_screen.dart';
import 'package:monawpaty/src/modules/profile/profile_screen.dart';
import 'package:monawpaty/src/modules/shifts_booking/shifts_booking_layout.dart';
import 'package:monawpaty/src/modules/shifts_changes/shifts_chnages_screen.dart';
import '../../models/shift.dart';
import '../../shared/end_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

part 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutInitial());

  static LayoutCubit get(context) => BlocProvider.of(context);

  List<Shift> listResult = [];

  int selectedScreenIndex = 0;
  final screens = [
    const HomeScreen(),
    const ShiftsBookingLayout(),
    const ShiftsChangesScreen(),
    const ProfileScreen()
  ];

  void changeScreen(int index) {
    selectedScreenIndex = index;
    emit(LayoutChangeNotifier());
  }

  Future<List<Shift>?> getResId() async {
    try {
      var url = Uri.parse(
          ConstantsService.baseUrl + ConstantsService.getResIdEndpoint);
      var response = await http.get(url);
      var responseBody = jsonDecode(response.body);
      for (var x in responseBody) {
        Shift temp = Shift.fromJson(x);
        listResult.add(temp);
      }
      return listResult;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "الرجاء التأكد من الاتصال بالانترنت",
          gravity: ToastGravity.BOTTOM);
    }
    return null;
  }
}
