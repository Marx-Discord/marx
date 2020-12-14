import 'dart:io';
import 'package:yaml/yaml.dart';

class Config {
  static final Config _config = Config._internal();

  factory Config() => _config;

  String token;
  String prefix;

  Config._internal() {
    var contents = File('configuration.yaml').readAsStringSync();
    var conf = loadYaml(contents);

    token = conf['token'];
    prefix = conf['prefix'];
  }
}
