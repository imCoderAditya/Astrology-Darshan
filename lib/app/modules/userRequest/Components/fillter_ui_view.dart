import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Function to show the filter dialog
Future<Map<String, dynamic>?> showFilterDialog(BuildContext context) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return const FilterDialog();
    },
  );
}

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  // Status filter options
  List<String> statusOptions = ['Active', 'Completed', 'Cancelled'];
  // List<String> selectedStatuses = [];

  
  // Communication type filter options (single selection)
  List<String> communicationTypes = ['Chat', 'Call'];
    String selectedStatuses = "";
  String selectedCommunicationType="";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusFilter(),
                    const SizedBox(height: 20),
                    _buildCommunicationTypeFilter(),
                    const SizedBox(height: 20),
                    // _buildSelectedFiltersPreview(),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: _clearAllFilters,
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                color: Colors.blue[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: statusOptions.map((status) {
              final isSelected = selectedStatuses.contains(status);
              return FilterChip(
                label: Text(
                  status,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedStatuses=status;
                    } else {
                      selectedStatuses="";
                    }
                  });
                },
                selectedColor: _getStatusColor(status),
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
                elevation: isSelected ? 2 : 0,
                pressElevation: 4,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunicationTypeFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.comment,
                color: Colors.green[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Communication Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: communicationTypes.map((type) {
              final isSelected = selectedCommunicationType == type;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCommunicationType = type;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.green[400]! : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected ? Colors.green[50] : Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            type == 'Chat' ? Icons.chat_bubble_outline : Icons.phone_outlined,
                            size: 18,
                            color: isSelected ? Colors.green[600] : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            type,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: isSelected ? Colors.green[700] : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding:  EdgeInsets.symmetric(vertical: 12),
                backgroundColor:AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green[600]!;
      case 'completed':
        return Colors.blue[600]!;
      case 'cancelled':
        return Colors.red[600]!;
      case 'pending':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  void _clearAllFilters() {
    setState(() {
      selectedStatuses="";
      selectedCommunicationType = "";
    });
  }

  void _applyFilters() {
    final filterResults = {
      'statuses': selectedStatuses,
      'communicationType': selectedCommunicationType,
    };
    
    // Return the filter results to the caller
    // Navigator.of(context).pop(filterResults);
    Get.back(result:filterResults);
  }
}
