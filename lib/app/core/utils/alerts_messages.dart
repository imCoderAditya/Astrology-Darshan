class AppAlertsMessage {
  // Success Messages
  static const String success = "Operation completed successfully.";
  static const String dataSaved = "Data saved successfully.";
  static const String updated = "Updated successfully.";
  static const String deleted = "Deleted successfully.";
  static const String submitted = "Submitted successfully.";

  // Error Messages
  static const String somethingWentWrong =
      "Something went wrong";
  static const String networkError =
      "Network error. Please check your connection.";
  static const String serverError = "Server error. Please try again later.";
  static const String unauthorized = "Unauthorized access. Please login again.";
  static const String validationError = "Please fill all required fields.";

  // Common Alerts
  static const String confirmDelete = "Are you sure you want to delete this?";
  static const String loading = "Loading, please wait...";
  static const String noDataFound = "No data available.";

  // Auth & Field Specific Messages
  static const String mobileRequired = "Mobile number is required.";
  static const String invalidMobile =
      "Please enter a valid 10-digit mobile number.";
  static const String otpRequired = "OTP is required.";
  static const String invalidOtp = "Invalid OTP entered.";
  static const String passwordRequired = "Password is required.";
  static const String invalidPassword = "Please enter a valid password.";
  static const String emailRequired = "Email is required.";
  static const String invalidEmail = "Please enter a valid email address.";
}
