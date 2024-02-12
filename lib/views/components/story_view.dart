import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

// ignore: must_be_immutable
class StoryScreen extends StatelessWidget {
  List<StoryItem> storyList = [];
  StoryController controller = StoryController();

  StoryScreen({super.key, required this.storyList, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(

        storyItems: storyList,
        controller: controller,
        inline: true, // Display story inline instead of fullscreen
        repeat: false,
        
        onStoryShow: (value) => {
        },
        onComplete: () {
          
          Navigator.of(context).pop();
        },
        onVerticalSwipeComplete: (direction) {
          // Handle vertical swipes (up or down)
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
