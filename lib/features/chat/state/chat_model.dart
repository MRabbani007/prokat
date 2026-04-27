import 'package:prokat/features/chat/state/chat_message_model.dart';

class ChatParticipant {
  final String id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? profileImageUrl;

  const ChatParticipant({
    required this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.role,
    this.profileImageUrl,
  });

  String get displayName {
    final fullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }

    if ((username ?? '').isNotEmpty) {
      return username!;
    }

    return 'User';
  }

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id:
          json['id']?.toString() ??
          json['userId']?.toString() ??
          json['participantId']?.toString() ??
          '',
      username: json['username']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      role: json['role']?.toString(),
      profileImageUrl:
          json['profileImageUrl']?.toString() ?? json['avatarUrl']?.toString(),
    );
  }
}

class ChatModel {
  final String id;
  final List<ChatParticipant> participants;
  final String? bookingId;
  final String? requestId;
  final ChatMessageModel? lastMessage;
  final String? title;
  final String? imageUrl;
  final int unreadCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatModel({
    required this.id,
    this.participants = const [],
    this.bookingId,
    this.requestId,
    this.lastMessage,
    this.title,
    this.imageUrl,
    this.unreadCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  List<String> get participantIds => participants
      .map((participant) => participant.id)
      .where((id) => id.isNotEmpty)
      .toList(growable: false);

  String displayTitle({String? currentUserId}) {
    if ((title ?? '').isNotEmpty) {
      return title!;
    }

    final otherParticipants = currentUserId == null
        ? participants
        : participants.where((participant) => participant.id != currentUserId);

    final names = otherParticipants
        .map((participant) => participant.displayName)
        .where((name) => name.isNotEmpty)
        .toList(growable: false);

    if (names.isNotEmpty) {
      return names.join(', ');
    }

    if (participants.isNotEmpty) {
      return participants.first.displayName;
    }

    return 'Chat';
  }

  String? displayImageUrl({String? currentUserId}) {
    if ((imageUrl ?? '').isNotEmpty) {
      return imageUrl;
    }

    final otherParticipant = currentUserId == null
        ? participants.firstOrNull
        : participants.firstWhere(
            (participant) => participant.id != currentUserId,
            orElse: () =>
                participants.firstOrNull ?? const ChatParticipant(id: ''),
          );

    final avatar = otherParticipant?.profileImageUrl;
    if ((avatar ?? '').isNotEmpty) {
      return avatar;
    }

    return null;
  }

  ChatModel copyWith({
    String? id,
    List<ChatParticipant>? participants,
    String? bookingId,
    String? requestId,
    ChatMessageModel? lastMessage,
    String? title,
    String? imageUrl,
    int? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      bookingId: bookingId ?? this.bookingId,
      requestId: requestId ?? this.requestId,
      lastMessage: lastMessage ?? this.lastMessage,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final rawParticipants = json['participants'];
    final participants = <ChatParticipant>[
      if (rawParticipants is List)
        for (final participant in rawParticipants)
          if (participant is Map<String, dynamic>)
            ChatParticipant.fromJson(participant)
          else if (participant is Map)
            ChatParticipant.fromJson(Map<String, dynamic>.from(participant))
          else
            ChatParticipant(id: participant.toString()),
    ];

    return ChatModel(
      id:
          json['id']?.toString() ??
          json['chatId']?.toString() ??
          json['conversationId']?.toString() ??
          '',
      participants: participants,
      bookingId: json['bookingId']?.toString(),
      requestId: json['requestId']?.toString(),
      lastMessage: _parseMessage(json['lastMessage']),
      title: json['title']?.toString() ?? json['name']?.toString(),
      imageUrl: json['imageUrl']?.toString() ?? json['avatarUrl']?.toString(),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static ChatMessageModel? _parseMessage(dynamic value) {
    if (value is Map<String, dynamic>) {
      return ChatMessageModel.fromJson(value);
    }

    if (value is Map) {
      return ChatMessageModel.fromJson(Map<String, dynamic>.from(value));
    }

    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
