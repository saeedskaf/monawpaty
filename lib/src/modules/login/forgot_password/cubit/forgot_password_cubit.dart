import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../shared/end_points.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  static ForgotPasswordCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> passReset() async {
    try {
      emit(ForgotPasswordLoading());
      var url = Uri.parse(
          ConstantsService.baseUrl + ConstantsService.passwordResetEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "email": emailController.text,
          }));

      if (response.statusCode == 200) {
        emit(ForgotPasswordSuccess());
      } else {
        throw Exception('invalid-data');
      }
    } catch (e) {
      emit(ForgotPasswordFailure(e.toString()));
    }
  }
}
