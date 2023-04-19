// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:shared_preferences/shared_preferences.dart';

class LocalSetting {
  Future createChache(String email, String senha) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    _preferences.setString('email', email);
    _preferences.setString('senha', senha);
  }

  Future createChacheDark(bool darkMode) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();

    _preferences.setBool('darkMode', darkMode);
  }

  Future readChache() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cacheEmail = _preferences.getString('email');
    var cacheSenha = _preferences.getString('senha');
    Map<String, dynamic> infos = {'email': cacheEmail, 'senha': cacheSenha};
    return infos;
  }

  Future readChacheDark() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var cacheDark = _preferences.getBool('darkMode');
    return cacheDark;
  }

  Future removeChache() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('senha');
    _preferences.remove('email');
  }
}
