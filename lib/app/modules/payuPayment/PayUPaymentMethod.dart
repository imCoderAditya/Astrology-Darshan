
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';

// class PayUCODPayment extends StatefulWidget {
//   const PayUCODPayment({super.key});

//   @override
//   State<PayUCODPayment> createState() => _PayUCODPaymentState();
// }

// class _PayUCODPaymentState extends State<PayUCODPayment> {
//   // Your existing merchant credentials
//   static const String merchantKey = "8751263";
//   static const String merchantSalt = "YOUR_MERCHANT_SALT_13213"; // Replace with actual salt
  
//   // PayU URLs
//   static const String testUrl = "https://test.payu.in/_payment";
//   static const String productionUrl = "https://secure.payu.in/_payment";
  
//   // Form controllers
//   final TextEditingController _amountController = TextEditingController(text: "500");
//   final TextEditingController _firstNameController = TextEditingController(text: "Rahul");
//   final TextEditingController _emailController = TextEditingController(text: "rahul@example.com");
//   final TextEditingController _phoneController = TextEditingController(text: "9876543210");
//   final TextEditingController _addressController = TextEditingController(text: "123 Main Street");
//   final TextEditingController _cityController = TextEditingController(text: "Mumbai");
//   final TextEditingController _stateController = TextEditingController(text: "Maharashtra");
//   final TextEditingController _pincodeController = TextEditingController(text: "400001");
  
//   bool _isTestEnvironment = true;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _firstNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _pincodeController.dispose();
//     super.dispose();
//   }

//   // Generate hash for COD payment
//   String _generateCODHash({
//     required String key,
//     required String txnId,
//     required String amount,
//     required String productInfo,
//     required String firstName,
//     required String email,
//     required String salt,
//   }) {
//     // Hash format for COD: key|txnid|amount|productinfo|firstname|email|||||||||||salt
//     String hashString = "$key|$txnId|$amount|$productInfo|$firstName|$email|||||||||||$salt";
//     final bytes = utf8.encode(hashString);
//     final digest = sha512.convert(bytes);
//     return digest.toString();
//   }

//   // Validate form data
//   bool _validateForm() {
//     if (_amountController.text.isEmpty || double.tryParse(_amountController.text) == null) {
//       _showAlertDialog("Validation Error", "Please enter a valid amount");
//       return false;
//     }
    
//     if (_firstNameController.text.isEmpty) {
//       _showAlertDialog("Validation Error", "Please enter first name");
//       return false;
//     }
    
//     if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
//       _showAlertDialog("Validation Error", "Please enter a valid email");
//       return false;
//     }
    
//     if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
//       _showAlertDialog("Validation Error", "Please enter a valid phone number");
//       return false;
//     }
    
//     if (_addressController.text.isEmpty) {
//       _showAlertDialog("Validation Error", "Please enter delivery address");
//       return false;
//     }
    
//     if (_cityController.text.isEmpty) {
//       _showAlertDialog("Validation Error", "Please enter city");
//       return false;
//     }
    
//     if (_stateController.text.isEmpty) {
//       _showAlertDialog("Validation Error", "Please enter state");
//       return false;
//     }
    
//     if (_pincodeController.text.isEmpty || _pincodeController.text.length != 6) {
//       _showAlertDialog("Validation Error", "Please enter a valid 6-digit pincode");
//       return false;
//     }
    
//     return true;
//   }

//   // Process COD Order
//   void _processCODOrder() async {
//     if (!_validateForm()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final String txnId = "COD_${DateTime.now().millisecondsSinceEpoch}";
//       final String amount = _amountController.text;
//       const String productInfo = "COD Order";
//       final String firstName = _firstNameController.text;
//       final String email = _emailController.text;
//       final String phone = _phoneController.text;

//       // Generate hash
//       final String hash = _generateCODHash(
//         key: merchantKey,
//         txnId: txnId,
//         amount: amount,
//         productInfo: productInfo,
//         firstName: firstName,
//         email: email,
//         salt: merchantSalt,
//       );

