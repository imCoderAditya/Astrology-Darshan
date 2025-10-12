// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/data/models/address/address_model.dart';
import 'package:astrology/app/data/models/ecommerce/cart_model.dart';
import 'package:astrology/app/modules/ecommerce/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/summary_controller.dart';

class SummaryView extends GetView<SummaryController> {
  final AddressDatum? addressEcModel;

  const SummaryView({super.key, this.addressEcModel});

  @override
  Widget build(BuildContext context) {
    // log("AddressModel: ${json.encode(addressEcModel)}");

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color dividerColor =
        isDark ? AppColors.darkDivider : AppColors.lightDivider;
    Get.put(SummaryController());
    return GetBuilder<SummaryController>(
      // init: SummaryController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16.0),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.headerGradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Icon(
                          Icons.receipt_long,
                          size: 32,
                          color: AppColors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Order Summary",
                          style: AppTextStyles.headlineMedium().copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  if (addressEcModel != null) ...[
                    _buildSectionTitle("Delivery Address", textColor),
                    _buildAddressCard(
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      isDark,
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildSectionTitle("Order Items", textColor),
                  Obx(
                    () => _buildOrderItemsCard(
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      isDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Price Details", textColor),
                  Obx(
                    () => _buildPriceBreakdownCard(
                      cardColor,
                      textColor,
                      secondaryTextColor,
                      dividerColor,
                      isDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Payment Method", textColor),
                  _buildPaymentMethodSelection(
                    cardColor,
                    textColor,
                    secondaryTextColor,
                    isDark,
                  ),
                  const SizedBox(height: 30),
                  Obx(() => _buildPlaceOrderButton(isDark)),
                  const SizedBox(height: 40),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Text(
        title,
        style: AppTextStyles.headlineMedium().copyWith(letterSpacing: 1.0),
      ),
    );
  }

  Widget _buildAddressCard(
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
  ) {
    // Check if the address model and its data are available
    final addressData = addressEcModel?.address;

    if (addressData == null) {
      return const SizedBox.shrink(); // Hide the card if no address data
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: cardColor,
        elevation: isDark ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "${addressData.firstName ?? ''} ${addressData.lastName ?? ''}",
                      style: AppTextStyles.subtitle(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.snackbar(
                        "Address",
                        "Change address functionality",
                        backgroundColor: AppColors.primaryColor,
                        colorText: AppColors.white,
                      );
                    },
                    child: Text(
                      "Change",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "${addressData.house ?? ''}, ${addressData.gali ?? ''}\n"
                "${addressData.city ?? ''}, ${addressData.state ?? ''}, ${addressData.postalCode ?? ''}\n"
                "${addressData.country ?? ''}",
                style: AppTextStyles.body().copyWith(height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.phone, color: AppColors.accentColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    addressData.phoneNumber ?? 'N/A',
                    style: AppTextStyles.body(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItemsCard(
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
  ) {
    final controller = Get.find<CartController>();
    final cartItems = controller.cartEcModel.value?.data?.cartItems ?? [];

    if (cartItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          color: cardColor,
          elevation: isDark ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 48,
                  color: secondaryTextColor,
                ),
                const SizedBox(height: 16),
                Text("No items in cart", style: AppTextStyles.subtitle()),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: cardColor,
        elevation: isDark ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children:
                cartItems
                    .map(
                      (item) => _buildCartItemTile(
                        item,
                        textColor,
                        secondaryTextColor,
                        isDark,
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItemTile(
    CartItem item,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  item.productImage != null
                      ? Image.network(
                        item.productImage!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.image_not_supported,
                              color: AppColors.primaryColor,
                            ),
                      )
                      : Icon(Icons.shopping_bag, color: AppColors.primaryColor),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName ?? "",
                  style: AppTextStyles.subtitle(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "Qty: ${item.quantity ?? 0}",
                      style: AppTextStyles.caption(),
                    ),
                    const SizedBox(width: 16),
                    if (item.isInStock == false)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Out of Stock",
                          style: AppTextStyles.small().copyWith(
                            color: AppColors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${item.totalPrice?.toStringAsFixed(2) ?? '0.00'}",
                style: AppTextStyles.subtitle().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if ((item.price ?? 0) > 0)
                Text(
                  "₹${item.price?.toStringAsFixed(2)}/each",
                  style: AppTextStyles.small(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdownCard(
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    Color dividerColor,
    bool isDark,
  ) {
    final controller = Get.find<CartController>();
    final summary = controller.cartEcModel.value?.data?.summary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: cardColor,
        elevation: isDark ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildPriceRow(
                "Subtotal",
                "₹${summary?.subtotal?.toStringAsFixed(2) ?? '0.00'}",
                textColor,
                secondaryTextColor,
              ),
              const SizedBox(height: 12),
              _buildPriceRow(
                "Shipping",
                "₹${summary?.shipping?.toStringAsFixed(2) ?? '0.00'}",
                textColor,
                secondaryTextColor,
              ),
              const SizedBox(height: 12),
              _buildPriceRow("Tax", "₹0.00", textColor, secondaryTextColor),
              const SizedBox(height: 16),
              Divider(color: dividerColor, thickness: 1),
              const SizedBox(height: 16),
              _buildPriceRow(
                "Total Amount",
                "₹${summary?.total?.toStringAsFixed(2) ?? '0.00'}",
                textColor,
                textColor,
                isTotal: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String amount,
    Color textColor,
    Color valueColor, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              isTotal
                  ? AppTextStyles.subtitle().copyWith(
                    fontWeight: FontWeight.bold,
                  )
                  : AppTextStyles.body(),
        ),
        Text(
          amount,
          style:
              isTotal
                  ? AppTextStyles.subtitle().copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  )
                  : AppTextStyles.body(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelection(
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: cardColor,
        elevation: isDark ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Payment Method",
                style: AppTextStyles.subtitle().copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // _buildPaymentOption(
              //   'cod',
              //   "Cash on Delivery",
              //   "Pay when you receive your order",
              //   Icons.money,
              //   cardColor,
              //   textColor,
              //   secondaryTextColor,
              //   isDark,
              // ),
              const SizedBox(height: 12),
              _buildPaymentOption(
                'online',
                "Online Payment",
                "Pay now with UPI, Card, or Net Banking",
                Icons.payment,
                cardColor,
                textColor,
                secondaryTextColor,
                isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String method,
    String title,
    String subtitle,
    IconData icon,
    Color cardColor,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
  ) {
    return Obx(() {
      final summaryController = Get.find<SummaryController>();
      final isSelected =
          summaryController.selectedPaymentMethod.value == method;

      return GestureDetector(
        onTap: () {
          summaryController.selectPaymentMethod(method);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected
                      ? AppColors.primaryColor
                      : (isDark
                          ? AppColors.darkDivider
                          : AppColors.lightDivider),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.primaryColor.withOpacity(0.2)
                          : AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.subtitle().copyWith(
                        color: isSelected ? AppColors.primaryColor : textColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption().copyWith(
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.primaryColor
                            : secondaryTextColor,
                    width: 2,
                  ),
                ),
                child:
                    isSelected
                        ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                        : null,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPlaceOrderButton(bool isDark) {
    final cartController = Get.find<CartController>();
    final summaryController = Get.find<SummaryController>();
    final summary = cartController.cartEcModel.value?.data?.summary;
    final total = summary?.total ?? 0.0;
    final isCod = summaryController.selectedPaymentMethod.value == 'cod';

    final paymentText =
        isCod
            ? "Place Order - ₹${total.toStringAsFixed(2)}"
            : "Pay Now - ₹${total.toStringAsFixed(2)}";
    final paymentIcon = isCod ? Icons.shopping_cart_checkout : Icons.payment;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.accentColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (summaryController.selectedPaymentMethod.value == "cod") {
                    _showOrderConfirmationDialog();
                  } else {
                    _showOrderConfirmationDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(paymentIcon, color: AppColors.white),
                    const SizedBox(width: 12),
                    Text(paymentText, style: AppTextStyles.button),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showOrderConfirmationDialog() {
    final summaryController = Get.find<SummaryController>();
    final cartController = Get.find<CartController>();
    final summary = cartController.cartEcModel.value?.data?.summary;

    final total = summary?.total ?? 0.0;
    final isCod = summaryController.selectedPaymentMethod.value == 'cod';
    final methodText = isCod ? "Cash on Delivery" : "Online Payment";
    Get.defaultDialog(
      title: "",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.sucessPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColors.sucessPrimary,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text("Order Confirmation", style: AppTextStyles.headlineMedium()),
          const SizedBox(height: 12),
          Text(
            "Confirm your order with $methodText?",
            style: AppTextStyles.body(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.placeOrderAPI(
                      address: addressEcModel,
                      amount: total.toString(),
                    );
                    // String txnId =
                    //     "megaone${DateTime.now().millisecondsSinceEpoch}";
                    // final payUParam = PayUPaymentParamModel(
                    //   type: "Eccomerce",
                    //   amount: total.toString(),
                    //   productInfo: "Astro Ecommerce",
                    //   firstName:
                    //       "${address?.firstName ?? ""} ${address?.lastName ?? ""}",
                    //   email:
                    //       profileController.profileModel.value?.data?.email ??
                    //       "",
                    //   phone: address?.phoneNumber ?? "",
                    //   environment: "0",
                    //   transactionId: txnId,
                    //   userCredential:
                    //       ":${profileController.profileModel.value?.data?.email ?? ""}",
                    // );
                    // controller.payuController.openPayUScreen(
                    //   payUPaymentParamModel: payUParam,
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor:
          Get.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
    );
  }
}
