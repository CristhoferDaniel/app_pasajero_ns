part of 'widgets.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isSelected;
  final bool enabled;

  CustomCheckbox({this.isSelected = false, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: akTitleColor.withOpacity(.085),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: isSelected ? akPrimaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Icon(
              Icons.check_rounded,
              size: akFontSize - 2.0,
              color: isSelected ? akWhiteColor : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
