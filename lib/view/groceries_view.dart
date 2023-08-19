import 'package:flutter/material.dart';

import 'package:shopping_list_app/model/grocery.dart';
import 'package:shopping_list_app/view/new_item.dart';
import 'package:shopping_list_app/widget/groceries_tile.dart';

class GroceriesView extends StatefulWidget {
  const GroceriesView({super.key});

  @override
  State<GroceriesView> createState() => _GroceriesViewState();
}

class _GroceriesViewState extends State<GroceriesView> {
  final List<GroceryItem> _groceryList = [];
  void addItem() async {
    //add item button funciton
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );
    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryList.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    //remove item
    setState(() {
      _groceryList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Groceries',
          style: TextStyle(fontSize: 18),
        ),
        actions: [IconButton(onPressed: addItem, icon: const Icon(Icons.add))],
      ),
      body: _groceryList.isEmpty
          ? Center(
              //if list empty
              child: Text(
                'Empty list',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Colors.white),
              ),
            )
          : ListView.builder(
              // list of groceryItems display
              itemCount: _groceryList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  //to remove by slide elemnt
                  onDismissed: (direction) {
                    _removeItem(_groceryList[index]);
                  },
                  key: ValueKey(_groceryList[index].id),
                  child: GroceriesTile(
                    title: _groceryList[index].name,
                    colorIcon: _groceryList[index].category.color,
                    quantity: _groceryList[index].quantity.toString(),
                  ),
                );
              },
            ),
    );
  }
}
