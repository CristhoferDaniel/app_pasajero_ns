part of 'widgets.dart';

enum SocialIconsAllowed { twitter, facebook, google, phone }

typedef SocialIconCallback = void Function(SocialIconsAllowed selected);

class SocialIconButtons extends StatelessWidget {
  final SocialIconCallback onPressed;

  const SocialIconButtons({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final List<SocialIconsAllowed> iconsNames = [
      // SocialIconsAllowed.twitter,
      SocialIconsAllowed.phone,
      SocialIconsAllowed.facebook,
      SocialIconsAllowed.google
    ];
    final List<Widget> icons = [];
    iconsNames.forEach((iconType) {
      final name = iconType.toString().split('.').last;

      /* icons.add(Container(
        width: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: akAccentColor, elevation: 0.0, shape: CircleBorder()),
          onPressed: () {
            this.onPressed(iconType);
          },
          child: Container(
            // padding: EdgeInsets.all(15),
            child: SvgPicture.asset(
              'assets/icons/$name.svg',
              width: 15,
              color: akPrimaryColor,
            ),
          ),
        ),
      )); */
      icons.add(Container(
        width: 50,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: AkButton(
          elevation: 0,
          borderRadius: 100,
          variant: AkButtonVariant.accent,
          onPressed: () {
            this.onPressed(iconType);
          },
          child: Container(
            // padding: EdgeInsets.all(15),
            child: SvgPicture.asset(
              'assets/icons/$name.svg',
              width: 15,
              color: akPrimaryColor,
            ),
          ),
        ),
      ));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: icons,
    );
  }
}
