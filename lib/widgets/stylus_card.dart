part of 'widgets.dart';

class StylusCard extends StatelessWidget {
  final String? title;
  final List<Widget> items;

  const StylusCard({Key? key, this.title, this.items = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        title == null
            ? SizedBox()
            : Container(
                child: AkText(
                  title ?? '',
                  style: TextStyle(
                    fontSize: akFontSize - 1.0,
                    fontWeight: FontWeight.w500,
                    color: akTitleColor.withOpacity(0.5),
                  ),
                ),
              ),
        SizedBox(height: 12.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
              color: Helpers.darken(akScaffoldBackgroundColor, 0.025),
              child: Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: akContentPadding * 0.5),
                        child: Divider(
                          color:
                              Helpers.darken(akScaffoldBackgroundColor, 0.15),
                          height: 1.0,
                          thickness: 0.7,
                        ),
                      ),
                    items[i],
                  ]
                ],
              )),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}

class StylusCardItem extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final TextOverflow? textOverflow;
  final VoidCallback? onTap;

  const StylusCardItem(
      {Key? key, this.icon, this.text, this.textOverflow, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          onTap?.call();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: akContentPadding * 0.5,
            vertical: akContentPadding * 0.8,
          ),
          child: Row(
            children: [
              icon == null
                  ? SizedBox()
                  : Container(
                      child: Icon(
                        icon,
                        size: akFontSize + 8,
                        color: akTitleColor.withOpacity(0.75),
                      ),
                    ),
              icon == null ? SizedBox() : SizedBox(width: 8.0),
              Expanded(
                child: text == null
                    ? SizedBox()
                    : AkText(
                        text ?? '',
                        style: TextStyle(
                          color: akTitleColor,
                        ),
                        overflow: textOverflow ?? TextOverflow.visible,
                      ),
              ),
              SizedBox(width: 8.0),
              Container(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: akFontSize - 1.0,
                  color: Helpers.darken(akScaffoldBackgroundColor, 0.25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
