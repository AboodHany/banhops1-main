class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
    this.isSystem = false,
  });

  final String role;
  final String content;
  final DateTime createdAt;
  final bool isSystem;
}