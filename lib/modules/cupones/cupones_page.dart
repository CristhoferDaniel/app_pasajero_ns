import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/modules/cupones/cupones_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:clippy_flutter/ticket.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CuponesPage extends StatelessWidget {
  final _conX = Get.put(CuponesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Color(0xFFF5F5F5),
      /* appBar: , */
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: _buildContent(constraints),
                        physics: BouncingScrollPhysics(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Obx(() => _conX.showInputLayer.value
              ? _buildInput()
              : Positioned.fill(child: SizedBox()))
        ],
      ),
      /* bottomNavigationBar: Container(
        padding: EdgeInsets.all(akContentPadding),
        color: akRedColor,
        child: TextFormField(),
      ), */
    );
  }

  Widget _buildInput() {
    return Positioned.fill(
      child: FadeIn(
        child: Stack(
          children: [
            GestureDetector(
              onTap: _conX.onCloseInputButtonTap,
              child: Container(
                color: akBlackColor.withOpacity(.5),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(akContentPadding),
                  color: akWhiteColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AkText(
                              'Agregar código'.toUpperCase(),
                              style: TextStyle(
                                color: akTitleColor,
                                fontSize: akFontSize - 3.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _conX.onCloseInputButtonTap,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Icons.clear_rounded,
                              color: akTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: akPrimaryColor.withOpacity(.15),
                      ),
                      SizedBox(height: 10.0),
                      AkInput(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 15.0,
                        ),
                        filledColor: Color(0xFFF1F1F1),
                        enabledBorderColor: Color(0xFFDBDBDB),
                        forceOutline: true,
                        filledFocusedColor: Color(0xFFF1F1F1),
                        keyboardType: TextInputType.text,
                        // controller: _conX.origenCtlr,
                        hintText: 'Punto de origen',
                        labelColor: akTextColor.withOpacity(.3),
                        focusNode: _conX.iptFNode,
                        enableMargin: false,
                        suffixIcon: Icon(Icons.search),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        type: AkInputType.legend,
                        borderRadius: 8.0,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.characters,
                        onFieldCleaned: () {
                          // _conX.setSearchText('');
                        },
                        onChanged: (text) {
                          // _conX.setSearchText(text);
                        },
                        onEditingComplete: _conX.onUserSubmitCode,
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
                Obx(() => SizedBox(height: _conX.inputPadding.value)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      // toolbarHeight: 10.0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: EdgeInsets.all(akContentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SafeArea(
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: akTitleColor,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            AkText(
              'Cupón de descuento',
              style: TextStyle(
                color: akTitleColor,
                fontSize: akFontSize + 8.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.all(akContentPadding),
          child: Column(
            children: [
              Obx(
                () => _conX.added.value
                    ? FadeIn(
                        key: ValueKey('_vkCA'), child: _buildCuponAplicado())
                    : FadeIn(key: ValueKey('_vkSC'), child: _buildSinCupones()),
              ),
              /* _buildCuponAplicado(),
              _buildCuponAplicado(),
              _buildCuponAplicado(),
              _buildCuponAplicado(), */
              Expanded(child: SizedBox()), // No quitar
              Obx(() => _conX.added.value ? SizedBox() : _buildMainButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSinCupones() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AkText(
              '¿Tienes un cupón?',
              style: TextStyle(
                color: akTitleColor,
                fontSize: akFontSize + 4.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 7.0),
            AkText(
              'Si tienes un cupón, puedes agregarlo y recibir descuentos en el monto final del viaje.',
              style: TextStyle(
                color: akTextColor.withOpacity(.6),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(
                  Icons.wallet_giftcard_outlined,
                  color: akTextColor.withOpacity(.15),
                  size: akFontSize + 30.0,
                ),
                SizedBox(width: 10.0),
                Icon(
                  Icons.local_offer_outlined,
                  color: akTextColor.withOpacity(.15),
                  size: akFontSize + 30.0,
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildCuponAplicado() {
    final _cp = akContentPadding * 0.85;
    final _cornerRadius = 5.0;
    final _ticketBg = Color(0xFFFBFBFB);
    final shadows = [
      ClipShadow(color: Colors.black.withOpacity(.25), elevation: 4.0)
    ];

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AkText(
            'Enhorabuena!',
            style: TextStyle(
              color: akTitleColor,
              fontSize: akFontSize + 4.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 7.0),
          AkText(
            'Has canjeado el siguiente cupón para tu viaje en TaxiGuaa.',
            style: TextStyle(
              color: akTextColor.withOpacity(.6),
            ),
          ),
          SizedBox(height: 20.0),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Ticket(
                    radius: _cornerRadius,
                    clipShadows: shadows,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _ticketBg,
                        border: Border(
                          top: BorderSide(
                            color: Helpers.darken(_ticketBg),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.all(_cp),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 5.0,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: akGreenColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: AkText(
                              'DESCUENTO',
                              style: TextStyle(
                                color: akGreenColor,
                                fontSize: akFontSize - 6.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 7.0),
                          AkText(
                            'Este cupón aplica un S/ 20.0 de descuento al monto final de un viaje.',
                            style: TextStyle(
                              color: akTextColor.withOpacity(.7),
                              fontSize: akFontSize - 2.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: _cornerRadius),
                  child: Stack(
                    children: [
                      Container(
                        width: 3.0,
                        color: _ticketBg,
                      ),
                      Positioned(
                        top: -10,
                        left: 1,
                        bottom: -10,
                        child: DottedBorder(
                          color: Colors.black.withOpacity(.35),
                          borderType: BorderType.Rect,
                          radius: Radius.circular(5),
                          dashPattern: [4, 4],
                          strokeWidth: 1,
                          child: Container(
                            width: 20.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Ticket(
                  radius: _cornerRadius,
                  clipShadows: shadows,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _ticketBg,
                      border: Border(
                        top: BorderSide(
                          color: Helpers.darken(_ticketBg),
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(_cp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AkText(
                          '-S/. 20',
                          style: TextStyle(
                              color: akTitleColor,
                              fontWeight: FontWeight.w500,
                              fontSize: akFontSize + 10.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return AkButton(
      enableMargin: false,
      fluid: true,
      onPressed: _conX.onAddButtonTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: akWhiteColor),
          SizedBox(width: 5.0),
          Flexible(
            child: AkText(
              'Agregar cupón de descuento',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: akWhiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
