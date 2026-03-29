// Sidebar

import 'package:eproject/pages/home.dart';
import 'package:eproject/pages/login.dart';
import 'package:flutter/material.dart';

class HomeSidebar extends StatelessWidget {
  const HomeSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // get app theme

    return Container(
      width: 200,
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          //Home button
          ListTile(
            leading: Icon(Icons.home, color: theme.colorScheme.primary),
            title: Text("Home", style: theme.textTheme.bodyMedium),
            onTap: () => {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => Home()) // redirect to home
              )
            },
          ),

          const Spacer(),

          //Logout button
          ListTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.error),
            title: Text("Logout", style: TextStyle(color: theme.colorScheme.error)),
            onTap: () => {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => Login()) // redirect to login page
              )
            },
          ),
        ],
      ),
    );
  }
}