/// Represents a query request to the AI
class QueryRequest {
  final String query;
  final String? context;
  final DateTime timestamp;

  QueryRequest({
    required this.query,
    this.context,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'context': context,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory QueryRequest.fromJson(Map<String, dynamic> json) {
    return QueryRequest(
      query: json['query'] as String,
      context: json['context'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
