import 'package:marx/config.dart';
import 'package:marx/base_group.dart';
import 'package:marx/database.dart';
import 'package:marx/poll_group.dart';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

Config config = Config();
Database database = Database();

void main() {
  database.connect();
  final bot = Nyxx(config.token, 1607);

  var baseGroup = initializeBaseGroup();
  var pollGroup = initializePollGroup();

  Commander(bot, prefix: config.prefix, beforeCommandHandler: passHandler, prefixHandler: prefixHandler)
    ..registerCommandGroup(baseGroup)
    ..registerCommandGroup(pollGroup);

  bot.onGuildCreate.listen(onGuildCreate);
}

bool passHandler(CommandContext context) {
  return !context.author.bot;
}

Future<String> prefixHandler(Message msg) async {
  print('CHECKING PREFIX');
  if(!(msg is GuildMessage)) return config.prefix;

  var query = await database.connection.query('SELECT prefix FROM guilds WHERE id = @id;', substitutionValues: {'id': (msg as GuildMessage).guild.id});
  print(query);

  return config.prefix;
}

void onGuildCreate(GuildCreateEvent event) async {
  await database.connection.query('INSERT INTO guilds (id) VALUES (@id) ON CONFLICT DO NOTHING;', substitutionValues: {'id': event.guild.id.id});
}