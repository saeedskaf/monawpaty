import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monawpaty/src/layout/app_layout.dart';
import 'package:monawpaty/src/modules/login/forgot_password/forgot_password_screen.dart';
import '../../shared/styles/colors.dart';
import '../../shared/components/components.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              circularProgress(context);
            }
            if (state is LoginSuccess) {
              Navigator.pop(context);
              navigateTo(context, const AppLayout());
            }
            if (state is LoginFailure) {
              Navigator.pop(context);
              FocusManager.instance.primaryFocus?.unfocus();
              if (state.error.toString() == 'Exception: invalid-data') {
                showSnackBar(
                    context: context,
                    message: "اسم المستخدم أو كلمة المرور خاطئة",
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
              backgroundColor: secondaryColor,
              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: size.height * 0.4,
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadiusDirectional.vertical(
                        bottom: Radius.circular(
                          25.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, right: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await Future.delayed(
                                const Duration(milliseconds: 100), () {
                              Navigator.pop(context);
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.4 - 30,
                    child: Visibility(
                      visible: !isKeyboard,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 90,
                              width: 90,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/images/logo.png",
                                ),
                              ),
                            ),
                            const Text("تسجيل الدخول",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: !isKeyboard
                                ? size.height * 0.4 - 175
                                : size.height * 0.4 - 250,
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              height: 260,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(
                                    25.0,
                                  ),
                                ),
                              ),
                              child: Form(
                                key: LoginCubit.get(context).formKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const SizedBox(height: 30),
                                      SizedBox(
                                        height: 55,
                                        child: defaultFormField(
                                            controller: LoginCubit.get(context)
                                                .usernameController,
                                            type: TextInputType.text,
                                            hint: 'اسم المستخدم',
                                            prefix: Icons.person,
                                            validate: (val) {
                                              if (val!.isEmpty) {
                                                return 'يجب إدخال اسم المستخدم';
                                              }
                                              return null;
                                            }),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 55,
                                        child: defaultFormField(
                                            controller: LoginCubit.get(context)
                                                .passwordController,
                                            type: TextInputType.visiblePassword,
                                            hint: 'كلمة المرور',
                                            prefix: Icons.lock,
                                            suffix:
                                                LoginCubit.get(context).suffix,
                                            isPassword: LoginCubit.get(context)
                                                .isPassword,
                                            suffixPressed: () {
                                              LoginCubit.get(context)
                                                  .changePasswordVisibility();
                                            },
                                            validate: (val) {
                                              if (val!.isEmpty) {
                                                return 'يجب إدخال كلمة المرور';
                                              }
                                              return null;
                                            }),
                                      ),
                                      const Spacer(),
                                      buildButton(
                                        width: size.width,
                                        text: "تسجيل الدخول",
                                        backgroundColor: primaryColor,
                                        borderColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        function: () {
                                          if (LoginCubit.get(context)
                                              .formKey
                                              .currentState!
                                              .validate()) {
                                            LoginCubit.get(context).loginUser();
                                          }
                                        },
                                      ),
                                      TextButton(
                                          child: const Text(
                                            'هل نسيت كلمة المرور ؟',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 13),
                                          ),
                                          onPressed: () {
                                            navigateTo(context,
                                                const ForgotPasswordScreen());
                                          })
                                    ],
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
