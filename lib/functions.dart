import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:coursework/file_storage.dart';

String convertDateTimeToString(DateTime date) {
  var year = date.year;
  var month = date.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  var day = date.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  String converted = '$day.$month.$year';
  return converted;
}

DateTime convertStringToDateTime(String date) {
  int year = int.parse(date.split('.')[2]);
  int month = int.parse(date.split('.')[1]);
  int day = int.parse(date.split('.')[0]);
  return DateTime(year, month, day);
}

String validateTime(String time) {
  try {
    String start = time.split('-')[0];
    String end = time.split('-')[1];
    try {
      DateTime startTime = DateTime(2024, 1, 1, int.parse(start.split(':')[0]),
          int.parse(start.split(':')[1]));
      try {
        DateTime endTime = DateTime(2024, 1, 1, int.parse(end.split(':')[0]),
            int.parse(end.split(':')[1]));
        if (startTime.isAfter(endTime) || startTime.isAtSameMomentAs(endTime)) {
          return "Время указано неправильно! Конец занятия должен быть после начала";
        } else {
          return "success";
        }
      } catch (e) {
        return "Время конца занятия указано неправильно. Следуйте указанному формату\n(формат \"XX:XX - XX:XX\")";
      }
    } catch (e) {
      return "Время начала занятия указано неправильно. Следуйте указанному формату\n(формат \"XX:XX - XX:XX\"";
    }
  } catch (e) {
    return "Время указано неверно. Разделите его с помощью \"-\"";
  }
  return '';
}

void addItemsToProfile(String key, String value) {
  final storage = LocalStorage('profile_storage');
  storage.setItem(key, value);
}

String getItemFromProfile(String key) {
  return LocalStorage('profile_storage').getItem(key);
}

void addItemsToFavourite(
    String logo_link,
    String title,
    String address,
    String work_time,
    String background_image_link,
    String id,
    String urlAfter) {
  final storage = LocalStorage('favourite_storage');
  int index = 0;
  bool finded = false;
  while (!finded) {
    var data = storage.getItem(index.toString());
    if (data == null) {
      storage.setItem(index.toString(),
          '$logo_link~$title~$address~$work_time~$background_image_link~$id~$urlAfter');
      break;
    }
    index = index + 1;
  }
}

String getItemFromFavourite(String index) {
  final storage = LocalStorage('favourite_storage');
  var item = storage.getItem(index.toString());
  if (item == null) {
    return '';
  } else {
    return item;
  }
}

void deleteItemFromFavourite(
    String logo_link,
    String title,
    String address,
    String work_time,
    String background_image_link,
    String id,
    String urlAfter) {
  final storage = LocalStorage('favourite_storage');
  int index = 0;
  bool finded = false;
  while (!finded) {
    var data = storage.getItem(index.toString());
    if (data.split('~')[1] == title) {
      finded = true;
      storage.deleteItem(index.toString());
      break;
    }
    index = index + 1;
  }
  ;
}

List<String> getAllItems() {
  final storage = LocalStorage('favourite_storage');
  List<String> items = [];
  int index = 0;
  bool finded = false;
  while (!finded) {
    var data = storage.getItem(index.toString());
    if (data == null) {
      break;
    } else {
      if (!items.contains(data)) {
        items.add(data);
      } else {
        List<String> place = data.split('~');
        String logo_link = place[0];
        String title = place[1];
        String address = place[2];
        String work_time = place[3];
        String background_image_link = place[4];
        String id = place[5];
        String urlAfter = place[6];
        deleteItemFromFavourite(logo_link, title, address, work_time,
            background_image_link, id, urlAfter);
      }
    }
    index = index + 1;
  }
  ;
  return items;
}

void updateItem(
    String logo_link,
    String title,
    String address,
    String work_time,
    String background_image_link,
    String id,
    String urlAfter) {
  List<String> items = [];
  String place =
      '$logo_link~$title~$address~$work_time~$background_image_link~$id~$urlAfter';
  FileStorage.read().then((value) {
    items = value.split('\n');
    if (items.contains(place)) {
      items.remove(place);
      FileStorage.writeCounter(items.join('\n'), 'favourites.txt');
    } else {
      items.add(place);
      FileStorage.writeCounter(items.join('\n'), 'favourites.txt');
    }
  });
}
