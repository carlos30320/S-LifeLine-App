import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData globalTheme = ThemeData(
    colorScheme: ColorScheme(
        background: Colors.white,
        onBackground: Colors.white,
        brightness: Brightness.light,
        primary: Colors.blueGrey,
        onPrimary: Colors.white,
        secondary: Colors.blueGrey.withOpacity(0.4),
        onSecondary: Colors.white,
        error: Colors.red.withOpacity(0.8),
        onError: Colors.red.withOpacity(0.2), 
        onSurface: Colors.blueGrey.withOpacity(0.4) ,
        surface: Colors.blueGrey.withOpacity(0.4)
        ),
    primaryColor: Colors.blueGrey.withOpacity(0.4),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.white);
