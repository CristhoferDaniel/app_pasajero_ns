import 'package:app_pasajero_ns/data/models/site.dart';
import 'package:app_pasajero_ns/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';

class SiteProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/site';

  Future<SitePaginatedResponse> getSitesPaginated(
    int page,
    int limit, {
    CancelToken? cancelToken,
  }) async {
    final resp = await _dioClient.get('$_endpoint',
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: cancelToken);
    return SitePaginatedResponse.fromJson(resp);
  }
}
