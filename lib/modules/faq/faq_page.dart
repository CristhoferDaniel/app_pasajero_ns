import 'package:app_pasajero_ns/data/models/preguntas_frecuentes_pasajero.dart';
import 'package:app_pasajero_ns/modules/faq/faq_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class FaqPage extends StatelessWidget {
  final _conX = Get.find<FaqController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas frecuentes'),
        // leading: _buildBackButton(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GetBuilder<FaqController>(
        id: 'lista',
        builder: (_) {
          return FutureBuilder(
            future: _conX.listaPreguntas(),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return _buildLoader();
              }
              if (snapshot.hasData &&
                  snapshot.data is List<PreguntasFrecuentesPasajero>) {
                return _buildLista(
                    snapshot.data as List<PreguntasFrecuentesPasajero>);
              }
              if (snapshot.hasError) {
                return _buildError();
              }
              return _buildNoData();
            },
          );
        });
  }

  Widget _buildLoader() {
    return Center(
      child: SpinLoadingIcon(
        color: akPrimaryColor,
        strokeWidth: 2.0,
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(akContentPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AkText(
              'No se pudo obtener la lista de preguntas',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            AkButton(
              size: AkButtonSize.small,
              type: AkButtonType.outline,
              onPressed: _conX.refreshList,
              text: 'Reintentar',
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return Center(
      child: AkText('No hay datos'),
    );
  }

  Widget _buildLista(List<PreguntasFrecuentesPasajero> lista) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: lista.length,
      itemBuilder: (_, i) {
        return _itemPregunta(lista[i]);
      },
    );
  }

  Widget _itemPregunta(PreguntasFrecuentesPasajero pregunta) {
    return Container(
      padding: EdgeInsets.only(top: akContentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: akContentPadding),
          Container(
            padding: EdgeInsets.symmetric(horizontal: akContentPadding),
            child: AkText(
              Helpers.removeTagHTML(htmlString: pregunta.pregunta),
              type: AkTextType.h9,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: akContentPadding - 8),
            child: Html(data: pregunta.respuesta),
          ),
          SizedBox(height: 10.0),
          Divider(
            color: Colors.black.withOpacity(.10),
            height: 1.0,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return SafeArea(
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded),
        onPressed: () => Get.back(),
      ),
    );
  }
}
