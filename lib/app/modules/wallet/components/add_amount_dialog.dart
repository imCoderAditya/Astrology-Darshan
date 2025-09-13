// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:astrology/components/Global_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddAmountDialog extends StatelessWidget {
  final WalletController controller;

  AddAmountDialog({super.key, required this.controller});

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border:
              isDark
                  ? Border.all(color: AppColors.darkDivider, width: 0.5)
                  : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(isDark),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        _buildAmountField(isDark),
                        SizedBox(height: 24.h),
                        _buildPaymentModeSection(isDark),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildActionButtons(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.accentColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Money',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add funds to your wallet',
                  style: AppTextStyles.caption().copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap:
                () => {Get.back(), controller.selectedPaymentMode?.value = ""},
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.currency_rupee,
              size: 20,
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              'Enter Amount',
              style: AppTextStyles.body().copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color:
                isDark
                    ? AppColors.darkBackground.withOpacity(0.5)
                    : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
          ),
          child: TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextStyles.headlineMedium().copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: AppTextStyles.headlineMedium().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              prefixIcon: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '₹',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentModeSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.payment,
              size: 20,
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
            ),
            const SizedBox(width: 8),
            Text(
              'Payment Mode',
              style: AppTextStyles.body().copyWith(
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          controller.isWithdrawalLoading.value;
          return Wrap(
            spacing: 12,
            children: [
              _buildPaymentModeChip(
                label: 'UPI',
                value: 'UPI',
                icon: Icons.account_balance_wallet,
                isDark: isDark,
              ),
              _buildPaymentModeChip(
                label: 'Offline',
                value: 'OFFLINE',
                icon: Icons.store,
                isDark: isDark,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPaymentModeChip({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    final isSelected = controller.selectedPaymentMode?.value == value;

    return GestureDetector(
      onTap: () {
        controller.selectedPaymentMode?.value = value;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : (isDark ? AppColors.darkBackground : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primaryColor
                    : (isDark ? AppColors.darkDivider : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppColors.primaryColor.withOpacity(0.2)
                        : (isDark
                            ? AppColors.darkTextSecondary.withOpacity(0.1)
                            : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color:
                    isSelected
                        ? AppColors.primaryColor
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.body().copyWith(
                color:
                    isSelected
                        ? AppColors.primaryColor
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_circle, size: 16, color: AppColors.primaryColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.darkBackground.withOpacity(0.5)
                : AppColors.lightBackground,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed:
                  () => {
                    Get.back(),
                    controller.selectedPaymentMode?.value = "",
                  },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color:
                        isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  ),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTextStyles.button.copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Obx(() {
              final isLoading = controller.isWithdrawalLoading.value;
              return ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : () {
                          if (_formKey.currentState!.validate()) {
                            if (controller.selectedPaymentMode?.value == null) {
                              return;
                            } else if ((controller
                                    .selectedPaymentMode
                                    ?.isEmpty ??
                                true)) {
                              GlobalToast.showError(
                                title: "Payment method",
                                message: "Please select payment method",
                              );
                              return;
                            }
                            controller.addMoney(
                              amount: double.tryParse(_amountController.text),
                              paymentMethod:
                                  controller.selectedPaymentMode?.value,
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Add Money',
                              style: AppTextStyles.button.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
