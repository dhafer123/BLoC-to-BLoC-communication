import 'package:equatable/equatable.dart';

class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.coverColor,
  });

  final String id;
  final String title;
  final String author;
  final String category;
  final int coverColor;

  @override
  List<Object> get props => [id, title, author, category, coverColor];
}
