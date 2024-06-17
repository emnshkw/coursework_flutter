import 'package:coursework/drawer.dart';
import 'package:coursework/functions.dart';
import 'package:coursework/pages/groups_page.dart';
import 'package:coursework/pages/main_page.dart';
import 'package:coursework/pages/table_page.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:coursework/api.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddLessonPage extends StatefulWidget {
  DateTime date;

  AddLessonPage(this.date);

  @override
  State<AddLessonPage> createState() => _AddLessonPageState(date);
}

class _AddLessonPageState extends State<AddLessonPage> {
  late DateTime date;

  _AddLessonPageState(DateTime date1) {
    date = date1;
    dateController.text = convertDateTimeToString(date1);
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
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(convert_px_to_adapt_width(5)))),
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
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(convert_px_to_adapt_height(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    lessonType,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff00275E)),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      removeLessonType(lessonType, color).then((response) {
                        Map<String, dynamic> data =
                            convert_response_to_map(response);
                        Fluttertoast.showToast(
                            msg: data['message'],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 15,
                            backgroundColor: Color(0xff00275E),
                            textColor: Colors.white,
                            fontSize: 16.0);
                        if (data['status'] == 'success') {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color(0xff00275E),
                    ))
              ],
            ),
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

  ElevatedButton lessonButton(String lessonName) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: () {
          lessonTitleController.text = lessonName;
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
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      lessonName,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void showLessonAdd() {
    newLessonNameController.text = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Добавление нового занятия'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (newLessonNameController.text == '') {
                      Fluttertoast.showToast(
                          msg: 'Укажите название занятия!',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 15,
                          backgroundColor: Color(0xff00275E),
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      addLessonName(newLessonNameController.text)
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
                            backgroundColor: Color(0xff00275E),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    }
                  },
                  child: Text('Подтвердить'))
            ],
            content: Column(
              children: [
                Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Название',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
                input(newLessonNameController, 'Введите название занятия')
              ],
            ),
          );
        });
  }


  void showLessonPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Выберите необходимый предмет.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showLessonAdd();
                },
                child: Text(
                  'Добавить занятие',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff00275E)),
              )
            ],
            content: Center(
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
                        List<String> lessonNames =
                            data['lesson_names'].split('\n');
                        List<Widget> nameButtons = [];
                        for (String lessonName in lessonNames) {
                          if (lessonName != '') {
                            nameButtons.add(lessonButton(lessonName));
                          }
                          // groupButtons.add(Divider());
                        }
                        return Column(
                          children: nameButtons,
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
                          String type = lessontType.split('~')[0];
                          String color = lessontType.split('~')[1];
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
    newLessonTypeController.clear();
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
                          backgroundColor: Color(0xff00275E),
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
                            backgroundColor: Color(0xff00275E),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    }
                  },
                  child: Text('Подтвердить'))
            ],
            content: Column(
              children: [
                Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Название',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
                input(newLessonTypeController, 'Введите название типа занятия'),
                Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Цвет',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
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

  Container lessonNameInput(TextEditingController controller, String hintText) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(15)),
      width: MediaQuery.of(context).size.width,
      child: TextField(
        onTap: showLessonPicker,
        maxLines: null,
        minLines: null,
        readOnly: true,
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

  TextEditingController lessonTitleController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController newLessonTypeController = TextEditingController();
  TextEditingController newLessonNameController = TextEditingController();
  TextEditingController newColorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String newColorCode = '0xff00275E';
  int selectedGroupId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff00275E),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Добавление занятия',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
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
                backgroundColor: Color(0xff00275E),
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
                backgroundColor: Color(0xff00275E),
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
                backgroundColor: Color(0xff00275E),
                textColor: Colors.white,
                fontSize: 16.0);
            return;
          }
          else{
            String time = timeController.text.trim();
            String validateResult = validateTime(time);
            if (validateResult == 'success'){
              addLesson(
                  lessonTitleController.text,
                  typeController.text,
                  newColorCode,
                  place.text,
                  dateController.text,
                  selectedGroupId,
                  timeController.text.replaceAll(' ', ''))
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
                      backgroundColor: Color(0xff00275E),
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              });
            }
            else{
              Fluttertoast.showToast(
                  msg: validateResult,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 15,
                  backgroundColor: Color(0xff00275E),
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }

        },
        child: Icon(Icons.check),
        backgroundColor: Color(0xff00275E),
      ),
      body: Column(
        children: [
          Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Название',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
          lessonNameInput(lessonTitleController, 'Выберите нужный предмет'),
          Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Тип предмета',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
          typePicker(typeController, 'Выберите тип занятия'),
          Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Место проведения',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
          input(place, 'Введите место проведения занятия'),
          Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Время проведения',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
          input(timeController,
              'Введите время (формат: ХХ:ХХ - ХХ:ХХ)\nИли выберите ниже'),
          times(),
          Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Группа',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
          groupPicker(groupController, 'Выберите группу'),
          Align(alignment: Alignment.centerLeft,child: Padding(padding: EdgeInsets.only(top: convert_px_to_adapt_height(15),left: convert_px_to_adapt_width(5)),child: Text('Дата',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),),),
          datePicker(dateController, 'Выберите дату')
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
