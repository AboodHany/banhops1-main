import 'package:banhops1/features/ai_chat/constants/constants.dart';
import 'package:banhops1/features/ai_chat/hive/chat_history.dart';
import 'package:banhops1/features/ai_chat/hive/settings.dart';
import 'package:banhops1/features/ai_chat/hive/user_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  // get the chat history box
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Constants.chatHistoryBox);

  // get user box
  static Box<UserModel> getUser() => Hive.box<UserModel>(Constants.userBox);

  // get settings box
  static Box<Settings> getSettings() =>
      Hive.box<Settings>(Constants.settingsBox);
}
