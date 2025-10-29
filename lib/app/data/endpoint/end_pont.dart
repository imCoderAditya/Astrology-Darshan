class EndPoint {
  //Base url
  static const baseurl = "https://astroapi.veteransoftwares.com/api/";

  // Login API
  static const sendOTP = "Login/SendOtp";
  static const otpVerify = "Login/LoginUser";
  static const registerCustomer = "Registration/customer";
  static const userProfile = "Profile/UserProfile";
  // Ecommerce API Section Given Below
  static const category = "Master/GetProduct_Category";

  static const product = "Master/GetProducts";
  static const cart = "Master/showcart";
  static const updateCartAPI = "Master/UpdateCartQuantity";
  static const addToCart = "/Master/AddToCart";
  static const deleteCartProduct = "Master/DeleteCartItem";

  // Get Address
  static const getAddress = "Address/GetAddress";
  static const addAddress = "Address/AddAddress";
  static const deleteAddress = "Address/DeleteAddress";
  static const updateAddress = "Address/UpdateAddress";
  static const placeOrder = "Master/create";
  static const getUserOrders = "Master/GetUserOrders";

  // Astrology API Section
  static const astrologers = "SearchAstrologer/astrologers";
  static const getConsultationCategoriess = "Master/GetConsultationCategoriess";
  static const bookConsultBook = "BookConsult/book";

  //Slider
  static const slider = "Master/GetSliders?typee=All";
  static const getSliders = "Master/GetSliders?typee=All";
  static const getPopups = "Master/GetPopups?type=All";

  //Reels Section
  static const fetchReels = "Reels/GetAll";

  //Wallet Data
  static const walletAPI = "Wallet/Get_By_User";
  static const addMoneyInWallet = "Wallet/Add_Money";

  // Live astrologer
  static const liveAstrologer = "LiveAstrologer/active";

  // get_consultation_sessions
  static const getConsultationSessions =
      "GetConsultations/get_consultation_sessions";
  static const statusUpdate = "BookConsult/update_Status";
  
  // Puja Section
  static const pujaCategories = "Puja/PujaCategories";
  static const pujaServices = "Puja/PujaServices";
  static const bookPuja = "Puja/BookPuja";
  static const myBooks = "Puja/MyBookings";
  static const updatePayment = "Puja/UpdatePaymentStatus";
  static const getVirtualGifts = "Master/GetVirtualGifts";
  static const sendGift = "LiveSession/SendGift";
  static const notification = "Notification/GetUnread";
  static const getReviews = "Consultation/GetReviews";
  static const getReAddOrUpdateReviewviews = "Consultation/AddOrUpdateReview";
  static const deleteReview = "Consultation/DeleteReview";
  static const liveSessionsendGift = "LiveSession/SendGift";
}
