import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monawpaty/src/layout/app_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:monawpaty/src/modules/login/login_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: size.height * 0.5,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadiusDirectional.vertical(
                  bottom: Radius.circular(
                    25.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.5 - 50,
              child: Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(
                        30.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.5 - 75,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 275,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.all(
                      Radius.circular(
                        25.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        const FittedBox(
                            fit: BoxFit.cover,
                            child: Text("أهلاً بك في تطبيق مناوباتي",
                                style: TextStyle(
                                    color: thirdColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22))),
                        const FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                                "احجز مناوباتك الآن وابدأ بمساعدة الاخرين",
                                style: TextStyle(
                                    color: thirdColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18))),
                        const Spacer(
                          flex: 1,
                        ),
                        buildButton(
                          width: size.width,
                          text: "تسجيل الدخول",
                          backgroundColor: primaryColor,
                          borderColor: primaryColor,
                          foregroundColor: Colors.white,
                          function: () {
                            navigateTo(context, const LoginScreen());
                          },
                        ),
                        const SizedBox(height: 12),
                        buildButton(
                          width: size.width,
                          text: "الصفحة الرئيسية",
                          backgroundColor: Colors.white,
                          borderColor: primaryColor,
                          foregroundColor: primaryColor,
                          function: () {
                            navigateTo(context, const AppLayout());
                          },
                        ),
                        const Spacer(
                          flex: 2,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 20,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                        fontFamily: GoogleFonts.cairo().fontFamily,
                        color: Colors.black,
                        fontSize: 13),
                    children: <TextSpan>[
                      const TextSpan(text: 'بالمتابعة فإنك توافق على  '),
                      TextSpan(
                          text: 'الشروط والأحكام',
                          style: const TextStyle(
                              color: primaryColor, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              var url = Uri.parse(
                                  "https://github.com/SaeedAlskaf/sarc-privacy/blob/main/privacy-policy.md");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            }),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
