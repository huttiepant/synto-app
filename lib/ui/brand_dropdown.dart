import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandDropdown extends StatefulWidget {
  const BrandDropdown({super.key});

  @override
  State<BrandDropdown> createState() => _BrandDropdownState();
}

class _BrandDropdownState extends State<BrandDropdown> {
  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                'Pick a Book',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff2B2B2B)),
              ),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff2B2B2B)),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          width: 160,
          padding:
              const EdgeInsets.only(top: 0, left: 16, bottom: 0, right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color(0xff2b2b2b),
            ),
            color: Colors.white,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
          ),
          iconSize: 24,
          iconEnabledColor: Color(0xff2b2b2b),
          iconDisabledColor: Color(0xff2b2b2b),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 132,
          padding: EdgeInsets.all(0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(20),
            thickness: WidgetStateProperty.all<double>(6),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData:  MenuItemStyleData(
          height: 44,
          overlayColor: WidgetStatePropertyAll(Color(0xffEAF2FF)),
          selectedMenuItemBuilder: (ctx, child) {
            return Container(
              color: Color(0xffEAF2FF),
              child: child,
            );
          },
          padding: EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
