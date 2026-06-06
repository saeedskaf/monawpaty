import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monawpaty/src/layout/cubit/layout_cubit.dart';
import '../../core/locator.dart';
import '../../core/shared_prefrence_repository.dart';
import '../shared/styles/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit()..getResId(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<LayoutCubit, LayoutState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                body: LayoutCubit.get(context)
                    .screens[LayoutCubit.get(context).selectedScreenIndex],
                bottomNavigationBar: Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.white),
                  child: BottomNavigationBar(
                    unselectedItemColor: secondaryColor,
                    selectedItemColor: primaryColor,
                    currentIndex: LayoutCubit.get(context).selectedScreenIndex,
                    onTap: (index) {
                      if (locator<SharedPreferencesRepository>()
                          .getLoggedIn()) {
                        LayoutCubit.get(context).changeScreen(index);
                      } else {
                        Fluttertoast.showToast(
                            msg: "قم بتسجيل الدخول أولاً",
                            gravity: ToastGravity.BOTTOM);
                      }
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.house),
                          label: 'الصفحة الرئيسية'),
                      BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.solidCalendarCheck),
                          label: "حجز مناوبات"),
                      BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.solidCalendarXmark),
                          label: "تعديل المناوبات"),
                      BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.solidUser),
                          label: "حسابي")
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }
}
