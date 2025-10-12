class PayUPaymentParamModel {
  final String amount;
  final String productInfo;
  final String firstName;
  final String email;
  final String phone;
  final String environment; // "0" = Production, "1" = Test
  final String transactionId;
  final String userCredential;

  PayUPaymentParamModel({
    required this.amount,
    required this.productInfo,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.environment,
    required this.transactionId,
    required this.userCredential,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'productInfo': productInfo,
      'firstName': firstName,
      'email': email,
      'phone': phone,
      'environment': environment,
      'transactionId': transactionId,
      'userCredential': userCredential,
    };
  }

  factory PayUPaymentParamModel.fromMap(Map<String, dynamic> map) {
    return PayUPaymentParamModel(
      amount: map['amount'] ?? '',
      productInfo: map['productInfo'] ?? '',
      firstName: map['firstName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      environment: map['environment'] ?? '0',
      transactionId: map['transactionId'] ?? '',
      userCredential: map['userCredential'] ?? '',
    );
  }

  @override
  String toString() {
    return 'PayUPaymentParamModel(amount: $amount, productInfo: $productInfo, firstName: $firstName, email: $email, phone: $phone, environment: $environment, transactionId: $transactionId, userCredential: $userCredential)';
  }
}
