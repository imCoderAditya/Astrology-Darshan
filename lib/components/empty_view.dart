// ignore_for_file: library_private_types_in_public_api


import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Import animate_do package
import 'package:google_fonts/google_fonts.dart';

class EmptyCartView extends StatefulWidget {
  final bool? isBtnDisabled;
  final String? title;
  final String? subTitle;
  final IconData? icon;

  const EmptyCartView({
    super.key,
    this.isBtnDisabled = false,
    this.title,
    this.subTitle,
    this.icon,
  });

  @override
  _EmptyCartViewState createState() => _EmptyCartViewState();
}

class _EmptyCartViewState extends State<EmptyCartView> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: FadeIn(
        duration: Duration(
          milliseconds: 500,
        ), // FadeIn animation for the entire view
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon ?? Icons.shopping_cart_outlined,
                  size: 120,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary.withValues(alpha: 0.7)
                          : AppColors.lightTextSecondary.withValues(alpha: 0.7),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.title ?? "Your cart is empty!",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.subTitle ??
                      "Looks like you haven't added anything to your cart yet.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                widget.isBtnDisabled == true
                    ? SizedBox.shrink()
                    : ZoomIn(
                      // ZoomIn animation for the button
                      duration: Duration(milliseconds: 600),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.explore),
                        label: const Text("Start Shopping"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5, // Add elevation for shadow
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
