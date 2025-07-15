import 'package:diaries/pages/homepage.dart';
import 'package:diaries/pages/new_note.dart';
import 'package:diaries/pages/profile.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';

class ButtomNavBar extends StatelessWidget {
  const ButtomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingNavBar(
      resizeToAvoidBottomInset: false,
      color: Theme.of(context).colorScheme.secondary,
      selectedIconColor: Theme.of(context).colorScheme.primaryContainer,
      unselectedIconColor: Theme.of(context).colorScheme.inversePrimary,
      items: [
        FloatingNavBarItem(
          iconData: Icons.home_outlined,
          page: MyHomePage(),
          title: 'Home',
        ),
        FloatingNavBarItem(
          iconData: Icons.add,
          page: NewNotePage(),
          title: 'New Note',
        ),
        FloatingNavBarItem(
          iconData: Icons.person_outlined,
          page: ProfilePage(),
          title: 'Profile',
        ),
      ],
      horizontalPadding: 20.0,
      hapticFeedback: true,
      showTitle: false,
    );
  }
}
