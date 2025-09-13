import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';

abstract class EcommerceRepositories {
  Future<dynamic> getCategory();
  Future<dynamic> getProductByCategoryId();
}

class EcommerceRepository extends EcommerceRepositories {
  @override
  Future getCategory() async {
    try {
      final res = await BaseClient.get(api: EndPoint.category);
      if (res != null && res.statusCode == 200) {
      
        return res;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("Category Error: $e", tag: "EcommerceRepository");
    }
  }

  @override
  Future getProductByCategoryId({
    int? categoryId,
    String? search,
    int? page,
    int? limit,
  }) async {
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.product}?categoryId=$categoryId&search=$search&page=$page&limit=$limit",
      );
      if (res != null && res.statusCode == 200) {
       
        return res;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("Product Error: $e", tag: "EcommerceRepository");
    }
  }
}
