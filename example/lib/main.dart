import 'package:flexible_segmented_button/flexible_segmented_button.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  int _selectedIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlexibleSegmentedButton(
          itemSize: 60,
          borderRadius: BorderRadius.circular(20),
          selectedSide: const BorderSide(width: 3, color: Color(0XFF6B6C75)),
          currentIndex: 5,
          selectedIndex: _selectedIndex,
          completedTextColor: Colors.white,
          currentTextColor: const Color(0XFF6B6C75),
          uncompletedTextColor: const Color(0XFF6B6C75),
          uncompletedColor: const Color(0xFFF4F4F4),
          completedColor: const Color(0XFFB20200),
          onSegmentTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          segments: const <FlexibleSegment<int>>[
            FlexibleSegment(
                top: Text('Week 1'),
                center: Text('1'),
                bottom: Text('Text'),
                isCompleted: true),
            FlexibleSegment(
                top: Text('Week 1'),
                center: Text('2'),
                bottom: Text('Text'),
                isCompleted: true),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('3'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('4'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('5'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('6'),
              bottom: Text('Text'),
            ),
            FlexibleSegment(
              top: Text('Week 1'),
              center: Text('7'),
              bottom: Text('Text'),
            ),
          ],
        ),
      ),
    );
  }
}
