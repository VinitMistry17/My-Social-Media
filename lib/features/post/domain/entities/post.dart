import 'package:cloud_firestore/cloud_firestore.dart';

import 'comments.dart';

class Post{
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}){
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  //convert post -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.fromDate(timestamp),
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }

  //convert json -> post
  factory Post.fromJson(Map<String, dynamic> json) {
    // prepare comments
    final List<Comment> comments = (json['comments'] as List<dynamic>?)
        ?.map((commentJson) => Comment.fromJson(commentJson))
        .toList() ??
        [];

    // handle timestamp (Firestore Timestamp or int)
    DateTime timestamp;
    if (json['timestamp'] is int) {
      timestamp = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
    } else if (json['timestamp'] != null) {
      // Firestore Timestamp has toDate() method
      timestamp = (json['timestamp'] as dynamic).toDate();
    } else {
      timestamp = DateTime.now();
    }

    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      timestamp: timestamp,
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments,
    );
  }
}
