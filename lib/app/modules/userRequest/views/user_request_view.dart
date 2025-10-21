import 'package:astrology/app/core/config/theme/app_text_styles.dart';
import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/utils/date_utils.dart';
import 'package:astrology/app/data/models/userRequest/user_request_model.dart';
import 'package:astrology/app/modules/chat/controllers/chat_controller.dart';
import 'package:astrology/app/modules/chat/views/chat_view.dart';
import 'package:astrology/app/modules/userRequest/Components/fillter_ui_view.dart';
import 'package:astrology/app/modules/voiceCall/views/voice_call_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/user_request_controller.dart';

class UserRequestView extends GetView<UserRequestController> {
  final String? type;
  const UserRequestView({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserRequestController>(
      init: UserRequestController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkBackground
                  : AppColors.lightBackground,
          appBar: _buildAppBar(context),
          body: _buildBody(controller),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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
        'Call & Chat',
        style: AppTextStyles.headlineMedium().copyWith(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () async {
            final result = await showFilterDialog(context);

            if (result != null) {
              String status = result['statuses'] ?? ""; // single selection
              String communication =
                  result['communicationType'] ?? ""; // single selection
              debugPrint(status);
              debugPrint(communication);
              // Call your controller method with the selected filters
              controller.fetchUserRequest(
                status: status,
                sessionType: communication,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildBody(UserRequestController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingState();
      }

      final sessions = controller.userRequestModel.value?.data?.sessions;

      if (sessions == null || sessions.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: () async {
          // Add refresh functionality
          controller.fetchUserRequest(status: type);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(sessions.length)),
            controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final session = sessions[index];
                    return _buildSessionCard(session, index);
                  }, childCount: sessions.length),
                ),
          ],
        ),
      );
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          SizedBox(height: 16.h),
          Text('Loading requests...', style: AppTextStyles.body()),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 80.w, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'No Requests Found',
            style: AppTextStyles.headlineMedium().copyWith(
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Client requests will appear here',
            style: AppTextStyles.body().copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int totalRequests) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.accentColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.request_page, color: Colors.white, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Requests', style: AppTextStyles.caption()),
                Text(
                  totalRequests.toString(),
                  style: AppTextStyles.headlineLarge().copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Session? session, int index) {
    final chatController = Get.put(ChatController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color:
            Theme.of(Get.context!).brightness == Brightness.dark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () async {
            // first time status set active

            final status = session?.status?.toLowerCase();
            final type = session?.sessionType;
            if (status == "cancelled" ||
                (status == "completed" && (type == "Call"))) {
              return;
            }
            // if (session?.status?.toLowerCase() == "pending") {
            // controller.statusUpdate("Active", session?.sessionId);
            // }
            if (session?.sessionType == "Chat") {
              if (session?.status?.toLowerCase() == "pending") {
                controller.statusUpdate("Active", session?.sessionId,"chat");
              }
              await chatController.setData(sessionId: session?.sessionId);
              Get.to(
                ChatView(sessionData: session, nativationType: "chat&call"),
              );
            } else {
              Get.to(
                VoiceCallView(
                  channelName: session?.sessionId.toString(),
                  session: session,
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildSessionHeader(session),
                SizedBox(height: 16.h),
                _buildSessionDetails(session),
                SizedBox(height: 16.h),
                _buildSessionFooter(session),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionHeader(Session? session) {
    return Row(
      children: [
        _buildAstrologerAvatar(session?.astrologerPhoto),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session?.astrologerName ?? "",
                style: AppTextStyles.headlineMedium().copyWith(fontSize: 16.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                session?.categoryName ?? 'General',
                style: AppTextStyles.caption().copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
        _buildStatusChip(session?.status),
      ],
    );
  }

  Widget _buildAstrologerAvatar(String? photoUrl) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: AppColors.headerGradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child:
          photoUrl != null && photoUrl.isNotEmpty
              ? ClipOval(
                child: Image.network(
                  photoUrl,
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildAvatarFallback();
                  },
                ),
              )
              : _buildAvatarFallback(),
    );
  }

  Widget _buildAvatarFallback() {
    return Icon(Icons.person, color: Colors.white, size: 24.w);
  }

  Widget _buildStatusChip(String? status) {
    Color chipColor;
    Color textColor;
    IconData icon;

    switch (status?.toLowerCase()) {
      case 'completed':
        chipColor = AppColors.sucessPrimary;
        textColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case 'pending':
        chipColor = AppColors.secondaryPrimary;
        textColor = Colors.white;
        icon = Icons.access_time;
        break;
      case 'cancelled':
        chipColor = AppColors.red;
        textColor = Colors.white;
        icon = Icons.cancel;
        break;
      default:
        chipColor = AppColors.textPrimaryLight;
        textColor = Colors.white;
        icon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 16.w),
          SizedBox(width: 4.w),
          Text(
            status ?? 'Unknown',
            style: AppTextStyles.caption().copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDetails(dynamic session) {
    return Column(
      children: [
        _buildDetailRow(
          Icons.person,
          'Customer',
          '${session?.customer?.firstName ?? ''} ${session?.customer?.lastName ?? ''}',
        ),
        SizedBox(height: 8.h),
        _buildDetailRow(
          Icons.video_call,
          'Session Type',
          session?.sessionType ?? 'Unknown',
        ),
        SizedBox(height: 8.h),
        _buildDetailRow(
          Icons.schedule,
          'Duration',
          '${session?.duration ?? 0} minutes',
        ),
        SizedBox(height: 8.h),
        _buildDetailRow(
          Icons.currency_rupee,
          'Amount',
          '₹${session?.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: AppColors.primaryColor),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: AppTextStyles.caption().copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.caption(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionFooter(Session? session) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 16.w, color: AppColors.primaryColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Scheduled: ${AppDateUtils.extractDate(session?.scheduledAt, 5)}',
              style: AppTextStyles.caption().copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text("#${session?.sessionId.toString() ?? ""}"),
          if (session?.customerRating != null) ...[
            Icon(Icons.star, size: 16.w, color: AppColors.secondaryPrimary),
            SizedBox(width: 4.w),
            Text(
              session?.customerRating.toString() ?? "",
              style: AppTextStyles.caption().copyWith(
                color: AppColors.secondaryPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
