import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monawpaty/src/shared/end_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  static RegistrationCubit get(context) => BlocProvider.of(context);

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  String? internationalNumber;
  String? gender;
  bool? operations;
  bool? opLeader;
  String? location;
  String? rank;
  String? image;
  File? imageFile;
  List<String> locationList = ["300", "320", "350", "360", "370", "380", "390"];
  List<String> rankList = [
    'قائد',
    'كشاف',
    'مسعف',
  ];

  Future getImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        List<int> imageBytes = imageFile!.readAsBytesSync();
        image = "data:image/png;base64,${base64Encode(imageBytes)}";
        emit(RegistrationChangeNotifier());
      }
    } catch (e) {
      emit(RegistrationFailure("Image cannot be loaded"));
    }
  }

  String? swapRank(String rank) {
    if (rank == 'قائد') {
      return "leader";
    } else if (rank == 'كشاف') {
      return "scout";
    } else if (rank == 'مسعف') {
      return "sought";
    } else {
      return rank;
    }
  }

  Future<void> registrationUser() async {
    try {
      emit(RegistrationLoading());
      String? swapedRank = swapRank(rank!);
      var url = Uri.parse(
          ConstantsService.baseUrl + ConstantsService.registrationEndpoint);

      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            "fullName": fullNameController.text,
            "username": userNameController.text,
            "password": passwordController.text,
            "email": emailController.text,
            "phoneNumber": "963${phoneController.text}",
            "gender": gender!,
            "operations": operations,
            "op_leader": opLeader,
            "location": location!,
            "rank": swapedRank!,
            "image": image!
          }));
      if (response.statusCode == 200) {
        phoneAuth();
      } else {
        throw Exception('invalid-data');
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    }
  }

  String? verification;
  Future phoneAuth() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+963${phoneController.text}",
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          emit(RegistrationFailure(e.code));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verification = verificationId;
        emit(RegistrationSuccess());
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(RegistrationPasswordVisibility());
  }

  int currentStep = 0;
  String? changeCurrentStep(int step) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (step > 0) {
      if (currentStep == 0) {
        if (formKey1.currentState!.validate() && gender != null) {
          currentStep += step;
          emit(RegistrationChangeNotifier());
          return "next";
        } else {
          return "incompleted";
        }
      } else if (currentStep == 1) {
        if (operations != null &&
            opLeader != null &&
            location != null &&
            rank != null) {
          currentStep += step;
          emit(RegistrationChangeNotifier());
          return "next";
        } else {
          return "incompleted";
        }
      } else if (currentStep == 2) {
        if (formKey2.currentState!.validate() && image != null) {
          return "completed";
        } else {
          return "incompleted";
        }
      }
    } else {
      currentStep += step;
      emit(RegistrationChangeNotifier());
      return "back";
    }

    return null;
  }

  void changeRadiogender(dynamic input) {
    gender = input;
    emit(RegistrationChangeNotifier());
  }

  void changeRadioOperations(dynamic input) {
    operations = input;
    emit(RegistrationChangeNotifier());
  }

  void changeRadioOpLeader(dynamic input) {
    opLeader = input;
    emit(RegistrationChangeNotifier());
  }

  void changeLocation(dynamic input) {
    location = input;
    emit(RegistrationChangeNotifier());
  }

  void changeRank(dynamic input) {
    rank = input;
    emit(RegistrationChangeNotifier());
  }
}
