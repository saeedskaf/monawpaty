import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monawpaty/src/layout/cubit/layout_cubit.dart';
import '../../../../core/locator.dart';
import '../../../../core/shared_prefrence_repository.dart';
import '../../../shared/end_points.dart';
import 'package:http/http.dart' as http;

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  late String fullName;
  late String rank;
  String? ambulanceShifts;
  String? operationShifts;

  String? swapRank(String rank) {
    if (rank == 'leader') {
      return "قائد";
    } else if (rank == 'scout') {
      return "كشاف";
    } else if (rank == 'sought') {
      return "مسعف";
    } else {
      return rank;
    }
  }

  getCountShifts(BuildContext context) async {
    try {
      emit(ProfileLoading());
      String token =
          locator<SharedPreferencesRepository>().getUserInfo().token!;

      var url = Uri.parse(
          ConstantsService.baseUrl + ConstantsService.getCountShiftsEndpoint);
      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });

      var responseBody = jsonDecode(response.body);
      ambulanceShifts = responseBody['message1'].toString();
      operationShifts = responseBody['message2'].toString();

      if (context.mounted) {
        if (LayoutCubit.get(context).selectedScreenIndex == 3) {
          emit(ProfileSuccess());
        }
      }
    } catch (e) {
      if (LayoutCubit.get(context).selectedScreenIndex == 3) {
        emit(ProfileFailure(e.toString()));
      }
    }
  }

  String decodeArabicString(String input) {
    List<int> bytes = input.toString().codeUnits;
    return utf8.decode(bytes);
  }

  void getProfileData(BuildContext context) {
    fullName = decodeArabicString(
        locator<SharedPreferencesRepository>().getUserInfo().fullname!);
    rank =
        swapRank(locator<SharedPreferencesRepository>().getUserInfo().rank!)!;
    emit(ProfileChangeNotifier());
    getCountShifts(context);
  }
}
