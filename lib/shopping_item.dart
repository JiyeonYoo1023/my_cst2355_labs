import 'package:floor/floor.dart';

@entity
class ShoppingItem {
  @primaryKey
  final int id;

  final String name;

  static int _nextId = 1;
  static int getNextId() => _nextId++;

  ShoppingItem(this.id, this.name);

  static void updateNextIdFrom(int existingId) {
    if (existingId >= _nextId) _nextId = existingId + 1;
  }
}
