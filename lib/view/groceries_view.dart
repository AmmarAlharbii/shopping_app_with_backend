import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/model/grocery.dart';
import 'package:shopping_list_app/widget/empty_list.dart';
import 'package:shopping_list_app/view/new_item.dart';
import 'package:shopping_list_app/widget/error_widget.dart';
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
  String? error;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    //method for fetch data
    final url = Uri.https(
        'shoppinglist-cd4be-default-rtdb.firebaseio.com', 'shopping-list.json');

    try {
      //try catch for any error will happend in take response
      final response = await http.get(url); //linked and make response
      if (response.statusCode >= 400) {
        setState(() {
          error = 'fetch data filed,please try again later.';
        });
      }

      if (response.body == 'null') {
        //hanlding if the data was null or empty

        setState(() {
          isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData =
          jsonDecode(response.body); //fetch data from api
      final List<GroceryItem> loadedItems = [];
      for (var item in listData.entries) {
        final categoryItem = categories.entries
            .firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
            ) //take a category which has same title
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
    } catch (e) {
      setState(() {
        error = 'something went wrong ,please try again later.';
      });
    }
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

  void _removeItem(GroceryItem item) async {
    final index = _groceryList.indexOf(item);
    setState(() {
      //remove item localy
      _groceryList.remove(item);
    });

    final url = Uri.https(
        //url for the item will we deleting
        'shoppinglist-cd4be-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url); //delete from backend
    if (!context.mounted) {
      return;
    }
    if (response.statusCode >= 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'error while delteing try again later',
          ),
        ),
      );
      setState(() {
        _groceryList.insert(index, item);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'item deleted successfully',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const EmptyList(); //intial content if list empty
    if (isLoading) {
      // if waiting for response
      content = const LoadingWidget();
    }
    if (_groceryList.isNotEmpty) {
      //if get data and list not empty
      content = content = ListView.builder(
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
      );
    }
    if (error != null) {
      //error handling
      content = ErrorWidgetMessage(message: error!);
    }
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(15, 15),
          ),
        ),
        title: const Text(
          'Your Groceries',
          style: TextStyle(fontSize: 18),
        ),
        actions: [IconButton(onPressed: addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
