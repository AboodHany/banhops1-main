import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:banhops1/features/ai_chat/apis/api_service.dart';
import 'package:banhops1/core/services/supabase_service.dart';
import 'package:banhops1/features/ai_chat/constants/constants.dart';
import 'package:banhops1/features/ai_chat/hive/boxes.dart';
import 'package:banhops1/features/ai_chat/hive/chat_history.dart';
import 'package:banhops1/features/ai_chat/hive/settings.dart';
import 'package:banhops1/features/ai_chat/hive/user_model.dart';
import 'package:banhops1/features/ai_chat/models/message.dart';
import 'package:banhops1/features/ai_chat/utilities/chat_error_formatter.dart';
import 'package:banhops1/core/models/transit_route_option.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  static const _requestTimeout = Duration(seconds: 40);

  final List<Message> _inChatMessages = [];
  List<XFile>? _imagesFileList = [];
  String _currentChatId = '';
  GenerativeModel? _model;
  GenerativeModel? _textModel;
  GenerativeModel? _visionModel;
  String _modelType = Constants.geminiTextModel;
  bool _isLoading = false;

  List<Message> get inChatMessages => _inChatMessages;
  List<XFile>? get imagesFileList => _imagesFileList;
  String get currentChatId => _currentChatId;
  GenerativeModel? get model => _model;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;
  String get modelType => _modelType;
  bool get isLoading => _isLoading;
  bool get hasMessages => _inChatMessages.isNotEmpty;

  int get messageCount => _inChatMessages.length;

  Future<void> setInChatMessages({required String chatId}) async {
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);
    _inChatMessages
      ..clear()
      ..addAll(messagesFromDB);
    notifyListeners();
  }

  Future<List<Message>> loadMessagesFromDB({required String chatId}) async {
    final client = SupabaseService.client;
    if (client != null && client.auth.currentUser != null) {
      final userId = client.auth.currentUser!.id;
      try {
        final response = await client
            .from('chats')
            .select()
            .eq('user_id', userId)
            .order('timestamp', ascending: true);
            
        final List<Message> messages = [];
        int idCounter = 0;
        for (var row in response) {
          final time = DateTime.tryParse(row['timestamp'] ?? '') ?? DateTime.now();
          
          messages.add(Message(
            messageId: '${idCounter++}',
            chatId: chatId,
            role: Role.user,
            message: StringBuffer(row['message'] ?? ''),
            imagesUrls: const [],
            timeSent: time,
          ));
          
          messages.add(Message(
            messageId: '${idCounter++}',
            chatId: chatId,
            role: Role.assistant,
            message: StringBuffer(row['ai_response'] ?? ''),
            imagesUrls: const [],
            timeSent: time.add(const Duration(milliseconds: 100)),
          ));
        }
        return messages;
      } catch (e) {
        debugPrint('Error loading from Supabase: $e');
      }
    }

    await Hive.openBox('${Constants.chatMessagesBox}$chatId');
    final messageBox = Hive.box('${Constants.chatMessagesBox}$chatId');
    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      return Message.fromMap(Map<String, dynamic>.from(message));
    }).toList();
    return newData;
  }

  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  void removeImageAt(int index) {
    if (_imagesFileList == null || index >= _imagesFileList!.length) {
      return;
    }
    final updated = List<XFile>.from(_imagesFileList!)..removeAt(index);
    _imagesFileList = updated;
    notifyListeners();
  }

  void clearDraft() {
    _imagesFileList = [];
    notifyListeners();
  }

  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  Future<void> setModel({required bool isTextOnly}) async {
    final modelName =
        isTextOnly ? Constants.geminiTextModel : Constants.geminiVisionModel;
    setCurrentModel(newModel: modelName);
    final generationConfig = GenerationConfig(
      temperature: isTextOnly ? 0.45 : 0.35,
      topP: 0.9,
      topK: 32,
      maxOutputTokens: 2048,
    );
    
    const transitInstruction =
        'You are Banhops AI, a friendly and helpful Egyptian transit assistant. '
        'Your primary expertise is in Egyptian transit and travel in Benha and Qalyubia '
        '(routes, fares, schedules, transfers, cities, neighborhoods, landmarks, nearby services). '
        'If the user asks about a currently planned trip, use the provided trip context. '
        'Reply in the same language as the user: Arabic if Arabic, English if English. '
        'Mention internal Suzuki fare is 5 EGP when relevant to transit questions. '
        'If you recommend a route, format it in this structure at the very end of your response:\n'
        '<ROUTE>\n'
        'transport: [TRAIN/MICROBUS/PUBLIC_BUS]\n'
        'cost_min: [minimum cost in EGP]\n'
        'cost_max: [maximum cost in EGP]\n'
        'time_min: [minimum duration in minutes]\n'
        'time_max: [maximum duration in minutes]\n'
        '<ROUTE/>\n'
        'Use Google Search when you need up-to-date details. Be helpful, concise, and friendly.';

    final systemInstruction = Content.system(transitInstruction);

    if (isTextOnly) {
      _textModel ??= GenerativeModel(
        model: modelName,
        apiKey: ApiService.apiKey,
        generationConfig: generationConfig,
        systemInstruction: systemInstruction,
      );
      _model = _textModel;
    } else {
      _visionModel ??= GenerativeModel(
        model: modelName,
        apiKey: ApiService.apiKey,
        generationConfig: generationConfig,
        systemInstruction: systemInstruction,
      );
      _model = _visionModel;
    }
    notifyListeners();
  }

  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> deleteChatMessages({required String chatId}) async {
    final storedImagePaths = await _storedImagePathsForChat(chatId: chatId);
    await _deleteImageFiles(storedImagePaths);

    final client = SupabaseService.client;
    if (client != null && client.auth.currentUser != null) {
      final userId = client.auth.currentUser!.id;
      try {
        await client.from('chats').delete().eq('user_id', userId);
      } catch (e) {
        debugPrint('Error deleting from Supabase: $e');
      }
    }

    if (!Hive.isBoxOpen('${Constants.chatMessagesBox}$chatId')) {
      await Hive.openBox('${Constants.chatMessagesBox}$chatId');
      await Hive.box('${Constants.chatMessagesBox}$chatId').clear();
      await Hive.box('${Constants.chatMessagesBox}$chatId').close();
    } else {
      await Hive.box('${Constants.chatMessagesBox}$chatId').clear();
      await Hive.box('${Constants.chatMessagesBox}$chatId').close();
    }

    if (currentChatId.isNotEmpty) {
      if (currentChatId == chatId) {
        setCurrentChatId(newChatId: '');
        _inChatMessages.clear();
        notifyListeners();
      }
    }
  }

  Future<void> clearAllChats() async {
    final historyBox = Boxes.getChatHistory();
    final chatIds = historyBox.keys.cast<String>().toList(growable: false);

    for (final chatId in chatIds) {
      await deleteChatMessages(chatId: chatId);
    }

    await historyBox.clear();
    _inChatMessages.clear();
    _currentChatId = '';
    notifyListeners();
  }

  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chatID,
  }) async {
    if (!isNewChat) {
      final chatHistory = await loadMessagesFromDB(chatId: chatID);
      _inChatMessages.clear();
      for (var message in chatHistory) {
        _inChatMessages.add(message);
      }
      setCurrentChatId(newChatId: chatID);
    } else {
      _inChatMessages.clear();
      setCurrentChatId(newChatId: chatID);
    }
    clearDraft();
    notifyListeners();
  }

  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
    List<XFile>? draftImages,
    TripPlanResult? plan,
  }) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) {
      return;
    }

    await setModel(isTextOnly: isTextOnly);
    setLoading(value: true);
    String chatId = getChatId();
    final imageFiles = isTextOnly
        ? const <XFile>[]
        : await _storeDraftImages(
            chatId: chatId,
            draftImages: draftImages,
          );
          
    // Build actual prompt sent to model, including trip context if available.
    String promptToSend = trimmedMessage;
    if (plan != null) {
      final best = plan.routes.isNotEmpty ? plan.routes.first : null;
      final compactPlan = <String, dynamic>{
        'origin': plan.originLabel,
        'destination': plan.destinationLabel,
        'mode': best == null ? 'unknown' : best.mode.name,
        'etaMin': best?.durationMinutes ?? 0,
        'costEgp': best?.estimatedCost ?? 0,
      };
      
      final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(trimmedMessage);
      final lang = isArabic ? 'ar' : 'en';
      
      promptToSend = 'Language: $lang\nQ: $trimmedMessage\nTrip: ${jsonEncode(compactPlan)}';
    }

    List<Content> history = [];
    history = await getHistory(chatId: chatId);
    List<String> imagesUrls = getImagesUrls(imageFiles: imageFiles);
    final messagesBox =
        await Hive.openBox('${Constants.chatMessagesBox}$chatId');
    final userMessageId = messagesBox.keys.length;
    final assistantMessageId = messagesBox.keys.length + 1;

    final userMessage = Message(
      messageId: userMessageId.toString(),
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(trimmedMessage), // Save the clean message
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(userMessage);
    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    await sendMessageAndWaitForResponse(
      message: promptToSend, // Send enriched prompt to Gemini
      chatId: chatId,
      isTextOnly: isTextOnly,
      imageFiles: imageFiles,
      history: history,
      userMessage: userMessage,
      modelMessageId: assistantMessageId.toString(),
      messagesBox: messagesBox,
    );
  }

  // send message to the model and wait for the response
  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<XFile> imageFiles,
    required List<Content> history,
    required Message userMessage,
    required String modelMessageId,
    required Box messagesBox,
  }) async {
    final chatSession = _model!.startChat(
      history: history.isEmpty || !isTextOnly ? null : history,
    );
    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
      imageFiles: imageFiles,
    );
    final assistantMessage = userMessage.copyWith(
      messageId: modelMessageId,
      role: Role.assistant,
      message: StringBuffer(),
      timeSent: DateTime.now(),
    );
    _inChatMessages.add(assistantMessage);
    notifyListeners();

    try {
      await _requestAssistantResponse(
        chatSession: chatSession,
        content: content,
        assistantMessage: assistantMessage,
        rawMessage: message,
      );
      await saveMessagesToDB(
        chatID: chatId,
        userMessage: userMessage,
        assistantMessage: assistantMessage,
        messagesBox: messagesBox,
      );
    } catch (error, stackTrace) {
      _removeAssistantDraft(assistantMessage);
      notifyListeners();
      Error.throwWithStackTrace(
        StateError(formatChatError(error)),
        stackTrace,
      );
    } finally {
      if (messagesBox.isOpen) {
        await messagesBox.close();
      }
      setLoading(value: false);
    }
  }

  Future<void> _requestAssistantResponse({
    required ChatSession chatSession,
    required Content content,
    required Message assistantMessage,
    String? rawMessage,
  }) async {
    try {
      final response =
          await chatSession.sendMessage(content).timeout(_requestTimeout);
      _applyAssistantText(
        assistantMessage: assistantMessage,
        text: response.text?.trim() ?? '',
      );
    } catch (error) {
      debugPrint('AI Chat error (package): $error');
      if (!shouldRetryRequest(error)) {
        if (rawMessage != null) {
          try {
            final fallbackText = await _fallbackHttpRequest(rawMessage);
            if (fallbackText.isNotEmpty) {
              _applyAssistantText(
                assistantMessage: assistantMessage,
                text: fallbackText,
              );
              return;
            }
          } catch (fallbackError) {
            debugPrint('AI Chat fallback error: $fallbackError');
          }
        }
        rethrow;
      }

      debugPrint('AI Chat: Retrying request...');
      final retryResponse =
          await chatSession.sendMessage(content).timeout(_requestTimeout);
      _applyAssistantText(
        assistantMessage: assistantMessage,
        text: retryResponse.text?.trim() ?? '',
      );
    }
  }

  Future<String> _fallbackHttpRequest(String message) async {
    final apiKey = ApiService.apiKey;
    if (apiKey.isEmpty) return '';

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent',
    ).replace(queryParameters: {'key': apiKey});

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': message},
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.45,
        'maxOutputTokens': 2048,
      },
    });

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: body,
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      final candidates = decoded['candidates'];
      if (candidates != null && candidates is List && candidates.isNotEmpty) {
        final parts = candidates[0]['content']?['parts'];
        if (parts != null && parts is List) {
          final buffer = StringBuffer();
          for (final part in parts) {
            if (part is Map && part.containsKey('text')) {
              buffer.write(part['text']);
            }
          }
          final result = buffer.toString().trim();
          if (result.isNotEmpty) return result;
        }
      }
    }

    throw Exception('Fallback API error ${response.statusCode}');
  }

  void _removeAssistantDraft(Message assistantMessage) {
    _inChatMessages.removeWhere(
      (element) =>
          element.messageId == assistantMessage.messageId &&
          element.role == Role.assistant &&
          element.message.isEmpty,
    );
  }

  void _applyAssistantText({
    required Message assistantMessage,
    required String text,
  }) {
    if (text.isEmpty) {
      throw StateError('No response returned. Try again.');
    }

    assistantMessage.message = StringBuffer(text);
    notifyListeners();
  }

  // save messages to hive db
  Future<void> saveMessagesToDB({
    required String chatID,
    required Message userMessage,
    required Message assistantMessage,
    required Box messagesBox,
  }) async {
    final client = SupabaseService.client;
    if (client != null && client.auth.currentUser != null) {
      final userId = client.auth.currentUser!.id;
      try {
        await client.from('chats').insert({
          'user_id': userId,
          'message': userMessage.message.toString(),
          'ai_response': assistantMessage.message.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('Error saving to Supabase: $e');
      }
    }

    final settings =
        Boxes.getSettings().isNotEmpty ? Boxes.getSettings().getAt(0) : null;
    final saveChatHistory = settings?.saveChatHistory ?? true;

    if (!saveChatHistory) {
      return;
    }

    await messagesBox.add(userMessage.toMap());
    await messagesBox.add(assistantMessage.toMap());
    final chatHistoryBox = Boxes.getChatHistory();
    
    // Create clean prompt preview for history listing
    final chatHistory = ChatHistory(
      chatId: chatID,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imagesUrls: userMessage.imagesUrls,
      timestamp: DateTime.now(),
    );
    await chatHistoryBox.put(chatID, chatHistory);
  }

  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
    required List<XFile> imageFiles,
  }) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageBytes = await Future.wait(
        imageFiles.map((imageFile) => imageFile.readAsBytes()),
      );
      final prompt = TextPart(message);
      final imageParts = imageBytes
          .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
          .toList();

      return Content.multi([prompt, ...imageParts]);
    }
  }

  List<String> getImagesUrls({
    required List<XFile> imageFiles,
  }) {
    return imageFiles.map((image) => image.path).toList(growable: false);
  }

  Future<List<XFile>> _storeDraftImages({
    required String chatId,
    List<XFile>? draftImages,
  }) async {
    final images = draftImages ?? _imagesFileList ?? const <XFile>[];
    if (images.isEmpty) {
      return const <XFile>[];
    }

    if (kIsWeb) {
      return images;
    }

    final appDir = await path.getApplicationDocumentsDirectory();
    final mediaDir = Directory(
      '${appDir.path}/${Constants.geminiDB}/chat_media/$chatId',
    );
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }

    final storedImages = <XFile>[];
    for (final imageFile in images) {
      final extension = _fileExtension(imageFile.path);
      final storedFile = File(
        '${mediaDir.path}/${const Uuid().v4()}.$extension',
      );
      await storedFile.writeAsBytes(
        await imageFile.readAsBytes(),
        flush: true,
      );
      storedImages.add(XFile(storedFile.path));
    }
    return storedImages;
  }

  String _fileExtension(String pathValue) {
    final lastDot = pathValue.lastIndexOf('.');
    if (lastDot == -1 || lastDot == pathValue.length - 1) {
      return 'jpg';
    }
    return pathValue.substring(lastDot + 1).toLowerCase();
  }

  Future<Set<String>> _storedImagePathsForChat({
    required String chatId,
  }) async {
    final imagePaths = <String>{};
    final storedMessages = await loadMessagesFromDB(chatId: chatId);
    for (final message in storedMessages) {
      imagePaths.addAll(message.imagesUrls);
    }

    if (currentChatId == chatId) {
      for (final message in _inChatMessages) {
        imagePaths.addAll(message.imagesUrls);
      }
    }

    return imagePaths;
  }

  Future<void> _deleteImageFiles(Iterable<String> imagePaths) async {
    for (final imagePath in imagePaths) {
      if (imagePath.isEmpty) {
        continue;
      }
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];
    if (currentChatId.isNotEmpty) {
      final messages = await loadMessagesFromDB(chatId: chatId);

      for (var message in messages) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(Content.model([TextPart(message.message.toString())]));
        }
      }
    }

    return history;
  }

  String getChatId() {
    if (currentChatId.isEmpty) {
      return const Uuid().v4();
    } else {
      return currentChatId;
    }
  }

  static initHive() async {
    await Hive.initFlutter(Constants.geminiDB);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());
    }

    await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    await Hive.openBox<UserModel>(Constants.userBox);
    await Hive.openBox<Settings>(Constants.settingsBox);
  }
}
