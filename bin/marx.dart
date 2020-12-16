import 'package:marx/config.dart';
import 'package:marx/base_group.dart';
import 'package:marx/database.dart';
import 'package:marx/poll_group.dart';
import 'package:marx/migrate.dart';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

Config config = Config();
Database database = Database();

void main(List<String> args) async {
  await database.connect();

  if(args.contains('--migrate') || args.contains('-m')) {
    print('[Marx] Attempting to migrate any database changes.');
    await migrate();
    }

  final bot = Nyxx(config.token, 1607);

  var baseGroup = initializeBaseGroup();
  var pollGroup = initializePollGroup();

  Commander(bot,
      beforeCommandHandler: passHandler,
      prefixHandler: prefixHandler)
    ..registerCommandGroup(baseGroup)
    ..registerCommandGroup(pollGroup);

  bot.onGuildCreate.listen(onGuildCreate);
}

bool passHandler(CommandContext context) {
  return !context.author.bot;
}

Future<String> prefixHandler(Message msg) async {
  if (!(msg is GuildMessage)) return config.prefix;

  var query = await database.connection.query(
      'SELECT prefix FROM guilds WHERE id = @id;',
      substitutionValues: {'id': (msg as GuildMessage).guild.id.id});

  if(query.isNotEmpty) {
    var prefix = query.first.first;
    return prefix;
  }

  return config.prefix;
}

void onGuildCreate(GuildCreateEvent event) async {
  await database.connection.query(
      'INSERT INTO guilds (id, prefix) VALUES (@id, @prefix) ON CONFLICT DO NOTHING;',
      substitutionValues: {'id': event.guild.id.id, 'prefix': config.prefix});
}
