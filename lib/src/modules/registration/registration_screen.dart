import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:monawpaty/src/modules/otp/otp_screen.dart';
import '../../shared/styles/colors.dart';
import '../../shared/components/components.dart';
import 'cubit/registration_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    var size = MediaQuery.of(context).size;

    List<Step> getSteps() => [
          Step(
              state: RegistrationCubit.get(context).currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
              title: const Text(""),
              content: Form(
                key: RegistrationCubit.get(context).formKey1,
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: defaultFormField(
                          controller:
                              RegistrationCubit.get(context).fullNameController,
                          type: TextInputType.text,
                          hint: 'الاسم الكامل',
                          prefix: FontAwesomeIcons.solidIdCard,
                          validate: (val) {
                            if (val!.isEmpty) {
                              return 'يجب إدخال الاسم الكامل';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      height: 60,
                      child: defaultFormField(
                          controller:
                              RegistrationCubit.get(context).emailController,
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
                    const SizedBox(
                      height: 4,
                    ),
                    SizedBox(
                      height: 60,
                      child: defaultFormField(
                          controller:
                              RegistrationCubit.get(context).userNameController,
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
                      height: 4,
                    ),
                    SizedBox(
                      height: 60,
                      child: defaultFormField(
                          controller:
                              RegistrationCubit.get(context).passwordController,
                          type: TextInputType.visiblePassword,
                          hint: 'كلمة المرور',
                          prefix: Icons.lock,
                          suffix: RegistrationCubit.get(context).suffix,
                          isPassword: RegistrationCubit.get(context).isPassword,
                          suffixPressed: () {
                            RegistrationCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (val) {
                            if (val!.isEmpty) {
                              return 'يجب إدخال كلمة المرور';
                            } else if (val.length < 6) {
                              return "يجب إدخال 6 محارف على الأقل";
                            }
                            return null;
                          }),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Radio(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return primaryColor;
                            }
                            return Colors.black54;
                          }),
                          value: "male",
                          groupValue: RegistrationCubit.get(context).gender,
                          onChanged: (value) {
                            RegistrationCubit.get(context)
                                .changeRadiogender(value);
                          },
                        ),
                        const Text(
                          "ذكر",
                          style: TextStyle(fontSize: 15),
                        ),
                        const Spacer(),
                        Radio(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return primaryColor;
                            }
                            return Colors.black54;
                          }),
                          value: "female",
                          groupValue: RegistrationCubit.get(context).gender,
                          onChanged: (value) {
                            RegistrationCubit.get(context)
                                .changeRadiogender(value);
                          },
                        ),
                        const Text(
                          "أنثى",
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(width: 16),
                        const Spacer()
                      ],
                    )
                  ],
                ),
              ),
              isActive: RegistrationCubit.get(context).currentStep >= 0),
          Step(
              state: RegistrationCubit.get(context).currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
              title: const Text(""),
              content: Column(
                children: [
                  const FittedBox(
                      fit: BoxFit.cover,
                      child: Text("■ هل لديك السماحية بحجز مناوبات عمليات :   ",
                          style: TextStyle(
                              color: thirdColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 20))),
                  Row(
                    children: [
                      const Spacer(),
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return primaryColor;
                          }
                          return Colors.black54;
                        }),
                        value: true,
                        groupValue: RegistrationCubit.get(context).operations,
                        onChanged: (value) {
                          RegistrationCubit.get(context)
                              .changeRadioOperations(value);
                        },
                      ),
                      const Text(
                        "نعم",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return primaryColor;
                          }
                          return Colors.black54;
                        }),
                        value: false,
                        groupValue: RegistrationCubit.get(context).operations,
                        onChanged: (value) {
                          RegistrationCubit.get(context)
                              .changeRadioOperations(value);
                        },
                      ),
                      const Text(
                        "لا",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 20),
                  const FittedBox(
                      fit: BoxFit.cover,
                      child: Text("■ هل لديك السماحية بحجز مناوبات قائد قطاع :",
                          style: TextStyle(
                              color: thirdColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 20))),
                  Row(
                    children: [
                      const Spacer(),
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return primaryColor;
                          }
                          return Colors.black54;
                        }),
                        value: true,
                        groupValue: RegistrationCubit.get(context).opLeader,
                        onChanged: (value) {
                          RegistrationCubit.get(context)
                              .changeRadioOpLeader(value);
                        },
                      ),
                      const Text(
                        "نعم",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      Radio(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return primaryColor;
                          }
                          return Colors.black54;
                        }),
                        value: false,
                        groupValue: RegistrationCubit.get(context).opLeader,
                        onChanged: (value) {
                          RegistrationCubit.get(context)
                              .changeRadioOpLeader(value);
                        },
                      ),
                      const Text(
                        "لا",
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer()
                    ],
                  ),
                  const SizedBox(height: 20),
                  const FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                          "■ قم باختيار المركز التابع إليه والرتبة  :               ",
                          style: TextStyle(
                              color: thirdColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 20))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      defaultDropdownButton(
                          context: context,
                          choice: RegistrationCubit.get(context).location,
                          label: "المركز",
                          list: RegistrationCubit.get(context).locationList,
                          onChange: (val) {
                            RegistrationCubit.get(context).changeLocation(val);
                          }),
                      const SizedBox(width: 10),
                      defaultDropdownButton(
                          context: context,
                          choice: RegistrationCubit.get(context).rank,
                          label: "الرتبة",
                          list: RegistrationCubit.get(context).rankList,
                          onChange: (val) {
                            RegistrationCubit.get(context).changeRank(val);
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
              isActive: RegistrationCubit.get(context).currentStep >= 1),
          Step(
              state: RegistrationCubit.get(context).currentStep > 2
                  ? StepState.complete
                  : StepState.indexed,
              title: const Text(""),
              content: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(2),
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: RegistrationCubit.get(context).image == null
                                ? thirdColor
                                : Colors.greenAccent),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset('assets/images/press-card.png',
                          fit: BoxFit.fill)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildButton(
                          height: 35,
                          fontSize: 14,
                          radius: 5,
                          width: 100,
                          text: "اختيار",
                          backgroundColor: secondaryColor,
                          borderColor: secondaryColor,
                          foregroundColor: Colors.black54,
                          function: () {
                            RegistrationCubit.get(context).getImage();
                          },
                        ),
                        buildButton(
                          height: 35,
                          fontSize: 14,
                          radius: 5,
                          width: 100,
                          text: "تعليمات",
                          backgroundColor: secondaryColor,
                          borderColor: secondaryColor,
                          foregroundColor: Colors.black54,
                          function: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Form(
                    key: RegistrationCubit.get(context).formKey2,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 90,
                        child: IntlPhoneField(
                          controller:
                              RegistrationCubit.get(context).phoneController,
                          disableLengthCheck: true,
                          invalidNumberMessage: "رقم الموبايل غير صالح",
                          decoration: InputDecoration(
                            labelText: ' \t \t \t رقم الموبايل',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: GoogleFonts.cairo().fontFamily,
                                fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: thirdColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                          initialCountryCode: 'SY',
                          validator: (phone) {
                            if (phone!.completeNumber.length != 13) {
                              return "رقم الموبايل غير صالح";
                            } else if (phone.completeNumber[4] != '9') {
                              return "رقم الموبايل غير صالح";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              isActive: RegistrationCubit.get(context).currentStep >= 1),
        ];

    return BlocConsumer<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationLoading) {
          circularProgress(context);
        }
        if (state is RegistrationSuccess) {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        verificationId:
                            RegistrationCubit.get(context).verification!,
                        contact:
                            RegistrationCubit.get(context).phoneController.text,
                      )));
        }
        if (state is RegistrationFailure) {
          Navigator.pop(context);
          FocusManager.instance.primaryFocus?.unfocus();
          if (state.error.toString() == 'Exception: invalid-data') {
            showSnackBar(
                context: context,
                message: "الرجاء التأكد من صحة البيانات",
                duration: 3,
                icon: Icons.error_outline);
          } else if (state.error.toString() == 'invalid-phone-number') {
            showSnackBar(
                context: context,
                message: "رقم الموبايل غير صالح",
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
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
                          const Text("تسجيل إشتراك",
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
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            height: 455,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(
                                  25.0,
                                ),
                              ),
                            ),
                            child: Theme(
                              data: ThemeData(
                                  fontFamily: GoogleFonts.cairo().fontFamily,
                                  primarySwatch: Colors.red,
                                  canvasColor: Colors.transparent,
                                  colorScheme: const ColorScheme.light(
                                      primary: primaryColor)),
                              child: Stepper(
                                physics: const NeverScrollableScrollPhysics(),
                                type: StepperType.horizontal,
                                elevation: 0,
                                steps: getSteps(),
                                currentStep:
                                    RegistrationCubit.get(context).currentStep,
                                controlsBuilder: (BuildContext context,
                                    ControlsDetails controls) {
                                  final isLastStep =
                                      RegistrationCubit.get(context)
                                              .currentStep ==
                                          getSteps().length - 1;
                                  return Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: buildButton(
                                            height: 38,
                                            fontSize: 16,
                                            radius: 5,
                                            width: size.width,
                                            text:
                                                isLastStep ? "تأكيد" : "التالي",
                                            backgroundColor: primaryColor,
                                            borderColor: primaryColor,
                                            foregroundColor: Colors.white,
                                            function: () {
                                              String? status =
                                                  RegistrationCubit.get(context)
                                                      .changeCurrentStep(1);
                                              if (status == "completed") {
                                                RegistrationCubit.get(context)
                                                    .registrationUser();
                                              } else if (status ==
                                                  "incompleted") {
                                                showSnackBar(
                                                    context: context,
                                                    message:
                                                        "يجب إدخال كافة البيانات المطلوبة",
                                                    duration: 3,
                                                    icon: Icons.error_outline);
                                              }
                                            }),
                                      ),
                                      if (RegistrationCubit.get(context)
                                              .currentStep !=
                                          0)
                                        const SizedBox(width: 12),
                                      if (RegistrationCubit.get(context)
                                              .currentStep !=
                                          0)
                                        Expanded(
                                          child: buildButton(
                                            height: 38,
                                            fontSize: 16,
                                            radius: 5,
                                            width: size.width,
                                            text: "رجوع",
                                            backgroundColor: secondaryColor,
                                            borderColor: secondaryColor,
                                            foregroundColor: Colors.black54,
                                            function: () {
                                              RegistrationCubit.get(context)
                                                  .changeCurrentStep(-1);
                                            },
                                          ),
                                        ),
                                    ],
                                  );
                                },
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
          ),
        );
      },
    );
  }
}
