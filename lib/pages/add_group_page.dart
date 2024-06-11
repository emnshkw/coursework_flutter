import 'package:coursework/drawer.dart';
import 'package:coursework/pages/groups_page.dart';
import 'package:coursework/pages/table_page.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:coursework/api.dart';

class AddGroupPage extends StatefulWidget {
  String groupNumberText;
  String groupNameText;
  String groupMarksText;
  Map tableData;
  bool created;
  String id;
  AddGroupPage(this.groupMarksText, this.groupNameText, this.groupNumberText,
      this.tableData,
      this.created,this.id);

  @override
  State<AddGroupPage> createState() => _AddGroupPageState(
      groupNumberText, groupNameText, groupMarksText, tableData, created,id);
}

class _AddGroupPageState extends State<AddGroupPage> {
  late Map tableData;
  late bool created;
  late String id;
  _AddGroupPageState(String groupNumberText1, String groupNameText1,
      String groupMarksText1, Map tableData1, bool created1,String id1) {
    groupNumberController.text = groupNumberText1;
    groupNameController.text = groupNameText1;
    groupMarksController.text = groupMarksText1;
    tableData = tableData1;
    created = created1;
    id = id1;
  }

  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  Container input(TextEditingController controller, String hintText) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: convert_px_to_adapt_height(15)),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              style: TextStyle(
                  fontSize: convert_px_to_adapt_height(23),
                  color: Colors.black),
              decoration: InputDecoration(
                // labelStyle: TextStyle(
                //   color: Color(0xff00275E)
                // ),
                filled: true,
                fillColor: Colors.white,
                hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: convert_px_to_adapt_height(20),
                    color: Color(0xff00275E)),
                hintText: hintText,
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(convert_px_to_adapt_width(20)),
                  borderSide: BorderSide(
                      color: Color(0xff00275E),
                      width: convert_px_to_adapt_width(2)),
                ),
                enabledBorder: OutlineInputBorder(
                  // borderRadius:
                  //     BorderRadius.circular(convert_px_to_adapt_width(20)),
                  borderSide: BorderSide(
                      color: Color(0xff00275E),
                      width: convert_px_to_adapt_width(1)),
                ),
                // prefixIcon: Padding(
                //   padding: EdgeInsets.only(
                //       left: convert_px_to_adapt_width(10),
                //       right: convert_px_to_adapt_width(10)),
                //   child: IconTheme(
                //     data: IconThemeData(color: Color(0xff00275E)),
                //     child: icon,
                //   ),
                // )
              ),
            ),
          )
        ],
      ),
    );
  }

  TextEditingController groupNumberController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupMarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Color(0xff00275E),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Добавление группы',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => GroupsPage(),
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
          if (groupNumberController.text.length == 0) {
            Fluttertoast.showToast(
                msg: 'Укажите номер группы!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 15,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            if (groupNameController.text.length == 0) {
              Fluttertoast.showToast(
                  msg: 'Укажите название группы!',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 15,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              List<String> students = [];
              for (var key in tableData.keys) {
                students.add(tableData[key]['name']);
              }
              if (created == true) {
                editGroup(groupNumberController.text, groupNameController.text,
                        groupMarksController.text, students.join('\n'),id)
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
                        pageBuilder: (_, __, ___) => GroupsPage(),
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
              } else {
                addGroup(groupNumberController.text, groupNameController.text,
                        groupMarksController.text, students.join('\n'))
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
                        pageBuilder: (_, __, ___) => GroupsPage(),
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
              }
            }
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Color(0xff00275E),
      ),
      body: Column(
        children: [
          input(groupNumberController, "Введите номер группы"),
          input(groupNameController, "Введите название группы"),
          input(groupMarksController, "Введите примечания к группе"),
          Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(20))),
          Align(
            alignment: Alignment.center,
            child: Text('Количество студентов в группе - ${tableData.length}'),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(20))),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Color(0xff00275E)),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => TablePage(
                        groupNumberController.text,
                        groupNameController.text,
                        groupMarksController.text,
                        tableData,created,id),
                    transitionDuration: Duration(milliseconds: 300),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ),
                );
              },
              child: Text(
                'Просмотр таблицы студентов',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
