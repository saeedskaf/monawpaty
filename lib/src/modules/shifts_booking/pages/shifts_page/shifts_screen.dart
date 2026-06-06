import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monawpaty/src/modules/shifts_booking/pages/booking_page/cubit/booking_cubit.dart';
import 'package:monawpaty/src/modules/shifts_booking/pages/shifts_page/cubit/shifts_cubit.dart';
import 'package:monawpaty/src/shared/styles/colors.dart';
import '../../../../shared/components/components.dart';

class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<ShiftsCubit, ShiftsState>(
      listener: (context, state) {
        if (state is ShiftsLoading) {
          circularProgress(context);
        }
        if (state is ShiftsSuccess) {
          Navigator.pop(context);
          showSnackBar(
              context: context,
              message: "تم حجز المناوبات بنجاح",
              duration: 3,
              icon: Icons.check);
        }
        if (state is ShiftsFailure) {
          Navigator.pop(context);
          showSnackBar(
              context: context,
              message: state.error.toString(),
              duration: 3,
              icon: Icons.error_outline);
        }
      },
      builder: (context, state) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                body: BookingCubit.get(context).shiftsList.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            const Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 4.0, top: 10),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("الرقم",
                                          style: TextStyle(
                                              color: thirdColor,
                                              fontWeight: FontWeight.bold)),
                                      Text("التاريخ       ",
                                          style: TextStyle(
                                              color: thirdColor,
                                              fontWeight: FontWeight.bold)),
                                      Text("الفترة      ",
                                          style: TextStyle(
                                              color: thirdColor,
                                              fontWeight: FontWeight.bold)),
                                      Text("حذف ",
                                          style: TextStyle(
                                              color: thirdColor,
                                              fontWeight: FontWeight.bold)),
                                    ])),
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility: false,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: BookingCubit.get(context)
                                        .shiftsList
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                          child: Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text((index + 1).toString()),
                                                  Text(
                                                      BookingCubit.get(context)
                                                          .shiftsList[index]
                                                          .date!,
                                                      style: const TextStyle(
                                                          fontSize: 13)),
                                                  Text(
                                                      BookingCubit.get(context)
                                                          .shiftsList[index]
                                                          .shiftTime!,
                                                      style: const TextStyle(
                                                          fontSize: 13)),
                                                  IconButton(
                                                      icon: const Icon(
                                                        Icons.delete,
                                                      ),
                                                      iconSize: 20,
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        BookingCubit.get(
                                                                context)
                                                            .shiftsList
                                                            .removeAt(index);
                                                        ShiftsCubit.get(context)
                                                            .changeNotifier();
                                                      }),
                                                ],
                                              )));
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildButton(
                                      height: 45,
                                      fontSize: 16,
                                      width: size.width * 0.4,
                                      text: "تسجيل",
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      borderColor: primaryColor,
                                      function: () async {
                                        BookingCubit.get(context)
                                                .selectedLocation =
                                            await locationDialog(context);
                                        if (context.mounted) {
                                          if (BookingCubit.get(context)
                                                  .selectedLocation !=
                                              null) {
                                            if (BookingCubit.get(context)
                                                    .choiceType !=
                                                null) {
                                              ShiftsCubit.get(context)
                                                  .sendShifts(context);
                                            } else {
                                              showSnackBar(
                                                  context: context,
                                                  message:
                                                      "قم بتحديد نوع المناوبات",
                                                  duration: 3,
                                                  icon: Icons.error_outline);
                                            }
                                          }
                                        }
                                      }),
                                  buildButton(
                                      height: 45,
                                      fontSize: 16,
                                      width: size.width * 0.4,
                                      text: "OnCall",
                                      backgroundColor: secondaryColor,
                                      foregroundColor: Colors.black54,
                                      borderColor: secondaryColor,
                                      function: () async {
                                        BookingCubit.get(context)
                                                .selectedLocation =
                                            await locationDialog(context);
                                        if (context.mounted) {
                                          if (BookingCubit.get(context)
                                                  .selectedLocation !=
                                              null) {
                                            if (BookingCubit.get(context)
                                                    .choiceType !=
                                                null) {
                                              ShiftsCubit.get(context)
                                                  .onCall(context);
                                            } else {
                                              showSnackBar(
                                                  context: context,
                                                  message:
                                                      "قم بتحديد نوع المناوبات",
                                                  duration: 3,
                                                  icon: Icons.error_outline);
                                            }
                                          }
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ])
                    : const Center(
                        child: Text('قم بإضافة المناوبات أولاً',
                            style: TextStyle(
                                backgroundColor: secondaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)))));
      },
    );
  }
}
