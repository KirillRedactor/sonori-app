import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.ralewayTextTheme().apply(),
  colorSchemeSeed: const Color.fromRGBO(92, 168, 48, 1),
);


// ThemeData(
//         primarySwatch: Colors.indigo,
        // useMaterial3: true,
//         textTheme: GoogleFonts.ralewayTextTheme(),
        // textTheme: GoogleFonts.silkscreenTextTheme(), //* pixels
        // textTheme: GoogleFonts.robotoTextTheme(),
//       );