import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monawpaty/src/shared/end_points.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/locator.dart';
import '../../../../core/shared_prefrence_repository.dart';
import '../../../models/user.dart';
import 'package:http/http.dart' as http;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      emit(LoginLoading());
      var url =
          Uri.parse(ConstantsService.baseUrl + ConstantsService.logInEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "username": usernameController.text,
            "password": passwordController.text
          }));
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        User user = User.fromJson(responseBody);
        locator<SharedPreferencesRepository>().setLoggedIn(isLoggedIn: true);
        locator<SharedPreferencesRepository>().saveUserInfo(user: user);
        emit(LoginSuccess());
      } else if (response.statusCode == 401) {
        throw Exception('invalid-data');
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(LoginPasswordVisibility());
  }
}
