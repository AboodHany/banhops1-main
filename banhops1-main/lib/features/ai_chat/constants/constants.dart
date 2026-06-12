class Constants {
  static const String appName = 'AI Chatbot';
  static const String appTitle = 'AI Chatbot';
  static const String appDescription = 'Fast Gemini chat';
  static const String chatHistoryBox = 'chat_history';
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings';

  static const String chatMessagesBox = 'chat_messages_';

  static const String geminiDB = 'gemini.db';
  static const String geminiTextModel = 'gemini-1.5-flash';
  static const String geminiVisionModel = 'gemini-1.5-flash';
  static const String assistantSystemInstruction =
      'You are AI Chatbot, a helpful assistant for Banhops (بنهاوبس), an Egyptian public transit helper app. '
      'Give clear, accurate, and concise answers in Arabic or English as preferred by the user. '
      'Do not output programming code, Python scripts, or Google Maps API code blocks when users ask for route directions or how to travel. '
      'Instead, politely guide them to use the search feature in the Banhops application to find real-time microbus, train, and metro routes. '
      'Provide simple, natural text advice about transit options (like microbuses from Ahmed Helmy/Ramses or trains to Benha) instead of scripts or code. '
      'Only provide programming code if the user explicitly asks for programming/developer assistance.';

  static const List<String> starterPrompts = [
    'Summarize this',
    'Plan my day',
    'Draft a reply',
    'Explain a concept',
    'Improve writing',
    'Analyze an image',
  ];
}
