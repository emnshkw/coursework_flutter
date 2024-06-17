import 'package:coursework/drawer.dart';
import 'package:coursework/functions.dart';
import 'package:coursework/pages/lesson_info.dart';
import 'package:coursework/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:coursework/api.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class LessonPage extends StatefulWidget {
  int lessonId;

  LessonPage(this.lessonId);

  @override
  State<LessonPage> createState() => _LessonPageState(lessonId);
}

class _LessonPageState extends State<LessonPage> {
  late int lessonId;

  _LessonPageState(int lessonId1) {
    lessonId = lessonId1;
    getLesson(lessonId).then((response) {
      Map<String, dynamic> lessonData =
          convert_response_to_map(response)['lesson'][0];
      updateFields(lessonData);
    });
  }

  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  ElevatedButton groupButton(Map<String, dynamic> groupInfo) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: () {
          Navigator.of(context).pop();
          groupController.text =
              '${groupInfo['group_number']} (${groupInfo['group_name']})';
          selectedGroupId = groupInfo['id'];
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              left: convert_px_to_adapt_width(25),
              top: convert_px_to_adapt_height(30),
              bottom: convert_px_to_adapt_height(30)),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // width: MediaQuery.of(context).size.width/1.5,

                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${groupInfo['group_number']} (${groupInfo['group_name']})',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  ElevatedButton colorButton(String lessonType, String color) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(int.parse(color)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: () {
          newColorCode = color;
          typeController.text = lessonType;
          Navigator.of(context).pop();
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              left: convert_px_to_adapt_width(25),
              top: convert_px_to_adapt_height(30),
              bottom: convert_px_to_adapt_height(30)),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // width: MediaQuery.of(context).size.width/1.5,

                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      lessonType,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void showGroupPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Выберите необходимую группу.'),
            content: Center(
              child: FutureBuilder(
                  future: getGroups(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          convert_snapshot_to_map(snapshot);
                      if (data['status'] == 'failed') {
                        return Center(
                          child: Text(
                            data['message'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff00275E),
                                fontSize: convert_px_to_adapt_height(40),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      if (data['status'] == 'success') {
                        List<dynamic> groups = data['groups'];
                        List<Widget> groupButtons = [];
                        for (Map<String, dynamic> groupInfo in groups) {
                          groupButtons.add(groupButton(groupInfo));
                          // groupButtons.add(Divider());
                        }
                        return Column(
                          children: groupButtons,
                        );
                      }
                      return Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height /
                                      2.5)),
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
                  }),
            ),
          );
        });
  }

  void showTypePicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showTypeAdd();
                },
                child: Text(
                  "Добавить новый тип занятия",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff00275E)),
              )
            ],
            title: Text('Выберите тип занятия'),
            content: SingleChildScrollView(
              child: FutureBuilder(
                  future: get_user_data(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          convert_snapshot_to_map(snapshot);
                      if (data['status'] == 'failed') {
                        return Center(
                          child: Text(
                            data['message'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff00275E),
                                fontSize: convert_px_to_adapt_height(40),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      if (data['status'] == 'success') {
                        List<dynamic> lessonTypes =
                            data['lesson_types'].split('\n');
                        List<Widget> typesWidgets = [];
                        for (String lessontType in lessonTypes) {
                          print(lessontType);
                          String type = lessontType.split(' - ')[0];
                          String color = lessontType.split(' - ')[1];
                          typesWidgets.add(colorButton(type, color));
                          typesWidgets.add(Padding(
                              padding: EdgeInsets.only(
                                  bottom: convert_px_to_adapt_height(10))));
                        }
                        return Column(
                          children: typesWidgets,
                        );
                      }
                      return Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height /
                                      2.5)),
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
                  }),
            ),
          );
        });
  }

  void showTypeAdd() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Добавление нового типа занятий'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (newLessonTypeController.text == '') {
                      Fluttertoast.showToast(
                          msg: 'Укажите тип занятия!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 15,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      print(newColorCode);
                      addLessonType(newLessonTypeController.text, newColorCode)
                          .then((response) {
                        Map<String, dynamic> data =
                            convert_response_to_map(response);
                        if (data['status'] == 'success') {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        }
                        Fluttertoast.showToast(
                            msg: data['message'],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 15,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    }
                  },
                  child: Text('Подтвердить'))
            ],
            content: Column(
              children: [
                input(newLessonTypeController, 'Введите название типа занятия'),
                colorPicker(newColorController, 'Выберите цвет')
              ],
            ),
          );
        });
  }

  Container input(TextEditingController controller, String hintText) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(15)),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        maxLines: null,
        minLines: null,
        controller: controller,
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23), color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: convert_px_to_adapt_height(20),
              color: Color(0xff00275E)),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(1)),
          ),
        ),
      ),
    );
  }

  Widget groupPicker(TextEditingController controller, String hintText) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(15)),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controller,
        onTap: () {
          showGroupPicker();
        },
        readOnly: true,
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23), color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: convert_px_to_adapt_height(20),
              color: Color(0xff00275E)),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(1)),
          ),
        ),
      ),
    );
  }

  Widget typePicker(TextEditingController controller, String hintText) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(15)),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controller,
        onTap: () {
          showTypePicker();
        },
        readOnly: true,
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23), color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: convert_px_to_adapt_height(20),
              color: Color(0xff00275E)),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(1)),
          ),
        ),
      ),
    );
  }

  Widget colorPicker(TextEditingController controller, String hintText) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(15)),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controller,
        onTap: () {
          showColors();
        },
        readOnly: true,
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23),
            color: Color(int.parse('$newColorCode'))),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: convert_px_to_adapt_height(20),
              color: Color(int.parse('$newColorCode'))),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(1)),
          ),
        ),
      ),
    );
  }

  void showColors() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Выберите цвет'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: Colors.blue,
                onColorChanged: (Color newColor) {
                  setState(() {
                    newColorCode = '0x${newColor.toHexString()}';
                    print(newColorCode);
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Подтвердить'),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    showTypeAdd();
                  });
                },
              ),
            ],
          );
        });
  }

  Widget times() {
    List<String> pairs = [
      '7:30 - 8:10',
      '8:20 - 9:55',
      '10:10 - 11:45',
      '12:00 - 13:35',
      '14:30 - 16:05',
      '16:15 - 17:50',
      '18:00 - 19:35',
      '19:40 - 21:15'
    ];
    List<Widget> rowWidgets = [];
    for (String pair in pairs) {
      rowWidgets.add(ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xff00275E)),
          onPressed: () {
            timeController.text = pair;
          },
          child: Container(
            child: Text(
              pair,
              style: TextStyle(color: Colors.white),
            ),
          )));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: rowWidgets,
      ),
    );
  }

  Future show_date_picker() async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime(DateTime.now().year + 1),
      helpText: 'Выбор даты',
      locale: const Locale('ru', 'RU'),
    );
    if (dateTime != null) {
      setState(() {
        date = dateTime;
        dateController.text = convertDateTimeToString(dateTime);
      });
    }
  }

  Widget datePicker(TextEditingController controller, String hintText) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(15)),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controller,
        onTap: () {
          show_date_picker();
        },
        readOnly: true,
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23), color: Color(0xff00275E)),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: convert_px_to_adapt_height(20),
              color: Color(0xff00275E)),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(1)),
          ),
        ),
      ),
    );
  }

  void updateFields(Map<String, dynamic> lessonData) {
    lessonTitleController.text = lessonData['lesson_title'];
    typeController.text = lessonData['lesson_type'].split('~')[0];
    newColorCode = lessonData['lesson_type'].split('~')[1];
    place.text = lessonData['place'];
    selectedGroupId = lessonData['group_id'];
    groupController.text =
        '${lessonData['group_number']} (${lessonData['group_name']})';
    timeController.text = lessonData['date'].split(' ')[1];
    date = convertStringToDateTime(lessonData['date'].split(' ')[0]);
    dateController.text = lessonData['date'].split(' ')[0];
  }

  Widget showTableBtn() {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => LessonTablePage(lessonId),
              transitionDuration: Duration(milliseconds: 300),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          );
        },
        child: Text(
          'Контроль посещаемости',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff00275E),
        ),
      ),
    );
  }

  DateTime date = DateTime(2024);
  TextEditingController lessonTitleController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController newLessonTypeController = TextEditingController();
  TextEditingController newColorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String newColorCode = '0xff00275E';
  int selectedGroupId = 0;
  bool dataLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff00275E),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Просмотр занятия',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => MainPage(),
                    transitionDuration: Duration(milliseconds: 300),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ),
                );
              },
              icon: Icon(Icons.close)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (lessonTitleController.text == '') {
            Fluttertoast.showToast(
                msg: 'Укажите название занятия!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 15,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          if (typeController.text == '') {
            Fluttertoast.showToast(
                msg: 'Укажите тип занятия!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 15,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          if (timeController.text == '') {
            Fluttertoast.showToast(
                msg: 'Укажите время занятия!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 15,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          editLesson(
                  lessonTitleController.text,
                  typeController.text,
                  newColorCode,
                  place.text,
                  dateController.text,
                  selectedGroupId,
                  timeController.text.replaceAll(' ', ''),
                  lessonId)
              .then((response) {
            Map<String, dynamic> data = convert_response_to_map(response);
            if (data['status'] == 'success') {
              Fluttertoast.showToast(
                  msg: data['message'],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 15,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => MainPage(),
                  transitionDuration: Duration(milliseconds: 300),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c),
                ),
              );
            } else {
              Fluttertoast.showToast(
                  msg: data['message'],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 15,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          });
        },
        child: Icon(Icons.check),
        backgroundColor: Color(0xff00275E),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: convert_px_to_adapt_height(15),
                    left: convert_px_to_adapt_width(5)),
                child: Text(
                  'Название',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            input(lessonTitleController, 'Введите название предмета'),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: convert_px_to_adapt_height(15),
                    left: convert_px_to_adapt_width(5)),
                child: Text(
                  'Тип занятия',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            typePicker(typeController, 'Выберите тип занятия'),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: convert_px_to_adapt_height(15),
                    left: convert_px_to_adapt_width(5)),
                child: Text(
                  'Место проведения',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            input(place, 'Введите место проведения занятия'),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: convert_px_to_adapt_height(15),
                    left: convert_px_to_adapt_width(5)),
                child: Text(
                  'Время',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            input(timeController,
                'Введите время (формат: ХХ:ХХ - ХХ:ХХ)\nИли выберите ниже'),
            Padding(
                padding:
                    EdgeInsets.only(bottom: convert_px_to_adapt_height(15))),
            times(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: convert_px_to_adapt_height(15),
                    left: convert_px_to_adapt_width(5)),
                child: Text(
                  'Группа',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            groupPicker(groupController, 'Выберите группу'),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    top: convert_px_to_adapt_height(15),
                    left: convert_px_to_adapt_width(5)),
                child: Text(
                  'Дата',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            datePicker(dateController, 'Выберите дату'),
            Padding(
                padding:
                    EdgeInsets.only(bottom: convert_px_to_adapt_height(15))),
            showTableBtn()
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
