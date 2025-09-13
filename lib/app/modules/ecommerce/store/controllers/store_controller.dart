import 'dart:convert';

import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/models/ecommerce/category_model.dart';
import 'package:astrology/app/data/models/ecommerce/product_model.dart';
import 'package:astrology/app/data/repositories/ecommerce/ecommerce_repositories.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  var isLoading = false.obs;
  var selectedCategoryId = -1.obs;
  final RxInt _currentPage = 1.obs;
  final RxInt _limit = 10.obs;
  RxString searchQuery = RxString("");
final  TextEditingController searchController = TextEditingController();

  EcommerceRepository ecommerceRepository = EcommerceRepository();

  final Rxn<CategoryEcModel> _categoryEcModel = Rxn<CategoryEcModel>();
  Rxn<CategoryEcModel> get categoryEcModel => _categoryEcModel;

  final Rxn<ProductEcModel> _productEcModel = Rxn<ProductEcModel>();
  Rxn<ProductEcModel> get productEcModel => _productEcModel;

  final RxList<Product> _productList = RxList<Product>([]);
  RxList<Product> get productList => _productList;

  ScrollController scrollController = ScrollController();
  void onCategorySelected(CategoryEc? category) {
    if (category != null) {
      _productList.clear();
      searchController.clear();
      selectedCategoryId = category.categoryId ?? 0;
      fetchProduct();
      update();
    }
  }

  @override
  void onInit() {
    fetchCategory();
    scrollController.addListener(_onScroll);
    super.onInit();
  }





  Future<void> fetchCategory() async {
    isLoading.value = true;
    try {
      final res = await ecommerceRepository.getCategory();
      if (res != null) {
        _categoryEcModel.value = categoryEcModelFromJson(json.encode(res.data));
        selectedCategoryId= _categoryEcModel.value?.categoryEc?.firstOrNull?.categoryId?? 0;
       await fetchProduct();
      } else {
        LoggerUtils.warning(
          "Fetch Category Data Failed ${res.data}",
          tag: "StoreController",
        );
      }
    } catch (e) {
      LoggerUtils.error("Error $e", tag: "StoreController");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProduct() async {
    isLoading.value = true;
    try {
      final res = await ecommerceRepository.getProductByCategoryId(
        categoryId: selectedCategoryId,
        page: _currentPage.value,
        limit: _limit.value,
        search: searchQuery.value,
      );
      if (res != null) {
        _productEcModel.value = productEcModelFromJson(json.encode(res.data));
        _productList.addAll(_productEcModel.value?.data?.products ?? []);
      } else {
        LoggerUtils.warning(
          "Fetch Product Data Failed ${res.data}",
          tag: "StoreController",
        );
      }
      
    } catch (e) {
      LoggerUtils.error("Error $e", tag: "StoreController");
    } finally {
      isLoading.value = false;
    }
  }

  void _onScroll() {
    debugPrint("_currentPage $_currentPage");
    debugPrint(_currentPage.toString());

    final totalPages = productEcModel.value?.data?.pagination?.totalPages;
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 && // added buffer
        !isLoading.value &&
        _currentPage < (totalPages ?? 0)) {
      loadMoreTransaction();
    }
  }

  void loadMoreTransaction() {
    final lastPage = productEcModel.value?.data?.pagination?.totalPages ?? 0;
    final totalRecords =
        productEcModel.value?.data?.pagination?.totalItems ?? 0;
    if (_currentPage < lastPage &&
        !isLoading.value &&
        productList.length < totalRecords) {
      _currentPage.value++;
      fetchProduct();
      update();
    }
  }


}
