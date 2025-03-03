import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.onTap,
  });

  final int count;
  final Function onTap;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      children: [
        ...List.generate(
            count,
            (index) => GestureDetector(
                  onTap: () {
                    onTap(index);
                  },
                  child: AnimatedContainer(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: index == currentIndex
                          ? Colors.black
                          : Color(0xffB8B8B8),
                      shape: BoxShape.circle,
                    ),
                    duration: Duration(milliseconds: 250),
                  ),
                ))
      ],
    );
  }
}
