List<Message> messageFromJson(Map<String, dynamic> data) => (data['message'] as List).map((json) => Message.fromJson(json)).toList();

class Message {
  late int id;
  late String username;
  late String message;

  Message({required this.id, required this.username, required this.message});

  Message.fromJson(Map<String, dynamic> json ) {
    id = json['id'];
    username = json['username'];
    message = json['message'];
  }
}