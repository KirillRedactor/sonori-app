import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  // brightness: Brightness.light,
  textTheme: GoogleFonts.ralewayTextTheme().apply(),
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.white,
    secondary: Colors.grey[300]!,
  ),
);


// ThemeData(
//         primarySwatch: Colors.indigo,
        // useMaterial3: true,
//         textTheme: GoogleFonts.ralewayTextTheme(),
        // textTheme: GoogleFonts.silkscreenTextTheme(), //* pixels
        // textTheme: GoogleFonts.robotoTextTheme(),
//       );