import 'package:coursework/drawer.dart';
import 'package:coursework/functions.dart';
import 'package:coursework/pages/add_lessons_page.dart';
import 'package:coursework/pages/lesson_page.dart';
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
              onTap: () {
                setState(() {
                  filtersOpened = !filtersOpened;
                });
              },
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

  List<dynamic> getLessonsInDay(List<dynamic> data, DateTime day) {
    String dayStr = convertDateTimeToString(day);
    List<Map<String, dynamic>> lessons = [];
    for (Map<String, dynamic> lesson in data) {
      if (lesson['date'].split(' ')[0] == dayStr) {
        lessons.add(lesson);
      }
    }
    return lessons;
  }

  FutureBuilder days() {
    return FutureBuilder(
        future: getLessons(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = convert_snapshot_to_map(snapshot);

            List<GestureDetector> weekDays = [];
            DateTime startWeek = getWeekStart(selectedDay);
            DateTime endWeek = getWeekEnd(selectedDay);
            while (!startWeek.isAfter(endWeek)) {
              List<Widget> circles = [];
              try {
                List<dynamic> curDayLessons =
                    getLessonsInDay(data['lessons'], startWeek);
                for (Map<String, dynamic> lesson in curDayLessons) {
                  if ((selectedLessons.length == 0 ||
                          selectedLessons.contains(lesson['lesson_title'])) &&
                      (selectedGroups.length == 0 ||
                          selectedGroups.contains(
                              '${lesson['group_number']} (${lesson['group_name']})'))) {
                    if (circles.length >= 6) {
                      circles.add(Icon(
                        Icons.more_horiz,
                        size: convert_px_to_adapt_height(10),
                      ));
                      break;
                    } else {
                      circles.add(CircleAvatar(
                        backgroundColor: Color(
                            int.parse(lesson['lesson_type'].split('~')[1])),
                        radius: convert_px_to_adapt_height(2.5),
                      ));
                    }
                    circles.add(Padding(
                        padding: EdgeInsets.only(
                            bottom: convert_px_to_adapt_height(2))));
                  }
                }
              } catch (e) {
                circles = [];
              }

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
                      border: startWeek.isAtSameMomentAs(selectedDay)
                          ? Border.all(
                              color: Color(0xff00275E),
                            )
                          : null,
                      borderRadius:
                          BorderRadius.circular(convert_px_to_adapt_width(10))),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: convert_px_to_adapt_width(5)),
                        child: Text(
                          day,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            right: convert_px_to_adapt_width(5),
                            top: convert_px_to_adapt_height(5)),
                        child: Column(
                          children: circles,
                        ),
                      )
                    ],
                  ),
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
          } else {
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
                      border: startWeek.isAtSameMomentAs(selectedDay)
                          ? Border.all(
                              color: Color(0xff00275E),
                            )
                          : null,
                      borderRadius:
                          BorderRadius.circular(convert_px_to_adapt_width(10))),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: convert_px_to_adapt_width(5)),
                        child: Text(
                          day,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
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
        });
  }

  Widget lessonBtn(Map<String, dynamic> lessonData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LessonPage(lessonData['id']),
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
            left: convert_px_to_adapt_width(15),
            right: convert_px_to_adapt_width(15)),
        decoration: BoxDecoration(
            color: Color(int.parse(lessonData['lesson_type'].split('~')[1])),
            borderRadius: BorderRadius.circular(convert_px_to_adapt_width(25))),
        child: Column(
          children: [
            // Дата и аудитория
            Container(
              padding: EdgeInsets.only(
                  left: convert_px_to_adapt_width(15),
                  right: convert_px_to_adapt_width(15),
                  top: convert_px_to_adapt_height(25)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // height: convert_px_to_adapt_height(25),
                    padding: EdgeInsets.only(
                        left: convert_px_to_adapt_width(10),
                        right: convert_px_to_adapt_width(10),
                        top: convert_px_to_adapt_height(5),
                        bottom: convert_px_to_adapt_height(5)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            convert_px_to_adapt_width(10))),
                    child: Text(lessonData['date'].split(' ')[1]),
                  ),
                  Container(
                    // height: convert_px_to_adapt_height(25),
                    padding: EdgeInsets.only(
                        left: convert_px_to_adapt_width(10),
                        right: convert_px_to_adapt_width(10),
                        top: convert_px_to_adapt_height(5),
                        bottom: convert_px_to_adapt_height(5)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            convert_px_to_adapt_width(10))),
                    child: Text(lessonData['place']),
                  )
                ],
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(bottom: convert_px_to_adapt_height(20))),
            Padding(
              padding: EdgeInsets.only(
                  left: convert_px_to_adapt_width(15),
                  right: convert_px_to_adapt_width(15)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(convert_px_to_adapt_width(10)),
                    color: Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: convert_px_to_adapt_width(15),
                          top: convert_px_to_adapt_height(15)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          lessonData['lesson_type'].split('~')[0],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: convert_px_to_adapt_height(20)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: convert_px_to_adapt_width(15),
                          right: convert_px_to_adapt_width(15)),
                      child: Container(
                        width: convert_px_to_adapt_width(
                            MediaQuery.of(context).size.width / 1.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Text(
                                lessonData['lesson_title'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: convert_px_to_adapt_height(20),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: convert_px_to_adapt_height(80))),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Text(
                                  '${lessonData['group_number']} (${lessonData['group_name']})'),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(bottom: convert_px_to_adapt_height(25)))
          ],
        ),
      ),
    );
  }

  Container lessons() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: getLessons(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = convert_snapshot_to_map(snapshot);
            List<Widget> lessonBtns = [];
            if (data['status'] == 'success') {
              lessonsData = data['lessons'];
              for (Map<String, dynamic> lessonData in data['lessons']) {
                if (lessonData['date'].split(' ')[0] ==
                        convertDateTimeToString(selectedDay) &&
                    (selectedLessons.length == 0 ||
                        selectedLessons.contains(lessonData['lesson_title'])) &&
                    (selectedGroups.length == 0 ||
                        selectedGroups.contains(
                            '${lessonData['group_number']} (${lessonData['group_name']})'))) {
                  lessonBtns.add(lessonBtn(lessonData));
                  lessonBtns.add(Padding(
                      padding: EdgeInsets.only(
                          bottom: convert_px_to_adapt_height(15))));
                }
              }
              return Column(
                children: lessonBtns,
              );
            } else {
              return Text(
                data['message'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: convert_px_to_adapt_height(40)),
              );
            }
          } else {
            return Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2.5)),
                Text(
                  "Журнал-мобайл",
                  style: TextStyle(
                      fontFamily: 'Cinzel',
                      fontWeight: FontWeight.w900,
                      fontSize: convert_px_to_adapt_height(35),
                      color: Color(0xff00275E)),
                ),
                LinearProgressIndicator()
              ],
            );
          }
        },
      ),
    );
  }

  ElevatedButton lessonInRowBtn(String lessonName) {
    lessonName = lessonName.replaceAll('\r', '');
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedLessons.contains(lessonName)
              ? selectedLessons.remove(lessonName)
              : selectedLessons.add(lessonName);
        });
      },
      child: Text(
        lessonName,
        style: TextStyle(
            color: Color(0xff00275E), fontSize: convert_px_to_adapt_height(12)),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: selectedLessons.contains(lessonName)
              ? Colors.grey
              : Colors.white),
    );
  }

  ElevatedButton groupInRowBtn(Map<String, dynamic> data) {
    String groupName = '${data['group_number']} (${data['group_name']})';
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedGroups.contains(groupName)
              ? selectedGroups.remove(groupName)
              : selectedGroups.add(groupName);
        });
      },
      child: Text(
        groupName,
        style: TextStyle(
            color: Color(0xff00275E), fontSize: convert_px_to_adapt_height(12)),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedGroups.contains(groupName) ? Colors.grey : Colors.white),
    );
  }

  Container filters() {
    return Container(
      padding: EdgeInsets.only(
          left: convert_px_to_adapt_width(15),
          right: convert_px_to_adapt_width(15)),
      width: MediaQuery.of(context).size.width - convert_px_to_adapt_width(30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(convert_px_to_adapt_height(10)),
          border: Border.all(color: Color(0xff00275E))),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_width(15))),
          FutureBuilder(
              future: get_user_data(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = convert_snapshot_to_map(snapshot);
                  List<Widget> lessonBtns = [];
                  for (String lessonName in data['lesson_names'].split('\n')) {
                    if (lessonName != '') {
                      lessonBtns.add(Padding(
                          padding: EdgeInsets.only(
                              left: convert_px_to_adapt_width(5))));
                      lessonBtns.add(lessonInRowBtn(lessonName));
                    }
                  }
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            convert_px_to_adapt_height(10))),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: convert_px_to_adapt_width(10)),
                          child: Text(
                            'Выберите необходимые занятия',
                            style: TextStyle(color: Color(0xff00275E)),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: lessonBtns,
                          ),
                        )
                      ],
                    ),
                  );
                }
                return SizedBox();
              }),
          Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_width(15))),
          FutureBuilder(
              future: getGroups(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = convert_snapshot_to_map(snapshot);
                  List<Widget> groupBtns = [];
                  for (Map<String, dynamic> groupInfo in data['groups']) {
                    groupBtns.add(Padding(
                        padding: EdgeInsets.only(
                            left: convert_px_to_adapt_width(5))));
                    groupBtns.add(groupInRowBtn(groupInfo));
                  }
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            convert_px_to_adapt_height(10))),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: convert_px_to_adapt_width(10)),
                          child: Text(
                            'Выберите необходимые группы',
                            style: TextStyle(color: Color(0xff00275E)),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: groupBtns,
                          ),
                        )
                      ],
                    ),
                  );
                }
                return SizedBox();
              }),
          Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(15)))
        ],
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
  List<dynamic> lessonsData = [];
  bool filtersOpened = false;
  List<String> selectedLessons = [];
  List<String> selectedGroups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff00275E),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Моё расписание',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => AddLessonPage(selectedDay),
              transitionDuration: Duration(milliseconds: 300),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(bottom: convert_px_to_adapt_height(20))),
            datePicker(),
            filtersOpened
                ? Padding(
                    padding:
                        EdgeInsets.only(top: convert_px_to_adapt_height(15)),
                    child: filters(),
                  )
                : Padding(padding: EdgeInsets.zero),
            days(),
            Padding(
              padding: EdgeInsets.only(
                  left: convert_px_to_adapt_width(15),
                  right: convert_px_to_adapt_width(15),
                  top: convert_px_to_adapt_height(15)),
              child: lessons(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
