import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/address/address_update_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';

abstract class AddressRepositories {
  Future<dynamic> fetchAddresses();
  Future<dynamic> addAddress({AddressUpdateModel addressUpdateModel});
  Future<dynamic> updateAddress({AddressUpdateModel addressUpdateModel});
  Future<dynamic> deleteAddress({required int addressId});
}

class AddressRepository extends AddressRepositories {
final userId = LocalStorageService.getUserId();

  @override
  Future addAddress({AddressUpdateModel? addressUpdateModel}) async {
    try {
      final response = await BaseClient.post(
        api: EndPoint.addAddress,
        data: addressUpdateModel?.toJson(),
      );
      if (response != null && response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("AddressRepository : Error $e");
      return null;
    }
  }

  @override
  Future deleteAddress({required int addressId}) async {
    try {
      final response = await BaseClient.post(
        api: EndPoint.deleteAddress,
        data: {"AddressId": addressId},
      );
      if (response != null && response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("AddressRepository : Error $e");
      return null;
    }
  }

  @override
  Future<dynamic> fetchAddresses() async {
    try {
    
      final response = await BaseClient.get(
        api: "${EndPoint.getAddress}?userId=$userId",
      );
      if (response != null && response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("AddressRepository : Error $e");
      return null;
    }
  }

  @override
  Future updateAddress({AddressUpdateModel? addressUpdateModel,String? addressId}) async {
    try {
      final response = await BaseClient.post(
        api: "${EndPoint.updateAddress}?id=$addressId",
        data: addressUpdateModel?.toJson(),
      );
      debugPrint("Response==>${response.data}");
      if (response != null && response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("AddressRepository : Error $e");
      return null;
    }
  }
}
