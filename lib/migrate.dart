import 'dart:io';
import 'package:marx/database.dart';

Database database = Database();

void migrate() async {
  var dir = Directory('./migrations');
  await dir
      .list(recursive: false, followLinks: false)
      .listen((FileSystemEntity entity) async {
    var fileName =
    entity.path.split('/').last.split('\\').last.replaceFirst('.sql', '');
    var response = await database.connection.query(
        "SELECT EXISTS( SELECT 1 FROM information_schema.tables WHERE table_name = 'migrations' and table_schema='public');");
    var migrated_once = false;
    for (final row in response) {
      if (row[0]) migrated_once = true;

      if (!migrated_once) {
        await database.connection.query(
            'CREATE TABLE IF NOT EXISTS migrations (migration TEXT UNIQUE)');
      } else {
        var migratedResponse = await database.connection.query(
            'SELECT true FROM migrations WHERE migration = @migration',
            substitutionValues: {'migration': fileName});
        for (final row in migratedResponse) {
          if (row[0]) return;
        }
      }
    }

    var contents = '';
    if (entity is File) contents = entity.readAsStringSync();

    if (contents != null) {
      await database.connection.execute(contents);
      await database.connection.query(
          'INSERT INTO migrations (migration) VALUES (@migration)',
          substitutionValues: {'migration': fileName});
    }
  });
}
