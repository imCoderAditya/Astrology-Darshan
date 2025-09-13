// To parse this JSON data, do
//
//     final cartEcModel = cartEcModelFromJson(jsonString);

import 'dart:convert';

CartEcModel cartEcModelFromJson(String str) => CartEcModel.fromJson(json.decode(str));

String cartEcModelToJson(CartEcModel data) => json.encode(data.toJson());

class CartEcModel {
    final bool? success;
    final CartEc? data;

    CartEcModel({
        this.success,
        this.data,
    });

    CartEcModel copyWith({
        bool? success,
        CartEc? data,
    }) => 
        CartEcModel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory CartEcModel.fromJson(Map<String, dynamic> json) => CartEcModel(
        success: json["success"],
        data: json["data"] == null ? null : CartEc.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class CartEc {
    final List<CartItem>? cartItems;
    final Summary? summary;

    CartEc({
        this.cartItems,
        this.summary,
    });

    CartEc copyWith({
        List<CartItem>? cartItems,
        Summary? summary,
    }) => 
        CartEc(
            cartItems: cartItems ?? this.cartItems,
            summary: summary ?? this.summary,
        );

    factory CartEc.fromJson(Map<String, dynamic> json) => CartEc(
        cartItems: json["cartItems"] == null ? [] : List<CartItem>.from(json["cartItems"]!.map((x) => CartItem.fromJson(x))),
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    );

    Map<String, dynamic> toJson() => {
        "cartItems": cartItems == null ? [] : List<dynamic>.from(cartItems!.map((x) => x.toJson())),
        "summary": summary?.toJson(),
    };
}

class CartItem {
    final int? cartId;
    final int? productId;
    final String? productName;
    final String? productImage;
    final double? price;
    final int? quantity;
    final double? totalPrice;
    final bool? isInStock;
    final int? maxQuantity;

    CartItem({
        this.cartId,
        this.productId,
        this.productName,
        this.productImage,
        this.price,
        this.quantity,
        this.totalPrice,
        this.isInStock,
        this.maxQuantity,
    });

    CartItem copyWith({
        int? cartId,
        int? productId,
        String? productName,
        String? productImage,
        double? price,
        int? quantity,
        double? totalPrice,
        bool? isInStock,
        int? maxQuantity,
    }) => 
        CartItem(
            cartId: cartId ?? this.cartId,
            productId: productId ?? this.productId,
            productName: productName ?? this.productName,
            productImage: productImage ?? this.productImage,
            price: price ?? this.price,
            quantity: quantity ?? this.quantity,
            totalPrice: totalPrice ?? this.totalPrice,
            isInStock: isInStock ?? this.isInStock,
            maxQuantity: maxQuantity ?? this.maxQuantity,
        );

    factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        cartId: json["CartID"],
        productId: json["ProductID"],
        productName: json["ProductName"],
        productImage: json["ProductImage"],
        price: json["Price"]?.toDouble(),
        quantity: json["Quantity"],
        totalPrice: json["TotalPrice"]?.toDouble(),
        isInStock: json["IsInStock"],
        maxQuantity: json["MaxQuantity"],
    );

    Map<String, dynamic> toJson() => {
        "CartID": cartId,
        "ProductID": productId,
        "ProductName": productName,
        "ProductImage": productImage,
        "Price": price,
        "Quantity": quantity,
        "TotalPrice": totalPrice,
        "IsInStock": isInStock,
        "MaxQuantity": maxQuantity,
    };
}

class Summary {
    final int? itemCount;
    final double? subtotal;
    final double? shipping;
    final double? total;

    Summary({
        this.itemCount,
        this.subtotal,
        this.shipping,
        this.total,
    });

    Summary copyWith({
        int? itemCount,
        double? subtotal,
        double? shipping,
        double? total,
    }) => 
        Summary(
            itemCount: itemCount ?? this.itemCount,
            subtotal: subtotal ?? this.subtotal,
            shipping: shipping ?? this.shipping,
            total: total ?? this.total,
        );

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        itemCount: json["itemCount"],
        subtotal: json["subtotal"]?.toDouble(),
        shipping: json["shipping"]?.toDouble(),
        total: json["total"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "itemCount": itemCount,
        "subtotal": subtotal,
        "shipping": shipping,
        "total": total,
    };
}
