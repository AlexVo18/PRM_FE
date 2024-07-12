class ChatMessage {
  final String emailSend;
  final String emailReceive;
  final String type; // 'text' or 'image'
  final String? text;
  final String? imageUrl;
  final DateTime timeSend;

  ChatMessage({
    required this.emailSend,
    required this.emailReceive,
    required this.type,
    this.text,
    this.imageUrl,
    required this.timeSend,
  });

  Map<String, dynamic> toMap() {
    return {
      'emailSend': emailSend,
      'emailReceive': emailReceive,
      'type': type,
      'text': text,
      'imageUrl': imageUrl,
      'timeSend': timeSend.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      emailSend: map['emailSend'],
      emailReceive: map['emailReceive'],
      type: map['type'],
      text: map['text'],
      imageUrl: map['imageUrl'],
      timeSend: DateTime.parse(map['timeSend']),
    );
  }
}
