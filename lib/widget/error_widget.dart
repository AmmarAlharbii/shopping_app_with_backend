import 'package:flutter/material.dart';

class ErrorWidgetMessage extends StatelessWidget {
  const ErrorWidgetMessage({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
