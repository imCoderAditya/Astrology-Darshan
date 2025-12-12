import 'package:get/get.dart';

import '../modules/address/bindings/address_binding.dart';
import '../modules/address/views/address_view.dart';
import '../modules/astroPuja/myPuja/bindings/my_puja_binding.dart';
import '../modules/astroPuja/myPuja/views/my_puja_view.dart';
import '../modules/astroPuja/puja/bindings/puja_binding.dart';
import '../modules/astroPuja/puja/views/puja_view.dart';
import '../modules/astrologerDetails/bindings/astrologer_details_binding.dart';
import '../modules/astrologerDetails/views/astrologer_details_view.dart';
import '../modules/astrologers/bindings/astrologers_binding.dart';
import '../modules/astrologers/views/astrologers_view.dart';
import '../modules/astrologyServices/horoscope/bindings/horoscope_binding.dart';
import '../modules/astrologyServices/horoscope/views/horoscope_view.dart';
import '../modules/astrologyServices/kundali/bindings/kundali_binding.dart';
import '../modules/astrologyServices/kundali/views/kundali_form_view.dart';
import '../modules/astrologyServices/kundali/views/kundali_view.dart';
import '../modules/astrologyServices/kundaliMatching/bindings/kundali_matching_binding.dart';
import '../modules/astrologyServices/kundaliMatching/views/kundali_matching_view.dart';
import '../modules/astrologyServices/kundaliMatchingDetails/bindings/kundali_matching_details_binding.dart';
import '../modules/astrologyServices/kundaliMatchingDetails/views/kundali_matching_details_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/otpVerify/bindings/otp_verify_binding.dart';
import '../modules/auth/otpVerify/views/otp_verify_view.dart';
import '../modules/auth/signup/bindings/signup_binding.dart';
import '../modules/auth/signup/views/signup_view.dart';
import '../modules/ecommerce/cart/bindings/cart_binding.dart';
import '../modules/ecommerce/cart/views/cart_view.dart';
import '../modules/ecommerce/productDetails/bindings/product_details_binding.dart';
import '../modules/ecommerce/productDetails/views/product_details_view.dart';
import '../modules/ecommerce/store/bindings/store_binding.dart';
import '../modules/ecommerce/store/views/store_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/liveAstro/bindings/live_astro_binding.dart';
import '../modules/liveBroadCastAstrology/bindings/live_astrology_binding.dart';
import '../modules/liveBroadCastAstrology/views/live_astrology_view.dart';
import '../modules/nav/bindings/nav_binding.dart';
import '../modules/nav/views/nav_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/astrologyServices/numerology/bindings/numerology_binding.dart';
import '../modules/astrologyServices/numerology/views/numerology_view.dart';
import '../modules/orderHistory/bindings/order_history_binding.dart';
import '../modules/orderHistory/views/order_history_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reels/bindings/reels_binding.dart';
import '../modules/reels/views/reels_view.dart';
import '../modules/review/bindings/review_binding.dart';
import '../modules/review/views/review_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/summary/bindings/summary_binding.dart';
import '../modules/summary/views/summary_view.dart';
import '../modules/transaction/bindings/transaction_binding.dart';
import '../modules/transaction/views/transaction_view.dart';
import '../modules/userRequest/bindings/user_request_binding.dart';
import '../modules/userRequest/views/user_request_view.dart';
import '../modules/voiceCall/bindings/voice_call_binding.dart';
import '../modules/voiceCall/views/voice_call_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;


  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(name: _Paths.NAV, page: () => NavView(), binding: NavBinding()),
    // GetPage(name: _Paths.CHAT, page: () => ChatView(), binding: ChatBinding()),
    GetPage(
      name: _Paths.ASTROLOGERS,
      page: () => AstrologersView(),
      binding: AstrologersBinding(),
    ),
    GetPage(
      name: _Paths.LIVE_ASTROLOGY,
      page: () => const LiveAstrologyView(),
      binding: LiveAstrologyBinding(),
    ),
    GetPage(
      name: _Paths.STORE,
      page: () => StoreView(),
      binding: StoreBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.REELS,
      page: () => ReelsView(),
      binding: ReelsBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(name: _Paths.CART, page: () => CartView(), binding: CartBinding()),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS,
      page: () => AddressView(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: _Paths.SUMMARY,
      page: () => const SummaryView(),
      binding: SummaryBinding(),
    ),
    GetPage(
      name: _Paths.TRANSACTION,
      page: () => const TransactionView(),
      binding: TransactionBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_HISTORY,
      page: () => const OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ASTROLOGER_DETAILS,
      page: () => AstrologerDetailsView(),
      binding: AstrologerDetailsBinding(),
    ),

    GetPage(
      name: _Paths.LIVE_ASTRO,
      page: () => const LiveAstrologyView(),
      binding: LiveAstroBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFY,
      page: () => const OtpVerifyView(),
      binding: OtpVerifyBinding(),
    ),
    GetPage(
      name: _Paths.VOICE_CALL,
      page: () => VoiceCallView(),
      binding: VoiceCallBinding(),
    ),
    GetPage(
      name: _Paths.USER_REQUEST,
      page: () => UserRequestView(),
      binding: UserRequestBinding(),
    ),
    GetPage(name: _Paths.PUJA, page: () => PujaView(), binding: PujaBinding()),
    GetPage(
      name: _Paths.MY_PUJA,
      page: () => const MyPujaView(),
      binding: MyPujaBinding(),
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () => const ReviewView(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: _Paths.KUNDALI,
      page: () => const KundaliView(),
      binding: KundaliBinding(),
    ),
    GetPage(
      name: _Paths.KUNDALIFORM,
      page: () => const KundaliFormView(),
      binding: KundaliBinding(),
    ),
    GetPage(
      name: _Paths.KUNDALI_MATCHING,
      page: () => const KundaliMatchingView(),
      binding: KundaliMatchingBinding(),
    ),
    GetPage(
      name: _Paths.KUNDALI_MATCHING_DETAILS,
      page: () => const KundaliMatchingDetailsView(),
      binding: KundaliMatchingDetailsBinding(),
    ),
    GetPage(
      name: _Paths.HOROSCOPE,
      page: () => const HoroscopeView(),
      binding: HoroscopeBinding(),
    ),
    GetPage(
      name: _Paths.NUMEROLOGY,
      page: () => const NumerologyView(),
      binding: NumerologyBinding(),
    ),
  ];
}
