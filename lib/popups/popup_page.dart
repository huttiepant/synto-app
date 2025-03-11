import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synto_app/popups/welcome_second_page.dart';
import 'package:synto_app/ui/brand_button.dart';

import '../ui/brand_colors.dart';

class PopupPage extends StatelessWidget {
  const PopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 213,
                height: 248,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/astronaut.jpg',
                        ),
                        fit: BoxFit.contain)),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Great call! This might feel like a small step, but it’s a giant leap toward reading like a master.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins().copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2A2A2A)),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 32),
                child: Html(
                  data: '''
            <p>Most people read books. Few truly understand them.</p>
            <p>You’re about to change that.</p>
            <p>We’ve built engaging challenges and activities to guide you before, during, and after reading. These aren’t just fun—they’re proven to help you get more from your book.</p>
            <h2>📚 Active Readers:</h2>
            
                <div><span class="emoji">✅</span> Remember more of what they read</div>
                <div><span class="emoji">✅</span> Apply ideas to everyday life</div>
                <div><span class="emoji">✅</span> Develop sharper critical thinking</div>
            
            <p>Let’s make your reading count.</p>
          ''',
                  style: {
                    "*": Style(
                      textAlign: TextAlign.center,
                      color: Color(0xff5A5A5A),
                    ),
                    "span.emoji": Style(
                        fontFamily: GoogleFonts.notoColorEmoji().fontFamily)
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: BrandButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeSecondPage(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    border: Border.all(color: Colors.white, width: 1),
                    text: 'Continue',
                    color: brandLightBlue,
                    textColor: Colors.white),
              )
            ],
          ),
        ),
      )),
    );
  }
}
