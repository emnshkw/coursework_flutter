import 'package:coursework/drawer.dart';
import 'package:coursework/pages/add_group_page.dart';
import 'package:flutter/material.dart';
import 'package:coursework/api.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupsPage extends StatefulWidget {
  @override
  State<GroupsPage> createState() => _MainChooseState();
}

class _MainChooseState extends State<GroupsPage> {
  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  void acceptDelete(int id){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Вы уверены, что хотите удалить группу?'),
        content: SizedBox(
          height: convert_px_to_adapt_height(40),
        ),
        actions: [
          ElevatedButton(style:ElevatedButton.styleFrom(
            backgroundColor: Color(0xff00275E)
          ),onPressed: (){
            deleteGroup(id).then((response){
              Map<String,dynamic> data = convert_response_to_map(response);
              if (data['status'] == 'success'){
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
              else{
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
          }, child: Text('Подтвердить',style:TextStyle(color: Colors.white))),
          ElevatedButton(style:ElevatedButton.styleFrom(
            backgroundColor: Color(0xff00275E)
          ),onPressed: (){}, child: Text('Отмена',style:TextStyle(color: Colors.white))),
        ],
      );
    });
  }

  ElevatedButton groupButton(Map<String, dynamic> groupInfo) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        onPressed: () {
          Map<dynamic, dynamic> data = {};
          List<String> students = groupInfo['students'].split('\n');
          for (int i = 0; i < students.length; i++) {
            data[i] = {'row': i, 'name': students[i]};
          }
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => AddGroupPage(
                  groupInfo['marks'],
                  groupInfo['group_name'],
                  groupInfo['group_number'],
                  data,
                  true,
                  groupInfo['id'].toString()),
              transitionDuration: Duration(milliseconds: 300),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          );
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
                width: MediaQuery.of(context).size.width/1.5,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('${groupInfo['group_number']} (${groupInfo['group_name']})',textAlign: TextAlign.center,),
                  ],
                ),
              ),
              IconButton(onPressed: (){
                acceptDelete(groupInfo['id']);
              }, icon: Icon(Icons.delete))
            ],
          ),
        ));
  }

  FloatingActionButton addGroupButton() {
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
          'Группы',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: addGroupButton(),
      body: Column(
        children: [
          FutureBuilder(
              future: getGroups(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = convert_snapshot_to_map(snapshot);
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
