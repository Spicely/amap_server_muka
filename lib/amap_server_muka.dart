// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'dart:convert';
import 'dart:io';

class AMapServerMuka {
  static String _key = '';

  static const String _baseUrl = 'https://restapi.amap.com/v3/';

  static HttpClient httpClient = HttpClient();

  static void setKey(String key) {
    _key = key;
  }

  static final Map<String, List<AMapDistrict>> _districtCache = {};

  /// 行政区域查询
  ///
  /// [cache] 是否缓存结果，默认为true
  /// 开启缓存在第一次成功后 不再请求
  /// 当获取全国数据时间非常有用
  static Future<List<AMapDistrict>> getDistrict({
    String? keywords,
    int subdistrict = 3,
    int page = 1,
    int offset = 20,
    String? extensions,
    String? filter,
    bool cache = false,
    String? cacheKey,
  }) async {
    assert(cache == true && cacheKey != null, 'cacheKey must be null when cache is true');
    if (cache && _districtCache[cacheKey] != null) {
      return _districtCache[cacheKey!]!;
    }
    final url = '${_baseUrl}config/district'
        '?key=$_key'
        '&keywords=$keywords'
        '&subdistrict=$subdistrict'
        '&page=$page'
        '&offset=$offset'
        '&extensions=$extensions'
        '&filter=$filter';

    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    dynamic res = await response.transform(utf8.decoder).join();

    List<AMapDistrict> data = (jsonDecode(res)['districts'] as List).map((e) => AMapDistrict.fromJson(e)).toList();
    if (cache) {
      _districtCache[cacheKey!] = data;
    }
    return data;
  }
}

class AMapDistrict {
  String? adCode;
  String? center;
  dynamic? cityCode;
  List<AMapDistrict>? districts;
  String? level;
  String? name;

  AMapDistrict({
    this.adCode,
    this.center,
    this.cityCode,
    this.districts,
    this.level,
    this.name,
  });

  AMapDistrict.fromJson(Map<String, dynamic> json) {
    adCode = json['adcode'];
    center = json['center'];
    cityCode = json['citycode'];
    districts = <AMapDistrict>[];
    json['districts'].forEach((v) {
      districts?.add(AMapDistrict.fromJson(v));
    });
    level = json['level'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['adcode'] = adCode;
    data['center'] = center;
    data['citycode'] = cityCode;
    data['districts'] = districts?.map((v) => v.toJson()).toList();
    data['level'] = level;
    data['name'] = name;
    return data;
  }
}
