//Searchbar style

import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  final void Function(String) onChanged; // required function on changed

  const Searchbar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // get app theme

    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextField(
        onChanged: onChanged, // call inputed on changed function from argument on changed
        decoration: InputDecoration(
          hintText: "Search students...",
          hintStyle: theme.textTheme.bodySmall,
          prefixIcon: Icon(Icons.search, color: theme.textTheme.bodySmall?.color),
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
      ),
    );
  }
}