import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final IconData? icon;
  final Color? confirmColor;
  final Color? iconColor;
  final bool isDanger;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = "Cancel",
    this.confirmText = "Confirm",
    required this.onConfirm,
    this.icon,
    this.confirmColor,
    this.iconColor,
    this.isDanger = false,
  });

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor =
        widget.confirmColor ??
        (widget.isDanger ? Colors.red : theme.primaryColor);
    final dialogIconColor = widget.iconColor ?? primaryColor;

    return Dialog(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon and close button
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
              child: Row(
                children: [
                  // Icon container
                  if (widget.icon != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: dialogIconColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: dialogIconColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        widget.icon,
                        color: dialogIconColor,
                        size: 28,
                      ),
                    ),

                  if (widget.icon != null) const SizedBox(width: 16),

                  // Title
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Close button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                widget.content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: TextButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              isLoading
                                  ? Colors.grey.shade400
                                  : Colors.grey.shade600,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.cancelText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Confirm button
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryColor.withOpacity(0.8)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  // Call the onConfirm callback
                                  widget.onConfirm();

                                  // Add a small delay to show loading state
                                  await Future.delayed(
                                    const Duration(milliseconds: 1000),
                                  );

                                  // Close dialog
                                  if (mounted) {
                                    Get.back();
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  widget.confirmText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