//       // Create order data
//       final Map<String, dynamic> orderData = {
//         'key': merchantKey,
//         'txnid': txnId,
//         'amount': amount,
//         'productinfo': productInfo,
//         'firstname': firstName,
//         'email': email,
//         'phone': phone,
//         'pg': 'COD', // Cash on Delivery payment gateway
//         'bankcode': 'COD', // COD bank code
//         'hash': hash,
//         'surl': _isTestEnvironment 
//             ? 'https://your-test-domain.com/success' 
//             : 'https://your-domain.com/success',
//         'furl': _isTestEnvironment 
//             ? 'https://your-test-domain.com/failure' 
//             : 'https://your-domain.com/failure',
//         'service_provider': 'payu_paisa',
        
//         // Delivery address details
//         'address1': _addressController.text,
//         'city': _cityController.text,
//         'state': _stateController.text,
//         'zipcode': _pincodeController.text,
//         'country': 'India',
        
//         // Additional parameters
//         'udf1': 'COD_Order',
//         'udf2': _cityController.text,
//         'udf3': _stateController.text,
//         'udf4': _pincodeController.text,
//         'udf5': phone,
//       };

//       // For demonstration, we'll show the order details
//       // In production, you would send this to your backend API
//       await _submitCODOrder(orderData);
      
//     } catch (e) {
//       _showAlertDialog("Error", "Failed to process COD order: ${e.toString()}");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   // Submit COD order (simulate backend call)
//   Future<void> _submitCODOrder(Map<String, dynamic> orderData) async {
//     // Simulate API call delay
//     await Future.delayed(const Duration(seconds: 2));
    
//     // In production, you would:
//     // 1. Send orderData to your backend
//     // 2. Your backend validates and stores the order
//     // 3. Your backend makes API call to PayU
//     // 4. Return response to app
    
//     // For now, we'll simulate a successful COD order
//     final orderResponse = {
//       'status': 'SUCCESS',
//       'txnid': orderData['txnid'],
//       'amount': orderData['amount'],
//       'productinfo': orderData['productinfo'],
//       'firstname': orderData['firstname'],
//       'email': orderData['email'],
//       'phone': orderData['phone'],
//       'address': '${orderData['address1']}, ${orderData['city']}, ${orderData['state']} - ${orderData['zipcode']}',
//       'payment_method': 'Cash on Delivery',
//       'order_id': 'ORD_${DateTime.now().millisecondsSinceEpoch}',
//       'estimated_delivery': _getEstimatedDeliveryDate(),
//       'message': 'COD order placed successfully!'
//     };
    
//     _showOrderSuccessDialog(orderResponse);
//   }

//   String _getEstimatedDeliveryDate() {
//     final deliveryDate = DateTime.now().add(const Duration(days: 3));
//     return "${deliveryDate.day}/${deliveryDate.month}/${deliveryDate.year}";
//   }

//   void _showOrderSuccessDialog(Map<String, dynamic> orderResponse) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => AlertDialog(
//         title: const Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green, size: 30),
//             SizedBox(width: 10),
//             Text("Order Placed Successfully!"),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildOrderDetailRow("Order ID:", orderResponse['order_id']),
//               _buildOrderDetailRow("Transaction ID:", orderResponse['txnid']),
//               _buildOrderDetailRow("Amount:", "₹${orderResponse['amount']}"),
//               _buildOrderDetailRow("Payment Method:", orderResponse['payment_method']),
//               _buildOrderDetailRow("Customer:", orderResponse['firstname']),
//               _buildOrderDetailRow("Phone:", orderResponse['phone']),
//               _buildOrderDetailRow("Delivery Address:", orderResponse['address']),
//               _buildOrderDetailRow("Estimated Delivery:", orderResponse['estimated_delivery']),
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade50,
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: Colors.green.shade200),
//                 ),
//                 child: Text(
//                   orderResponse['message'],
//                   style: TextStyle(
//                     color: Colors.green.shade700,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _resetForm();
//             },
//             child: const Text("Place Another Order"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//             child: const Text("OK", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrderDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//           Expanded(
//             child: Text(value),
//           ),
//         ],
//       ),
//     );
//   }

