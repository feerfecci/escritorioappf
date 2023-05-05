import 'package:shared_preferences/shared_preferences.dart';

class LocalSetting {
  Future createChache(String email, String senha) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('email', email);
    preferences.setString('senha', senha);
  }

  // Future createChacheDark(bool darkMode) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();

  //   preferences.setBool('darkMode', darkMode);
  // }

  Future readChache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var cacheEmail = preferences.getString('email');
    var cacheSenha = preferences.getString('senha');
    Map<String, dynamic> infos = {'email': cacheEmail, 'senha': cacheSenha};
    return infos;
  }

  // Future readChacheDark() async {
  //   SharedPreferences _preferences = await SharedPreferences.getInstance();
  //   var cacheDark = _preferences.getBool('darkMode');
  //   return cacheDark;
  // }

  Future removeChache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('senha');
    preferences.remove('email');
  }
}
