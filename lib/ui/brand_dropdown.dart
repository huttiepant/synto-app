import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownOption<T> {
  final String title;
  final T value;

  DropDownOption({required this.title, required this.value});
}

class BrandDropdown<T> extends StatelessWidget {
  const BrandDropdown(
      {super.key,
      required this.title,
      required this.options,
      required this.onSelect});

  final String title;
  final List<DropDownOption<T>> options;
  final Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins().copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff2B2B2B)),
              ),
            ),
          ],
        ),
        items: options
            .map((DropDownOption option) => DropdownMenuItem<T>(
                  value: option.value,
                  child: Text(
                    option.title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff2B2B2B)),
                  ),
                ))
            .toList(),
        onChanged: (T? value) {
          if (value != null) {
            onSelect(value);
          }
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
        menuItemStyleData: MenuItemStyleData(
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
