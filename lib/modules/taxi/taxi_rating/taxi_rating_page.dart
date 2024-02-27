import 'package:app_pasajero_ns/modules/taxi/taxi_rating/taxi_rating_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class TaxiRatingPage extends StatelessWidget {
  final _conX = Get.put(TaxiRatingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Califica tu viaje'),
      ),
      body: Container(
        padding: EdgeInsets.all(akContentPadding),
        child: Column(
          children: [
            _buildDriverInfo(),
            _buildEnviar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverInfo() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(),
            SizedBox(height: 5.0),
            // AkText('Miembro desde hace 4 años', type: AkTextType.comment),
            SizedBox(height: 10.0),
            Divider(color: akGreyColor),
            SizedBox(height: 10.0),
            AkText(
              'Califica al conductor',
              type: AkTextType.body1,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.0),
            _buildRating(),
            SizedBox(height: 10.0),
            /* AkInput(
              filledColor: Colors.transparent,
              type: AkInputType.underline,
              hintText: 'Escribe una nota de agradecimiento',
            ), */
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildRating() {
    return RatingBar.builder(
      glow: false,
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
        _conX.rating = rating;
      },
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black26, width: 2),
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                  image: NetworkImage(
                      'https://thumbs.dreamstime.com/b/portrait-young-man-beard-hair-style-male-avatar-vector-portrait-young-man-beard-hair-style-male-avatar-105082137.jpg'),
                  fit: BoxFit.cover)),
        ),
      ],
    );
  }

  Widget _buildEnviar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AkText(
          'Todas las calificaciones son anónimas',
          type: AkTextType.comment,
          style: TextStyle(color: akTextColor.withOpacity(.45)),
        ),
        SizedBox(height: 7.0),
        AkButton(
          enableMargin: false,
          fluid: true,
          onPressed: () {
            _conX.guardarCalificacion();
          },
          text: 'Enviar',
        ),
      ],
    );
  }
}
