import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';

class RazorpayService {
  late Razorpay _razorpay;
  String? _orderId;
  // Callbacks
  final Function(PaymentSuccessResponse)? onPaymentSuccess;
  final Function(PaymentFailureResponse)? onPaymentError;
  final Function(ExternalWalletResponse)? onExternalWallet;

  RazorpayService({
    this.showSuccessPopup = true,
    this.showErrorPopup = true,
    this.showWalletPopup = true,
    this.onSuccessButtonPressed,
    this.onErrorButtonPressed,
    this.onWalletButtonPressed,
    this.onPaymentSuccess,
    this.onPaymentError,
    this.onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // Control popup visibility
  final bool showSuccessPopup;
  final bool showErrorPopup;
  final bool showWalletPopup;

  // Custom button callbacks
  final VoidCallback? onSuccessButtonPressed;
  final VoidCallback? onErrorButtonPressed;
  final VoidCallback? onWalletButtonPressed;

  void openCheckout({
    required String key,
    required int amount, // Amount in paise (e.g., 100 = ₹1.00)
    required String name,
    required String description,
    String? orderId,
    String? customerName,
    String? customerEmail,
    String? customerContact,
    String? currency = 'INR',
    List<String>? externalWallets,
  }) {
    var options = {
      'key': key,
      'amount': amount,
      'name': name,
      'description': description,
      'currency': currency,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': customerContact ?? '',
        'email': customerEmail ?? '',
        'name': customerName ?? '',
      },
      'external': {
        'wallets': externalWallets ?? ['paytm'],
      },
    };

    if (orderId != null) {
      options['order_id'] = orderId;
      _orderId = orderId;
    }

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      Get.snackbar(
        'Error',
        'Failed to open payment gateway',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   debugPrint('Payment Success: ${response.paymentId}');
  //   debugPrint('Order ID: ${response.orderId}');
  //   debugPrint('Signature: ${response.signature}');

  //   if (showSuccessPopup) {
  //     _showPaymentDialog(
  //       onButtonPressed: onSuccessButtonPressed,
  //       icon: Icons.check_circle,
  //       iconColor: AppColors.green,
  //       title: 'Payment Successful',
  //       message: 'Your payment has been processed successfully',
  //       details: [
  //         {'label': 'Payment ID', 'value': response.paymentId ?? 'N/A'},
  //         {'label': 'Order ID', 'value': _orderId ?? 'N/A'},
  //       ],
  //     );
  //   }

  //   if (onPaymentSuccess != null) {
  //     onPaymentSuccess!(response);
  //   }
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   debugPrint('Payment Error: ${response.code} - ${response.message}');
  //   debugPrint('Error metadata: ${response.error}');

  //   if (showErrorPopup) {
  //     _showPaymentDialog(
  //       onButtonPressed: onErrorButtonPressed,
  //       icon: Icons.error,
  //       iconColor: AppColors.red,
  //       title: 'Payment Failed',
  //       message: response.message ?? 'Something went wrong',
  //       details: [
  //         {'label': 'Error Code', 'value': response.code?.toString() ?? 'N/A'},
  //         if (response.error != null)
  //           {'label': 'Details', 'value': response.message ?? ""},
  //       ],
  //     );
  //   }

  //   if (onPaymentError != null) {
  //     onPaymentError!(response);
  //   }
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   debugPrint('External Wallet Selected: ${response.walletName}');

  //   if (showWalletPopup) {
  //     _showPaymentDialog(
  //       onButtonPressed: onWalletButtonPressed,
  //       icon: Icons.account_balance_wallet,
  //       iconColor: AppColors.accentColor,
  //       title: 'External Wallet',
  //       message: 'Payment redirected to external wallet',
  //       details: [
  //         {'label': 'Wallet', 'value': response.walletName ?? 'N/A'},
  //       ],
  //     );
  //   }

  //   if (onExternalWallet != null) {
  //     onExternalWallet!(response);
  //   }
  // }

  // Usage in your RazorpayService:
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Payment Success: ${response.paymentId}');
    debugPrint('Order ID: ${response.orderId}');
    debugPrint('Signature: ${response.signature}');

    if (showSuccessPopup) {
      Get.off(
        () => PaymentStatusPage(
          isSuccess: true,
          title: 'Payment Successful!',
          message: 'Your payment has been processed successfully',
          details: [
            {'label': 'Payment ID', 'value': response.paymentId ?? 'N/A'},
            {'label': 'Order ID', 'value': _orderId ?? 'N/A'},
            {'label': 'Date', 'value': DateTime.now().toString().split('.')[0]},
          ],
          onButtonPressed: onSuccessButtonPressed,
        ),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    }

    if (onPaymentSuccess != null) {
      onPaymentSuccess!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    debugPrint('Error metadata: ${response.error}');

    if (showErrorPopup) {
      Get.off(
        () => PaymentStatusPage(
          isSuccess: false,
          title: 'Payment Failed',
          message: response.message ?? 'Something went wrong with your payment',
          details: [
            {
              'label': 'Error Code',
              'value': response.code?.toString() ?? 'N/A',
            },
            if (response.error != null)
              {
                'label': 'Details',
                'value': response.message ?? 'Unknown error',
              },
            {'label': 'Date', 'value': DateTime.now().toString().split('.')[0]},
          ],
          onButtonPressed: onErrorButtonPressed,
        ),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    }

    if (onPaymentError != null) {
      onPaymentError!(response);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet Selected: ${response.walletName}');

    if (showWalletPopup) {
      Get.off(
        () => PaymentStatusPage(
          isSuccess: true,
          title: 'Redirected to Wallet',
          message: 'Payment redirected to external wallet',
          details: [
            {'label': 'Wallet', 'value': response.walletName ?? 'N/A'},
            {'label': 'Date', 'value': DateTime.now().toString().split('.')[0]},
          ],
          onButtonPressed: onWalletButtonPressed,
        ),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 300),
      );
    }

    if (onExternalWallet != null) {
      onExternalWallet!(response);
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}

class PaymentStatusPage extends StatefulWidget {
  final bool isSuccess;
  final String title;
  final String message;
  final List<Map<String, String>> details;
  final VoidCallback? onButtonPressed;

  const PaymentStatusPage({
    Key? key,
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.details,
    this.onButtonPressed,
  }) : super(key: key);

  @override
  State<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = widget.isSuccess ? AppColors.green : AppColors.red;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 60.h),

                  // Animated Icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            statusColor.withOpacity(0.2),
                            statusColor.withOpacity(0.05),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: statusColor.withOpacity(0.3),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.isSuccess
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 70.sp,
                        color: statusColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      widget.title,
                      style: AppTextStyles.headlineMedium().copyWith(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Message
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      widget.message,
                      style: AppTextStyles.body().copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Details Card
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: statusColor.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.receipt_long_rounded,
                                  size: 20.sp,
                                  color: statusColor,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Transaction Details',
                                  style: AppTextStyles.body().copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            ...widget.details.asMap().entries.map((entry) {
                              final isLast =
                                  entry.key == widget.details.length - 1;
                              final detail = entry.value;
                              return Column(
                                children: [
                                  _buildDetailRow(
                                    label: detail['label']!,
                                    value: detail['value']!,
                                    isDark: isDark,
                                  ),
                                  if (!isLast) ...[
                                    SizedBox(height: 12.h),
                                    Divider(
                                      color:
                                          isDark
                                              ? Colors.grey[800]
                                              : Colors.grey[300],
                                      height: 1,
                                    ),
                                    SizedBox(height: 12.h),
                                  ],
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Status Badge
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: statusColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isSuccess
                                ? Icons.verified_rounded
                                : Icons.error_outline_rounded,
                            size: 16.sp,
                            color: statusColor,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            widget.isSuccess
                                ? 'Payment Verified'
                                : 'Payment Failed',
                            style: AppTextStyles.caption().copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 60.h),

                  // Action Buttons
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Primary Button
                        SizedBox(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {
                              if (widget.onButtonPressed != null) {
                                widget.onButtonPressed!();
                              } else {
                                Get.back();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: statusColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              widget.isSuccess ? 'Continue' : 'Next',
                              style: AppTextStyles.button.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // if (!widget.isSuccess) ...[
                        //   SizedBox(height: 12.h),
                        //   // Secondary Button
                        //   SizedBox(
                        //     width: double.infinity,
                        //     height: 56.h,
                        //     child: OutlinedButton(
                        //       onPressed: () {
                        //         Get.back();
                        //       },
                        //       style: OutlinedButton.styleFrom(
                        //         foregroundColor: isDark ? Colors.white : Colors.black,
                        //         side: BorderSide(
                        //           color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                        //           width: 1.5,
                        //         ),
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(16.r),
                        //         ),
                        //       ),
                        //       child: Text(
                        //         'Cancel',
                        //         style: AppTextStyles.button.copyWith(
                        //           fontSize: 16.sp,
                        //           fontWeight: FontWeight.w600,

                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ],
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body().copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 14.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body().copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
