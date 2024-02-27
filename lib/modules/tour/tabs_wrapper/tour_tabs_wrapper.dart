import 'package:app_pasajero_ns/modules/tour/Categorias/tour_Categorias_tab.dart';
import 'package:app_pasajero_ns/modules/tour/conocer/tour_conocer_tab.dart';
import 'package:app_pasajero_ns/modules/tour/mapa/tour_mapa_tab.dart';
import 'package:app_pasajero_ns/modules/tour/tabs_wrapper/tour_tabs_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TourTabsWrapper extends StatelessWidget {
  final _conX = Get.put(TourTabsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BuildContext? c =
            _conX.navigatorKeys[_conX.paginaActual]?.currentState?.context;
        print('tipo: ${c.runtimeType}');

        if (c != null) {
          return !await Navigator.maybePop(c);
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _conX.pageController,
          children: [
            TourCategoriasTab(
                tabIndex: 0, navigatorKey: _conX.navigatorKeys[0]!),
            TourConocerTab(tabIndex: 1, navigatorKey: _conX.navigatorKeys[1]!),
            TourMapaTab(index: 2, navigatorKey: _conX.navigatorKeys[2]!),
          ],
        ),
        bottomNavigationBar: GetBuilder<TourTabsController>(
          id: 'gbBottomNavigations',
          builder: (_) => _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: akScaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 1.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Row(
        children: [
          _buildBottomItem(
              icon: Icons.search_outlined,
              title: 'Categorías',
              currentIndex: _conX.paginaActual,
              index: 0,
              onTap: _conX.onItemTapped),
          _buildBottomItem(
              icon: Icons.location_on_outlined,
              title: 'Conocer',
              currentIndex: _conX.paginaActual,
              index: 1,
              onTap: _conX.onItemTapped),
          _buildBottomItem(
              icon: Icons.map_outlined,
              title: 'Mapa',
              currentIndex: _conX.paginaActual,
              index: 2,
              onTap: _conX.onItemTapped),
        ],
      ),
    );
  }

  Widget _buildBottomItem({
    required String title,
    required int currentIndex,
    required int index,
    required void Function(int i) onTap,
    required IconData icon,
  }) {
    Color textColor = Color(0xFF9F9F9F);
    Color topBarColor = Colors.transparent;

    if (index == currentIndex) {
      textColor = Color(0xFF030303);
      topBarColor = akAccentColor;
    }

    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => onTap.call(index),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: 4.0,
                            width: Get.size.width * 0.17,
                            color: topBarColor,
                          ),
                          SizedBox(height: 4.0),
                          Icon(
                            icon,
                            size: akFontSize + 10.0,
                            color: textColor,
                          ),
                          SizedBox(height: 1.0),
                          AkText(
                            title,
                            style: TextStyle(
                              fontSize: akFontSize - 4.0,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 6.0),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
