// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) => WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
    final bool? status;
    final String? message;
    final Customer? customer;
    final List<Transaction>? transactions;

    WalletModel({
        this.status,
        this.message,
        this.customer,
        this.transactions,
    });

    WalletModel copyWith({
        bool? status,
        String? message,
        Customer? customer,
        List<Transaction>? transactions,
    }) => 
        WalletModel(
            status: status ?? this.status,
            message: message ?? this.message,
            customer: customer ?? this.customer,
            transactions: transactions ?? this.transactions,
        );

    factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        status: json["status"],
        message: json["message"],
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "customer": customer?.toJson(),
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    };
}

class Customer {
    final int? customerId;
    final int? userId;
    final double? walletBalance;
    final double? totalSpent;
    final String? preferredLanguage;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final User? user;

    Customer({
        this.customerId,
        this.userId,
        this.walletBalance,
        this.totalSpent,
        this.preferredLanguage,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    Customer copyWith({
        int? customerId,
        int? userId,
        double? walletBalance,
        double? totalSpent,
        String? preferredLanguage,
        DateTime? createdAt,
        DateTime? updatedAt,
        User? user,
    }) => 
        Customer(
            customerId: customerId ?? this.customerId,
            userId: userId ?? this.userId,
            walletBalance: walletBalance ?? this.walletBalance,
            totalSpent: totalSpent ?? this.totalSpent,
            preferredLanguage: preferredLanguage ?? this.preferredLanguage,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
        );

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        customerId: json["CustomerID"],
        userId: json["UserID"],
        walletBalance: json["WalletBalance"]?.toDouble(),
        totalSpent: json["TotalSpent"]?.toDouble(),
        preferredLanguage: json["PreferredLanguage"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
        user: json["User"] == null ? null : User.fromJson(json["User"]),
    );

    Map<String, dynamic> toJson() => {
        "CustomerID": customerId,
        "UserID": userId,
        "WalletBalance": walletBalance,
        "TotalSpent": totalSpent,
        "PreferredLanguage": preferredLanguage,
        "CreatedAt": createdAt?.toIso8601String(),
        "UpdatedAt": updatedAt?.toIso8601String(),
        "User": user?.toJson(),
    };
}

class User {
    final int? userId;
    final String? email;
    final bool? isActive;
    final bool? isVerified;

    User({
        this.userId,
        this.email,
        this.isActive,
        this.isVerified,
    });

    User copyWith({
        int? userId,
        String? email,
        bool? isActive,
        bool? isVerified,
    }) => 
        User(
            userId: userId ?? this.userId,
            email: email ?? this.email,
            isActive: isActive ?? this.isActive,
            isVerified: isVerified ?? this.isVerified,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["UserID"],
        email: json["Email"],
        isActive: json["IsActive"],
        isVerified: json["IsVerified"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "Email": email,
        "IsActive": isActive,
        "IsVerified": isVerified,
    };
}

class Transaction {
    final int? transactionId;
    final String? transactionType;
    final double? amount;
    final String? description;
    final String? reference;
    final String? status;
    final DateTime? createdAt;
    final double? gst;
    final double? totalWithGst;

    Transaction({
        this.transactionId,
        this.transactionType,
        this.amount,
        this.description,
        this.reference,
        this.status,
        this.createdAt,
        this.gst,
        this.totalWithGst,
    });

    Transaction copyWith({
        int? transactionId,
        String? transactionType,
        double? amount,
        String? description,
        String? reference,
        String? status,
        DateTime? createdAt,
        double? gst,
        double? totalWithGst,
    }) => 
        Transaction(
            transactionId: transactionId ?? this.transactionId,
            transactionType: transactionType ?? this.transactionType,
            amount: amount ?? this.amount,
            description: description ?? this.description,
            reference: reference ?? this.reference,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            gst: gst ?? this.gst,
            totalWithGst: totalWithGst ?? this.totalWithGst,
        );

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        transactionId: json["TransactionID"],
        transactionType: json["TransactionType"],
        amount: json["Amount"]?.toDouble(),
        description: json["Description"],
        reference: json["Reference"],
        status: json["Status"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        gst: json["Gst"]?.toDouble(),
        totalWithGst: json["TotalWithGst"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "TransactionID": transactionId,
        "TransactionType": transactionType,
        "Amount": amount,
        "Description": description,
        "Reference": reference,
        "Status": status,
        "CreatedAt": createdAt?.toIso8601String(),
        "Gst": gst,
        "TotalWithGst": totalWithGst,
    };
}
