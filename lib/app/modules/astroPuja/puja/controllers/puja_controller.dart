import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/data/models/puja/puja_category_model.dart';
import 'package:astrology/app/data/models/puja/puja_services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaController extends GetxController {
  Rxn<PujaCategoryModel> pujaCategoryModel = Rxn<PujaCategoryModel>();
  Rxn<PujaServiceModel> pujaServiceModel = Rxn<PujaServiceModel>();
  RxList<PujaService> pujaServicesList = RxList<PujaService>([]);
  TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;

  final RxInt _currentPage = 1.obs;
  final RxInt selectIndex = 0.obs;
  final RxInt _limit = 10.obs;
  String? categoryId;
  final RxString query = "".obs;
  final ScrollController scrollController = ScrollController();

  Future<void> pujaCategoryAPI() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(api: EndPoint.pujaCategories);

      if (res != null && res.statusCode == 200) {
        pujaCategoryModel.value = pujaCategoryModelFromJson(
          json.encode(res.data),
        );
        categoryId =
            pujaCategoryModel.value?.pujaCategory?.firstOrNull?.pujaCategoryId
                .toString() ??
            "";
        pujaServicesAPI();
      } else {
        LoggerUtils.error('Failed Response : ${res?.data}');
      }
    } catch (e) {
      LoggerUtils.error('Error : $e');
    } finally {
      isLoading.value = false;

      update();
    }
  }

  Future<void> pujaServicesAPI() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.pujaServices}?search=$query&categoryId=$categoryId&page=$_currentPage&limit=$_limit",
      );

      if (res != null && res.statusCode == 200) {
        pujaServiceModel.value = pujaServiceModelFromJson(
          json.encode(res.data),
        );
        pujaServicesList.addAll(pujaServiceModel.value?.pujaService ?? []);
      } else {
        LoggerUtils.error('Failed Response : ${res?.data}');
      }
    } catch (e) {
      LoggerUtils.error('Error : $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  setSelectIndex({required int index, String? id}) async {
    selectIndex.value = index;
    categoryId = id;
    pujaServicesList.clear();
    searchController.clear();
    query.value="";
    pujaServicesAPI();
  }

  @override
  void onInit() {
    pujaServicesList.clear();
    pujaCategoryAPI();
    scrollController.addListener(_onScroll); // For pagination
    super.onInit();
  }

  void _onScroll() {
    debugPrint("_currentPage $_currentPage");
    debugPrint(_currentPage.toString());

    final totalPages = pujaServiceModel.value?.totalCount;
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 && // added buffer
        !isLoading.value &&
        _currentPage < (totalPages ?? 0)) {
      loadMoreTransaction();
    }
  }

  void loadMoreTransaction() {
    final lastPage = pujaServiceModel.value?.page ?? 0;
    final totalRecords = pujaServiceModel.value?.totalCount ?? 0;
    if (_currentPage < lastPage &&
        !isLoading.value &&
        (pujaServiceModel.value?.pujaService?.length ?? 0) < totalRecords) {
      _currentPage.value++;
      pujaServicesAPI();
      update();
    }
  }
}
