import 'dart:convert';
import 'package:coursework/pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coursework/api.dart';

class OtpPage extends StatefulWidget {
  // const OtpPage({super.key});

  Map<String, String> data;

  OtpPage(this.data);

  @override
  State<OtpPage> createState() => _OtpPageState(data);
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController _otpController = TextEditingController();

  late Map<String, String> data;

  _OtpPageState(Map<String, String> data1) {
    data = data1;
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
    Navigator.of(context).pushNamedAndRemoveUntil('/landing', (route) => false);
  }

  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  Padding backBtn() {
    return Padding(
      padding: EdgeInsets.only(
          top: convert_px_to_adapt_height(80),
          left: convert_px_to_adapt_width(30)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Row(
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            Padding(
                padding: EdgeInsets.only(right: convert_px_to_adapt_width(10))),
            Text(
              'Назад',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: convert_px_to_adapt_height(20)),
            )
          ],
        ),
      ),
    );
  }

  Padding enterText() {
    return Padding(
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(70)),
      child: Text(
        'Подтверждение',
        style: TextStyle(
            color: Color(0xff00275E), fontSize: convert_px_to_adapt_height(30)),
      ),
    );
  }

  Padding subscription() {
    return Padding(
        padding: EdgeInsets.only(top: convert_px_to_adapt_height(30)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Введите 4 последние цифры номера, который позвонил\nна номер ${data["phone"]}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff757483),
              fontSize: convert_px_to_adapt_height(17),
            ),
          ),
        ));
  }

  Padding otpField() {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Container(
        height: convert_px_to_adapt_height(70),
        width: convert_px_to_adapt_width(150),
        child: TextField(
            textAlign: TextAlign.center,
            controller: _otpController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(4),
            ],
            style: TextStyle(
                fontSize: convert_px_to_adapt_height(25),
                color: Color(0xff00275E)),
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(convert_px_to_adapt_width(20)),
                  borderSide: BorderSide(
                      color: Color(0xff00275E),
                      width: convert_px_to_adapt_width(0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xff00275E),
                      width: convert_px_to_adapt_width(0)),
                ))),
      ),
    );
  }

  Padding acceptBtn() {
    return Padding(
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(50)),
      child: ElevatedButton(
          onPressed: () {
            data['code'] = _otpController.text;
            setState(() {
              submitted = true;
            });
          },
          child: Text(
            'Подтвердить',
            style: TextStyle(
                color: Colors.white, fontSize: convert_px_to_adapt_height(17)),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff00275E),
            foregroundColor: Color(0xff333450),
            fixedSize: Size(
                convert_px_to_adapt_width(230), convert_px_to_adapt_height(60)),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(convert_px_to_adapt_width(20)),
            ),
          )),
    );
  }

  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            child: backBtn(),
          ),
          Container(
            child: enterText(),
          ),
          Container(
            child: subscription(),
          ),
          Container(
            child: otpField(),
          ),
          Container(
            child: acceptBtn(),
          ),
          submitted
              ? FutureBuilder(
                  future: try_to_register(data),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic> response_data =
                          jsonDecode(utf8.decode(snapshot.data.bodyBytes));

                      if (response_data['status'].toLowerCase() == 'success') {
                        Fluttertoast.showToast(
                            msg: 'Успешно!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 15,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        saveToken(response_data['message']);
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => LandingPage(),
                            transitionDuration: Duration(milliseconds: 300),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c),
                          ),
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: '${response_data['message']}',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 15,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        submitted = false;
                      }
                      return Text('');
                    } else {
                      if (snapshot.hasError) {
                        Fluttertoast.showToast(
                            msg: 'Что-то пошло не так!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 15,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        submitted = false;
                        _otpController.text = '';
                      }
                      if (!snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.done) {
                        Fluttertoast.showToast(
                            msg:
                                'Что-то пошло не так!\nПроверьте подключение к интернету.',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 15,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        submitted = false;
                        _otpController.text = '';
                      }
                      return LinearProgressIndicator();
                    }
                  })
              : Text('')
        ],
      ),
    );
  }
}
