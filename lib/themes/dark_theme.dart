import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.ralewayTextTheme().apply(
    displayColor: Colors.white,
    bodyColor: const Color.fromARGB(223, 255, 255, 255),
  ),
  colorSchemeSeed: const Color.fromRGBO(92, 168, 48, 1),
);

// ThemeData(
//         primarySwatch: Colors.indigo,
        // useMaterial3: true,
//         textTheme: GoogleFonts.ralewayTextTheme(),
        // textTheme: GoogleFonts.silkscreenTextTheme(), //* pixels
        // textTheme: GoogleFonts.robotoTextTheme(),
//       );