import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monawpaty/src/modules/profile/change_password/cubit/change_password_cubit.dart';

import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordLoading) {
                FocusManager.instance.primaryFocus?.unfocus();
                circularProgress(context);
              }
              if (state is ChangePasswordSuccess) {
                Navigator.pop(context);
                showSnackBar(
                    context: context,
                    message: "تم تغيير كلمة المرور بنجاح",
                    duration: 3,
                    icon: Icons.check);
              }
              if (state is ChangePasswordFailure) {
                Navigator.pop(context);
                if (state.error.toString() == 'Exception: wrong-password') {
                  showSnackBar(
                      context: context,
                      message: "كلمة المرور القديمة خاطئة",
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
                    title: const Text("تغيير كلمة المرور"),
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
                    key: ChangePasswordCubit.get(context).formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 50),
                            SizedBox(
                              height: 75,
                              child: defaultFormField(
                                  isPassword: true,
                                  controller: ChangePasswordCubit.get(context)
                                      .oldPassController,
                                  type: TextInputType.visiblePassword,
                                  hint: 'كلمة المرور القديمة',
                                  prefix: Icons.lock,
                                  validate: (val) {
                                    if (val!.isEmpty) {
                                      return 'يجب إدخال كلمة المرور';
                                    } else if (val.length < 6) {
                                      return "يجب إدخال 6 محارف على الأقل";
                                    }
                                    return null;
                                  }),
                            ),
                            SizedBox(
                              height: 75,
                              child: defaultFormField(
                                  isPassword: true,
                                  controller: ChangePasswordCubit.get(context)
                                      .newPassController,
                                  type: TextInputType.visiblePassword,
                                  hint: 'كلمة المرور الجديدة',
                                  prefix: Icons.lock,
                                  validate: (val) {
                                    if (val!.isEmpty) {
                                      return 'يجب إدخال كلمة المرور';
                                    } else if (val.length < 6) {
                                      return "يجب إدخال 6 محارف على الأقل";
                                    } else if (val ==
                                        ChangePasswordCubit.get(context)
                                            .oldPassController
                                            .text) {
                                      return "يجب اختيار كلمة مرور أخرى";
                                    }
                                    return null;
                                  }),
                            ),
                            SizedBox(
                              height: 75,
                              child: defaultFormField(
                                  isPassword: true,
                                  controller: ChangePasswordCubit.get(context)
                                      .confirmPassController,
                                  type: TextInputType.visiblePassword,
                                  hint: 'تأكيد كلمة المرور',
                                  prefix: Icons.lock,
                                  validate: (val) {
                                    if (val!.isEmpty) {
                                      return 'يجب إدخال كلمة المرور';
                                    } else if (val !=
                                        ChangePasswordCubit.get(context)
                                            .newPassController
                                            .text) {
                                      return "كلمة المرور غير مطابقة";
                                    }
                                    return null;
                                  }),
                            ),
                            buildButton(
                              width: size.width,
                              text: "تعديل كلمة المرور",
                              backgroundColor: primaryColor,
                              borderColor: primaryColor,
                              foregroundColor: Colors.white,
                              function: () {
                                if (ChangePasswordCubit.get(context)
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  ChangePasswordCubit.get(context).changePass();
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
