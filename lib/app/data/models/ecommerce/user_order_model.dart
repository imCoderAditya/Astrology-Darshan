// To parse this JSON data, do
//
//     final userOrderModel = userOrderModelFromJson(jsonString);

import 'dart:convert';

UserOrderModel userOrderModelFromJson(String str) =>
    UserOrderModel.fromJson(json.decode(str));

String userOrderModelToJson(UserOrderModel data) => json.encode(data.toJson());

class UserOrderModel {
  final bool? success;
  final UserOrder? data;

  UserOrderModel({this.success, this.data});

  UserOrderModel copyWith({bool? success, UserOrder? data}) =>
      UserOrderModel(success: success ?? this.success, data: data ?? this.data);

  factory UserOrderModel.fromJson(Map<String, dynamic> json) => UserOrderModel(
    success: json["success"],
    data: json["data"] == null ? null : UserOrder.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class UserOrder {
  final int? currentPage;
  final int? totalPages;
  final int? totalOrders;
  final List<Order>? orders;

  UserOrder({this.currentPage, this.totalPages, this.totalOrders, this.orders});

  UserOrder copyWith({
    int? currentPage,
    int? totalPages,
    int? totalOrders,
    List<Order>? orders,
  }) => UserOrder(
    currentPage: currentPage ?? this.currentPage,
    totalPages: totalPages ?? this.totalPages,
    totalOrders: totalOrders ?? this.totalOrders,
    orders: orders ?? this.orders,
  );

  factory UserOrder.fromJson(Map<String, dynamic> json) => UserOrder(
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    totalOrders: json["totalOrders"],
    orders:
        json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "currentPage": currentPage,
    "totalPages": totalPages,
    "totalOrders": totalOrders,
    "orders":
        orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
  };
}

class Order {
  final int? orderId;
  final String? orderNumber;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethod;
  final double? subTotal;
  final double? taxAmount;
  final double? shippingAmount;
  final double? discountAmount;
  final double? totalAmount;
  final dynamic couponCode;
  final dynamic notes;
  final ShippingAddress? shippingAddress;
  final dynamic trackingNumber;
  final dynamic estimatedDelivery;
  final dynamic deliveredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem>? orderItems;

  Order({
    this.orderId,
    this.orderNumber,
    this.status,
    this.paymentStatus,
    this.paymentMethod,
    this.subTotal,
    this.taxAmount,
    this.shippingAmount,
    this.discountAmount,
    this.totalAmount,
    this.couponCode,
    this.notes,
    this.shippingAddress,
    this.trackingNumber,
    this.estimatedDelivery,
    this.deliveredAt,
    this.createdAt,
    this.updatedAt,
    this.orderItems,
  });

  Order copyWith({
    int? orderId,
    String? orderNumber,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    double? subTotal,
    double? taxAmount,
    double? shippingAmount,
    double? discountAmount,
    double? totalAmount,
    dynamic couponCode,
    dynamic notes,
    ShippingAddress? shippingAddress,
    dynamic trackingNumber,
    dynamic estimatedDelivery,
    dynamic deliveredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItem>? orderItems,
  }) => Order(
    orderId: orderId ?? this.orderId,
    orderNumber: orderNumber ?? this.orderNumber,
    status: status ?? this.status,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    subTotal: subTotal ?? this.subTotal,
    taxAmount: taxAmount ?? this.taxAmount,
    shippingAmount: shippingAmount ?? this.shippingAmount,
    discountAmount: discountAmount ?? this.discountAmount,
    totalAmount: totalAmount ?? this.totalAmount,
    couponCode: couponCode ?? this.couponCode,
    notes: notes ?? this.notes,
    shippingAddress: shippingAddress ?? this.shippingAddress,
    trackingNumber: trackingNumber ?? this.trackingNumber,
    estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
    deliveredAt: deliveredAt ?? this.deliveredAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    orderItems: orderItems ?? this.orderItems,
  );

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["OrderID"],
    orderNumber: json["OrderNumber"],
    status: json["Status"],
    paymentStatus: json["PaymentStatus"],
    paymentMethod: json["PaymentMethod"],
    subTotal: json["SubTotal"],
    taxAmount: json["TaxAmount"],
    shippingAmount: json["ShippingAmount"],
    discountAmount: json["DiscountAmount"],
    totalAmount: json["TotalAmount"],
    couponCode: json["CouponCode"],
    notes: json["Notes"],
    shippingAddress:
        json["ShippingAddress"] == null
            ? null
            : ShippingAddress.fromJson(json["ShippingAddress"]),
    trackingNumber: json["TrackingNumber"],
    estimatedDelivery: json["EstimatedDelivery"],
    deliveredAt: json["DeliveredAt"],
    createdAt:
        json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    updatedAt:
        json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
    orderItems:
        json["OrderItems"] == null
            ? []
            : List<OrderItem>.from(
              json["OrderItems"]!.map((x) => OrderItem.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "OrderID": orderId,
    "OrderNumber": orderNumber,
    "Status": status,
    "PaymentStatus": paymentStatus,
    "PaymentMethod": paymentMethod,
    "SubTotal": subTotal,
    "TaxAmount": taxAmount,
    "ShippingAmount": shippingAmount,
    "DiscountAmount": discountAmount,
    "TotalAmount": totalAmount,
    "CouponCode": couponCode,
    "Notes": notes,
    "ShippingAddress": shippingAddress?.toJson(),
    "TrackingNumber": trackingNumber,
    "EstimatedDelivery": estimatedDelivery,
    "DeliveredAt": deliveredAt,
    "CreatedAt": createdAt?.toIso8601String(),
    "UpdatedAt": updatedAt?.toIso8601String(),
    "OrderItems":
        orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
  };
}

class OrderItem {
  final int? orderItemId;
  final int? productId;
  final String? productName;
  final int? quantity;
  final double? price;
  final double? totalPrice;
  final DateTime? createdAt;
  final String? mainImage;

  OrderItem({
    this.orderItemId,
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.totalPrice,
    this.createdAt,
    this.mainImage,
  });

  OrderItem copyWith({
    int? orderItemId,
    int? productId,
    String? productName,
    int? quantity,
    double? price,
    double? totalPrice,
    DateTime? createdAt,
    String? mainImage,
  }) => OrderItem(
    orderItemId: orderItemId ?? this.orderItemId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    totalPrice: totalPrice ?? this.totalPrice,
    createdAt: createdAt ?? this.createdAt,
    mainImage: mainImage ?? this.mainImage,
  );

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    orderItemId: json["OrderItemID"],
    productId: json["ProductID"],
    productName: json["ProductName"],
    quantity: json["Quantity"],
    price: json["Price"],
    totalPrice: json["TotalPrice"],
    createdAt:
        json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    mainImage: json["MainImage"],
  );

  Map<String, dynamic> toJson() => {
    "OrderItemID": orderItemId,
    "ProductID": productId,
    "ProductName": productName,
    "Quantity": quantity,
    "Price": price,
    "TotalPrice": totalPrice,
    "CreatedAt": createdAt?.toIso8601String(),
    "MainImage": mainImage,
  };
}

class ShippingAddress {
  final String? firstName;
  final String? lastName;
  final String? house;
  final String? gali;
  final String? nearLandmark;
  final String? address2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String? phoneNumber;
  final String? address1;

  ShippingAddress({
    this.firstName,
    this.lastName,
    this.house,
    this.gali,
    this.nearLandmark,
    this.address2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.phoneNumber,
    this.address1,
  });

  ShippingAddress copyWith({
    String? firstName,
    String? lastName,
    String? house,
    String? gali,
    String? nearLandmark,
    String? address2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phoneNumber,
    String? address1,
  }) => ShippingAddress(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    house: house ?? this.house,
    gali: gali ?? this.gali,
    nearLandmark: nearLandmark ?? this.nearLandmark,
    address2: address2 ?? this.address2,
    city: city ?? this.city,
    state: state ?? this.state,
    postalCode: postalCode ?? this.postalCode,
    country: country ?? this.country,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    address1: address1 ?? this.address1,
  );

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        firstName: json["firstName"],
        lastName: json["lastName"],
        house: json["house"],
        gali: json["gali"],
        nearLandmark: json["Near Landmark"],
        address2: json["address2"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postalCode"],
        country: json["country"],
        phoneNumber: json["phoneNumber"],
        address1: json["address1"],
      );

  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "lastName": lastName,
    "house": house,
    "gali": gali,
    "Near Landmark": nearLandmark,
    "address2": address2,
    "city": city,
    "state": state,
    "postalCode": postalCode,
    "country": country,
    "phoneNumber": phoneNumber,
    "address1": address1,
  };
}
