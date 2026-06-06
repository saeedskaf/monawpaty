import 'package:flutter/material.dart';
import 'package:monawpaty/core/locator.dart';
import 'package:monawpaty/core/shared_prefrence_repository.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../shared/components/components.dart';
import '../welcome/welcome_screen.dart';

var pageController = PageController();

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: PageView(
          controller: pageController,
          children: [
            boardPage(
                'assets/images/2.jpg',
                'أهلا بك في تطبيق مناوباتي',
                'استمر معنا ليتم اطلاعك عل جميع \n التعديلات الجديدة',
                pageController,
                false,
                context),
            boardPage(
                'assets/images/3.jpg',
                'تسجيل مناوبات onCall',
                'أصبح بإمكان جميع المسعفين تسجيل مناوبات onCall لتسجيل المناوبات التي لم يتمكن المسعف من حجزها في فترة الحجز المخصصة',
                pageController,
                false,
                context),
            // boardPage(
            //     'assets/images/3.jpg',
            //     'مرحلة تسجيل الدخول',
            //     'يجب عل كل المسعفين القيام بإدخال جميع المعلومات  المطلوبة ( معلومات شخصية - تاكيد عن طريق الرمز - صورة البطاقة التعريفية ) لإتمام عملية تسجيل الدخول بشكلها الصحيح',
            //     pageController,
            //     false,
            //     context),
            boardPage(
                'assets/images/4.jpg',
                'الإشعارات',
                'تم توفير ميزة الاشعارات في هذه النسخة حيث يتم ارسال رسائل خاصة للمسعفين في حالات معينة مثل  موعد المناوبة - قبول او رفض طلب ترميم - تعميم',
                pageController,
                true,
                context),
          ],
        ),
      ),
    );
  }
}

boardPage(String imgPath, String title, String desc, PageController controller,
        bool islast, BuildContext context) =>
    Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                imgPath,
              ),
              fit: BoxFit.cover,
              colorFilter: const ColorFilter.mode(
                  Colors.black45, BlendMode.luminosity))),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            desc,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildButton(
              fontSize: 15,
              radius: 50,
              height: 50,
              width: 120,
              text: "تجاهل",
              backgroundColor: Colors.red[600]!,
              borderColor: Colors.red[600]!,
              foregroundColor: Colors.black,
              function: () {
                locator
                    .get<SharedPreferencesRepository>()
                    .savedata(key: 'on_board', value: true)
                    .whenComplete(() =>
                        navigateAndFinish(context, const WelcomeScreen()));
              },
            ),
            buildButton(
              fontSize: islast ? 13 : 14,
              radius: 50,
              height: 50,
              width: 120,
              text: islast ? "الصفحة الرئيسية" : "التالي",
              backgroundColor: Colors.red[600]!,
              borderColor: Colors.red[600]!,
              foregroundColor: Colors.black,
              function: () {
                if (islast) {
                  locator
                      .get<SharedPreferencesRepository>()
                      .savedata(key: 'on_board', value: true)
                      .whenComplete(() =>
                          navigateAndFinish(context, const WelcomeScreen()));
                } else {
                  controller.nextPage(
                      duration: const Duration(microseconds: 500),
                      curve: Curves.easeInOut);
                }
              },
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SmoothPageIndicator(
          controller: controller,
          count: 3,
          effect: ExpandingDotsEffect(
              dotColor: Colors.grey,
              expansionFactor: 4,
              dotWidth: 10,
              spacing: 5,
              activeDotColor: Colors.red[600]!),
        ),
      ]),
    );
