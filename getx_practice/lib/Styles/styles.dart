import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final title = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static final reviewName = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
  );

  static final reviewDate = GoogleFonts.poppins(
    fontSize: 12,
    color: Colors.grey[600],
  );

  static final reviewComment = GoogleFonts.poppins(
    fontSize: 14,
  );

  static final ratingNumber = GoogleFonts.poppins(
    fontSize: 44,
    fontWeight: FontWeight.w600,
  );

  static final subText = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.grey[700],
  );

  static final hintText = GoogleFonts.poppins(
    fontSize: 14,
  );
}
