String formatChatError(Object error) {
  if (error case StateError(:final message)) {
    return message;
  }

  final text = error.toString().toLowerCase();

  if (text.contains('operation timed out') ||
      text.contains('timeoutexception')) {
    return 'Request timed out. Check your connection and try again.';
  }

  if (text.contains('socketexception') ||
      text.contains('clientexception') ||
      text.contains('failed host lookup') ||
      text.contains('connection closed') ||
      text.contains('xmlhttprequest') ||
      text.contains('cors')) {
    return 'Could not reach Gemini. Check your network and try again.';
  }

  if (text.contains('api key') || text.contains('api_key')) {
    return 'Add your Gemini API key to continue.';
  }

  if (text.contains('permission') || text.contains('403')) {
    return 'API access denied. Check your Gemini API key permissions.';
  }

  if (text.contains('quota') || text.contains('429') || text.contains('rate')) {
    return 'API rate limit exceeded. Please wait and try again.';
  }

  if (text.contains('not found') || text.contains('404') || text.contains('model')) {
    return 'AI model not available. Please try again later.';
  }

  if (text.contains('400') || text.contains('invalid')) {
    return 'Invalid request. Please try a different message.';
  }

  final detailedMessage = error.toString();
  if (detailedMessage.length > 10 && detailedMessage.length < 300) {
    return 'Error: $detailedMessage';
  }

  return 'Something went wrong. Please try again.';
}

bool shouldRetryRequest(Object error) {
  final text = error.toString().toLowerCase();

  if (text.contains('api key') ||
      text.contains('permission') ||
      text.contains('not found')) {
    return false;
  }

  return text.contains('operation timed out') ||
      text.contains('timeoutexception') ||
      text.contains('socketexception') ||
      text.contains('failed host lookup') ||
      text.contains('connection closed');
}
