import 'package:coursework/api.dart';
import 'package:coursework/pages/groups_page.dart';
import 'package:coursework/pages/landing_page.dart';
import 'package:coursework/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:coursework/functions.dart';

class CustomDrawer extends StatefulWidget {
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff00275E),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: convert_px_to_adapt_height(45)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                    size: convert_px_to_adapt_height(40),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    delete_token();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => LandingPage(),
                        transitionDuration: Duration(milliseconds: 300),
                        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                    size: convert_px_to_adapt_height(30),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              CircleAvatar(
                radius: convert_px_to_adapt_width(60),
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: convert_px_to_adapt_height(80),
                  color: Color(0xff00275E),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: convert_px_to_adapt_height(15)),
                width: convert_px_to_adapt_width(215),
                child: Text(
                  getItemFromProfile('name'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: convert_px_to_adapt_height(15),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: convert_px_to_adapt_height(20),
                    left: convert_px_to_adapt_width(11),
                    right: convert_px_to_adapt_width(11)),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => MainPage(),
                            transitionDuration: Duration(milliseconds: 300),
                            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                          ),
                        );
                      },
                      child: Padding(
                        padding:
                        EdgeInsets.only(left: convert_px_to_adapt_width(15)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Расписание',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: convert_px_to_adapt_height(18)),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => GroupsPage(),
                            transitionDuration: Duration(milliseconds: 300),
                            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                          ),
                        );
                      },
                      child: Padding(
                        padding:
                        EdgeInsets.only(left: convert_px_to_adapt_width(15)),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Группы',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: convert_px_to_adapt_height(18)),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: convert_px_to_adapt_width(15)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Итоговые сводки',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: convert_px_to_adapt_height(18)),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.white,
                    ),

                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
