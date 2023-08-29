import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class EmptyList extends StatefulWidget {
  const EmptyList({super.key});

  @override
  State<EmptyList> createState() => _EmptyListState();
}

class _EmptyListState extends State<EmptyList> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'bounce',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      //if list empty
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Empty list',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white),
            ),
            const RiveAnimation.asset(
              useArtboardSize: true,
              'assets/5825-11357-empty-bee.riv',
            ),
          ],
        ),
      ),
    );
  }
}
