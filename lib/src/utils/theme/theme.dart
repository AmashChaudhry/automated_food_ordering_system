import 'package:automated_food_ordering_system/src/utils/theme/widgets_theme/text_form_field_theme.dart';
import 'package:flutter/material.dart';
import 'package:automated_food_ordering_system/src/utils/theme/widgets_theme/outlined_button_theme.dart';
import 'package:automated_food_ordering_system/src/utils/theme/widgets_theme/elevated_button_theme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(

    dividerColor: Colors.black,

    brightness: Brightness.light,
    primarySwatch: Colors.orange,

    outlinedButtonTheme: AOutlinedButtonTheme.lightOutlinedButtonTheme,
    elevatedButtonTheme: AElevatedButtonTheme.lightElevatedButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.lightTextFormFieldTheme,
  );

  static ThemeData darkTheme = ThemeData(

    dividerColor: Colors.white,

    brightness: Brightness.dark,
    primarySwatch: Colors.orange,

    outlinedButtonTheme: AOutlinedButtonTheme.darkOutlinedButtonTheme,
    elevatedButtonTheme: AElevatedButtonTheme.darkElevatedButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.darkTextFormFieldTheme,
  );
}
