import '../../domain/entities/book.dart';
import '../../domain/repositories/shelf_repository.dart';

class ShelfRepositoryImpl implements ShelfRepository {
  static const _catalog = [
    Book(
      id: 'atomic-habits',
      title: 'Atomic Habits',
      author: 'James Clear',
      category: 'HABITS',
      coverColor: 0xFFB8D8D8,
    ),
    Book(
      id: 'design-everyday',
      title: 'The Design of Everyday Things',
      author: 'Don Norman',
      category: 'DESIGN',
      coverColor: 0xFFF2CC8F,
    ),
    Book(
      id: 'creative-act',
      title: 'The Creative Act',
      author: 'Rick Rubin',
      category: 'CREATIVE',
      coverColor: 0xFFE07A5F,
    ),
    Book(
      id: 'tomorrow',
      title: 'Tomorrow, and Tomorrow, and Tomorrow',
      author: 'Gabrielle Zevin',
      category: 'FICTION',
      coverColor: 0xFF81B29A,
    ),
  ];

  @override
  List<Book> getCatalog() => _catalog;
}
