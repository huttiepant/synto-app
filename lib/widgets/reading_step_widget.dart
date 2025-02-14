import 'package:flutter/material.dart';
import 'package:synto_app/services/books_service.dart';
import 'package:synto_app/widgets/book_tag.dart';

class ReadingLevel {
  final String displayName;
  final ReadingStep value;

  ReadingLevel({required this.displayName, required this.value});
}

List<ReadingLevel> readingLevels = [
  ReadingLevel(displayName: 'Pre-Read', value: ReadingStep.preReading),
  ReadingLevel(displayName: 'Reading', value: ReadingStep.whileReading),
  ReadingLevel(displayName: 'Post Read', value: ReadingStep.postReading),
];

class ReadingStepWidget extends StatefulWidget {
  const ReadingStepWidget({super.key, required this.step});

  final ReadingStep step;

  @override
  State<ReadingStepWidget> createState() => _ReadingStepWidgetState();
}

class _ReadingStepWidgetState extends State<ReadingStepWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...readingLevels.map((level) => BookTag(
              onTap: () {},
              title: level.displayName,
              selected: level.value == widget.step,
            )),
      ],
    );
  }
}
