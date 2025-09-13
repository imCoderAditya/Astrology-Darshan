// ignore_for_file: deprecated_member_use

import 'package:astrology/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:get/get.dart';

class CallChatConfirmationDialog {
  static void show({
    required BuildContext context,
    required String astrologerName,
    String? astrologerPhoto,
    required String type, // 'call' or 'chat'
    double? rate,
    required Function(int result) onConfirm,
    VoidCallback? onCancel,
    VoidCallback? onWalletRedirect, // Wallet redirect callback
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _ConfirmationContent(
            astrologerName: astrologerName,
            astrologerPhoto: astrologerPhoto ?? "",
            type: type,
            rate: rate ?? 0.0,
            onConfirm: onConfirm,
            onCancel: onCancel ?? () => Navigator.of(context).pop(),
            onWalletRedirect: onWalletRedirect,
          ),
        );
      },
    );
  }
}

class _ConfirmationContent extends StatefulWidget {
  final String astrologerName;
  final String astrologerPhoto;
  final String type;
  final double rate;
  final Function(int result) onConfirm;
  final VoidCallback onCancel;
  final VoidCallback? onWalletRedirect;

  const _ConfirmationContent({
    required this.astrologerName,
    required this.astrologerPhoto,
    required this.type,
    required this.rate,
    required this.onConfirm,
    required this.onCancel,
    this.onWalletRedirect,
  });

  @override
  State<_ConfirmationContent> createState() => _ConfirmationContentState();
}

class _ConfirmationContentState extends State<_ConfirmationContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get isCall => widget.type.toLowerCase() == 'call';
  bool get isChat => widget.type.toLowerCase() == 'chat';

  // Calculate maximum talk time based on wallet balance
  double get maxTalkTimeInMinutes {
    final walletBalance =
        double.tryParse(
          profileController.profileModel.value?.data?.walletBalance
                  .toString() ??
              "0",
        ) ??
        0.0;

    if (widget.rate <= 0) return 0.0;
    return walletBalance / widget.rate;
  }

  // Check if user has sufficient balance for minimum 5 minutes call
  bool get hasSufficientBalance {
    if (isChat) return maxTalkTimeInMinutes > 0;
    return maxTalkTimeInMinutes >= 5.0;
  }

  // Calculate minimum required amount for 5 minutes
  double get minimumRequiredAmount {
    return widget.rate * 5.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildContent(),
                if (!hasSufficientBalance) _buildInsufficientBalanceWarning(),
                if (!hasSufficientBalance) SizedBox(height: 20.h),
                _buildButtons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.headerGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Column(
        children: [
          Icon(
            isCall ? Icons.call : Icons.chat,
            color: Colors.white,
            size: 32.w,
          ),
          SizedBox(height: 8.h),
          Text(
            isCall ? 'Start Call?' : 'Start Chat?',
            style: AppTextStyles.headlineMedium().copyWith(
              color: Colors.white,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final walletBalance =
        double.tryParse(
          profileController.profileModel.value?.data?.walletBalance
                  .toString() ??
              "0",
        ) ??
        0.0;

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Astrologer Info
          Row(
            children: [
              _buildAvatar(),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.astrologerName,
                      style: AppTextStyles.headlineMedium().copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: AppColors.sucessPrimary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Online',
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.sucessPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Rate Info
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.currency_rupee,
                      color: AppColors.primaryColor,
                      size: 18.w,
                    ),
                    Text(
                      widget.rate.toStringAsFixed(0),
                      style: AppTextStyles.headlineLarge().copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 20.sp,
                      ),
                    ),
                    Text(
                       '/min',
                      style: AppTextStyles.body().copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                'Minimum 5 minutes consultation',
                 
                  style: AppTextStyles.caption(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Balance and Total Time Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color:
                  hasSufficientBalance
                      ? AppColors.sucessPrimary.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color:
                    hasSufficientBalance
                        ? AppColors.sucessPrimary.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Wallet Balance:', style: AppTextStyles.body()),
                    Row(
                      children: [
                        Icon(
                          Icons.currency_rupee,
                          size: 14.w,
                          color: AppColors.primaryColor,
                        ),
                        Text(
                          walletBalance.toStringAsFixed(0),
                          style: AppTextStyles.headlineMedium().copyWith(
                            fontSize: 14.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (hasSufficientBalance && isCall) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sucessPrimary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: AppColors.sucessPrimary,
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Total Talk Time:',
                              style: AppTextStyles.body().copyWith(
                                color: AppColors.sucessPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${maxTalkTimeInMinutes.floor()}/m",
                          style: AppTextStyles.headlineLarge().copyWith(
                            fontSize: 16.sp,
                            color: AppColors.sucessPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (hasSufficientBalance && isChat) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 12.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sucessPrimary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble,
                              color: AppColors.sucessPrimary,
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Available Minutes:',
                              style: AppTextStyles.body().copyWith(
                                color: AppColors.sucessPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${maxTalkTimeInMinutes.floor()}/m',
                          style: AppTextStyles.headlineLarge().copyWith(
                            fontSize: 16.sp,
                            color: AppColors.sucessPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsufficientBalanceWarning() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20.w),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Insufficient Balance!',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color: Colors.red,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            isCall
                ? 'You need minimum ₹${minimumRequiredAmount.toStringAsFixed(0)} for 5 minutes consultation. Please recharge your wallet.'
                : 'You need sufficient balance to start chatting. Please recharge your wallet.',
            style: AppTextStyles.caption().copyWith(color: Colors.red[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: AppColors.headerGradientColors),
      ),
      child:
          widget.astrologerPhoto.isNotEmpty
              ? ClipOval(
                child: Image.network(
                  widget.astrologerPhoto,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.person, color: Colors.white, size: 24.w);
                  },
                ),
              )
              : Icon(Icons.person, color: Colors.white, size: 24.w),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.w),
      child: Row(
        children: [
          // Cancel Button
          Expanded(
            child: OutlinedButton(
              onPressed: widget.onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[600],
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'Cancel',
                style: AppTextStyles.button.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Confirm Button or Recharge Button
          Expanded(
            child: ElevatedButton(
              onPressed:
                  hasSufficientBalance
                      ?()=> widget.onConfirm(maxTalkTimeInMinutes.floor())
                      : () {
                        Get.back();
                        widget.onWalletRedirect?.call();
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    hasSufficientBalance
                        ? AppColors.primaryColor
                        : Colors.orange,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasSufficientBalance
                        ? (isCall ? Icons.call : Icons.chat)
                        : Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 16.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    hasSufficientBalance
                        ? (isCall ? 'Call Now' : 'Chat Now')
                        : 'Recharge Wallet',
                    style: AppTextStyles.button.copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
