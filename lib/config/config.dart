class Config {
  static const String APP_NAME = 'TaxiWaa';
//static const URL_API_BACKEND = 'http://178.128.158.138:8091';
  static const URL_API_BACKEND = 'http://192.168.100.11:3000';
 
  //gamanet sms
  static const URL_API_GAMANET = 'http://api2.gamanet.pe/smssend';
  static const API_CARD_GAMANET = '6580052761';
  static const API_KEY_GAMANET = 'MBZ4VLQHGCKZ';
  static const API_TOKEN_GAMANET = 'NjU4MDA1Mjc2MTpNQlo0VkxRSEdDS1o=';

  //static const String URL_API_BACKEND = 'http://192.168.1.4:3000';
  //static const String API_GOOGLE_KEY =
  //'AIzaSyCJU-_5fuUlJKtqCxlgF5RX8imXPXbcGbA';
  static const String API_GOOGLE_KEY =
      'AIzaSyDn0njgdzbg-dYVqbpr-MMFvowOJiMlpbA';

  // ID TIPOS SERVICIO
  static const int ID_TIPO_SERVICIO_REGULAR = 8;
  static const int ID_TIPO_SERVICIO_TURISTICO = 7;

  // SERVICIO DE TAXI
  static const int TIMEOUT_TOTAL_SOLICITUD = 180;
  static const int TIMEOUT_POR_CONDUCTOR = 20;

  // SMS
  // TODO: CAMBIAR POR LA CUENTA DE MAILJET SMS
  static const SMS_MAILJET_APIKEY = 'ea9a0f98648f4c69baed51f7a74bb8db';
  static const APP_COMPANY_NAME = 'TaxiGuaa';
  static const APP_SIGNATURE = '6/T788ykNAg';
  static const TEST_PHONE_NUMBERS = [
    '+51987654321',
    '+51999999999',
    '+51888888888',
    '+51777777777',
    '+51555555555'
  ];
  static const int SMS_RETRY_TIME = 3;
}
