part of 'widgets.dart';

class DividerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: 35.0,
      height: 6.0,
      decoration: BoxDecoration(
        color: akAccentColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
