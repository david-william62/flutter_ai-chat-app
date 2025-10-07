import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  ChatSession? _chat;

  GeminiService(String apiKey) {
    _model = GenerativeModel(model: 'gemini-2.5-pro', apiKey: apiKey);
    _chat = _model.startChat();
  }

  // Send message and get response
  Future<String> sendMessage(String message) async {
    try {
      _chat ??= _model.startChat();
      final content = Content.text(message);
      final response = await _chat!.sendMessage(content);
      return response.text ?? 'No response from AI';
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }

  Stream<String> sendMessageStream(String message) async* {
    try {
      _chat ??= _model.startChat();
      final content = Content.text(message);
      final responseStream = _chat!.sendMessageStream(content);
      var accumulated = '';
      var shown = '';

      await for (final response in responseStream) {
        final text = response.text;
        if (text == null || text.isEmpty) continue;

        final previous = accumulated;
        if (!text.startsWith(previous)) {
          accumulated = text;
          shown = text;
          yield shown;
          continue;
        }

        final delta = text.substring(previous.length);
        if (delta.isEmpty) {
          accumulated = text;
          continue;
        }

        accumulated = text;
        var buffer = shown;
        final tokens = _splitTokens(delta);

        for (final token in tokens) {
          buffer += token;
          shown = buffer;
          yield shown;
          await Future.delayed(_delayForToken(token));
        }
      }
    } catch (e) {
      throw Exception('Failed to stream AI response: $e');
    }
  }

  // Reset chat session
  void resetChat() {
    _chat = _model.startChat();
  }

  // Get a single response without chat history
  Future<String> getSingleResponse(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);
      return response.text ?? 'No response from AI';
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }

  static final RegExp _tokenPattern = RegExp(r'(\s+|\w+|[^\s\w]+)');
  static final RegExp _sentenceTerminator = RegExp(r'''[.!?]["')]*$''');

  List<String> _splitTokens(String value) {
    final tokens = <String>[];
    var index = 0;
    while (index < value.length) {
      final match = _tokenPattern.matchAsPrefix(value, index);
      if (match != null) {
        tokens.add(match.group(0)!);
        index = match.end;
      } else {
        tokens.add(value[index]);
        index++;
      }
    }
    return tokens;
  }

  Duration _delayForToken(String token) {
    if (token.trim().isEmpty) return const Duration(milliseconds: 12);
    if (_sentenceTerminator.hasMatch(token)) return const Duration(milliseconds: 95);
    if (token.length > 12) return const Duration(milliseconds: 55);
    if (token.length > 6) return const Duration(milliseconds: 38);
    return const Duration(milliseconds: 26);
  }
}
