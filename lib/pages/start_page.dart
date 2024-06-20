import 'dart:convert';
import 'package:coursework/pages/auth_page.dart';
import 'package:coursework/pages/landing_page.dart';
import 'package:coursework/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coursework/api.dart';
import 'package:coursework/pages/otp_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  double convert_px_to_adapt_width(double px) {
    return MediaQuery.of(context).size.width / 392 * px;
  }

  double convert_px_to_adapt_height(double px) {
    return MediaQuery.of(context).size.height / 852 * px;
  }

  Padding topPadding() {
    return Padding(
      padding: EdgeInsets.only(
          top: convert_px_to_adapt_height(280),
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
        'Журнальчик',
        style: TextStyle(
            color: Color(0xff00275E),
            fontSize: convert_px_to_adapt_height(30),
            fontWeight: FontWeight.bold),
      ),
    );
  }

  ElevatedButton registerBtn() {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => AuthPage(),
              transitionDuration: Duration(milliseconds: 300),
              transitionsBuilder: (_, a, __, c) =>
                  FadeTransition(opacity: a, child: c),
            ),
          );
        },
        child: Text(
          'Регистрация',
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


  ElevatedButton loginBtn() {
    return ElevatedButton(
        onPressed: () {
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
          'Войти',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/photos/background.png'),
                fit: BoxFit.fill)),
        child: Center(
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
              Container(child: loginBtn()),
              Padding(
                padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(15)),
              ),
              Container(child: registerBtn()),
            ],
          ),
        ),
      ),
    );
  }
}
