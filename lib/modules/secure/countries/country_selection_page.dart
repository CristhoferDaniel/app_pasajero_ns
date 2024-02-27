import 'package:animate_do/animate_do.dart';
import 'package:app_pasajero_ns/data/models/app_type.dart';
import 'package:app_pasajero_ns/modules/app_prefs/app_prefs_controller.dart';
import 'package:app_pasajero_ns/modules/secure/countries/country_selection_controller.dart';
import 'package:app_pasajero_ns/themes/ak_ui.dart';
import 'package:app_pasajero_ns/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';

class CountrySelectionPage extends StatelessWidget {
  final _conX = Get.put(CountrySelectionController());
  final _appX = Get.find<AppPrefsController>();

  @override
  Widget build(BuildContext context) {
    final dfTitleStyle = TextStyle(
      color: akTitleColor,
      fontSize: akFontSize + 10.0,
      fontWeight: FontWeight.w500,
    );

    final toolbarHeight = 130.0;

    return WillPopScope(
      onWillPop: () async => await _conX.handleBack(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 130.0,
          flexibleSpace: FlexibleSpaceBar(
            background: WaveSliverBg(toolbarHeight: toolbarHeight),
            titlePadding: EdgeInsetsDirectional.only(
              bottom: akContentPadding,
            ),
            centerTitle: false,
            // title: Text('Mis datos', textScaleFactor: 1),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SafeArea(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5, left: 5),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/back.svg',
                            width: akFontSize + 3.0,
                            color: akTitleColor,
                          ),
                          onPressed: () async {
                            if (await _conX.handleBack()) Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.0),
                Flexible(
                  child: FadeInDown(
                    delay: Duration(milliseconds: 100),
                    duration: Duration(milliseconds: 100),
                    from: 10,
                    child: Content(
                      child: AkText(
                        'País',
                        style: dfTitleStyle,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Content(
                  child: FadeIn(
                    delay: Duration(milliseconds: 100),
                    duration: Duration(milliseconds: 100),
                    child: AkText(
                      'Selecciona el país del celular',
                      style: TextStyle(
                        color: _appX.type == AppType.passenger
                            ? akTitleColor
                            : akTextColor,
                        fontWeight: FontWeight.normal,
                        fontSize: akFontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: akContentPadding * 0.5),
            _buildSearchInput(),
            _buildCountries(),
          ],
        ),
      ),
    );
  }

  Widget _buildCountries() {
    return Expanded(
      child: GetBuilder<CountrySelectionController>(
        id: 'gbList',
        builder: (_) => GroupedListView<dynamic, String>(
          physics: BouncingScrollPhysics(),
          elements: _conX.filtered,
          groupBy: (element) => element['group'],
          sort: false,
          itemBuilder: (c, element) {
            String codeCountry = element['code'].toString().toLowerCase();
            Widget flag = SvgPicture.asset('assets/flags/$codeCountry.svg');
            ListTile item = ListTile(
              contentPadding:
                  EdgeInsets.only(left: 7.0, right: 0.0, top: 3.0, bottom: 0.0),
              minLeadingWidth: 10,
              leading: Container(
                width: 30,
                child: flag,
              ),
              title: Container(
                margin: EdgeInsets.only(top: 4),
                child:
                    Text(element['name'] + ' (' + element['dial_code'] + ')'),
              ),
              trailing: element['selected'] == 'true'
                  ? Icon(
                      Icons.check_circle_sharp,
                      color: Color(0xFF43C589),
                      size: 26,
                    )
                  : Icon(
                      Icons.circle_outlined,
                      color: akTextColor.withOpacity(0.25),
                      size: 26,
                    ),
            );

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _conX.sendResponse(element['code'], element['dial_code']);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: akContentPadding,
                      vertical: akContentPadding - 12),
                  child: item,
                ),
              ),
            );
          },
          groupSeparatorBuilder: (value) {
            if (value == '_main') {
              return SizedBox();
            } else {
              return Container(
                  margin: EdgeInsets.only(
                    top: akContentPadding + 10,
                    left: akContentPadding + 7,
                    bottom: akContentPadding - 7,
                  ),
                  child: AkText(
                    'Otros países',
                  ));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: akContentPadding),
      child: AkInput(
        filledColor: Colors.transparent,
        type: AkInputType.underline,
        hintText: 'Buscar un país',
        // validator: _loginX.validatePassword,
        labelColor: akTextColor.withOpacity(0.35),
        // onSaved: (text) => _loginX.password = text!.trim(),
        textInputAction: TextInputAction.done,
        onChanged: _conX.onSearchChange,
        suffixIcon: Icon(Icons.search_outlined),
        onFieldCleaned: () => _conX.onSearchChange(''),
        // onFieldSubmitted: (text) => _loginX.onIngresar(),
      ),
    );
  }
}
