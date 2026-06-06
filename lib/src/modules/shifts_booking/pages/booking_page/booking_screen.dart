import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:monawpaty/src/models/shift.dart';
import 'package:monawpaty/src/modules/shifts_booking/pages/booking_page/cubit/booking_cubit.dart';
import 'package:monawpaty/src/shared/components/components.dart';
import '../../../../shared/styles/colors.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingLoading) {
          circularProgress(context);
        }
        if (state is BookingSuccess) {
          Navigator.pop(context);
        }
        if (state is BookingFailure) {
          Navigator.pop(context);
          showSnackBar(
              context: context,
              message: "الرجاء المحاولة لاحقا",
              duration: 3,
              icon: Icons.error_outline);
        }
      },
      builder: (context, state) {
        return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          defaultChoiceChip(
                              width: size.width * 0.35,
                              label: "اسعاف",
                              variable: BookingCubit.get(context).choiceType,
                              onSelected: (bool selected) {
                                BookingCubit.get(context).selectedWeek = null;
                                BookingCubit.get(context).tableShifts =
                                    List<String>.generate(28, (i) {
                                  return "";
                                });
                                BookingCubit.get(context).choiceType =
                                    (selected ? 'اسعاف' : null);
                                BookingCubit.get(context).changeNotifier();
                              }),
                          defaultChoiceChip(
                              width: size.width * 0.35,
                              label: "عمليات",
                              variable: BookingCubit.get(context).choiceType,
                              onSelected: (bool selected) {
                                BookingCubit.get(context).selectedWeek = null;
                                BookingCubit.get(context).tableShifts =
                                    List<String>.generate(28, (i) {
                                  return "";
                                });
                                BookingCubit.get(context).choiceType =
                                    (selected ? 'عمليات' : null);
                                BookingCubit.get(context).changeNotifier();
                              })
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: defaultDropdownButton(
                        height: 45,
                        width: size.width,
                        context: context,
                        choice: BookingCubit.get(context).selectedWeek,
                        label: "اختر الأسبوع",
                        list: [
                          'الأسبوع الأول',
                          'الأسبوع الثاني',
                          'الأسبوع الثالث',
                          'الأسبوع الرابع',
                          'الأسبوع الخامس',
                        ],
                        onChange: (String? selected) {
                          if (BookingCubit.get(context).choiceType == null) {
                            showSnackBar(
                                context: context,
                                message: "يجب تحديد نوع المناوبات",
                                duration: 3,
                                icon: Icons.error_outline);
                          } else {
                            BookingCubit.get(context).selectedWeek = selected!;
                            BookingCubit.get(context).changeNotifier();
                            BookingCubit.get(context).loadTableShifts();
                          }
                        }),
                  ),
                  Container(
                      width: size.width,
                      margin: const EdgeInsets.all(10),
                      child: Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FractionColumnWidth(0.15),
                          1: FractionColumnWidth(0.283),
                          2: FractionColumnWidth(0.283),
                          3: FractionColumnWidth(0.283),
                        },
                        children: <TableRow>[
                          headerTableRow(),
                          tableRow(
                              BookingCubit.get(context).tableShifts[0],
                              BookingCubit.get(context).tableShifts[1],
                              BookingCubit.get(context).tableShifts[2],
                              BookingCubit.get(context).tableShifts[3]),
                          tableRow(
                              BookingCubit.get(context).tableShifts[4],
                              BookingCubit.get(context).tableShifts[5],
                              BookingCubit.get(context).tableShifts[6],
                              BookingCubit.get(context).tableShifts[7]),
                          tableRow(
                              BookingCubit.get(context).tableShifts[8],
                              BookingCubit.get(context).tableShifts[9],
                              BookingCubit.get(context).tableShifts[10],
                              BookingCubit.get(context).tableShifts[11]),
                          tableRow(
                              BookingCubit.get(context).tableShifts[12],
                              BookingCubit.get(context).tableShifts[13],
                              BookingCubit.get(context).tableShifts[14],
                              BookingCubit.get(context).tableShifts[15]),
                          tableRow(
                              BookingCubit.get(context).tableShifts[16],
                              BookingCubit.get(context).tableShifts[17],
                              BookingCubit.get(context).tableShifts[18],
                              BookingCubit.get(context).tableShifts[19]),
                          tableRow(
                              BookingCubit.get(context).tableShifts[20],
                              BookingCubit.get(context).tableShifts[21],
                              BookingCubit.get(context).tableShifts[22],
                              BookingCubit.get(context).tableShifts[23]),
                          tableRow(
                              BookingCubit.get(context).tableShifts[24],
                              BookingCubit.get(context).tableShifts[25],
                              BookingCubit.get(context).tableShifts[26],
                              BookingCubit.get(context).tableShifts[27])
                        ],
                      )),
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
                              choice:
                                  BookingCubit.get(context).selectedShiftTime,
                              label: "اختر الفترة",
                              list: [
                                'الفترة الأولى',
                                'الفترة الثانية',
                                'الفترة الثالثة',
                              ],
                              onChange: (String? selected) {
                                BookingCubit.get(context).selectedShiftTime =
                                    selected!;
                                BookingCubit.get(context).changeNotifier();
                              }),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(color: thirdColor, spreadRadius: 1.4),
                              ],
                            ),
                            height: 37,
                            width: 130,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BookingCubit.get(context).selectedDate == null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Text(
                                          "اختر التاريخ",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(right: 40.0),
                                        child: Text(
                                          BookingCubit.get(context)
                                              .selectedDate!
                                              .day
                                              .toString(),
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
                                      BookingCubit.get(context).selectedDate =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month + 1,
                                                  1),
                                              firstDate: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month,
                                                  1),
                                              lastDate: DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month + 1,
                                                  BookingCubit.get(context)
                                                      .getDaysInMonth()));
                                      if (context.mounted) {
                                        BookingCubit.get(context)
                                            .changeNotifier();
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 45),
                    child: buildButton(
                        height: 45,
                        fontSize: 16,
                        width: size.width,
                        text: "إضـافـة",
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        borderColor: primaryColor,
                        function: () {
                          if (BookingCubit.get(context).selectedShiftTime !=
                              null) {
                            if (BookingCubit.get(context).selectedDate !=
                                null) {
                              circularProgress(context);
                              BookingCubit.get(context).shiftsList.add(Shift(
                                  shiftTime: BookingCubit.get(context)
                                      .selectedShiftTime,
                                  date: BookingCubit.get(context)
                                      .convertDateTimeDisplay(
                                          BookingCubit.get(context)
                                              .selectedDate
                                              .toString()),
                                  dayInMonth: BookingCubit.get(context)
                                      .selectedDate!
                                      .day));
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                Navigator.pop(context);
                              });
                            } else {
                              showSnackBar(
                                  context: context,
                                  message: "قم بتحديد اليوم",
                                  duration: 3,
                                  icon: Icons.error_outline);
                            }
                          } else {
                            showSnackBar(
                                context: context,
                                message: "قم بتحديد الفترة",
                                duration: 3,
                                icon: Icons.error_outline);
                          }
                        }),
                  ),
                ],
              )),
            ));
      },
    );
  }
}

TableRow headerTableRow() {
  return const TableRow(children: <Widget>[
    Padding(
        padding: EdgeInsets.all(3),
        child: Text("التاريخ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ))),
    Padding(
        padding: EdgeInsets.all(3),
        child: Text("الفترة الأولى",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ))),
    Padding(
        padding: EdgeInsets.all(3),
        child: Text("الفترة الثانية",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ))),
    Padding(
        padding: EdgeInsets.all(3),
        child: Text("الفترة الثالثة",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ))),
  ]);
}

TableRow tableRow(String first, String second, String third, String forth) {
  Color getColor(String type) {
    if (type == "متاح") {
      return Colors.green;
    } else if (type == "حجزته مسبقا") {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  return TableRow(children: <Widget>[
    Padding(
        padding: const EdgeInsets.all(3),
        child: Text(first,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ))),
    Padding(
        padding: const EdgeInsets.all(3),
        child: Text(second,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: getColor(second),
            ))),
    Padding(
        padding: const EdgeInsets.all(3),
        child: Text(third,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: getColor(third),
            ))),
    Padding(
        padding: const EdgeInsets.all(3),
        child: Text(forth,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: getColor(forth),
            ))),
  ]);
}
