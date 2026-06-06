import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monawpaty/src/modules/login/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:monawpaty/src/modules/otp/otp_screen.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => ForgotPasswordCubit(),
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordLoading) {
                FocusManager.instance.primaryFocus?.unfocus();
                circularProgress(context);
              }
              if (state is ForgotPasswordSuccess) {
                Navigator.pop(context);
                navigateTo(
                    context,
                    OtpScreen(
                        verificationId: "",
                        contact: ForgotPasswordCubit.get(context)
                            .emailController
                            .text));
              }
              if (state is ForgotPasswordFailure) {
                Navigator.pop(context);
                if (state.error.toString() == 'Exception: invalid-data') {
                  showSnackBar(
                      context: context,
                      message: "البريد الكتروني غير مطابق لبياناتك",
                      duration: 3,
                      icon: Icons.error_outline);
                } else {
                  showSnackBar(
                      context: context,
                      message: "الرجاء المحاولة لاحقا",
                      duration: 3,
                      icon: Icons.error_outline);
                }
              }
            },
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: Colors.white),
                    title: const Text("استعادة كلمة المرور"),
                    titleTextStyle: TextStyle(
                        fontFamily: GoogleFonts.cairo().fontFamily,
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    backgroundColor: primaryColor,
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                      child: Form(
                    key: ForgotPasswordCubit.get(context).formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 50),
                            SizedBox(
                              height: 70,
                              child: defaultFormField(
                                  controller: ForgotPasswordCubit.get(context)
                                      .emailController,
                                  type: TextInputType.emailAddress,
                                  hint: 'البريد الالكتروني',
                                  prefix: Icons.mail,
                                  validate: (val) {
                                    if (val!.isEmpty) {
                                      return 'يجب إدخال البريد الالكتروني';
                                    } else if (!EmailValidator.validate(val)) {
                                      return 'البريد الالكتروني غير صالح';
                                    }
                                    return null;
                                  }),
                            ),
                            buildButton(
                              width: size.width,
                              text: "إرسال",
                              backgroundColor: primaryColor,
                              borderColor: primaryColor,
                              foregroundColor: Colors.white,
                              function: () {
                                if (ForgotPasswordCubit.get(context)
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  ForgotPasswordCubit.get(context).passReset();
                                }
                              },
                            ),
                          ]),
                    ),
                  )));
            },
          )),
    );
  }
}
