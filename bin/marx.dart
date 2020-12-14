import 'package:marx/config.dart';
import 'package:marx/base_group.dart';
import 'package:marx/poll_group.dart';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

Config config = Config();

void main() {
  final bot = Nyxx(config.token, 1607);

  var baseGroup = initializeBaseGroup();
  var pollGroup = initializePollGroup();

  Commander(bot, prefix: config.prefix, beforeCommandHandler: passHandler)
    ..registerCommandGroup(baseGroup)
    ..registerCommandGroup(pollGroup);
}

bool passHandler(CommandContext context) {
  return !context.author.bot;
}
