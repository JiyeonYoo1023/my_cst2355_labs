import 'package:flutter/material.dart';
import 'package:my_cst2355_labs/shopping_item_dao.dart';
import 'package:my_cst2355_labs/app_database.dart';
import 'package:my_cst2355_labs/shopping_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      home: Scaffold(
        appBar: AppBar(title: const Text('Shopping List')),
        body: const ShoppingListView(),
      ),
    );
  }
}

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  late AppDatabase database;
  late ShoppingItemDao dao;
  bool _dbReady = false;
  List<ShoppingItem> items = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    database = await $FloorAppDatabase.databaseBuilder('shopping_database.db').build();
    dao = database.shoppingItemDao;

    final loaded = await dao.findAllItems();

    setState(() {
      items = loaded;
      _dbReady = true;
    });
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty || _qtyController.text.isEmpty) return;

    final newItem = ShoppingItem(ShoppingItem.getNextId(), "${_nameController.text} (Qty: ${_qtyController.text})");
    await dao.insertItem(newItem);

    setState(() {
      items.add(newItem);
      _nameController.clear();
      _qtyController.clear();
    });
  }

  Future<void> _deleteItem(ShoppingItem item) async {
    await dao.deleteItem(item);
    setState(() {
      items.removeWhere((i) => i.id == item.id);
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete item"),
        content: Text("Do you want to delete '${items[index].name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              _deleteItem(items[index]);
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_dbReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Expanded(
                child: TextField(
                  controller: _qtyController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              ElevatedButton(
                onPressed: _addItem,
                child: const Text('Add'),
              ),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text("There is No items"))
              : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text("${index + 1}. ${item.name}"),
                onLongPress: () => _confirmDelete(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
