// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/data/models/wallet/wallet_model.dart';
import 'package:astrology/app/modules/wallet/components/add_amount_dialog.dart';
import 'package:astrology/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletView extends GetView<WalletController> {
  WalletView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldWalletKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Get.put(WalletController(), permanent: true);
    return GetBuilder<WalletController>(
      init: WalletController(),
      builder: (controller) {
        return Scaffold(
          key: _scaffoldWalletKey,
          backgroundColor:
              Get.isDarkMode
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppColors.white),
            title: Text(
              'My Wallet',
              style: AppTextStyles.headlineMedium().copyWith(
                color:
                    Get.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace:
                !Get.isDarkMode
                    ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.headerGradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    )
                    : null,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => controller.toggleFilterSection(),
                icon: Obx(
                  () => Icon(
                    controller.isFilterSectionVisible.value
                        ? Icons.filter_list_off
                        : Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => controller.fetchWallet(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBalanceCard(controller),
                  _buildFilterSection(controller),
                  _buildTransactionHistory(context, controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(WalletController controller) {
    final isDark = Get.isDarkMode;

    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: controller.isFilterSectionVisible.value ? null : 0,
        child:
            controller.isFilterSectionVisible.value
                ? Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border:
                        isDark
                            ? Border.all(
                              color: AppColors.darkDivider,
                              width: 0.5,
                            )
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color:
                                isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Filter Transactions',
                            style: AppTextStyles.headlineLarge().copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (controller.hasActiveFilters())
                            TextButton(
                              onPressed: () => controller.clearAllFilters(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                              ),
                              child: Text(
                                'Clear All',
                                style: AppTextStyles.caption().copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Transaction Type Filter
                      Text(
                        'Transaction Type',
                        style: AppTextStyles.body().copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildFilterChip(
                            controller: controller,
                            label: 'All',
                            value: '',
                            isSelected:
                                controller.selectTransactionType.value.isEmpty,
                            onTap:
                                () => controller.setTransactionTypeFilter(''),
                            isDark: isDark,
                          ),
                          _buildFilterChip(
                            controller: controller,
                            label: 'Credit',
                            value: 'credit',
                            isSelected:
                                controller.selectTransactionType.value ==
                                'credit',
                            onTap:
                                () => controller.setTransactionTypeFilter(
                                  'credit',
                                ),
                            isDark: isDark,
                            color: AppColors.sucessPrimary,
                          ),
                          _buildFilterChip(
                            controller: controller,
                            label: 'Debit',
                            value: 'debit',
                            isSelected:
                                controller.selectTransactionType.value ==
                                'debit',
                            onTap:
                                () => controller.setTransactionTypeFilter(
                                  'debit',
                                ),
                            isDark: isDark,
                            color: AppColors.red,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Status Filter
                      Text(
                        'Status',
                        style: AppTextStyles.body().copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterChip(
                            controller: controller,
                            label: 'All',
                            value: '',
                            isSelected: controller.selectStatus.value.isEmpty,
                            onTap: () => controller.setStatusFilter(''),
                            isDark: isDark,
                          ),
                          _buildFilterChip(
                            controller: controller,
                            label: 'Completed',
                            value: 'completed',
                            isSelected:
                                controller.selectStatus.value == 'completed',
                            onTap:
                                () => controller.setStatusFilter('completed'),
                            isDark: isDark,
                            color: AppColors.sucessPrimary,
                          ),
                          _buildFilterChip(
                            controller: controller,
                            label: 'Pending',
                            value: 'pending',
                            isSelected:
                                controller.selectStatus.value == 'pending',
                            onTap: () => controller.setStatusFilter('pending'),
                            isDark: isDark,
                            color: AppColors.secondaryPrimary,
                          ),
                          _buildFilterChip(
                            controller: controller,
                            label: 'Failed',
                            value: 'failed',
                            isSelected:
                                controller.selectStatus.value == 'failed',
                            onTap: () => controller.setStatusFilter('failed'),
                            isDark: isDark,
                            color: AppColors.red,
                          ),
                          _buildFilterChip(
                            controller: controller,
                            label: 'Cancelled',
                            value: 'cancelled',
                            isSelected:
                                controller.selectStatus.value == 'cancelled',
                            onTap:
                                () => controller.setStatusFilter('cancelled'),
                            isDark: isDark,
                            color: Colors.grey,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Apply Filter Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => controller.applyFilters(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Apply Filters',
                                style: AppTextStyles.button.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : null,
      );
    });
  }

  Widget _buildFilterChip({
    required WalletController controller,
    required String label,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (color ?? AppColors.primaryColor).withOpacity(0.1)
                  : (isDark ? AppColors.darkBackground : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? (color ?? AppColors.primaryColor)
                    : (isDark ? AppColors.darkDivider : Colors.grey.shade300),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check_circle,
                size: 16,
                color: color ?? AppColors.primaryColor,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.caption().copyWith(
                color:
                    isSelected
                        ? (color ?? AppColors.primaryColor)
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(WalletController controller) {
    return Obx(() {
      final wallet = controller.walletModel.value;
      final balance = wallet?.customer?.walletBalance ?? 0.0;
      final totalSpent = wallet?.customer?.totalSpent ?? 0.0;

      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryColor,
              AppColors.accentColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Balance',
              style: AppTextStyles.subtitle().copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₹${balance.toStringAsFixed(2)}',
              style: AppTextStyles.headlineLarge().copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Spent',
                      style: AppTextStyles.caption().copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '₹${totalSpent.toStringAsFixed(2)}',
                      style: AppTextStyles.body().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Last updated: ${DateTime.now().toString().substring(0, 10)}',
                  style: AppTextStyles.small().copyWith(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.sucessPrimary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.dialog(
                    AddAmountDialog(controller: controller),
                    barrierDismissible: false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Add Money',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTransactionHistory(
    BuildContext context,
    WalletController controller,
  ) {
    final isDark = Get.isDarkMode;

    return Obx(() {
      final wallet = controller.walletModel.value;
      final transactions = wallet?.transactions ?? [];

      // Filter transactions based on selected type and status
      final filteredTransactions =
          transactions.where((transaction) {
            bool typeMatch =
                controller.selectTransactionType.value.isEmpty ||
                transaction.transactionType?.toLowerCase() ==
                    controller.selectTransactionType.value.toLowerCase();

            bool statusMatch =
                controller.selectStatus.value.isEmpty ||
                transaction.status?.toLowerCase() ==
                    controller.selectStatus.value.toLowerCase();

            return typeMatch && statusMatch;
          }).toList();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction History',
                  style: AppTextStyles.headlineMedium().copyWith(
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                  ),
                ),
                if (controller.hasActiveFilters())
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${filteredTransactions.length} filtered',
                      style: AppTextStyles.small().copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (filteredTransactions.isEmpty)
              _buildEmptyState(context, controller.hasActiveFilters())
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = filteredTransactions[index];
                  return _buildTransactionCard(
                    context,
                    transaction,
                    index,
                    controller,
                  );
                },
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTransactionCard(
    BuildContext context,
    Transaction transaction,
    int index,
    WalletController controller,
  ) {
    final isDark = Get.isDarkMode;
    final isCredit = transaction.transactionType?.toLowerCase() == 'credit';
    final status = transaction.status?.toLowerCase() ?? 'pending';

    return Obx(() {
      final isExpanded = controller.expandedCards.contains(index);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border:
              isDark
                  ? Border.all(color: AppColors.darkDivider, width: 0.5)
                  : null,
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => _toggleExpansion(controller, index),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            isCredit
                                ? _getStatusColor(status).withOpacity(0.1)
                                : AppColors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCredit ? Icons.add : Icons.remove,
                        color:
                            isCredit ? AppColors.sucessPrimary : AppColors.red,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
                            style: AppTextStyles.headlineMedium().copyWith(
                              color:
                                  isCredit
                                      ? _getStatusColor(status)
                                      : AppColors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(transaction.createdAt),
                            style: AppTextStyles.caption().copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Transaction Id: ${transaction.transactionId ?? 'N/A'}',
                            style: AppTextStyles.small().copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Credit/Debit Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isCredit
                                    ? _getStatusColor(status).withOpacity(0.1)
                                    : AppColors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isCredit ? 'Credit' : 'Debit',
                            style: AppTextStyles.small().copyWith(
                              color:
                                  isCredit
                                      ? _getStatusColor(status)
                                      : AppColors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _getStatusText(status),
                                style: AppTextStyles.small().copyWith(
                                  color: _getStatusColor(status),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded ? null : 0,
              child:
                  isExpanded
                      ? Container(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkBackground.withOpacity(0.5)
                                  : AppColors.lightBackground,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            Divider(
                              height: 1,
                              color:
                                  isDark
                                      ? AppColors.darkDivider
                                      : AppColors.lightDivider,
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              context,
                              'Description',
                              transaction.description ?? 'N/A',
                            ),
                            _buildDetailRow(
                              context,
                              'Reference',
                              transaction.reference ?? 'N/A',
                            ),
                            _buildDetailRow(
                              context,
                              'Status',
                              _getStatusText(status),
                              valueColor: _getStatusColor(status),
                            ),
                            _buildDetailRow(
                              context,
                              'Date & Time',
                              _formatDateTime(transaction.createdAt),
                            ),
                          ],
                        ),
                      )
                      : null,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDetailRow(
    BuildContext context,
    String title,
    String value, {
    Color? valueColor,
  }) {
    final isDark = Get.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: AppTextStyles.caption().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: AppTextStyles.caption().copyWith(
                color:
                    valueColor ??
                    (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary),
                fontWeight:
                    valueColor != null ? FontWeight.w600 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool hasFilters) {
    final isDark = Get.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Icon(
            hasFilters
                ? Icons.search_off
                : Icons.account_balance_wallet_outlined,
            size: 60,
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters ? "No Matching Transactions" : "No Transactions Found",
            style: AppTextStyles.body().copyWith(
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? "Try adjusting your filters to see more results"
                : "Your transactions will appear here",
            style: AppTextStyles.caption().copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _toggleExpansion(WalletController controller, int index) {
    if (controller.expandedCards.contains(index)) {
      controller.expandedCards.remove(index);
    } else {
      controller.expandedCards.add(index);
    }
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.sucessPrimary;
      case 'pending':
        return Colors.yellow;
      case 'failed':
        return AppColors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  // Helper method to get status text with proper capitalization
  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  // Helper method to format date
  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  // Helper method to format date and time
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}
