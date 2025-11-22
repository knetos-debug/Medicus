/// Represents a response from the AI
class QueryResponse {
  final String content;
  final String provider;
  final DateTime timestamp;
  final bool success;
  final String? error;
  final Map<String, dynamic>? metadata;

  QueryResponse({
    required this.content,
    required this.provider,
    required this.timestamp,
    required this.success,
    this.error,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'provider': provider,
      'timestamp': timestamp.toIso8601String(),
      'success': success,
      'error': error,
      'metadata': metadata,
    };
  }

  factory QueryResponse.fromJson(Map<String, dynamic> json) {
    return QueryResponse(
      content: json['content'] as String,
      provider: json['provider'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      success: json['success'] as bool,
      error: json['error'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
