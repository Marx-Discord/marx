import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

List<String> indicators = [
  '🇦',
  '🇧',
  '🇨',
  '🇩',
  '🇪',
  '🇫',
  '🇬',
  '🇭',
  '🇮',
  '🇯',
  '🇰',
  '🇱',
  '🇲',
  '🇳',
  '🇴',
  '🇵',
  '🇶',
  '🇷',
  '🇸',
  '🇹'
];

void pollSimple(CommandContext ctx, String msg) {
  var message = ctx.channel.sendMessage(content: ctx.getQuotedText().first);
  message.then((sentMessage) {
    sentMessage.createReaction(UnicodeEmoji('✅'));
    sentMessage.createReaction(UnicodeEmoji('❌'));
  });
}

void pollAdvanced(CommandContext ctx, String msg) {
  var quoted = ctx.getQuotedText();

  if (quoted.length > 2 && quoted.length < 21) {
    var buffer = StringBuffer();
    for (var i = 0; i < quoted.length - 1; i++) {
      buffer.write('${indicators[i]} ${quoted.toList()[i + 1]}');

      if (i != quoted.length - 1) {
        buffer.write('\n');
      }
    }

    var embed = EmbedBuilder();
    embed.title = 'Poll';
    embed.description = quoted.first;
    embed.addField(name: 'Options', content: buffer.toString());

    var message = ctx.channel.sendMessage(embed: embed);
    message.then((sentMessage) async {
      for (var i = 0; i < quoted.length - 1; i++) {
        await sentMessage.createReaction(UnicodeEmoji(indicators[i]));
      }
    });
  } else {
    ctx.channel.sendMessage(
        content: 'You need to provide between 2 and 20 poll options!');
  }
}

CommandGroup initializePollGroup() {
  var pollGroup = CommandGroup(name: 'poll', aliases: ['p']);

  pollGroup.registerDefaultCommand((context, message) => {
        context.reply(
            content: 'Please specify if the poll is `simple` or `advanced`.')
      });

  pollGroup.registerSubCommand('simple', pollSimple);
  pollGroup.registerSubCommand('s', pollSimple);

  pollGroup.registerSubCommand('advanced', pollAdvanced);
  pollGroup.registerSubCommand('adv', pollAdvanced);
  pollGroup.registerSubCommand('a', pollAdvanced);

  return pollGroup;
}
