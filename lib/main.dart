import 'package:flutter/material.dart';

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
        body: ListPage(),
      ),
    );
  }
}

Widget ListPage() {
  return const ShoppingListView();
}

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  final List<String> itemNames = [];
  final List<String> itemQtys = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  void _addItem() {
    if (_nameController.text.isEmpty || _qtyController.text.isEmpty) return;

    setState(() {
      itemNames.add(_nameController.text);
      itemQtys.add(_qtyController.text);
      _nameController.clear();
      _qtyController.clear();
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete item"),
        content: Text("Do you want to delete '${itemNames[index]}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                itemNames.removeAt(index);
                itemQtys.removeAt(index);
              });
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
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Type the item here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _qtyController,
                decoration: const InputDecoration(
                  labelText: 'Type the Quantity here',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Click here'),
            ),
          ],
        ),

        if(itemNames.isEmpty)
          Text("No items")
        else
        Expanded(
          child: Column(
              children: List.generate(itemNames.length, (index) {
                return GestureDetector(
                  onLongPress: () {
                    _confirmDelete(index);
                  },
                  child: Text(
                  "${index + 1}. ${itemNames[index]} Quantity: ${itemQtys[index]}",
                  )
                );
              }),
            ),
        ),
      ],
    );
  }
}
