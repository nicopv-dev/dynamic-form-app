import 'package:flutter/material.dart';

class AppTheme {
  static final theme = ThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.yellow),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.yellow,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );
}
