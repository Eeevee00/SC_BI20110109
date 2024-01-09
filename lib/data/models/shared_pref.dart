import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(key)){
      return json.decode(prefs.getString(key)!);
    }
    else{
      return null;
    }
    
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    //String jsonUser = json.encode(value);
    //print(jsonUser);
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}