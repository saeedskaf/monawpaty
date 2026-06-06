import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monawpaty/src/modules/profile/my_shfits/cubit/my_shifts_cubit.dart';
import 'package:monawpaty/src/shared/components/month_year_picker.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class MyShiftsScreen extends StatelessWidget {
  const MyShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => MyShiftsCubit()..getMyShiftsInitial(),
      child: Directionality(
          textDirection: TextDirection.ltr,
          child: BlocConsumer<MyShiftsCubit, MyShiftsState>(
            listener: (context, state) {
              if (state is MyShiftsLoading) {
                circularProgress(context);
              }
              if (state is MyShiftsSuccess) {
                Navigator.pop(context);
              }
              if (state is MyShiftsFailure) {
                Navigator.pop(context);

                showSnackBar(
                    context: context,
                    message: "الرجاء المحاولة لاحقا",
                    duration: 3,
                    icon: Icons.error_outline);
              }
            },
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_forward))
                    ],
                    leadingWidth: 175,
                    leading: MonthYearPicker(
                      onDateTimeChanged: (DateTime dateTime) {
                        MyShiftsCubit.get(context).selectedDate =
                            "${dateTime.year}-${dateTime.month}";

                        MyShiftsCubit.get(context).getMyReservations();
                      },
                    ),
                    backgroundColor: thirdColor,
                  ),
                  body: MyShiftsCubit.get(context).myReservations.isNotEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 12.0, top: 10),
                              child: Row(children: [
                                const Text("المركز",
                                    style: TextStyle(
                                        color: thirdColor,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: size.width * 0.17),
                                const Text("التاريخ",
                                    style: TextStyle(
                                        color: thirdColor,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: size.width * 0.17),
                                const Text("  \t \t \t  الفترة",
                                    style: TextStyle(
                                        color: thirdColor,
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                const Text("النوع",
                                    style: TextStyle(
                                        color: thirdColor,
                                        fontWeight: FontWeight.bold)),
                              ]),
                            ),
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility: false,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: MyShiftsCubit.get(context)
                                        .myReservations
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      MyShiftsCubit.get(context)
                                                          .myReservations[index]
                                                          .location!),
                                                  Text(
                                                      MyShiftsCubit.get(context)
                                                          .myReservations[index]
                                                          .date
                                                          .toString()),
                                                  Text(
                                                      MyShiftsCubit.get(context)
                                                          .myReservations[index]
                                                          .shiftTime!),
                                                  MyShiftsCubit.get(context)
                                                              .myReservations[
                                                                  index]
                                                              .id ==
                                                          1
                                                      ? const Text("اسعاف")
                                                      : const Text("عمليات")
                                                ],
                                              )));
                                    }),
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: Text("ليس لديك مناوبات في هذا الشهر",
                              style: TextStyle(
                                  backgroundColor: secondaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))));
            },
          )),
    );
  }
}
