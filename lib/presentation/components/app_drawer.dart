import 'package:basic/domain/models/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:basic/shared/themes/app_colors.dart';

import 'package:basic/shared/config/app_menu_options.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Authentication authentication = Provider.of(context, listen: false);
    final menu = authentication.getMenusOption();
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: AppColors.primary,
          ),
          currentAccountPicture: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            // child: Image.network(
            //     'https://media-exp1.licdn.com/dms/image/C4E03AQGgh_pQqA2PeQ/profile-displayphoto-shrink_100_100/0/1516240331647?e=1671667200&v=beta&t=5eF7HZKPidy0a0WZOnz2vriNqhyN-AXYAqHUsHkKri4'),
          ),
          accountName: Text('André Dourado'),
          accountEmail: Text('andreldcastro@gmail.com'),
        ),
        Flexible(
          child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: menu.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: Icon(menu[index].icon),
                    title: Text(menu[index].title),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(menu[index].route);
                    });
              }),
        ),
      ],
    ));
  }
}
