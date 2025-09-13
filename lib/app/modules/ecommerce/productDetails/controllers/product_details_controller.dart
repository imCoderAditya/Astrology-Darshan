import 'package:astrology/app/core/utils/logger_utils.dart';
import 'package:astrology/app/data/baseclient/base_client.dart';
import 'package:astrology/app/data/endpoint/end_pont.dart';
import 'package:astrology/app/routes/app_pages.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:astrology/app/data/models/ecommerce/product_model.dart';

class ProductDetailsController extends GetxController {
  final userId = LocalStorageService.getUserId();
  // Observable variables
  var isLoading = false.obs;
  var currentImageIndex = 0.obs;
  var quantity = 1.obs;
  var isFavorite = false.obs;
  var selectedImageUrl = ''.obs;

  // Product data
  Rx<Product?> product = Rx<Product?>(null);

  // Controllers
  PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();

    // Get product from arguments
    final arguments = Get.arguments;
    if (arguments != null && arguments is Product) {
      product.value = arguments;
      if (product.value?.images?.isNotEmpty ?? false) {
        selectedImageUrl.value = product.value!.images!.first.imageUrl ?? '';
      }
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Methods
  void changeImage(int index) {
    currentImageIndex.value = index;
    if (product.value?.images != null &&
        index < product.value!.images!.length) {
      selectedImageUrl.value = product.value!.images![index].imageUrl ?? '';
    }
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void incrementQuantity() {
    if (quantity.value < (product.value?.stock ?? 1)) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  Future<void> addToCart() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.addToCart,
        data: {
          "userId": userId,
          "productId": product.value?.productId,
          "quantity": quantity.value,
        },
      );
      if (res != null && res.statusCode == 200) {
        Get.toNamed(Routes.CART);
        quantity.value=1; // Reset quantity to 1 after adding to cart
      } else {
        LoggerUtils.error("Error fetching cart items", tag: "CartController");
      }
    } catch (e) {
      LoggerUtils.error("Error $e", tag: "CartController");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void buyNow() {
    if (product.value != null) {
      Get.snackbar(
        'Purchase',
        'Proceeding to checkout for ${product.value!.productName}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void shareProduct() {
    if (product.value != null) {
      Get.snackbar(
        'Share',
        'Sharing ${product.value!.productName}',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Helper methods
  String get discountPercentage {
    // Placeholder calculation - you can implement actual discount logic
    return '20%';
  }

  bool get isInStock {
    return (product.value?.stock ?? 0) > 0;
  }

  String get stockStatus {
    final stock = product.value?.stock ?? 0;
    if (stock == 0) return 'Out of Stock';
    if (stock < 5) return 'Only $stock left';
    return 'In Stock';
  }
}
