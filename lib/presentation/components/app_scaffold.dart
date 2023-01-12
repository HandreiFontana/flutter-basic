import 'package:basic/presentation/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:basic/shared/themes/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget title;
  final Widget body;
  final String? route;

  const AppScaffold(
      {super.key, required this.title, required this.body, this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        backgroundColor: AppColors.primary,
      ),
      body: body,
      drawer: AppDrawer(),
      //bottomNavigationBar: AppNavigationBar(),
      floatingActionButton: route == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(route ?? '');
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
            ),
    );
  }
}
