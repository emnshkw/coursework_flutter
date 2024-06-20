import 'dart:convert';
import 'package:coursework/pages/login_page.dart';
import 'package:coursework/pages/login_page.dart';
import 'package:coursework/pages/start_page.dart';
import 'package:coursework/pages/start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:coursework/functions.dart';
import 'package:coursework/api.dart';
import 'package:coursework/pages/auth_page.dart';
import 'package:coursework/pages/main_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double convert_px_to_adapt_width(double px) {
      return MediaQuery.of(context).size.width / 392 * px;
    }

    double convert_px_to_adapt_height(double px) {
      return MediaQuery.of(context).size.height / 852 * px;
    }

    final storage = FlutterSecureStorage();
    try {
      String lstorageTest = getItemFromFavourite('test');
    } catch (e) {
      final lstorage = new LocalStorage('favourite_storage');
    }

    try {
      String pstorageTest = getItemFromProfile('name');
    } catch (e) {
      final pstorage = new LocalStorage('profile_storage');
    }

    Future<String> getToken() async {
      final token = await storage.read(key: 'auth_token');
      if (token == null) {
        return '';
      }
      return token;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: getToken(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              String token = snapshot.data;

              if (snapshot.data == '' ||
                  snapshot.data == 'null' ||
                  snapshot.data == null) {
                return StartPage();
              } else {
                // return MainChoose(snapshot.data);
                print(token);
                return FutureBuilder(
                    future: check_token(token),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        try {
                          var data = jsonDecode(
                              utf8.decode(snapshot.data.bodyBytes).toString());
                        } catch (e) {
                          return Center(
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                2.5)),
                                Text(
                                  "Журнал-онлайн",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: convert_px_to_adapt_height(35),
                                      color: Color(0xff00275E)),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            convert_px_to_adapt_height(20))),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: convert_px_to_adapt_width(26),
                                      right: convert_px_to_adapt_width(26)),
                                  child: Text(
                                    "Что-то пошло не так!\nПроверьте подключение к интернету",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            convert_px_to_adapt_height(20),
                                        color: Color(0xff00275E)),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            convert_px_to_adapt_height(30))),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              LandingPage(),
                                          transitionDuration:
                                              Duration(milliseconds: 300),
                                          transitionsBuilder: (_, a, __, c) =>
                                              FadeTransition(
                                                  opacity: a, child: c),
                                        ),
                                      );
                                    },
                                    child: Text('Повторить попытку'))
                              ],
                            ),
                          );
                        }
                        var data = jsonDecode(
                            utf8.decode(snapshot.data.bodyBytes).toString());
                        bool success = false;
                        try {
                          String detail = data['detail'];
                          success = false;
                        } catch (e) {
                          String status = data['status'];
                          if (status == 'success') {
                            success = true;
                          }
                        }
                        if (success == true) {
                          addItemsToProfile('name', data['username']);
                          addItemsToProfile('phone', data['phone']);

                          return MainPage();
                        } else {
                          return StartPage();
                        }
                      } else {
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                2.5)),
                                Text(
                                  "Журнал-мобайл",
                                  style: TextStyle(
                                      fontFamily: 'Cinzel',
                                      fontWeight: FontWeight.w900,
                                      fontSize: convert_px_to_adapt_height(35),
                                      color: Color(0xff00275E)),
                                ),
                                Text(
                                  "Что-то пошло не так!\nПроверьте подключение к интернету",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: convert_px_to_adapt_height(20),
                                      color: Color(0xff00275E)),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            convert_px_to_adapt_height(30))),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          2.5)),
                              Text(
                                "Журнал-мобайл",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: convert_px_to_adapt_height(35),
                                    color: Color(0xff00275E)),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: convert_px_to_adapt_height(30))),
                              LinearProgressIndicator()
                            ],
                          );
                        }
                      }
                    });
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
          }),
    );
  }
}
