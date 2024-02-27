import 'package:app_pasajero_ns/data/models/google_suggestion_response.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PredictionItemList extends StatefulWidget {
  final Prediction prediction;
  final String typeIcon;
  final Function(Prediction prediction)? onFavoriteAdd;
  final Function(Prediction prediction)? onFavoriteRemove;
  final Function(Prediction prediction)? onPress;
  final Function(Prediction prediction)? onLongPress;

  PredictionItemList({
    required this.prediction,
    required this.typeIcon,
    this.onFavoriteAdd,
    this.onFavoriteRemove,
    this.onPress,
    this.onLongPress,
  });

  @override
  _PredictionItemListState createState() => _PredictionItemListState();
}

class _PredictionItemListState extends State<PredictionItemList> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final icon = Container(
      width: 35.0,
      child: PlacesIcons(
        placeType: this.widget.typeIcon,
      ),
      alignment: Alignment.centerLeft,
    );

    final hearIcon = Container(
      padding: EdgeInsets.only(right: 8.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            color: akSecondaryColor.withOpacity(.5),
            padding: EdgeInsets.all(6.0),
            child: Icon(
              Icons.favorite,
              size: 15.0,
              color: akWhiteColor,
            ),
            alignment: Alignment.centerLeft,
          )),
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () async {
          this.widget.onPress?.call(this.widget.prediction);
        },
        onLongPress: () {
          this.widget.onLongPress?.call(this.widget.prediction);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: akContentPadding * 0.75,
              // vertical: 200.0,
              horizontal: akContentPadding * 0.75),
          child: Row(
            children: [
              (widget.prediction.isFavorite != null &&
                      widget.prediction.isFavorite == true)
                  ? hearIcon
                  : icon,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AkText(
                      '${this.widget.prediction.structuredFormatting.mainText}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: akFontSize - 1.0),
                    ),
                    // SkelContainer(),
                    SizedBox(height: 3.5),
                    AkText(
                      '${this.widget.prediction.structuredFormatting.secondaryText}',
                      style: TextStyle(
                          fontSize: akFontSize * 0.8,
                          color: akTextColor.withOpacity(0.55)),
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              (widget.prediction.isFavorite != null &&
                      widget.prediction.isFavorite == true)
                  ? SizedBox()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              if (isFavorite) {
                                AppSnackbar().success(
                                    message: 'Añadido a favoritos!',
                                    duration: Duration(milliseconds: 1000));
                                this
                                    .widget
                                    .onFavoriteAdd
                                    ?.call(this.widget.prediction);
                              } else {
                                this
                                    .widget
                                    .onFavoriteRemove
                                    ?.call(this.widget.prediction);
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.favorite,
                              size: akDefaultGutterSize + 8.0,
                              color: isFavorite
                                  ? akSecondaryColor
                                  : akTextColor.withOpacity(.2),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
