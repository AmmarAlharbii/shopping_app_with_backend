import 'package:flutter/material.dart';
import 'package:shopping_list_app/model/categories.dart';
import 'package:shopping_list_app/model/grocery.dart';

import '../data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final formKey = GlobalKey<FormState>();
  var _enterdName = '';
  var _enterdQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables];
  void _saveForm() {
    if (formKey.currentState!.validate()) //validate fields before save
    {
      formKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem(
            id: DateTime.now().toString(),
            name: _enterdName,
            quantity: _enterdQuantity,
            category: _selectedCategory!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                // name
                style: const TextStyle(color: Colors.white),

                maxLength: 30,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(14),
                      ),
                    ),
                    label: Text('name'),
                    disabledBorder: InputBorder.none),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 to 50 chracters';
                  }
                  return null;
                },
                onSaved: (newValue) => _enterdName = newValue!,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      //Quantity
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(14),
                            ),
                          ),
                          label: Text('Quantity'),
                          disabledBorder: InputBorder.none),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be positve number ';
                        }
                        return null;
                      },
                      onSaved: (newValue) =>
                          _enterdQuantity = int.parse(newValue!),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  category.value.title,
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      formKey.currentState!.reset(); //reset fields
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: const Text('Add item'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
