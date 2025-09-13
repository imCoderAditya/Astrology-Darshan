import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/data/models/address/address_update_model.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAddressDialogBox extends StatefulWidget {
  final AddressUpdateModel? existingAddress;
  final Function(AddressUpdateModel) onSave;
  final bool isUpdateMode;

  const AddAddressDialogBox({
    super.key,
    this.existingAddress,
    required this.onSave,

    this.isUpdateMode = false,
  });

  @override
  State<AddAddressDialogBox> createState() => _AddAddressDialogBoxState();
}

class _AddAddressDialogBoxState extends State<AddAddressDialogBox>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Controllers for AddressUpdateModel fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _galiController = TextEditingController();
  final TextEditingController _nearLandmarkController = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Time tracking
  DateTime? _createdAt;
  DateTime? _updatedAt;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeControllers();
    _initializeTimestamps();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _initializeControllers() {
    if (widget.existingAddress != null) {
      final address = widget.existingAddress!;
      _firstNameController.text = address.firstName ?? '';
      _lastNameController.text = address.lastName ?? '';
      _houseController.text = address.house ?? '';
      _galiController.text = address.gali ?? '';
      _nearLandmarkController.text = address.nearLandmark ?? '';
      _address2Controller.text = address.address2 ?? '';
      _cityController.text = address.city ?? '';
      _stateController.text = address.state ?? '';
      _postalCodeController.text = address.postalCode ?? '';
      _countryController.text = address.country ?? '';
      _phoneNumberController.text = address.phoneNumber ?? '';
    } else {
      // Set default country for new addresses
      _countryController.text = 'India';
    }
  }

  void _initializeTimestamps() {
    final now = DateTime.now();

    if (widget.existingAddress != null) {
      _createdAt =
          DateTime.now(); // This would typically come from the existing address
      _updatedAt = now;
    } else {
      _createdAt = now;
      _updatedAt = null;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _houseController.dispose();
    _galiController.dispose();
    _nearLandmarkController.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool get _isDarkMode => Get.isDarkMode;

  Color get _backgroundColor =>
      _isDarkMode ? AppColors.darkSurface : AppColors.lightSurface;

  Color get _dialogBackground =>
      _isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

  Color get _borderColor =>
      _isDarkMode ? AppColors.darkDivider : AppColors.lightDivider;

  // Determine if this is an add or update operation
  bool get _isAddMode => widget.existingAddress == null;

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.subtitle().copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            
            decoration: BoxDecoration(
              
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: _borderColor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: (_isDarkMode ? Colors.black : Colors.grey).withValues(
                    alpha: 0.1,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => SizedBox(),
              validator: validator,
              maxLength:maxLength ,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: AppTextStyles.body(),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.caption().copyWith(
                  color:
                      _isDarkMode
                          ? AppColors.darkTextSecondary.withValues(alpha: 0.7)
                          : AppColors.lightTextSecondary.withValues(alpha: 0.7),
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(12.w),
                  child: Icon(icon, color: AppColors.primaryColor, size: 20.sp),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    bool isOutlined = false,
  }) {
    return Expanded(
      child: Container(
        height: 50.h,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isOutlined ? Colors.transparent : backgroundColor,
            foregroundColor: textColor,
            elevation: isOutlined ? 0 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side:
                  isOutlined
                      ? BorderSide(color: backgroundColor, width: 1.5)
                      : BorderSide.none,
            ),
          ),
          child: Text(
            text,
            style: AppTextStyles.button.copyWith(
              color: textColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimestampInfo() {
    if (_createdAt == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color:
            _isDarkMode
                ? AppColors.darkSurface.withValues(alpha: 0.5)
                : AppColors.lightSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: _borderColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 16.sp,
            color:
                _isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _isAddMode
                  ? 'Creating: ${_formatTimestamp(_createdAt!)}'
                  : 'Last Updated: ${_formatTimestamp(_updatedAt ?? _createdAt!)}',
              style: AppTextStyles.caption().copyWith(
                fontSize: 12.sp,
                color:
                    _isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  void _handleSave() {
    final userId = LocalStorageService.getUserId();
    if (_formKey.currentState!.validate()) {
      // Create address model using correct AddressUpdateModel fields
      final address = AddressUpdateModel(
        userId: int.parse(userId ?? ""),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        house: _houseController.text.trim(),
        gali: _galiController.text.trim(),
        nearLandmark: _nearLandmarkController.text.trim(),
        address2: _address2Controller.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        country: _countryController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
      );

      // Debug information
      debugPrint('=== Address Save Debug ===');
      debugPrint('Mode: ${_isAddMode ? "ADD" : "UPDATE"}');
      debugPrint('UserId: ${address.userId}');
      debugPrint('Name: ${address.firstName} ${address.lastName}');
      debugPrint('House: ${address.house}');
      debugPrint('Gali: ${address.gali}');
      debugPrint('Address2: ${address.address2}');
      debugPrint('City: ${address.city}');
      debugPrint('State: ${address.state}');
      debugPrint('PostalCode: ${address.postalCode}');
      debugPrint('Country: ${address.country}');
      debugPrint('Phone: ${address.phoneNumber}');
      debugPrint('NearLandmark: ${address.nearLandmark}');
      debugPrint('========================');

      widget.onSave(address);
    
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(16.w),
              child: Container(
                constraints: BoxConstraints(maxWidth: 400.w, maxHeight: 0.9.sh),
                decoration: BoxDecoration(
                  color: _dialogBackground,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.headerGradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              _isAddMode
                                  ? Icons.add_location_alt
                                  : Icons.edit_location_alt,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isAddMode
                                      ? 'Add New Address'
                                      : 'Edit Address',
                                  style: AppTextStyles.headlineMedium()
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                      ),
                                ),
                                Text(
                                  _isAddMode
                                      ? 'Creating new address entry'
                                      : 'Updating existing address',
                                  style: AppTextStyles.caption().copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form Content
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.w),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timestamp info
                              _buildTimestampInfo(),

                              // Personal Information Section
                              Text(
                                'Personal Information',
                                style: AppTextStyles.subtitle().copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 12.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomTextField(
                                      controller: _firstNameController,
                                      label: 'First Name',
                                      hint: 'Enter first name',
                                      icon: Icons.person,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'First name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: _buildCustomTextField(
                                      controller: _lastNameController,
                                      label: 'Last Name',
                                      hint: 'Enter last name',
                                      icon: Icons.person_outline,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Last name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              _buildCustomTextField(
                                controller: _phoneNumberController,
                                label: 'Phone Number',
                                hint: 'Enter phone number',
                                icon: Icons.phone,
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  if (value.length < 10) {
                                    return 'Phone number must be at least 10 digits';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 20.h),

                              // Address Information Section
                              Text(
                                'Address Information',
                                style: AppTextStyles.subtitle().copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 12.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomTextField(
                                      controller: _houseController,
                                      label: 'House/Flat No.',
                                      hint: 'Enter house/flat number',
                                      icon: Icons.home,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'House number is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: _buildCustomTextField(
                                      controller: _galiController,
                                      label: 'Gali/Lane',
                                      hint: 'Enter gali/lane',
                                      icon: Icons.route,
                                    ),
                                  ),
                                ],
                              ),

                              _buildCustomTextField(
                                controller: _address2Controller,
                                label: 'Street Address',
                                hint: 'Enter street address',
                                icon: Icons.location_on,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Street address is required';
                                  }
                                  return null;
                                },
                                maxLines: 2,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomTextField(
                                      controller: _cityController,
                                      label: 'City',
                                      hint: 'Enter city',
                                      icon: Icons.location_city,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'City is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: _buildCustomTextField(
                                      controller: _stateController,
                                      label: 'State',
                                      hint: 'Enter state',
                                      icon: Icons.map,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'State is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomTextField(
                                      controller: _postalCodeController,
                                      label: 'Postal Code',
                                      hint: 'Enter postal code',
                                      maxLength: 6,
                                      icon: Icons.pin_drop,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Postal code is required';
                                        }
                                        if (value.length != 6) {
                                          return 'Postal code must be 6 digits';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: _buildCustomTextField(
                                      controller: _countryController,
                                      label: 'Country',
                                      hint: 'Enter country',
                                      icon: Icons.flag,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Country is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              _buildCustomTextField(
                                controller: _nearLandmarkController,
                                label: 'Near Landmark (Optional)',
                                hint: 'Enter nearby landmark',
                                icon: Icons.place,
                              ),

                              SizedBox(height: 20.h),

                              // Action Buttons
                              Row(
                                children: [
                                  _buildActionButton(
                                    text: 'Cancel',
                                    onPressed: () => Get.back(),
                                    backgroundColor:
                                        _isDarkMode
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                    textColor:
                                        _isDarkMode
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                    isOutlined: true,
                                  ),
                                  _buildActionButton(
                                    text:
                                        _isAddMode
                                            ? 'Add Address'
                                            : 'Update Address',
                                    onPressed: _handleSave,
                                    backgroundColor: AppColors.primaryColor,
                                    textColor: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Updated usage manager
class AddressManager {
  static void showAddAddressDialog({
    required Function(AddressUpdateModel) onSave,

  }) {
    Get.dialog(
      AddAddressDialogBox(onSave: onSave, isUpdateMode: false),
      barrierDismissible: false,
    );
  }

  static void showUpdateAddressDialog({
    required AddressUpdateModel existingAddress,
    required Function(AddressUpdateModel) onSave,
  }) {
    Get.dialog(
      AddAddressDialogBox(
        existingAddress: existingAddress,
        onSave: onSave,
        isUpdateMode: true,
      ),
      barrierDismissible: false,
    );
  }
}
