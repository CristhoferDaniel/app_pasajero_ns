import 'package:app_pasajero_ns/modules/perfil/foto/perfil_foto_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class PerfilFotoPage extends StatelessWidget {
  final _conX = Get.put(PerfilPhotoController());

  @override
  Widget build(BuildContext context) {
    final maxScale = PhotoViewComputedScale.covered * 2;

    final minScale = PhotoViewComputedScale.contained;
    final photoViewDecoration = BoxDecoration(
      color: akPrimaryColor,
    );

    return Scaffold(
      backgroundColor: akPrimaryColor,
      appBar: AppBar(
        backgroundColor: akPrimaryColor,
        leading: _buildBackButton(),
        title: Text(
          _conX.title,
          style: TextStyle(color: akWhiteColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: (_conX.isRemoteImage)
                  ? PhotoView(
                      backgroundDecoration: photoViewDecoration,
                      imageProvider: NetworkImage(_conX.imgUrl),
                      loadingBuilder: (_, __) => Center(
                        child: SpinLoadingIcon(
                          color: akWhiteColor,
                        ),
                      ),
                      maxScale: maxScale,
                      minScale: minScale,
                    )
                  : (_conX.imgBytes != null)
                      ? PhotoView(
                          backgroundDecoration: photoViewDecoration,
                          imageProvider: MemoryImage(_conX.imgBytes!),
                          maxScale: maxScale,
                          minScale: minScale,
                        )
                      : SizedBox()),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back_rounded, color: akWhiteColor),
      onPressed: () async {
        Get.back();
      },
    );
  }
}
