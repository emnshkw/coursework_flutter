import 'package:coursework/drawer.dart';
import 'package:coursework/pages/add_group_page.dart';
import 'package:coursework/pages/result_table.dart';
import 'package:flutter/material.dart';
import 'package:coursework/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResultsPage extends StatefulWidget {
  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  void acceptDelete(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Вы уверены, что хотите удалить группу?'),
            content: SizedBox(
              height: convert_px_to_adapt_height(40),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff00275E)),
                  onPressed: () {
                    deleteGroup(id).then((response) {
                      Map<String, dynamic> data =
                          convert_response_to_map(response);
                      if (data['status'] == 'success') {
                        setState(() {
                          Fluttertoast.showToast(
                              msg: data['message'],
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 15,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        });
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
                    Navigator.of(context).pop();
                  },
                  child: Text('Подтвердить',
                      style: TextStyle(color: Colors.white))),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff00275E)),
                  onPressed: () {},
                  child: Text('Отмена', style: TextStyle(color: Colors.white))),
            ],
          );
        });
  }

  ElevatedButton lessonButton(Map<String, dynamic> lessonInfo) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: () {
          if (lessonInfo['generated']) {
            getResults(lessonInfo['result_id']).then((response) {
              Map<String, dynamic> data = convert_response_to_map(response);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => ResultTablePage(data),
                  transitionDuration: Duration(milliseconds: 300),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c),
                ),
              );
            });
          } else {
            Fluttertoast.showToast(
                msg: 'Необходимо сгенерировать сводку!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 15,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
          }
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
                width: MediaQuery.of(context).size.width / 3,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${lessonInfo['group_number']} (${lessonInfo['group_name']})',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${lessonInfo['lesson_title']}'.replaceAll('\r', ''),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    lessonInfo['generated'] == false
                        ? generateResults(
                                lessonInfo['id'],
                                lessonInfo['group_id'],
                                lessonInfo['lesson_title'])
                            .then((response) {
                            Map<String, dynamic> data =
                                convert_response_to_map(response);
                            if (data['status'] == 'success') {
                              setState(() {
                                Fluttertoast.showToast(
                                    msg: data['message'],
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 15,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              });
                            }
                          })
                        : updateResults(
                                lessonInfo['id'],
                                lessonInfo['group_id'],
                                lessonInfo['lesson_title'],
                                lessonInfo['result_id'])
                            .then((response) {
                            Map<String, dynamic> data =
                                convert_response_to_map(response);
                            if (data['status'] == 'success') {
                              setState(() {
                                Fluttertoast.showToast(
                                    msg: data['message'],
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 15,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              });
                            }
                          });
                  },
                  child: Text(
                    lessonInfo['generated'] == false
                        ? 'Сгенерировать'
                        : "Обновить сводку",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  FloatingActionButton addlessonButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                AddGroupPage('', '', '', {}, false, ''),
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      },
      child: Center(
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff00275E),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Итоговые сводки',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: getLessonResults(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = convert_snapshot_to_map(snapshot);
                  print(data);
                  if (data['status'] == 'success') {
                    List<dynamic> lessons = data['lessons'];
                    List<Widget> lessonButtons = [];
                    for (Map<String, dynamic> lessonInfo in lessons) {
                      lessonButtons.add(lessonButton(lessonInfo));
                    }
                    return Column(
                      children: lessonButtons,
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
                }
                print(snapshot);
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
              })
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
