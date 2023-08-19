import 'package:flutter/material.dart';

class GroceriesTile extends StatelessWidget {
  const GroceriesTile({
    super.key,
    required this.title,
    required this.colorIcon,
    required this.quantity,
  });

  final String title;
  final Color colorIcon;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //title
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      //square icon
      leading: Container(
        width: 24,
        height: 24,
        color: colorIcon,
      ),
      trailing: Text(
        quantity,
        style: Theme.of(context)
            .textTheme
            .labelMedium!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
