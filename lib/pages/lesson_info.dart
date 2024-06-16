import 'package:coursework/drawer.dart';
import 'package:coursework/pages/add_group_page.dart';
import 'package:coursework/pages/lesson_page.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coursework/api.dart';

class LessonTablePage extends StatefulWidget {
  int lessonId;

  LessonTablePage(this.lessonId);

  @override
  State<LessonTablePage> createState() => _LessonTablePageState(lessonId);
}

class _LessonTablePageState extends State<LessonTablePage> {
  late Map<dynamic, dynamic> tableData;
  late int lessonId;
  late List rows;

  _LessonTablePageState(int lessonId1) {
    lessonId = lessonId1;
    rows = [];
    tableData = {};
    getLesson(lessonId).then((response){
      Map<String,dynamic> lessonData = convert_response_to_map(response)['lesson'][0];
      String groupInfo = lessonData['group_info'];
      int iteration = 0;
      for (String student in groupInfo.split('\n')){
        List<String> studentInfo = student.split('~');
        String fio = studentInfo[0];
        String isHere = studentInfo[1];
        String point = studentInfo[2];
        String marks = studentInfo[3];
        rows.add({
          "row":iteration,
          "fio":fio,
          'isHere':isHere,
          'point':point,
          'marks':marks
        });
        tableData[iteration] = {
          "row":iteration,
          "fio":fio,
          'isHere':isHere,
          'point':point,
          'marks':marks
        };
        iteration++;
      }
      setState(() {

      });
    });

  }

  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }


  List? getRows() {
    return _editableKey.currentState?.rows;
  }

  final _editableKey = GlobalKey<EditableState>();

  void updateTableData() {
    List? rows = _editableKey.currentState?.rows;
    if (rows!.isNotEmpty) {
      for (int i = 0; i < rows.length; i++) {
        Map<dynamic, dynamic> row = rows[i];
        tableData[i] = row;
      }
    }
    List? editedRows = _editableKey.currentState?.editedRows;
    if (editedRows!.isNotEmpty) {
      for (int i = 0; i < editedRows.length; i++) {
        Map<dynamic, dynamic> row = editedRows[i];
        for(var editedKey in row.keys){
          tableData[row['row']][editedKey] = row[editedKey];
        }

      }
    }
    List<Map<dynamic, dynamic>> clearData = [];
    for (var key in tableData.keys) {
      if (tableData[key]['name'] != "") {
        clearData.add(tableData[key]);
      }
    }
    tableData.clear();
    for (int i = 0; i < clearData.length; i++) {
      Map<dynamic, dynamic> updated = clearData[i];
      updated['row'] = i;
      tableData[i] = updated;
    }
  }

  List cols = [
    {"title": 'ФИО', 'widthFactor': 0.8, 'key': 'fio'},
    {"title": 'Присутствие (+/-)', 'widthFactor': 0.4, 'key': 'isHere'},
    {"title": 'Оценка', 'widthFactor': 0.4, 'key': 'point'},
    {"title": 'Примечание', 'widthFactor': 0.4, 'key': 'marks'},
  ];

  void saveTable(){
    updateTableData();
    List<String> students = [];
    print(tableData);
    for (int row in tableData.keys){
      Map<String,dynamic> studentInfo = tableData[row];
      String fio = studentInfo['fio'].replaceAll('~','');
      String isHere = studentInfo['isHere'].replaceAll('~','');
      String point = studentInfo['point'].replaceAll('~','');
      String marks = studentInfo['marks'].replaceAll('~','');
      students.add('$fio~$isHere~$point~$marks');
    }
    editLessonGroupInfo(students.join('\n'), lessonId).then((response){
      Map<String,dynamic> data = convert_response_to_map(response);
      if (data['status'] == 'success'){
        Navigator.of(context).pop();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LessonPage(lessonId),
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (_, a, __, c) =>
                FadeTransition(opacity: a, child: c),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00275E),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Просмотр информации',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                saveTable();
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Editable(
        key: _editableKey,
        //Assign Key to Widget
        columns: cols,
        rows: rows,
        columnRatio: 0.4,
        borderColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
    );
  }
}
