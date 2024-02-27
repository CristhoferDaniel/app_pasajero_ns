import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';

class ViajeDetallePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del viaje'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: akContentPadding,
                    horizontal: akContentPadding * 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAvatar(),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AkText('Andrés López'),
                            AkText('ABC-123'),
                            AkText('Chevrolet Sonic'),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30.0),
                    AkText(
                      'Detalle del recorrido',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: akPrimaryColor,
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AkText('Av. Javier Padro 35'),
                            AkText('27/07/2021     08:45 p.m.'),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: akAccentColor,
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AkText('Av. Javier Padro 35'),
                            AkText('27/07/2021     08:45 p.m.'),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: akContentPadding, horizontal: akContentPadding * 3),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AkText('Total',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    AkText('S/ 40.00',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10.0),
                AkButton(
                  enableMargin: false,
                  fluid: true,
                  onPressed: () {},
                  text: 'Ver mapa',
                ),
              ],
            ),
          )
        ],
      ),
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
}
