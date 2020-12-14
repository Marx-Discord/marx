import 'dart:io';
import 'package:yaml/yaml.dart';

class Config {
  static final Config _config = Config._internal();

  factory Config() => _config;

  String token;
  String prefix;

  DBConfig database;

  Config._internal() {
    var contents = File('configuration.yaml').readAsStringSync();
    var conf = loadYaml(contents);

    token = conf['token'];
    prefix = conf['prefix'];

    database = DBConfig(
        conf['database']['host'],
        conf['database']['port'],
        conf['database']['database'],
        conf['database']['username'],
        conf['database']['password']);
  }
}

class DBConfig {
  final String _host;
  final int _port;
  final String _username;
  final String _password;
  String _db;

  String get host => _host;
  int get port => _port;
  String get database => _db;
  String get username => _username;
  String get password => _password;

  DBConfig(this._host, this._port, this._db, this._username, this._password);
}
