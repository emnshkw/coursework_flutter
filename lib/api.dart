import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

final String urlStart = 'http://92.255.107.47';

Future<String> getToken() async {
  final token = await storage.read(key: 'auth_token');
  if (token == null) {
    return '';
  }
  return token;
}

List<dynamic> convert_snapshot_to_list(var snapshot) {
  var data = jsonDecode(utf8.decode(snapshot.data.bodyBytes).toString());
  return data['data'];
}

Map<String, dynamic> convert_snapshot_to_map(var snapshot) {
  var data = jsonDecode(utf8.decode(snapshot.data.bodyBytes).toString());
  return (data);
}

Map<String, dynamic> convert_response_to_map(Response response) {
  var data = jsonDecode(utf8.decode(response.bodyBytes).toString());
  return (data);
}


Future<Response> get_info_as_future(String urlAfter) async {
  final token = await getToken();
  var response = get(Uri.parse('$urlStart/api/v1/$urlAfter'),
      headers: {
        'Content-Type': 'text/html',
        'charset': 'UTF-8',
        'Authorization': "Token $token"
      });
  return response;
}

Stream<Response> get_info_as_stream(String urlAfter) async* {
  final token = await getToken();
  yield* Stream.periodic(Duration(seconds: 5), (_) {
    return get(Uri.parse('$urlStart/api/v1/$urlAfter'), headers: {
      'Content-Type': 'text/html',
      'charset': 'UTF-8',
      'Authorization': "Token $token"
    });
  }).asyncMap((event) async => await event);
}

Future<Response> try_to_get_registration_token(

    String name, String phone) async {
  final body = {'username': name, "phone": phone};

  final jsonString = json.encode(body);
  final response = await post(
      Uri.parse('$urlStart/api/v1/auth/user/get_token'),
      body: jsonString,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}

Future<Response> try_to_get_reset_token(String phone, String password) async {
  final body = {'password': password, "phone": phone};
  final jsonString = json.encode(body);
  final response = await post(
      Uri.parse(
          '$urlStart/api/v1/auth/user/send_update_password_code'),
      body: jsonString,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}

Future<Response> get_token(String phone, String password) async {
  final body = {'password': password, "phone": phone};

  final jsonString = json.encode(body);
  final response = await post(
      Uri.parse('$urlStart/auth/token/login'),
      body: jsonString,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}

final storage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  // final storage = FlutterSecureStorage();
  await storage.write(key: 'auth_token', value: token);
}

Future<void> delete_token() async {
  await storage.delete(key: 'auth_token');
}

// $urlStart/auth/token/logout/
Future<Response> logout() async {
  final token = await getToken();
  var response = post(Uri.parse('$urlStart/auth/token/logout/'),
      headers: {
        'Content-Type': 'text/html',
        'charset': 'UTF-8',
        'Authorization': "Token $token"
      });
  delete_token();
  return response;
}

Future<Response> check_token(String token) async {
  var response = await get(Uri.parse('$urlStart/api/v1/auth/user/'),
      headers: {
        'Content-Type': 'text/html',
        'charset': 'UTF-8',
        'Authorization': "Token $token"
      });
  return response;
}

Future<Response> try_to_register(Map<String, String> data) async {
  final body = {
    'username': data['name'],
    "phone": data['phone'],
    "password": data['password'],
    'code': data['code'],
    'new_city': data['city'],
    "re_password": data['password'],
    "role":data['role']
  };
  final jsonString = json.encode(body);
  final response = await post(
      Uri.parse('$urlStart/api/v1/auth/user/check_token'),
      body: jsonString,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}

Future<Response> try_to_reset_password(
    String phone, String password, String code) async {
  final body = {
    "phone": phone,
    "password": password,
    'code': code,
  };
  final jsonString = json.encode(body);
  final response = await post(
      Uri.parse(
          '$urlStart/api/v1/auth/user/check_update_password_code'),
      body: jsonString,
      headers: {
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}


Future<Response> get_user_data() async {
  final token = await getToken();
  final response = await get(
      Uri.parse('$urlStart/api/v1/auth/user'),
      headers: {'Authorization': "Token $token"});
  return response;
}

Future<Response> addLessonType(String lessonType,String hexColor) async {
  final body = {
    'lesson_type':lessonType,
    'color':hexColor
  };
  final token = await getToken();
  final jsonString = json.encode(body);
  final response = await post(
      Uri.parse('$urlStart/api/v1/auth/user/'),
      body: jsonString,
      headers: {'Authorization': "Token $token",
        'Content-Type': 'application/json',
        'charset': 'UTF-8',});
  return response;
}

Future<Response> getGroups() async {
  final token = await getToken();
  final response = await get(
      Uri.parse('$urlStart/api/v1/groups/'),
      headers: {'Authorization': "Token $token"});
  return response;
}


Future<Response> addGroup(
    String groupNumber,String groupName,String groupMarks,String students) async {
  final body = {
    "group_number": groupNumber,
    "group_name": groupName,
    'marks': groupMarks,
    "students":students
  };
  final token = await getToken();
  final jsonString = json.encode(body);
  final response = await post(
      Uri.parse(
          '$urlStart/api/v1/groups/'),
      body: jsonString,
      headers: {
        'Authorization': "Token $token",
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}
Future<Response> editGroup(
    String groupNumber,String groupName,String groupMarks,String students,String id) async {
  final body = {
    "group_number": groupNumber,
    "group_name": groupName,
    'marks': groupMarks,
    "students":students
  };
  final token = await getToken();
  final jsonString = json.encode(body);
  final response = await put(
      Uri.parse(
          '$urlStart/api/v1/groups/$id/'),
      body: jsonString,
      headers: {
        'Authorization': "Token $token",
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}
Future<Response> deleteGroup(int id) async {

  final token = await getToken();
  final response = await delete(
      Uri.parse(
          '$urlStart/api/v1/groups/$id/'),
      headers: {
        'Authorization': "Token $token",
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}

Future<Response> getLessons() async {
  final token = await getToken();
  final response = await get(
      Uri.parse('$urlStart/api/v1/lessons/'),
      headers: {'Authorization': "Token $token"});
  return response;
}

Future<Response> addLesson(
    String lesson_title,String lessonType,String color,String place,String date,int group_id,String time) async {
  final body = {
    'lesson_title':lesson_title,
    'place':place,
    'group_id':group_id,
    'date':'$date $time',
    'lesson_type':'$lessonType~$color'
  };
  final token = await getToken();
  final jsonString = json.encode(body);
  final response = await post(
      Uri.parse(
          '$urlStart/api/v1/lessons/'),
      body: jsonString,
      headers: {
        'Authorization': "Token $token",
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}
Future<Response> editLesson(
    String lesson_title,String lessonType,String color,String place,String date,int group_id,String time) async {
  final body = {
    'lesson_title':lesson_title,
    'place':place,
    'group_id':group_id,
    'date':'$date $time',
    'lesson_type':'$lessonType~$color'
  };
  final token = await getToken();
  final jsonString = json.encode(body);
  final response = await put(
      Uri.parse(
          '$urlStart/api/v1/lessons/'),
      body: jsonString,
      headers: {
        'Authorization': "Token $token",
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}
Future<Response> deleteLesson(int id) async {

  final token = await getToken();
  final response = await delete(
      Uri.parse(
          '$urlStart/api/v1/lessons/$id/'),
      headers: {
        'Authorization': "Token $token",
        'Content-Type': 'application/json',
        'charset': 'UTF-8',
      });
  return response;
}