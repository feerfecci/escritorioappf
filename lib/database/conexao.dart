import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'escritorioapp.mysql.dbaas.com.br',
      user = 'escritorioapp',
      password = 'Escritorio#123',
      db = 'escritorioapp';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}