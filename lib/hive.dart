import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    List<Map<String, dynamic>> items = [];
    final shoppingBox = Hive.box('Shopping_box');
    void refreshItems() {
      final data = shoppingBox.keys.map((key) {
        final item = shoppingBox.get(key);
        return {"key": key, "name": item["name"], "quantity": item['quantity']};
      }).toList();
      setState(() {
        items = data.reversed.toList();
        print(items.length);
        // reversed is for sorting from the latest to the oldest
      });
    }

    @override
    void initState() {
      refreshItems();
      super.initState();
    }

    // create new item
    Future<void> createItem(Map<String, dynamic> newItem) async {
      await shoppingBox.add(newItem);
      refreshItems();
      print('amount data is ${shoppingBox.length}');
    }

    // open modal bottom sheet to submit new item
    void showForm(BuildContext context, int? itemKey) async {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => SizedBox(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: quantityController,
                  decoration: const InputDecoration(hintText: 'Quantity'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    createItem({
                      "name": nameController.text,
                      "quantity": quantityController,
                    });
                    // clear the textfields
                    nameController.text = '';
                    quantityController.text = '';
                    Navigator.of(context).pop();
                  },
                  child: const Text('Create new'),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) {
          final currentItem = items[index];
          return Card(
            color: Colors.orange.shade100,
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
              title: Text(currentItem['name']),
              subtitle: Text(currentItem['quantity'].toString()),
              trailing: const Row(
                children: [],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
