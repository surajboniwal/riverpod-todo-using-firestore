import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Todo> todoFromJson(String str) => List<Todo>.from(json.decode(str).map((x) => Todo.fromMap(x)));

String todoToJson(List<Todo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Todo {
  Todo({
    this.name,
    this.status,
    this.id,
  });

  String? id;
  String? name;
  bool? status;

  Todo copyWith({
    String? id,
    String? name,
    bool? status,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
    );
  }

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        name: json["name"],
        status: json["status"],
      );

  factory Todo.fromDocument(QueryDocumentSnapshot doc) => Todo(
        id: doc.id,
        name: doc.get('name'),
        status: doc.get('status'),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "status": status,
      };
}
