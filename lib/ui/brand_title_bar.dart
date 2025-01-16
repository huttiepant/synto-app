import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../api/services/auth_service.dart';

class BrandTitleBar extends StatefulWidget {
  const BrandTitleBar({super.key, required this.title});

  final String title;

  @override
  State<BrandTitleBar> createState() => _BrandTitleBarState();
}

class _BrandTitleBarState extends State<BrandTitleBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.router.pushNamed('/'),
            child: SvgPicture.asset(
              'assets/svgs/arrow-left.svg',
              height: 24,
              width: 24,
            ),
          ),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins().copyWith(
              color: Color(0xff2A2A2A),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: () async {
              await GetIt.I<AuthService>().signOut();
              context.router.replaceNamed('/auth');
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
