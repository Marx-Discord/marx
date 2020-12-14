import 'package:nyxx_commander/commander.dart';

CommandGroup initializeBaseGroup() {
  var baseGroup = CommandGroup();

  baseGroup.registerSubCommand(
      'ping', (context, message) => context.reply(content: 'Pong!'));

  return baseGroup;
}
