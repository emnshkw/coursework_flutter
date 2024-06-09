import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:coursework/file_storage.dart';


void addItemsToProfile(
    String key,String value) {
  final storage = LocalStorage('profile_storage');
  storage.setItem(key, value);
}

String getItemFromProfile(String key){
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
  };
}

List<String> getAllItems(){
  final storage = LocalStorage('favourite_storage');
  List<String> items = [];
  int index = 0;
  bool finded = false;
  while (!finded) {
    var data = storage.getItem(index.toString());
    if (data == null) {
      break;
    }
    else{
      if (!items.contains(data)) {
        items.add(data);
      }
      else{
        List<String> place = data.split('~');
        String logo_link = place[0];
        String title = place[1];
        String address = place[2];
        String work_time = place[3];
        String background_image_link = place[4];
        String id = place[5];
        String urlAfter = place[6];
        deleteItemFromFavourite(logo_link, title, address, work_time, background_image_link, id, urlAfter);
      }
    }
    index = index + 1;
  };
  return items;
}


void updateItem(
    String logo_link,
    String title,
    String address,
    String work_time,
    String background_image_link,
    String id,
    String urlAfter){
  List<String> items=[];
  String place = '$logo_link~$title~$address~$work_time~$background_image_link~$id~$urlAfter';
  FileStorage.read().then((value){
    items = value.split('\n');
    if (items.contains(place)){
      items.remove(place);
      FileStorage.writeCounter(items.join('\n'), 'favourites.txt');
    }
    else{
      items.add(place);
      FileStorage.writeCounter(items.join('\n'), 'favourites.txt');
    }
  });
}

