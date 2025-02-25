import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/ui/brand_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/brand_colors.dart';

class InformationPopup extends StatelessWidget {
  const InformationPopup({
    super.key,
    required this.title,
    required this.info,
    this.themes,
    this.onTap,
  });

  final String title;
  final String info;
  final String? themes;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if(title.isNotEmpty)
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins().copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff2A2A2A)),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Html(
                          data: info,
                          onAnchorTap: (url, a, e) async {
                            if (url == null) {
                              return;
                            }
                            await launchUrl(Uri.parse(url));
                          },
                          style: {
                            "*": Style(
                              textAlign: TextAlign.center,
                              color: Color(0xff5A5A5A),
                            ),
                            "span": Style(
                              fontSize: FontSize(15),
                            ),
                          },
                        ),
                        if(themes != null)
                        Html(
                          data: themes,
                          style: {
                            "h2": Style(
                              textAlign: TextAlign.center,
                              color: Color(0xff5A5A5A),
                              fontStyle: GoogleFonts.poppins().fontStyle,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                            "span": Style(
                              color: Color(0xff5A5A5A),
                              alignment: Alignment.center,
                              textAlign: TextAlign.center,
                              fontSize: FontSize(15),
                              fontStyle: GoogleFonts.poppins().fontStyle,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          },
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: BrandButton(
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                    return;
                  }
                  Navigator.of(context).pop();
                },
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                border: Border.all(color: Colors.white, width: 1),
                text: 'Ok',
                color: brandLightBlue,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      )),
    );
  }
}
