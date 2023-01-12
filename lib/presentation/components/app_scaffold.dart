import 'package:flutter/material.dart';
import 'package:basic/presentation/components/app_drawer.dart';
import 'package:basic/presentation/components/app_navigation_bar.dart';
import 'package:basic/shared/themes/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget title;
  final Widget body;

  const AppScaffold({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        backgroundColor: AppColors.primary,
      ),
      body: body,
      drawer: AppDrawer(),
      bottomNavigationBar: AppNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
