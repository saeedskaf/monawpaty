import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monawpaty/core/locator.dart';
import 'package:monawpaty/src/layout/app_layout.dart';
import 'package:monawpaty/src/modules/on_board/on_board_screen.dart';
import 'package:monawpaty/src/modules/welcome/welcome_screen.dart';
import 'package:monawpaty/src/shared/bloc_observer.dart';
import 'core/shared_prefrence_repository.dart';
import 'src/shared/styles/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  await setupLocator();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  nextScreen = await initialization();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

Future<Widget> initialization() async {
  Widget nextScreen;
  bool? onboard =
      locator.get<SharedPreferencesRepository>().getData(key: 'on_board');
  bool isLoggedIn = locator.get<SharedPreferencesRepository>().getLoggedIn();

  if (onboard != null && isLoggedIn) {
    nextScreen = const AppLayout();
  } else if (onboard != null && !isLoggedIn) {
    nextScreen = const WelcomeScreen();
  } else {
    nextScreen = const OnBoardScreen();
  }
  await Future.delayed(const Duration(seconds: 2));
  return nextScreen;
}

late Widget nextScreen;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        color: primaryColor,
        debugShowCheckedModeBanner: false,
        title: 'Monawpaty',
        theme: ThemeData(
          fontFamily: GoogleFonts.cairo().fontFamily,
          primarySwatch: Colors.red,
        ),
        home: nextScreen);
  }
}
