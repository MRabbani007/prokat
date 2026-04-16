import 'package:prokat/features/chat/state/chat_message_model.dart';

class ChatModel {
  final String id;

  /// participants (user ids)
  final List<String> participantIds;

  final String? bookingId;
  final String? requestId;

  /// last message preview
  final ChatMessageModel? lastMessage;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatModel({
    required this.id,
    required this.participantIds,

    this.bookingId,
    this.requestId,

    this.lastMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id']?.toString() ?? '',
      participantIds:
          (json['participants'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      bookingId: json['bookingId']?.toString(),
      requestId: json['requestId']?.toString(),
      lastMessage: json['lastMessage'] != null
          ? ChatMessageModel.fromJson(json['lastMessage'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
