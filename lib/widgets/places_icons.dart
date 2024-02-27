part of 'widgets.dart';

class PlacesIcons extends StatelessWidget {
  final String placeType;

  const PlacesIcons({required this.placeType});

  Widget _getIcon() {
    Widget _baseIcon = Icon(Icons.location_on_outlined);
    try {
      String? iconPath = _getPathIcon(this.placeType);
      if (iconPath != null) {
        Widget _customIcon = SvgPicture.asset(iconPath);
        _baseIcon = SizedBox(
          height: 22.0,
          width: 22.0,
          child: _customIcon,
        );
      }
    } catch (e) {}
    return _baseIcon;
  }

  @override
  Widget build(BuildContext context) {
    // return _getIcon();
    return _SafeBuilderPlaceIcon(
      builder: (_) {
        return _getIcon();
      },
    );
  }

  String? _getPathIcon(String type) {
    final basePath = 'assets/places3/';
    String icon = '';
    Map<String, String> matrixIcons = {
      // 'accounting': '',
      'airport': 'airport',
      'amusement_park': 'amusement_park',
      // 'aquarium': '',
      // 'art_gallery': '',
      // 'atm': '',
      // 'bakery': '',
      'bank': 'bank',
      'bar': 'bar',
      // 'beauty_salon': '',
      'bicycle_store': 'bicycle_store',
      // 'book_store': '',
      // 'bowling_alley': '',
      'bus_station': 'bus_station',
      'cafe': 'cafe',
      // 'campground': '',
      // 'car_dealer': '',
      // 'car_rental': '',
      // 'car_repair': '',
      // 'car_wash': '',
      // 'casino': '',
      'cemetery': 'cemetery',
      'church': 'church',
      'city_hall': 'city_hall',
      'clothing_store': 'clothing_store',
      'convenience_store': 'convenience_store',
      // 'courthouse': '',
      // 'dentist': '',
      'department_store': 'department_store',
      'doctor': 'doctor',
      // 'drugstore': '',
      // 'electrician': '',
      // 'electronics_store': '',
      'embassy': 'embassy',
      'fire_station': 'fire_station',
      // 'florist': '',
      'funeral_home': 'funeral_home',
      'furniture_store': 'furniture_store',
      'gas_station': 'gas_station',
      // 'gym': '',
      // 'hair_care': '',
      // 'hardware_store': '',
      // 'hindu_temple': '',
      // 'home_goods_store': '',
      'hospital': 'hospital',
      // 'insurance_agency': '',
      'jewelry_store': 'jewelry_store',
      // 'laundry': '',
      // 'lawyer': '',

      'library': 'library',

      /* 'light_rail_station': '',
      'liquor_store': '',
      'local_government_office': '',
      'locksmith': '',
      'lodging': '',
      'meal_delivery': '',
      'meal_takeaway': '',
      'mosque': '',
      'movie_rental': '',
      'movie_theater': '',
      'moving_company': '',
      'museum': '',
      'night_club': '',
      'painter': '',
      'park': '',
      'parking': '',
      'pet_store': '',
      'pharmacy': '',
      'physiotherapist': '',
      'plumber': '',
      'police': '',
      'post_office': '',
      'primary_school': '',
      'real_estate_agency': '',
      'restaurant': '',
      'roofing_contractor': '',
      'rv_park': '',
      'school': '',
      'secondary_school': '',
      'shoe_store': '',
      'shopping_mall': '',
      'spa': '',
      'stadium': '',
      'storage': '',
      'store': '',
      'subway_station': '',
      'supermarket': '',
      'synagogue': '',
      'taxi_stand': '',
      'tourist_attraction': '',
      'train_station': '',
      'transit_station': '',
      'travel_agency': '',
      'university': '',
      'veterinary_care': '',
      'zoo': '', */
    };

    matrixIcons.containsKey(type);

    if (matrixIcons.containsKey(type)) {
      icon = matrixIcons[type]!;
      return '$basePath$icon.svg';
    }
  }
}

class _SafeBuilderPlaceIcon extends StatelessWidget {
  _SafeBuilderPlaceIcon({
    Key? key,
    this.builder,
  }) : super(key: key);
  final WidgetBuilder? builder;
  @override
  Widget build(BuildContext context) {
    try {
      if (this.builder != null) {
        return builder!(context);
      } else {
        return SizedBox();
      }
    } catch (error) {
      return SizedBox();
    }
  }
}
