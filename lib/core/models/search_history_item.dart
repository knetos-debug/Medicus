import 'query_request.dart';
import 'query_response.dart';

/// Represents a saved search history item
class SearchHistoryItem {
  final String id;
  final QueryRequest request;
  final QueryResponse response;
  final DateTime timestamp;
  final bool isFavorite;

  SearchHistoryItem({
    required this.id,
    required this.request,
    required this.response,
    required this.timestamp,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request': request.toJson(),
      'response': response.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id'] as String,
      request: QueryRequest.fromJson(json['request'] as Map<String, dynamic>),
      response: QueryResponse.fromJson(json['response'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  SearchHistoryItem copyWith({
    String? id,
    QueryRequest? request,
    QueryResponse? response,
    DateTime? timestamp,
    bool? isFavorite,
  }) {
    return SearchHistoryItem(
      id: id ?? this.id,
      request: request ?? this.request,
      response: response ?? this.response,
      timestamp: timestamp ?? this.timestamp,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
