import 'package:coursework/drawer.dart';
import 'package:coursework/pages/add_group_page.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:coursework/api.dart';

class ResultTablePage extends StatefulWidget {
  Map<String,dynamic> data;
  ResultTablePage(this.data);

  @override
  State<ResultTablePage> createState() => _ResultTablePageState(data);
}

class _ResultTablePageState extends State<ResultTablePage> {
  late Map<String,dynamic> data;
  _ResultTablePageState(Map<String,dynamic> data1) {
    data=data1['result'][0];
    List<String> result =data['result'].split('\n');
    List<String> resultCols = result.removeAt(0).split('~');
    for (String col in resultCols){
      if (col == 'ФИО'){
        cols.add({"title": col, 'widthFactor': 0.4, 'key': col});
        continue;
      }
      if (col.contains('/')){
        cols.add({"title": col.replaceAll('/', '\n'), 'widthFactor': 0.4, 'key': col});
        continue;
      }
      cols.add({"title": col, 'widthFactor': 0.3, 'key': col});
    }
    Map<String,dynamic> students = {};
    for (String info in data['result_points'].replaceAll('\r','').split('\n')){
      String fio = info.split('~')[0];
      String point = info.split('~')[1];
      students[fio] = {'Итог':point};
    }
    for (String studentResult in result){
      List<String> resultInfo = studentResult.split('~');
      int iter=2;
      String fio = resultInfo.removeAt(0);
      for (String resultPart in resultInfo){
        String key = cols.elementAt(iter)['key'];
        if (key != 'ФИО' && key != 'Итог'){
          students[fio][key] = resultPart.replaceAll('/', '\n');
        }
        iter=iter + 1;
      }
    }
    int rowNumber = 0;
    for (String student in students.keys){
      Map<String,dynamic> newRow = {'row':rowNumber};
      newRow['ФИО'] = student;
      for (String studentKey in students[student].keys){
        newRow[studentKey] = students[student][studentKey];
      }
      rows.add(newRow);
      rowNumber++;
    }
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
        for (String updatedKey in row.keys){
          tableData[row['row']][updatedKey] = row[updatedKey];
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

  Map<String,dynamic> convertTableDataToMap(){
    List<String> students = [];
    List<String> results = [];
    for (int rowNumber in tableData.keys){
      Map<String,dynamic> row = tableData[rowNumber];
      List<String> student = [];
      String result = '';
      for (String studentKey in row.keys){
        if (studentKey == 'row'){
          continue;
        }
        if (studentKey == 'Итог'){
          result = row[studentKey];
          continue;
        }
        student.add(row[studentKey]);
      }
      students.add(student.join('~'));
      results.add('${student[0]}~$result');
    }

    return {
      'result':students.join('\n'),
      'result_point':results.join('\n')
    };
  }


  List cols = [];
  List rows = [];
  Map<int,dynamic> tableData = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00275E),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Просмотр сводки',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff00275E),
        onPressed: () {
          updateTableData();
         Map<String,dynamic> results = convertTableDataToMap();
          editResults(data['id'], results['result'], results['result_point']).then((response){
            Map<String,dynamic> data = convert_response_to_map(response);
            print(data);
          });
        },
        child: Icon(Icons.check),
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
