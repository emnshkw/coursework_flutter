import 'package:coursework/drawer.dart';
import 'package:coursework/pages/add_group_page.dart';
import 'package:dynamic_table/dynamic_table.dart';
import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:coursework/api.dart';

class TablePage extends StatefulWidget {
  String groupNumberText;
  String groupNameText;
  String groupMarksText;
  Map<dynamic, dynamic> tableData;
  bool created;
  String id;

  TablePage(this.groupMarksText, this.groupNameText, this.groupNumberText,
      this.tableData, this.created, this.id);

  @override
  State<TablePage> createState() => _TablePageState(
      groupNumberText, groupNameText, groupMarksText, tableData, created, id);
}

class _TablePageState extends State<TablePage> {
  late Map<dynamic, dynamic> tableData;
  late String groupNumberText;
  late String groupNameText;
  late String groupMarksText;
  late List rows;
  late bool created;
  late String id;

  _TablePageState(
      String groupNumberText1,
      String groupNameText1,
      String groupMarksText1,
      Map<dynamic, dynamic> tableData1,
      bool created1,
      String id1) {
    groupNumberText = groupNumberText1;
    groupNameText = groupNameText1;
    groupMarksText = groupMarksText1;
    tableData = tableData1;
    created = created1;
    id = id1;
    rows = [];
    for (var key in tableData.keys) {
      rows.add(tableData[key]);
    }
    print(tableData);
  }

  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  void _addNewRow() {
    setState(() {
      _editableKey.currentState?.createRow();
    });
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
        tableData[row['row']] = row;
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
    {"title": 'ФИО', 'widthFactor': 1, 'key': 'name'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                updateTableData();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => AddGroupPage(
                        groupNumberText,
                        groupNameText,
                        groupMarksText,
                        tableData,
                        created,
                        id),
                    transitionDuration: Duration(milliseconds: 300),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ),
                );
              },
              icon: Icon(Icons.check))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff00275E),
        onPressed: () {
          _addNewRow();
        },
        child: Icon(Icons.add),
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
