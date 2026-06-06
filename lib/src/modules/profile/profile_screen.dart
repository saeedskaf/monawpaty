import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monawpaty/src/modules/profile/change_password/change_password_screen.dart';
import 'package:monawpaty/src/modules/profile/cubit/profile_cubit.dart';
import 'package:monawpaty/src/modules/profile/my_shfits/my_shifts_screen.dart';
import 'package:monawpaty/src/modules/welcome/welcome_screen.dart';
import 'package:monawpaty/src/shared/app_info.dart';
import 'package:monawpaty/src/shared/components/components.dart';
import '../../../core/locator.dart';
import '../../../core/shared_prefrence_repository.dart';
import '../../shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileData(context),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                    leading: Container(),
                    backgroundColor: Colors.transparent,
                    expandedHeight: 375,
                    flexibleSpace: FlexibleSpaceBar(
                        background: Stack(children: [
                      Container(
                        color: Colors.grey,
                        width: size.width,
                        height: 260,
                        child: Image.asset("assets/images/IMG_4021.png",
                            fit: BoxFit.fill),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 200.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: CircleAvatar(
                                  backgroundColor: secondaryColor,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6, right: 6),
                                      child: Image.asset(
                                          "assets/images/profile.png"),
                                    ),
                                  ),
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.cairo().fontFamily,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${ProfileCubit.get(context).fullName} \n'),
                                    TextSpan(
                                      text: ProfileCubit.get(context).rank,
                                      style: const TextStyle(
                                          color: thirdColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]))),
                SliverAppBar(
                    leading: Container(),
                    backgroundColor: primaryColor,
                    pinned: false,
                    snap: false,
                    floating: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                          margin: const EdgeInsets.only(top: 15),
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Text(
                                    "مناوبات الإسعاف",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ProfileCubit.get(context).ambulanceShifts ==
                                            null
                                        ? ""
                                        : ProfileCubit.get(context)
                                            .ambulanceShifts!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  const Text(
                                    "مناوبات العمليات",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    ProfileCubit.get(context).operationShifts ==
                                            null
                                        ? ""
                                        : ProfileCubit.get(context)
                                            .operationShifts!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    )),
                SliverList(
                    delegate: SliverChildListDelegate([
                  const SizedBox(height: 15.0),
                  Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.calendar_month_rounded,
                            color: primaryColor,
                          ),
                          title: const Text("مناوباتي الشهرية"),
                          trailing: const Icon(Icons.keyboard_arrow_left),
                          onTap: () {
                            navigateTo(context, const MyShiftsScreen());
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(
                            Icons.warning_amber_sharp,
                            color: primaryColor,
                          ),
                          title: const Text("حول التطبيق"),
                          trailing: const Icon(Icons.keyboard_arrow_left),
                          onTap: () {
                            navigateTo(context, const AppInfo());
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(
                            Icons.key,
                            color: primaryColor,
                          ),
                          title: const Text("تغيير كلمة المرور"),
                          trailing: const Icon(Icons.keyboard_arrow_left),
                          onTap: () {
                            navigateTo(context, const ChangePasswordScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 3.0,
                    margin: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            color: primaryColor,
                          ),
                          title: const Text("تسجيل الخروج"),
                          onTap: () {
                            locator<SharedPreferencesRepository>().logout();
                            navigateAndFinish(context, const WelcomeScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.45,
                  )
                ]))
              ]),
            );
          },
        ),
      ),
    );
  }
}

Container _buildDivider() {
  return Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    width: double.infinity,
    height: 1.5,
    color: secondaryColor,
  );
}
