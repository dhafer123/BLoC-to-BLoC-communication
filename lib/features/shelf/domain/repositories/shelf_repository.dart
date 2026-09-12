import '../entities/book.dart';

abstract class ShelfRepository {
  List<Book> getCatalog();
}
