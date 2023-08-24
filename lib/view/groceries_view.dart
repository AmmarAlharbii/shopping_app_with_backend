import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/model/grocery.dart';
import 'package:shopping_list_app/view/empty_list.dart';
import 'package:shopping_list_app/view/new_item.dart';
import 'package:shopping_list_app/widget/groceries_tile.dart';
import 'package:shopping_list_app/widget/loading_circle.dart';

class GroceriesView extends StatefulWidget {
  const GroceriesView({super.key});

  @override
  State<GroceriesView> createState() => _GroceriesViewState();
}

class _GroceriesViewState extends State<GroceriesView> {
  List<GroceryItem> _groceryList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'shoppinglist-cd4be-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url); //linked and make response
    final Map<String, dynamic> listData =
        jsonDecode(response.body); //fetch data from api
    final List<GroceryItem> loadedItems = [];
    for (var item in listData.entries) {
      final categoryItem = categories.entries
          .firstWhere(
            (catItem) => catItem.value.title == item.value['category'],
          ) //review here
          .value;
      loadedItems.add(
        GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: categoryItem),
      );
    }
    setState(() {
      _groceryList = loadedItems;
      isLoading = false;
    });
  }

  void addItem() async {
    //add item button funciton
    final newItem = await Navigator.of(context).push<GroceryItem>(
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
      body: isLoading
          ? const LoadingWidget() // if loading will show circle indicator
          : _groceryList.isEmpty
              ? const EmptyList() // after check loading it will chick for the list if empty
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
