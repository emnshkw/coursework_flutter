import 'package:coursework/drawer.dart';
import 'package:flutter/material.dart';
import 'package:coursework/api.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  DateTime getWeekStart(DateTime day) {
    while (day.weekday != 1) {
      day = day.subtract(Duration(days: 1));
    }
    return day;
  }

  DateTime getWeekEnd(DateTime day) {
    while (day.weekday != 7) {
      day = day.add(Duration(days: 1));
    }
    return day;
  }

  void changeDislayWeek() {
    DateTime startWeek = getWeekStart(selectedDay);
    DateTime endWeek = getWeekEnd(selectedDay);
    if (startWeek.month == endWeek.month) {
      displayWeek =
          '${startWeek.day} - ${endWeek.day} ${translatedMonth[endWeek.month]} ${endWeek.year}';
    } else {
      displayWeek =
          '${startWeek.day} ${translatedMonth[startWeek.month]} - ${endWeek.day} ${translatedMonth[endWeek.month]} ${endWeek.year}';
    }
  }

  Future show_date_picker() async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime(DateTime.now().year + 1),
      helpText: 'Выбор даты',
      locale: const Locale('ru', 'RU'),
    );
    if (dateTime != null) {
      setState(() {
        selectedDay = dateTime;
      });
    }
  }

  Container datePicker() {
    changeDislayWeek();
    return Container(
      padding: EdgeInsets.only(
          left: convert_px_to_adapt_width(15),
          right: convert_px_to_adapt_width(15)),
      height: convert_px_to_adapt_height(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff00275E),
                ),
                borderRadius:
                    BorderRadius.circular(convert_px_to_adapt_width(10))),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay =
                      getWeekStart(selectedDay).subtract(Duration(days: 1));
                });
              },
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Color(0xff00275E),
                size: convert_px_to_adapt_height(40),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              show_date_picker();
            },
            child: Container(
              width: convert_px_to_adapt_width(200),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff00275E),
                  ),
                  borderRadius:
                      BorderRadius.circular(convert_px_to_adapt_width(10))),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  displayWeek,
                  style: TextStyle(
                      color: Color(0xff00275E),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff00275E),
                ),
                borderRadius:
                    BorderRadius.circular(convert_px_to_adapt_width(10))),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedDay = getWeekEnd(selectedDay).add(Duration(days: 1));
                });
              },
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Color(0xff00275E),
                size: convert_px_to_adapt_height(40),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff00275E),
                ),
                borderRadius:
                    BorderRadius.circular(convert_px_to_adapt_width(10))),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.filter_alt_outlined,
                color: Color(0xff00275E),
                size: convert_px_to_adapt_height(40),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container days() {
    List<GestureDetector> weekDays = [];
    DateTime startWeek = getWeekStart(selectedDay);
    DateTime endWeek = getWeekEnd(selectedDay);
    while (!startWeek.isAfter(endWeek)) {
      String day = startWeek.day.toString();
      day = day.length == 1 ? '0$day' : day;
      DateTime showedDay = startWeek;
      weekDays.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedDay = showedDay;
          });
        },
        child: Container(
          height: convert_px_to_adapt_height(45),
          width: convert_px_to_adapt_width(45),
          decoration: BoxDecoration(
              color: !startWeek.isAtSameMomentAs(selectedDay)
                  ? Color(0xffE4E4E4)
                  : Colors.white,
              border: Border.all(
                color: Color(0xff00275E),
              ),
              borderRadius:
                  BorderRadius.circular(convert_px_to_adapt_width(10))),
          alignment: Alignment.center,
          child: Text(day),
        ),
      ));
      startWeek = startWeek.add(Duration(days: 1));
    }
    return Container(
      padding: EdgeInsets.only(
          top: convert_px_to_adapt_height(20),
          left: convert_px_to_adapt_width(15),
          right: convert_px_to_adapt_width(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekDays,
      ),
    );
  }

  String displayWeek = '';
  DateTime selectedDay = DateTime.now();
  Map<int, String> translatedMonth = {
    1: 'Января',
    2: 'Февраля',
    3: 'Марта',
    4: "Апреля",
    5: "Мая",
    6: "Июня",
    7: "Июля",
    8: "Августа",
    9: "Сентября",
    10: "Октября",
    11: "Ноября",
    12: "Декабря"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
          backgroundColor: Color(0xff00275E),
          iconTheme: IconThemeData(color: Colors.white)),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                top: convert_px_to_adapt_height(20),
                bottom: convert_px_to_adapt_height(20)),
            child: Text(
              'Моё расписание',
              style: TextStyle(
                  color: Color(0xff00275E),
                  fontSize: convert_px_to_adapt_height(20),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold),
            ),
          ),
          datePicker(),
          days()
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
