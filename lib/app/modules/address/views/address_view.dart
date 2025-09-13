import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/data/models/address/address_model.dart';
import 'package:astrology/app/data/models/address/address_update_model.dart';
import 'package:astrology/app/modules/address/controllers/address_controller.dart';
import 'package:astrology/app/modules/address/views/components/add_address_dialog_box.dart';
import 'package:astrology/app/modules/summary/views/summary_view.dart';
import 'package:astrology/app/services/storage/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Address List Screen
class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      init: AddressController(),
      builder: (context) {
        return Scaffold(
          backgroundColor:
              Get.isDarkMode
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.headerGradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: Text(
              'My Addresses',
              style: AppTextStyles.headlineMedium().copyWith(
                color: AppColors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  AddressManager.showAddAddressDialog(
                    onSave:
                        (address) => {
                          debugPrint('Address added: $address'),
                          controller.addAddress(address),
                        },
                  );
                },
                icon: Icon(
                  Icons.add_location_alt,
                  color: AppColors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),

          floatingActionButton: Obx(
            () =>
                controller.selectedAddressId.value != 0
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: MediaQuery.of(Get.context!).size.width - 32,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.off(
                              SummaryView(
                                addressEcModel: controller.addressDatum.value,
                              ),
                            );
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
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                    : SizedBox(),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,

          body: Obx(() {
            if (controller.isLoading.value &&
                (controller.addressModel.value?.data?.isEmpty ?? true)) {
              return Center(child: CircularProgressIndicator());
            }
            if (!controller.isLoading.value &&
                (controller.addressModel.value?.data?.isEmpty ?? true)) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                // Header Info
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color:
                        Get.isDarkMode
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Get.isDarkMode
                                ? Colors.black26
                                : Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Select your delivery address',
                          style: AppTextStyles.body().copyWith(
                            color:
                                Get.isDarkMode
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Address List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 90.h,
                    ),
                    itemCount: controller.addressModel.value?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final addressData =
                          controller.addressModel.value?.data?[index];
                      return _buildAddressCard(addressData);
                    },
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildAddressCard(AddressDatum? addressData) {
    final userId = LocalStorageService.getUserId();
    return Obx(() {
      final isSelected = controller.selectedAddressId.value == addressData?.id;
      final address = addressData?.address;

      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                () => controller.selectAddress(
                  addressData?.id ?? 0,
                  address: addressData,
                ),
            borderRadius: BorderRadius.circular(16.r),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color:
                    Get.isDarkMode
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color:
                      isSelected
                          ? AppColors.primaryColor
                          : (Get.isDarkMode
                              ? AppColors.darkDivider
                              : AppColors.lightDivider),
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isSelected
                            ? AppColors.primaryColor.withValues(alpha: 0.1)
                            : (Get.isDarkMode
                                ? Colors.black26
                                : Colors.grey.withValues(alpha: 0.1)),
                    blurRadius: isSelected ? 8 : 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Address Icon
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.primaryColor,
                          size: 20.sp,
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Address Type & Name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${address?.firstName ?? ""} ${address?.lastName ?? ""}'
                                  .trim(),
                              style: AppTextStyles.subtitle().copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (address?.phoneNumber?.isNotEmpty ?? false)
                              Text(
                                address?.phoneNumber ?? "",
                                style: AppTextStyles.caption().copyWith(
                                  color:
                                      Get.isDarkMode
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Active Status Badge
                      if (addressData?.isActive == true)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.green.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'Active',
                            style: AppTextStyles.caption().copyWith(
                              color: AppColors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                      SizedBox(width: 8.w),

                      // Selected Indicator
                      if (isSelected)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            'Selected',
                            style: AppTextStyles.caption().copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Address Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // House and Gali
                      if (address?.house?.isNotEmpty ?? false)
                        Text(
                          '${address?.house ?? ""}${(address?.gali?.isNotEmpty ?? false) ? ", ${address?.gali}" : ""}',
                          style: AppTextStyles.body(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      // Address2 (Street)
                      if (address?.address2?.isNotEmpty ?? false) ...[
                        SizedBox(height: 4.h),
                        Text(
                          address?.address2 ?? "",
                          style: AppTextStyles.body(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      SizedBox(height: 4.h),

                      // City, State, Postal Code
                      Text(
                        '${address?.city ?? ""}, ${address?.state ?? ""} - ${address?.postalCode ?? ""}',
                        style: AppTextStyles.body().copyWith(
                          color:
                              Get.isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                        ),
                      ),

                      // Country
                      if (address?.country?.isNotEmpty ?? false) ...[
                        SizedBox(height: 2.h),
                        Text(
                          address?.country ?? "",
                          style: AppTextStyles.caption().copyWith(
                            color:
                                Get.isDarkMode
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],

                      // Near Landmark
                      if (address?.nearLandmark?.isNotEmpty ?? false) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.place,
                              size: 14.sp,
                              color: AppColors.accentColor,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                "Near ${address?.nearLandmark}",
                                style: AppTextStyles.caption().copyWith(
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Edit Button
                      TextButton.icon(
                        onPressed: () {
                          AddressManager.showUpdateAddressDialog(
                            existingAddress: AddressUpdateModel(
                              userId: int.parse(userId.toString()),
                              firstName: addressData?.address?.firstName ?? "",
                              lastName: addressData?.address?.lastName ?? "",
                              house: addressData?.address?.house ?? "",
                              gali: addressData?.address?.gali ?? "",
                              nearLandmark:
                                  addressData?.address?.nearLandmark ?? "",
                              address2: addressData?.address?.address2 ?? "",
                              city: addressData?.address?.city ?? "",
                              state: addressData?.address?.state ?? "",
                              postalCode:
                                  addressData?.address?.postalCode ?? "",
                              country: addressData?.address?.country ?? "",
                              phoneNumber:
                                  addressData?.address?.phoneNumber ?? "",
                            ),

                            onSave:
                                (address) => {
                                  Get.back(),
                                  controller.editAddress(
                                    address,
                                    addressData?.id.toString(),
                                  ),
                                },
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                        label: Text(
                          'Edit',
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(width: 8.w),

                      // Delete Button
                      TextButton.icon(
                        onPressed:
                            () => _showDeleteDialog(addressData?.id ?? 0),
                        icon: Icon(
                          Icons.delete,
                          size: 16.sp,
                          color: AppColors.red,
                        ),
                        label: Text(
                          'Delete',
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 80.sp,
            color:
                Get.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
          SizedBox(height: 16.h),
          Text('No addresses found', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 8.h),
          Text(
            'Add your first delivery address',
            style: AppTextStyles.body().copyWith(
              color:
                  Get.isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () {
              AddressManager.showAddAddressDialog(
                onSave:
                    (address) => {
                      debugPrint('Address added: $address'),
                      controller.addAddress(address),
                    },
              );
            },
            icon: Icon(Icons.add, color: AppColors.white),
            label: Text('Add Address', style: AppTextStyles.button),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int addressId) {
    Get.dialog(
      AlertDialog(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text('Delete Address', style: AppTextStyles.headlineMedium()),
        content: Text(
          'Are you sure you want to delete this address?',
          style: AppTextStyles.body(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(
                color:
                    Get.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteAddress(addressId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('Delete', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
