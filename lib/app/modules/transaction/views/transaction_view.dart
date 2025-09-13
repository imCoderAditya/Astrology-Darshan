// ignore_for_file: deprecated_member_use

import 'package:astrology/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionView extends StatefulWidget {
  final Map<String, dynamic>? orderData;

  const TransactionView({super.key, this.orderData});

  @override
  State<TransactionView> createState() => _TransactionSuccessScreenState();
}

class _TransactionSuccessScreenState extends State<TransactionView>
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
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background = isDark ? Colors.black : Colors.white;
    final Color cardColor =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
    final Color textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Icon
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 80,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      widget.orderData?['message'] ??
                          "Order Placed Successfully!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Thank you for your purchase. We'll send you an email confirmation shortly.",
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Animated Details Card
                    SlideTransition(
                      position: _slideAnimation,
                      child: Card(
                        color: cardColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                'Order ID',
                                '#${widget.orderData?['orderId'] ?? 'N/A'}',
                                textColor,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                'Total Amount',
                                '₹${(widget.orderData?['TotalAmount'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
                                textColor,
                              ),
                              const Divider(height: 24),
                              _buildDetailRow(
                                'Payment Status',
                                widget.orderData?['PaymentStatus'] ?? 'N/A',
                                Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Animated Action Button
                    SlideTransition(
                      position: _slideAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offNamed(Routes.NAV);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continue Shopping',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'View Order Details',
                        style: TextStyle(
                          color: textColor.withOpacity(0.6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
