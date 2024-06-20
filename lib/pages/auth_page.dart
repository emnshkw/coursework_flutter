import 'dart:convert';
import 'package:coursework/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coursework/api.dart';
import 'package:coursework/pages/otp_page.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  _AuthPageState();
  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  Padding topPadding() {
    return Padding(
      padding: EdgeInsets.only(
          top: convert_px_to_adapt_height(80),
          left: convert_px_to_adapt_width(30)),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Icon(
              Icons.arrow_back,
              color: Colors.transparent,
            ),
            Padding(
                padding: EdgeInsets.only(right: convert_px_to_adapt_width(10))),
            Text(
              '      ',
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
        'Регистрация',
        style: TextStyle(
            color: Colors.white,
            fontSize: convert_px_to_adapt_height(30),
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _phoneInput(Icon icon, String hint, TextEditingController controller,
      bool hinded, TextInputType keyboardType) {
    return Container(
      padding: EdgeInsets.only(
          left: convert_px_to_adapt_width(26),
          right: convert_px_to_adapt_width(26)),
      width: convert_px_to_adapt_width(330),
      height: convert_px_to_adapt_height(55),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        inputFormatters: [
          LengthLimitingTextInputFormatter(12),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        obscureText: hinded,
        onChanged: (String p) {
          controller.text = "+${controller.text.replaceAll('+', "")}";
        },
        onTap: () {
          controller.text = "+${controller.text.replaceAll('+', "")}";
        },
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23), color: Color(0xff00275E)),
        decoration: InputDecoration(

          contentPadding: EdgeInsets.only(bottom: convert_px_to_adapt_width(5),top: convert_px_to_adapt_width(5)),
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: convert_px_to_adapt_height(20),
              color: Color(0xff00275E)),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(convert_px_to_adapt_width(20)),
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(convert_px_to_adapt_width(20)),
            borderSide: BorderSide(
                color: Color(0xff00275E), width: convert_px_to_adapt_width(1)),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
                left: convert_px_to_adapt_width(10),
                right: convert_px_to_adapt_width(10)),
            child: IconTheme(
              data: IconThemeData(color: Color(0xff00275E)),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordInput(Icon icon, String hint,
      TextEditingController controller, TextInputType keyboardType) {
    return Container(
      padding: EdgeInsets.only(
          left: convert_px_to_adapt_width(26),
          right: convert_px_to_adapt_width(26)),
      width: convert_px_to_adapt_width(330),
      height: convert_px_to_adapt_height(55),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        obscureText: pwdHinded,
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23), color: Color(0xff00275E)),
        decoration: InputDecoration(

            contentPadding: EdgeInsets.only(bottom: convert_px_to_adapt_width(5),top: convert_px_to_adapt_width(5)),
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: convert_px_to_adapt_height(20),
                color: Color(0xff00275E)),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(convert_px_to_adapt_width(20)),
              borderSide: BorderSide(
                  color: Color(0xff00275E),
                  width: convert_px_to_adapt_width(2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(convert_px_to_adapt_width(20)),
              borderSide: BorderSide(
                  color: Color(0xff00275E),
                  width: convert_px_to_adapt_width(1)),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  left: convert_px_to_adapt_width(10),
                  right: convert_px_to_adapt_width(10)),
              child: IconTheme(
                data: IconThemeData(color: Color(0xff00275E)),
                child: icon,
              ),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(
                  left: convert_px_to_adapt_width(10),
                  right: convert_px_to_adapt_width(10)),
              child: IconTheme(
                data: IconThemeData(color: Colors.white),
                child: GestureDetector(
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    setState(() {
                      pwdHinded = !pwdHinded;
                    });
                  },
                ),
              ),
            )),
      ),
    );
  }

  Widget _nameInput(Icon icon, String hint, TextEditingController controller,
      TextInputType keyboardType) {
    return Container(
      padding: EdgeInsets.only(
          left: convert_px_to_adapt_width(26),
          right: convert_px_to_adapt_width(26)),
      width: convert_px_to_adapt_width(330),
      height: convert_px_to_adapt_height(55),
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        maxLines: 1,
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23), color: Colors.black),
        decoration: InputDecoration(
            // labelStyle: TextStyle(
            //   color: Color(0xff00275E)
            // ),
          contentPadding: EdgeInsets.only(bottom: convert_px_to_adapt_width(5),top: convert_px_to_adapt_width(5)),
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: convert_px_to_adapt_height(20),
                color: Color(0xff00275E)),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(convert_px_to_adapt_width(20)),
              borderSide: BorderSide(
                  color: Color(0xff00275E),
                  width: convert_px_to_adapt_width(2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(convert_px_to_adapt_width(20)),
              borderSide: BorderSide(
                  color: Color(0xff00275E),
                  width: convert_px_to_adapt_width(1)),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  left: convert_px_to_adapt_width(10),
                  right: convert_px_to_adapt_width(10)),
              child: IconTheme(
                data: IconThemeData(color: Color(0xff00275E)),
                child: icon,
              ),
            )),
      ),
    );
  }

  ElevatedButton regBtn() {
    return ElevatedButton(
        onPressed: () {
          if (_phoneController.text.length == 12 &&
              _nameController.text.length != 0) {
            if (_passwordController.text.length < 6) {
              Fluttertoast.showToast(
                  msg: 'Пароль должен состоять минимум из 6 символов',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 15,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              Map<String, String> data = {
                'name': _nameController.text,
                'password': _passwordController.text,
                'phone': _phoneController.text,
                'type': 'Регистрация'
              };
              try_to_get_registration_token(
                      _nameController.text, _phoneController.text)
                  .then((value) {
                Map<String, dynamic> response_data =
                    jsonDecode(utf8.decode(value.bodyBytes));
                if (response_data['status'].toString().toLowerCase() ==
                    'success') {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => OtpPage(data),
                      transitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: response_data['message'].toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              });
            }
          } else {
            if (_nameController.text.length == 0) {
              Fluttertoast.showToast(
                  msg: 'Необходимо указать имя',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 15,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            if (_phoneController.text.length != 12) {
              Fluttertoast.showToast(
                  msg: 'Номер телефона введён не полностью',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 15,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
        child: Text(
          'Далее',
          style: TextStyle(
              color: Colors.white,
              fontSize: convert_px_to_adapt_height(17),
              fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff00275E),
          foregroundColor: Color(0xff333450),
          fixedSize: Size(
              convert_px_to_adapt_width(280), convert_px_to_adapt_height(40)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(convert_px_to_adapt_width(20)),
          ),
        ));
  }

  Padding alreadyRegistered() {
    return Padding(
      padding: EdgeInsets.only(top: convert_px_to_adapt_height(10)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => LoginPage(),
              transitionDuration: Duration(milliseconds: 300),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          );
        },
        child: Text(
          'Уже зарегистрированы?\nВойдите',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  bool pwdHinded = true;

  // String selectedCity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/photos/background.png'),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Container(
              child: topPadding(),
            ),
            Container(
              child: enterText(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(55)),
            ),
            Container(
              child: _nameInput(Icon(Icons.person), 'ФИО', _nameController,
                  TextInputType.text),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(15)),
            ),
            Container(
              child: _phoneInput(Icon(Icons.phone), 'Номер телефона',
                  _phoneController, false, TextInputType.phone),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(15)),
            ),
            Container(
              child: _passwordInput(Icon(Icons.lock), 'Пароль',
                  _passwordController, TextInputType.text),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(25)),
            ),
            Container(child: regBtn()),
            alreadyRegistered(),
          ],
        ),
      ),
    );
  }
}
