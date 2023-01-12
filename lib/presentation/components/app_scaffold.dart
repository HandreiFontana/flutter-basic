import 'package:basic/presentation/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:basic/shared/themes/app_colors.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showDrawer,
    this.route,
  });

  final Widget title;
  final Widget body;
  final bool? showDrawer;
  final String? route;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title,
        backgroundColor: AppColors.primary,
      ),
      body: widget.body,
      drawer: widget.showDrawer != null ? AppDrawer() : null,
      floatingActionButton: widget.route == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(widget.route!);
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
            ),
    );
  }
}
