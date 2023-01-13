import 'package:flutter/material.dart';

class MenuIcon {
  MenuIcon(this.iconName, this.icon);

  String iconName;
  final IconData icon;
}

final List<MenuIcon> icons = [
  MenuIcon('question_mark', Icons.question_mark),
  MenuIcon('home', Icons.home),
  MenuIcon('public', Icons.public),
  MenuIcon('apartment', Icons.apartment),
  MenuIcon('monetization_on', Icons.monetization_on),
  MenuIcon('groups', Icons.groups),
  MenuIcon('person', Icons.person),
  MenuIcon('people', Icons.people),
  MenuIcon('sell', Icons.sell),
  MenuIcon('money', Icons.money),
  MenuIcon('shopping_cart', Icons.shopping_cart),
  MenuIcon('widgets', Icons.widgets),
  MenuIcon('exit_to_app', Icons.exit_to_app),
];
