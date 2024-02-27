part of 'widgets.dart';

class InfoRuta extends StatelessWidget {
  final bool showTitle;
  final bool vuelta;
  final String origenName;
  final String destinoName;

  final DateTime? fechaReserva;

  const InfoRuta({
    Key? key,
    this.showTitle = true,
    this.vuelta = false,
    this.origenName = '',
    this.destinoName = '',
    this.fechaReserva,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String reservaFechaString = '';

    if (fechaReserva != null) {
      final dia = Helpers.capitalizeFirstLetter(
          DateFormat('EEEE', 'es').format(fechaReserva!));
      reservaFechaString = dia +
          ', ' +
          DateFormat('d', 'es').format(fechaReserva!) +
          ' de ' +
          DateFormat('MMMM', 'es').format(fechaReserva!) +
          ' a las ' +
          DateFormat('h:mm aa', 'es').format(fechaReserva!);
    }

    return Container(
      width: double.infinity,
      child: Content(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showTitle
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AkText(
                        "Viaje de ${vuelta ? 'vuelta' : 'ida'}",
                        style: TextStyle(
                          fontSize: akFontSize + 1.0,
                          color: akTitleColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  )
                : SizedBox(),
            AkText(
              reservaFechaString,
              style: TextStyle(
                fontSize: akFontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 15.0),
            EtiquetasInicioFin(
              origenText: origenName,
              destinoText: destinoName,
            )
          ],
        ),
      ),
    );
  }
}
