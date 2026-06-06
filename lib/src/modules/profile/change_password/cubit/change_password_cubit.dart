import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/locator.dart';
import '../../../../../core/shared_prefrence_repository.dart';
import '../../../../shared/end_points.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  Future<void> changePass() async {
    try {
      emit(ChangePasswordLoading());
      String token =
          locator<SharedPreferencesRepository>().getUserInfo().token!;
      var url = Uri.parse(
          ConstantsService.baseUrl + ConstantsService.changePasswordEndpoint);
      var response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "old_password": oldPassController.text,
            "password": confirmPassController.text
          }));
      if (response.statusCode == 200) {
        emit(ChangePasswordSuccess());
      } else if (response.statusCode == 400) {
        throw Exception('wrong-password');
      }
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }
}
