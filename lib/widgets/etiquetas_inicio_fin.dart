part of 'widgets.dart';

class EtiquetasInicioFin extends StatelessWidget {
  final String origenText;
  final String destinoText;

  const EtiquetasInicioFin(
      {Key? key, this.origenText = '', this.destinoText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: const ShapeRoute(),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              child: AbsorbPointer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildLabels(this.origenText, true),
                    SizedBox(height: 10.0),
                    _buildLabels(this.destinoText, false),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabels(String text, bool isOrigin) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: AkText(
            text,
            style: TextStyle(
              fontSize: akFontSize - 2.0,
              color: akTextColor.withOpacity(.65),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 2.0),
        Container(
          alignment: Alignment.centerLeft,
          child: AkText(
            isOrigin ? 'Origen' : 'Destino',
            style: TextStyle(
                fontSize: akFontSize - 2.0,
                color: akTextColor.withOpacity(.50)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 15.0),
      ],
    );
  }
}

class EtiquetasInicioFinStyle2 extends StatelessWidget {
  final String origenText;
  final String destinoText;

  const EtiquetasInicioFinStyle2(
      {Key? key, this.origenText = '', this.destinoText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          const ShapeRoute2(),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              child: AbsorbPointer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildLabels(this.origenText),
                    SizedBox(height: 8.0),
                    _buildLabels(this.destinoText),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabels(String text) {
    return Container(
      height: akFontSize * 3,
      alignment: Alignment.centerLeft,
      child: AkText(
        text,
        style: TextStyle(
            fontSize: akFontSize - 2.0, color: akTextColor.withOpacity(.65)),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ShapeRoute extends StatelessWidget {
  const ShapeRoute();

  @override
  Widget build(BuildContext context) {
    return _buildShapeRoute();
  }

  Widget _buildShapeRoute() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _circleDot(),
        ..._dottedLines(count: 7),
        _circleDot(isOrigin: false),
      ],
    );
  }

  Widget _circleDot({double size = 11.0, bool isOrigin = true}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: isOrigin ? null : akSecondaryColor,
          border: Border.all(
              color: isOrigin ? akPrimaryColor : akSecondaryColor, width: 2.0)),
      height: size,
      width: size,
      child: SizedBox(),
    );
  }

  List<Widget> _dottedLines({int count = 2}) {
    List<Widget> lines = [];
    Widget line = Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(color: akSecondaryColor),
      width: 1.0,
      height: 5.0,
    );
    for (var i = 0; i < count; i++) {
      lines.add(line);
    }
    return lines;
  }
}

class ShapeRoute2 extends StatelessWidget {
  const ShapeRoute2();

  @override
  Widget build(BuildContext context) {
    return _buildShapeRoute();
  }

  Widget _buildShapeRoute() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _circleDot(),
        ..._dottedLines(count: 5),
        _circleDot(isOrigin: false),
      ],
    );
  }

  Widget _circleDot({double size = 11.0, bool isOrigin = true}) {
    return Container(
      padding: EdgeInsets.all(size * 0.25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        color: isOrigin ? akPrimaryColor : akSecondaryColor,
      ),
      child: Icon(
        isOrigin ? Icons.location_on_rounded : Icons.star_rounded,
        size: size * 1.2,
        color: akWhiteColor,
      ),
    );
  }

  List<Widget> _dottedLines({int count = 2}) {
    List<Widget> lines = [];
    Widget line = Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(color: akSecondaryColor),
      width: 1.0,
      height: 5.0,
    );
    for (var i = 0; i < count; i++) {
      lines.add(line);
    }
    return lines;
  }
}
