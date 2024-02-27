part of 'widgets.dart';

class StarsRating extends StatelessWidget {
  final Color? color;
  final double? size;

  StarsRating({
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    Color colorStar = this.color ?? akPrimaryColor;
    double sizeStar = this.size ?? akFontSize + 3.0;

    return Row(
      children: [
        Icon(Icons.star_rounded, color: colorStar, size: sizeStar),
        Icon(Icons.star_rounded, color: colorStar, size: sizeStar),
        Icon(Icons.star_rounded, color: colorStar, size: sizeStar),
        Icon(Icons.star_border_rounded, color: colorStar, size: sizeStar),
        Icon(Icons.star_border_rounded, color: colorStar, size: sizeStar),
      ],
    );
  }
}
