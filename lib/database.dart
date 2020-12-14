import 'package:postgres/postgres.dart';

import 'config.dart';

Config config = Config();

class Database {
  static final Database _database = Database._internal();
  factory Database() => _database;

  PostgreSQLConnection connection;

  Database._internal() {
    connection = PostgreSQLConnection(
        config.database.host, config.database.port, config.database.database,
        username: config.database.username, password: config.database.password);
  }

  void connect() async {
    await connection.open();
  }
}