//   void _resetForm() {
//     _amountController.clear();
//     _firstNameController.clear();
//     _emailController.clear();
//     _phoneController.clear();
//     _addressController.clear();
//     _cityController.clear();
//     _stateController.clear();
//     _pincodeController.clear();
//   }

//   void _showAlertDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("PayU COD Payment"),
//         backgroundColor: Colors.orange,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header Section
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.orange.shade100, Colors.orange.shade50],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Column(
//                 children: [
//                   Icon(Icons.local_shipping, size: 50, color: Colors.orange),
//                   SizedBox(height: 10),
//                   Text(
//                     "Cash on Delivery",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.orange,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "Pay when you receive your order",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 24),
            
//             // Environment Toggle
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text("Test Environment:", style: TextStyle(fontWeight: FontWeight.w500)),
//                   Switch(
//                     value: _isTestEnvironment,
//                     onChanged: (value) {
//                       setState(() {
//                         _isTestEnvironment = value;
//                       });
//                     },
//                     activeColor: Colors.orange,
//                   ),
//                 ],
//               ),
//             ),
            
//             const SizedBox(height: 24),
            
//             // Order Details Form
//             const Text(
//               "Order Details",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
            
//             _buildTextField(
//               controller: _amountController,
//               label: "Amount (₹)",
//               keyboardType: TextInputType.number,
//               icon: Icons.currency_rupee,
//             ),
            
//             const SizedBox(height: 20),
            
//             // Customer Details
//             const Text(
//               "Customer Details",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
            
//             _buildTextField(
//               controller: _firstNameController,
//               label: "First Name",
//               icon: Icons.person,
//             ),
            
//             _buildTextField(
//               controller: _emailController,
//               label: "Email",
//               keyboardType: TextInputType.emailAddress,
//               icon: Icons.email,
//             ),
            
//             _buildTextField(
//               controller: _phoneController,
//               label: "Phone Number",
//               keyboardType: TextInputType.phone,
//               icon: Icons.phone,
//             ),
            
//             const SizedBox(height: 20),
            
//             // Delivery Address
//             const Text(
//               "Delivery Address",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
            
//             _buildTextField(
//               controller: _addressController,
//               label: "Address",
//               maxLines: 2,
//               icon: Icons.home,
//             ),
            
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTextField(
//                     controller: _cityController,
//                     label: "City",
//                     icon: Icons.location_city,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildTextField(
//                     controller: _stateController,
//                     label: "State",
//                     icon: Icons.map,
//                   ),
//                 ),
//               ],
//             ),
            
//             _buildTextField(
//               controller: _pincodeController,
//               label: "Pincode",
//               keyboardType: TextInputType.number,
//               icon: Icons.pin_drop,
//             ),
            
//             const SizedBox(height: 30),
            
//             // Place Order Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _processCODOrder,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         "Place COD Order",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//               ),
//             ),
            
//             const SizedBox(height: 16),
            
//             // Info Note
//             Container(
           
//               decoration: BoxDecoration(
//                 color: Colors.blue.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue.shade200),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       "• COD orders are processed immediately\n"
//                       "• Delivery charges may apply\n"
//                       "• Please keep exact change ready\n"
//                       "• Orders are delivered within 3-5 business days",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.blue.shade700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType? keyboardType,
//     IconData? icon,
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: icon != null ? Icon(icon, color: Colors.orange) : null,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: const BorderSide(color: Colors.orange, width: 2),
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//       ),
//     );
//   }
// }

// // Complete PayU COD Implementation
// // This combines the UI and service layer for a production-ready COD system


// // Main COD Payment Widget
// class PayUCODComplete extends StatefulWidget {
//   const PayUCODComplete({super.key});

//   @override
//   State<PayUCODComplete> createState() => _PayUCODCompleteState();
// }

// class _PayUCODCompleteState extends State<PayUCODComplete> {
//   final _formKey = GlobalKey<FormState>();
  
//   // Controllers
//   final TextEditingController _amountController = TextEditingController(text: "750");
//   final TextEditingController _firstNameController = TextEditingController(text: "Rahul Kumar");
//   final TextEditingController _emailController = TextEditingController(text: "rahul@example.com");
//   final TextEditingController _phoneController = TextEditingController(text: "9876543210");
//   final TextEditingController _addressController = TextEditingController(text: "123 Main Street, Sector 5");
//   final TextEditingController _cityController = TextEditingController(text: "Mumbai");
//   final TextEditingController _stateController = TextEditingController(text: "Maharashtra");
//   final TextEditingController _pincodeController = TextEditingController(text: "400001");
  
//   bool _isTestEnvironment = true;
//   bool _isLoading = false;
//   bool _codAvailable = true;
//   double _codCharges = 0.0;
//   DateTime? _estimatedDelivery;

//   @override
//   void initState() {
//     super.initState();
//     _checkCODAvailability();
//     _calculateCharges();
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _firstNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _pincodeController.dispose();
//     super.dispose();
//   }

//   void _checkCODAvailability() async {
//     if (_pincodeController.text.length == 6) {
//       final available = await PayUCODService.checkCODAvailability(_pincodeController.text);
//       final estimatedDate = PayUCODService.getEstimatedDeliveryDate(_pincodeController.text);
      
//       setState(() {
//         _codAvailable = available;
//         _estimatedDelivery = estimatedDate;
//       });
//     }
//   }

//   void _calculateCharges() {
//     final amount = double.tryParse(_amountController.text) ?? 0.0;
//     setState(() {
//       _codCharges = PayUCODService.calculateCODCharges(amount);
//     });
//   }

//   void _processCODOrder() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (!_codAvailable) {
//       _showSnackBar("COD is not available for this pincode", Colors.red);
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final result = await PayUCODService.createCODOrder(
//         amount: double.parse(_amountController.text),
//         firstName: _firstNameController.text,
//         email: _emailController.text,
//         phone: _phoneController.text,
//         address: _addressController.text,
//         city: _cityController.text,
//         state: _stateController.text,
//         pincode: _pincodeController.text,
//         productInfo: "E-commerce Order",
//         isTestEnvironment: _isTestEnvironment,
//       );

//       if (result['success']) {
//         _showOrderSuccessDialog(result['data']);
//       } else {
//         _showSnackBar(result['error'], Colors.red);
//       }
//     } catch (e) {
//       _showSnackBar("Error: ${e.toString()}", Colors.red);
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showOrderSuccessDialog(Map<String, dynamic> orderData) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.green, size: 30),
//             SizedBox(width: 10),
//             Text("Order Placed!", style: TextStyle(color: Colors.green)),
//           ],
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildSuccessRow("Order ID:", orderData['order_id'] ?? "ORD_${DateTime.now().millisecondsSinceEpoch}"),
//               _buildSuccessRow("Amount:", "₹${_amountController.text}"),
//               _buildSuccessRow("COD Charges:", _codCharges > 0 ? "₹$_codCharges" : "FREE"),
//               _buildSuccessRow("Total Amount:", "₹${(double.parse(_amountController.text) + _codCharges).toStringAsFixed(2)}"),
//               _buildSuccessRow("Payment Method:", "Cash on Delivery"),
//               _buildSuccessRow("Estimated Delivery:", _formatDate(_estimatedDelivery!)),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.orange.shade200),
//                 ),
//                 child: const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "📋 Important Instructions:",
//                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
//                     ),
//                     SizedBox(height: 8),
//                     Text("• Keep exact change ready", style: TextStyle(fontSize: 13)),
//                     Text("• Verify product before payment", style: TextStyle(fontSize: 13)),
//                     Text("• Order tracking SMS will be sent", style: TextStyle(fontSize: 13)),
//                     Text("• Contact support for any issues", style: TextStyle(fontSize: 13)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _resetForm();
//             },
//             child: const Text("Place Another Order"),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.of(context).pop(),
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//             child: const Text("Done", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSuccessRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
//           Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return "${date.day} ${months[date.month - 1]} ${date.year}";
//   }

//   void _resetForm() {
//     _formKey.currentState?.reset();
//     _amountController.text = "750";
//     _firstNameController.text = "Rahul Kumar";
//     _emailController.text = "rahul@example.com";
//     _phoneController.text = "9876543210";
//     _addressController.text = "123 Main Street, Sector 5";
//     _cityController.text = "Mumbai";
//     _stateController.text = "Maharashtra";
//     _pincodeController.text = "400001";
//   }

//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text("Cash on Delivery", style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.orange,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 16),
//             child: Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _isTestEnvironment ? Colors.red.shade100 : Colors.green.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   _isTestEnvironment ? "TEST" : "LIVE",
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: _isTestEnvironment ? Colors.red.shade700 : Colors.green.shade700,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Card
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.orange.shade400, Colors.orange.shade600],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.orange.shade200,
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: const Column(
//                   children: [
//                     Icon(Icons.payments, size: 48, color: Colors.white),
//                     SizedBox(height: 12),
//                     Text(
//                       "Pay When You Receive",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "Secure • Convenient • Trusted",
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               const SizedBox(height: 24),
              
//               // Environment Toggle
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Row(
//                         children: [
//                           Icon(Icons.settings, color: Colors.grey),
//                           SizedBox(width: 8),
//                           Text("Test Environment", style: TextStyle(fontWeight: FontWeight.w500)),
//                         ],
//                       ),
//                       Switch(
//                         value: _isTestEnvironment,
//                         onChanged: (value) {
//                           setState(() {
//                             _isTestEnvironment = value;
//                           });
//                         },
//                         activeColor: Colors.orange,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // Order Summary Card
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Row(
//                         children: [
//                           Icon(Icons.shopping_cart, color: Colors.orange),
//                           SizedBox(width: 8),
//                           Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _amountController,
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) => _calculateCharges(),
//                         decoration: const InputDecoration(
//                           labelText: "Order Amount (₹)",
//                           prefixIcon: Icon(Icons.currency_rupee),
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) return "Amount is required";
//                           if (double.tryParse(value) == null) return "Invalid amount";
//                           if (double.parse(value) < 50) return "Minimum order amount is ₹50";
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text("COD Charges:", style: TextStyle(fontWeight: FontWeight.w500)),
//                           Text(
//                             _codCharges > 0 ? "₹$_codCharges" : "FREE",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: _codCharges > 0 ? Colors.orange : Colors.green,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text("Total Amount:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                           Text(
//                             "₹${(double.tryParse(_amountController.text) ?? 0.0 + _codCharges).toStringAsFixed(2)}",
//                             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // Customer Details Card
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Row(
//                         children: [
//                           Icon(Icons.person, color: Colors.orange),
//                           SizedBox(width: 8),
//                           Text("Customer Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _firstNameController,
//                         decoration: const InputDecoration(
//                           labelText: "Full Name",
//                           prefixIcon: Icon(Icons.person_outline),
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) => value?.isEmpty == true ? "Name is required" : null,
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: const InputDecoration(
//                           labelText: "Email Address",
//                           prefixIcon: Icon(Icons.email_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value?.isEmpty == true) return "Email is required";
//                           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) return "Invalid email";
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _phoneController,
//                         keyboardType: TextInputType.phone,
//                         decoration: const InputDecoration(
//                           labelText: "Phone Number",
//                           prefixIcon: Icon(Icons.phone_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value?.isEmpty == true) return "Phone is required";
//                           if (value!.length < 10) return "Invalid phone number";
//                           return null;
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // Delivery Address Card
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Row(
//                         children: [
//                           Icon(Icons.location_on, color: Colors.orange),
//                           SizedBox(width: 8),
//                           Text("Delivery Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _addressController,
//                         maxLines: 2,
//                         decoration: const InputDecoration(
//                           labelText: "Full Address",
//                           prefixIcon: Icon(Icons.home_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                         validator: (value) => value?.isEmpty == true ? "Address is required" : null,
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _cityController,
//                               decoration: const InputDecoration(
//                                 labelText: "City",
//                                 prefixIcon: Icon(Icons.location_city_outlined),
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator: (value) => value?.isEmpty == true ? "City is required" : null,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _stateController,
//                               decoration: const InputDecoration(
//                                 labelText: "State",
//                                 prefixIcon: Icon(Icons.map_outlined),
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator: (value) => value?.isEmpty == true ? "State is required" : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _pincodeController,
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) {
//                           if (value.length == 6) _checkCODAvailability();
//                         },
//                         decoration: InputDecoration(
//                           labelText: "Pincode",
//                           prefixIcon: const Icon(Icons.pin_drop_outlined),
//                           border: const OutlineInputBorder(),
//                           suffixIcon: _pincodeController.text.length == 6
//                               ? Icon(
//                                   _codAvailable ? Icons.check_circle : Icons.cancel,
//                                   color: _codAvailable ? Colors.green : Colors.red,
//                                 )
//                               : null,
//                         ),
//                         validator: (value) {
//                           if (value?.isEmpty == true) return "Pincode is required";
//                           if (value!.length != 6) return "Invalid pincode";
//                           return null;
//                         },
//                       ),
//                       if (!_codAvailable && _pincodeController.text.length == 6)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text(
//                             "❌ COD not available for this pincode",
//                             style: TextStyle(color: Colors.red.shade700, fontSize: 12),
//                           ),
//                         ),
//                       if (_codAvailable && _estimatedDelivery != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text(
//                             "✅ COD available • Estimated delivery: ${_formatDate(_estimatedDelivery!)}",
//                             style: TextStyle(color: Colors.green.shade700, fontSize: 12),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 24),
              
//               // Place Order Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: _isLoading ? null : _processCODOrder,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     elevation: 4,
//                   ),
//                   child: _isLoading
//                       ? const SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                         )
//                       : const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.shopping_bag_outlined, size: 24),
//                             SizedBox(width: 8),
//                             Text("Place COD Order", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                           ],
//                         ),
//                 ),
//               ),
              
//               const SizedBox(height: 16),
              
//               // Info Card
//               Card(
//                 color: Colors.blue.shade50,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.info_outline, color: Colors.blue.shade700),
//                           const SizedBox(width: 8),
//                           Text(
//                             "Important Information",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       _buildInfoPoint("💰 Pay only when you receive your order"),
//                       _buildInfoPoint("📦 Verify product before payment"),
//                       _buildInfoPoint("🚚 Free delivery above ₹1000"),
//                       _buildInfoPoint("📱 Order tracking via SMS"),
//                       _buildInfoPoint("🔒 100% secure and trusted"),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoPoint(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 13,
//           color: Colors.blue.shade700,
//         ),
//       ),
//     );
//   }
// }

// // PayU COD Service Class
// class PayUCODService {
//   static const String merchantKey = "8751263";
//   static const String merchantSalt = "YOUR_MERCHANT_SALT_13213";
  
//   static String generateHash({
//     required String key,
//     required String txnId,
//     required String amount,
//     required String productInfo,
//     required String firstName,
//     required String email,
//     required String salt,
//     String udf1 = "",
//     String udf2 = "",
//     String udf3 = "",
//     String udf4 = "",
//     String udf5 = "",
//   }) {
//     String hashString = "$key|$txnId|$amount|$productInfo|$firstName|$email|$udf1|$udf2|$udf3|$udf4|$udf5||||||$salt";
//     final bytes = utf8.encode(hashString);
//     final digest = sha512.convert(bytes);
//     return digest.toString();
//   }

//   static Future<Map<String, dynamic>> createCODOrder({
//     required double amount,
//     required String firstName,
//     required String email,
//     required String phone,
//     required String address,
//     required String city,
//     required String state,
//     required String pincode,
//     required String productInfo,
//     bool isTestEnvironment = true,
//   }) async {
//     // Simulate API call delay
//     await Future.delayed(const Duration(seconds: 2));
    
//     final String txnId = "COD_${DateTime.now().millisecondsSinceEpoch}";
//     final String orderId = "ORD_${DateTime.now().millisecondsSinceEpoch}";
    
//     // In production, make actual API call to your backend
//     return {
//       'success': true,
//       'order_id': orderId,
//       'txnid': txnId,
//       'status': 'success',
//       'message': 'COD order placed successfully',
//       'amount': amount.toString(),
//       'payment_method': 'COD',
//       'estimated_delivery': getEstimatedDeliveryDate(pincode).toIso8601String(),
//     };
//   }

//   static Future<bool> checkCODAvailability(String pincode) async {
//     // Simulate checking COD availability
//     await Future.delayed(const Duration(milliseconds: 500));
    
//     const List<String> codPincodes = [
//       '400001', '400002', '400003', '400004', '400005', // Mumbai
//       '110001', '110002', '110003', '110004', '110005', // Delhi
//       '560001', '560002', '560003', '560004', '560005', // Bangalore
//       '600001', '600002', '600003', '600004', '600005', // Chennai
//       '700001', '700002', '700003', '700004', '700005', // Kolkata
//       '500001', '500002', '500003', '500004', '500005', // Hyderabad
//     ];
    
//     return codPincodes.contains(pincode);
//   }

//   static double calculateCODCharges(double orderAmount) {
//     if (orderAmount >= 1000) return 0.0;
//     if (orderAmount >= 500) return 25.0;
//     return 40.0;
//   }

//   static DateTime getEstimatedDeliveryDate(String pincode) {
//     const Map<String, int> deliveryDays = {
//       '400001': 1, '400002': 1, '400003': 1,
//       '110001': 2, '110002': 2, '110003': 2,
//       '560001': 2, '560002': 2, '560003': 2,
//     };
    
//     final days = deliveryDays[pincode] ?? 3;
//     return DateTime.now().add(Duration(days: days));
//   }
// }


import 'dart:math';
import 'package:flutter/material.dart';
import 'package:payu_upi_flutter/PayUUPIConstantKeys.dart';
import 'package:payu_upi_flutter/payu_upi_flutter.dart';

class Payupaymentmethod extends StatefulWidget {
  const Payupaymentmethod({Key? key}) : super(key: key);

  @override
  _UpiPaymentPageState createState() => _UpiPaymentPageState();
}

class _UpiPaymentPageState extends State<Payupaymentmethod> implements PayUUPIProtocol {
  late PayUUpiFlutter payUUpi;
  final _formKey = GlobalKey<FormState>();

  // Sample input fields
  String _firstName = '';
  String _email = '';
  String _phone = '';
  String _amount = '';
  String _productInfo = '';
  String _transactionId = '';

  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    payUUpi = PayUUpiFlutter(this);
  }

  // Generate a random transaction ID (or get from backend)
  String _generateTxnId() {
    final now = DateTime.now();
    final rnd = Random().nextInt(1000000);
    return 'txn${now.millisecondsSinceEpoch}$rnd';
  }

  // This should be called after getting hash from your server
  Future<String> _getHashFromBackend({
    required String key,
    required String txnId,
    required String amount,
    required String productInfo,
    required String firstName,
    required String email,
  }) async {

    await Future.delayed(const Duration(seconds: 1));
    return "GENERATED_HASH_FROM_SERVER";
  }

  void _startPayment() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    _transactionId = _generateTxnId();

    // Merchant key etc - replace with your actual values
    const String merchantKey = "8751263";
    const String androidSurl = "https://yourdomain.com/android_success";
    const String androidFurl = "https://yourdomain.com/android_failure";
    const String iosSurl = "https://yourdomain.com/ios_success";
    const String iosFurl = "https://yourdomain.com/ios_failure";

    // Generate hash via backend
    String hash = await _getHashFromBackend(
      key: merchantKey,
      txnId: _transactionId,
      amount: _amount,
      productInfo: _productInfo,
      firstName: _firstName,
      email: _email,
    );

    // Prepare params
    final paymentParams = {
      // required
      'key': merchantKey,
      'transaction_id': _transactionId,
      'amount': _amount,
      'product_info': _productInfo,
      'first_name': _firstName,
      'email': _email,
      'phone': _phone,

      // success/failure URLs
      'android_surl': androidSurl,
      'android_furl': androidFurl,
      'ios_surl': iosSurl,
      'ios_furl': iosFurl,

      // environment: "0" => production, "1" => test
      'environment': "0",

      // the hash from backend
      'hash': hash,

      // payment mode: "INTENT" (will open UPI apps) or "upi"
      'payment_mode': "INTENT",
    };

    try {
      await payUUpi.makeUPIPayment(params: paymentParams);
    } catch (e) {
      setState(() {
        _statusMessage = "Error initiating payment: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void onPayUUPIMakePayment(Map response) {
    setState(() {
      _isLoading = false;
    });

    final String eventType = response[PayUEventType.eventType] ?? "";
    final eventResponse = response[PayUEventType.eventResponse];

    switch (eventType) {
      case PayUEventType.onPaymentSuccess:
        setState(() {
          _statusMessage = "Payment Success!\nDetails: $eventResponse";
        });
        break;
      case PayUEventType.onPaymentFailure:
        setState(() {
          _statusMessage = "Payment Failed!\nDetails: $eventResponse";
        });
        break;
      case PayUEventType.onErrorReceived:
        setState(() {
          _statusMessage = "Error received: $eventResponse";
        });
        break;
      case PayUEventType.onPaymentTerminate:
        setState(() {
          _statusMessage = "Payment Terminated by user.";
        });
        break;
      default:
        setState(() {
          _statusMessage = "Unknown event: $eventType, response: $eventResponse";
        });
    }
  }

  @override
  void onPayUUPIValidateVPA(Map response) {
    // Optionally implement VPA validation if you allow user to enter VPA
    // Or ignore if you’re using intent flow where UPI app handles this
    final String eventType = response[PayUEventType.eventType] ?? "";
    final eventResponse = response[PayUEventType.eventResponse];
    setState(() {
      _statusMessage = "Validate VPA: $eventType, $eventResponse";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UPI Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Enter name' : null,
                      onSaved: (val) => _firstName = val!.trim(),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) =>
                          val == null || !val.contains('@') ? 'Enter valid email' : null,
                      onSaved: (val) => _email = val!.trim(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (val) =>
                          val == null || val.trim().length < 10 ? 'Enter valid phone' : null,
                      onSaved: (val) => _phone = val!.trim(),
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Amount'),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Enter amount' : null,
                      onSaved: (val) => _amount = val!.trim(),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Product Info'),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Enter product info' : null,
                      onSaved: (val) => _productInfo = val!.trim(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _startPayment,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Pay with UPI"),
                    ),
                    const SizedBox(height: 20),
                    if (_statusMessage.isNotEmpty)
                      Text(
                        _statusMessage,
                        style: const TextStyle(color: Colors.black),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
