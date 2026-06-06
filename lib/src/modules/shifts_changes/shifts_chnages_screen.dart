import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monawpaty/src/modules/shifts_changes/cubit/shifts_changes_cubit.dart';
import 'package:monawpaty/src/shared/components/components.dart';
import '../../shared/styles/colors.dart';

class ShiftsChangesScreen extends StatelessWidget {
  const ShiftsChangesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => ShiftsChangesCubit(),
      child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocConsumer<ShiftsChangesCubit, ShiftsChangesState>(
            listener: (context, state) {
              if (state is ShiftsChangesLoading) {
                circularProgress(context);
              }
              if (state is ShiftsChangesSuccess) {
                if (state.type == "post") {
                  Navigator.pop(context);
                  showSnackBar(
                      context: context,
                      message: "تم إرسال الطلب بنجاح",
                      duration: 3,
                      icon: Icons.check);
                } else {
                  Navigator.pop(context);
                }
              }
              if (state is ShiftsChangesFailure) {
                Navigator.pop(context);
                showSnackBar(
                    context: context,
                    message: state.error.toString(),
                    duration: 3,
                    icon: Icons.error_outline);
              }
            },
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    leading: Container(),
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    title: const Text(
                      "تعديل المناوبات",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: primaryColor,
                    centerTitle: true,
                  ),
                  body: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              defaultChoiceChip(
                                  width: size.width * 0.35,
                                  label: "إلغاء",
                                  variable: ShiftsChangesCubit.get(context)
                                      .choiceType,
                                  onSelected: (bool selected) {
                                    ShiftsChangesCubit.get(context).choiceType =
                                        (selected ? 'إلغاء' : null);
                                    ShiftsChangesCubit.get(context)
                                        .changeNotifier();
                                  }),
                              defaultChoiceChip(
                                  width: size.width * 0.35,
                                  label: "ترميم",
                                  variable: ShiftsChangesCubit.get(context)
                                      .choiceType,
                                  onSelected: (bool selected) {
                                    ShiftsChangesCubit.get(context).choiceType =
                                        (selected ? 'ترميم' : null);
                                    ShiftsChangesCubit.get(context)
                                        .changeNotifier();
                                  })
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: defaultDropdownButton(
                            height: 45,
                            width: size.width,
                            context: context,
                            choice: ShiftsChangesCubit.get(context).shiftsType,
                            label: "اختر نوع المناوبات",
                            list: [
                              'اسعاف',
                              'عمليات',
                            ],
                            onChange: (String? selected) {
                              ShiftsChangesCubit.get(context).shiftsType =
                                  selected!;
                              ShiftsChangesCubit.get(context).changeNotifier();
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              defaultDropdownButton(
                                  height: 40,
                                  width: 130,
                                  context: context,
                                  choice: ShiftsChangesCubit.get(context)
                                      .selectedShiftTime,
                                  label: "اختر الفترة",
                                  list: [
                                    'الفترة الأولى',
                                    'الفترة الثانية',
                                    'الفترة الثالثة',
                                  ],
                                  onChange: (String? selected) {
                                    ShiftsChangesCubit.get(context)
                                        .selectedShiftTime = selected!;
                                    ShiftsChangesCubit.get(context)
                                        .changeNotifier();
                                  }),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: thirdColor, spreadRadius: 1.4),
                                  ],
                                ),
                                height: 37,
                                width: 130,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ShiftsChangesCubit.get(context)
                                                .selectedDate ==
                                            null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Text(
                                              "اختر التاريخ",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Text(
                                              '${ShiftsChangesCubit.get(context).selectedDate!.day}/${ShiftsChangesCubit.get(context).selectedDate!.month}/${ShiftsChangesCubit.get(context).selectedDate!.year}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                    IconButton(
                                        icon: const Icon(
                                            FontAwesomeIcons.calendarDays),
                                        color: thirdColor,
                                        iconSize: 20,
                                        onPressed: () async {
                                          DateTime? date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  DateTime.now().day),
                                              firstDate: DateTime(2023),
                                              lastDate: DateTime(2030));
                                          if (context.mounted) {
                                            ShiftsChangesCubit.get(context)
                                                .selectedDate = date;
                                            ShiftsChangesCubit.get(context)
                                                .changeNotifier();
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: buildButton(
                            height: 45,
                            fontSize: 16,
                            width: size.width,
                            text: "إرسال",
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            borderColor: primaryColor,
                            function: () async {
                              if (ShiftsChangesCubit
                                              .get(context)
                                          .choiceType !=
                                      null &&
                                  ShiftsChangesCubit.get(context).shiftsType !=
                                      null &&
                                  ShiftsChangesCubit.get(context)
                                          .selectedShiftTime !=
                                      null &&
                                  ShiftsChangesCubit.get(context)
                                          .selectedDate !=
                                      null) {
                                ShiftsChangesCubit.get(context)
                                        .selectedLocation =
                                    await locationDialog(context);
                                if (context.mounted) {
                                  if (ShiftsChangesCubit.get(context)
                                          .selectedLocation !=
                                      null) {
                                    ShiftsChangesCubit.get(context)
                                        .sendRequests(context);
                                  }
                                }
                              } else {
                                showSnackBar(
                                    context: context,
                                    message:
                                        "الرجاء إدخال كافة البيانات المطلوبة",
                                    duration: 3,
                                    icon: Icons.error_outline);
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 5),
                        child: buildButton(
                            height: 45,
                            fontSize: 16,
                            width: size.width * 0.7,
                            text: "حالة الطلبات",
                            backgroundColor: secondaryColor,
                            borderColor: secondaryColor,
                            foregroundColor: Colors.black54,
                            function: () async {
                              if (ShiftsChangesCubit.get(context).choiceType !=
                                  null) {
                                await ShiftsChangesCubit.get(context)
                                    .getStatus()
                                    .then((value) async {
                                  await Future.delayed(
                                      const Duration(milliseconds: 3));
                                  if (context.mounted) {
                                    showModalBottomSheet<void>(
                                        backgroundColor: Colors.white,
                                        context: context,
                                        elevation: 30,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        builder: (context) => value!.isNotEmpty
                                            ? Column(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "حالة الطلبات",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const Divider(
                                                    color: secondaryColor,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10,
                                                            right: 8,
                                                            left: 12.0,
                                                            top: 15),
                                                    child: Row(children: [
                                                      const Text("المركز",
                                                          style: TextStyle(
                                                              color: thirdColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(
                                                          width: size.width *
                                                              0.17),
                                                      const Text("التاريخ",
                                                          style: TextStyle(
                                                              color: thirdColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(
                                                          width: size.width *
                                                              0.17),
                                                      const Text(
                                                          "\t \t \t الفترة",
                                                          style: TextStyle(
                                                              color: thirdColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      const Spacer(),
                                                      const Text("النوع",
                                                          style: TextStyle(
                                                              color: thirdColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ]),
                                                  ),
                                                  Expanded(
                                                    child: Scrollbar(
                                                      thumbVisibility: false,
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          physics:
                                                              const AlwaysScrollableScrollPhysics(),
                                                          itemCount:
                                                              value.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          5),
                                                              color: value[
                                                                          index]
                                                                      .accept!
                                                                  ? Colors
                                                                      .greenAccent
                                                                  : Colors.red,
                                                              width: size.width,
                                                              child: Card(
                                                                  elevation: 0,
                                                                  color: value[
                                                                              index]
                                                                          .accept!
                                                                      ? Colors
                                                                          .greenAccent
                                                                      : Colors
                                                                          .red,
                                                                  child:
                                                                      Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical:
                                                                                  15.0,
                                                                              horizontal:
                                                                                  5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(value[index].location!),
                                                                              Text(value[index].date.toString()),
                                                                              Text(value[index].shiftTime!),
                                                                              Text(value[index].type!),
                                                                            ],
                                                                          ))),
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const Center(
                                                child: Text(
                                                    "ليس لديك طلبات في الفترة الحالية",
                                                    style: TextStyle(
                                                        backgroundColor:
                                                            secondaryColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold))));
                                  }
                                });
                              } else {
                                showSnackBar(
                                    context: context,
                                    message: "قم بتحديد إلغاء أو ترميم",
                                    duration: 3,
                                    icon: Icons.error_outline);
                              }
                            }),
                      ),
                    ],
                  ));
            },
          )),
    );
  }
}
