import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coursework/api.dart';
import 'package:coursework/pages/otp_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cityController = TextEditingController(text: 'Выбор города');
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initFirebase();
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
        'Регистрация',
        style: TextStyle(
            color: Colors.white, fontSize: convert_px_to_adapt_height(30)),
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
            fontSize: convert_px_to_adapt_height(23), color: Colors.white),
        decoration: InputDecoration(
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: convert_px_to_adapt_height(20),
              color: Colors.white30),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(convert_px_to_adapt_width(20)),
            borderSide: BorderSide(
                color: Colors.white, width: convert_px_to_adapt_width(2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(convert_px_to_adapt_width(20)),
            borderSide: BorderSide(
                color: Colors.white54, width: convert_px_to_adapt_width(1)),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(
                left: convert_px_to_adapt_width(10),
                right: convert_px_to_adapt_width(10)),
            child: IconTheme(
              data: IconThemeData(color: Colors.white),
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
            fontSize: convert_px_to_adapt_height(23), color: Colors.white),
        decoration: InputDecoration(
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: convert_px_to_adapt_height(20),
                color: Colors.white30),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(convert_px_to_adapt_width(20)),
              borderSide: BorderSide(
                  color: Colors.white, width: convert_px_to_adapt_width(2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(convert_px_to_adapt_width(20)),
              borderSide: BorderSide(
                  color: Colors.white54, width: convert_px_to_adapt_width(1)),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  left: convert_px_to_adapt_width(10),
                  right: convert_px_to_adapt_width(10)),
              child: IconTheme(
                data: IconThemeData(color: Colors.white),
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
        style: TextStyle(
            fontSize: convert_px_to_adapt_height(23), color: Colors.white),
        decoration: InputDecoration(
            hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: convert_px_to_adapt_height(20),
                color: Colors.white30),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(convert_px_to_adapt_width(20)),
              borderSide: BorderSide(
                  color: Colors.white, width: convert_px_to_adapt_width(2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(convert_px_to_adapt_width(20)),
              borderSide: BorderSide(
                  color: Colors.white54, width: convert_px_to_adapt_width(1)),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  left: convert_px_to_adapt_width(10),
                  right: convert_px_to_adapt_width(10)),
              child: IconTheme(
                data: IconThemeData(color: Colors.white),
                child: icon,
              ),
            )),
      ),
    );
  }

  GestureDetector forget_password() {
    return GestureDetector(
      child: Text(
        'Забыл пароль',
        style: TextStyle(
            color: Color(0xffB8B8B8), fontSize: convert_px_to_adapt_height(15)),
      ),
    );
  }

  ElevatedButton regBtn() {
    return ElevatedButton(
        onPressed: () {
          if (_phoneController.text.length == 12 &&
              _nameController.text.length != 0 && _cityController.text != 'Выбор города') {
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
                'city': _cityController.text,
                'type':'Регистрация'
              };
              try_to_get_registration_token(_nameController.text,_phoneController.text).then((value) {
                Map<String, dynamic> response_data =
                jsonDecode(utf8.decode(value.bodyBytes));
                if (response_data['status'].toString().toLowerCase() == 'success') {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => OtpPage(data),
                      transitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
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
            if (_cityController.text == "Выбор города") {
              Fluttertoast.showToast(
                  msg: 'Выберите город',
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
              color: Color(0xff333450),
              fontSize: convert_px_to_adapt_height(17)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xff333450),
          fixedSize: Size(
              convert_px_to_adapt_width(280), convert_px_to_adapt_height(40)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(convert_px_to_adapt_width(20)),
          ),
        ));
  }

  Widget cityPicker(Icon icon, String hint, TextEditingController controller) {
    List<DropdownMenuItem> entries = [];
    for (String text in ['Преподаватель',"Ученик"]) {
      entries.add(
        // DropdownMenuEntry(value: city_el['city_ru_name'], label: city_el['city_ru_name'])
          DropdownMenuItem(
            child: Container(
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: convert_px_to_adapt_height(17),
                    color: Colors.black45),
              ),
            ),
            value: text,
          ));
    }
    return Container(
      padding: EdgeInsets.only(
          left: convert_px_to_adapt_width(5),
          right: convert_px_to_adapt_width(10)),
      width: convert_px_to_adapt_width(280),
      height: convert_px_to_adapt_height(55),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(convert_px_to_adapt_width(20)),
          border: Border.all(
            color: Colors.white54,
            width: convert_px_to_adapt_height(2),
          )),
      child: Container(
          child: DropdownButton(
            items: entries,
            hint: Container(
              width: convert_px_to_adapt_width(230),
              child: TextField(
                  controller: _cityController,
                  readOnly: true,
                  style: TextStyle(
                      fontSize: convert_px_to_adapt_height(23),
                      color: Colors.white54),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            convert_px_to_adapt_width(20)),
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            width: convert_px_to_adapt_width(0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            width: convert_px_to_adapt_width(0)),
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                            right: convert_px_to_adapt_width(10)),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.white),
                          child: icon,
                        ),
                      ))),
            ),
            onChanged: (dynamic value) {
              _cityController.text = value;
            },
            // value: selectedCity,
          )),
    );
  }

  bool pwdHinded = true;

  // String selectedCity = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff333450),
      body: Column(
        children: [
          Container(
            child: backBtn(),
          ),
          Container(
            child: enterText(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: convert_px_to_adapt_height(55)),
          ),
          Container(
            child: _nameInput(
                Icon(Icons.person), 'Имя', _nameController, TextInputType.text),
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
            child:
            cityPicker(Icon(Icons.location_city), 'Город', _cityController),
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
        ],
      ),
    );
  }
}
