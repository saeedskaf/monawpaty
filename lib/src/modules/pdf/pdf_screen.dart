import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shared/styles/colors.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfScreen extends StatelessWidget {
  final String title;
  final String pdfName;
  const PdfScreen({super.key, required this.title, required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(title),
              titleTextStyle: TextStyle(
                  fontFamily: GoogleFonts.cairo().fontFamily,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              backgroundColor: primaryColor,
              centerTitle: true,
            ),
            body: const PDF(
              enableSwipe: true,
              pageFling: false,
            ).fromAsset('assets/files/$pdfName.pdf')));
  }
}
