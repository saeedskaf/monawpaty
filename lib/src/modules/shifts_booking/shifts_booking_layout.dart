import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monawpaty/src/modules/shifts_booking/pages/booking_page/booking_screen.dart';
import 'package:monawpaty/src/modules/shifts_booking/pages/booking_page/cubit/booking_cubit.dart';
import 'package:monawpaty/src/modules/shifts_booking/pages/shifts_page/cubit/shifts_cubit.dart';
import 'package:monawpaty/src/modules/shifts_booking/pages/shifts_page/shifts_screen.dart';
import '../../shared/styles/colors.dart';

class ShiftsBookingLayout extends StatelessWidget {
  const ShiftsBookingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookingCubit(),
        ),
        BlocProvider(
          create: (context) => ShiftsCubit(),
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              leading: Container(),
              bottom: const TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 5,
                tabs: [
                  Tab(child: Icon(FontAwesomeIcons.solidSquarePlus, size: 25)),
                  Tab(
                      child:
                          Icon(FontAwesomeIcons.squareArrowUpRight, size: 25)),
                ],
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              title: const Text(
                "حجز مناوبات",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: primaryColor,
              centerTitle: true,
            ),
            body:
                const TabBarView(children: [BookingScreen(), ShiftsScreen()])),
      ),
    );
  }
}
