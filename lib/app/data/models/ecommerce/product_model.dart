// To parse this JSON data, do
//
//     final productEcModel = productEcModelFromJson(jsonString);

import 'dart:convert';

ProductEcModel productEcModelFromJson(String str) => ProductEcModel.fromJson(json.decode(str));

String productEcModelToJson(ProductEcModel data) => json.encode(data.toJson());

class ProductEcModel {
    final bool? success;
    final Data? data;

    ProductEcModel({
        this.success,
        this.data,
    });

    ProductEcModel copyWith({
        bool? success,
        Data? data,
    }) => 
        ProductEcModel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory ProductEcModel.fromJson(Map<String, dynamic> json) => ProductEcModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    final List<Product>? products;
    final Pagination? pagination;

    Data({
        this.products,
        this.pagination,
    });

    Data copyWith({
        List<Product>? products,
        Pagination? pagination,
    }) => 
        Data(
            products: products ?? this.products,
            pagination: pagination ?? this.pagination,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    );

    Map<String, dynamic> toJson() => {
        "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
    };
}

class Pagination {
    final int? currentPage;
    final int? totalPages;
    final int? totalItems;
    final int? itemsPerPage;

    Pagination({
        this.currentPage,
        this.totalPages,
        this.totalItems,
        this.itemsPerPage,
    });

    Pagination copyWith({
        int? currentPage,
        int? totalPages,
        int? totalItems,
        int? itemsPerPage,
    }) => 
        Pagination(
            currentPage: currentPage ?? this.currentPage,
            totalPages: totalPages ?? this.totalPages,
            totalItems: totalItems ?? this.totalItems,
            itemsPerPage: itemsPerPage ?? this.itemsPerPage,
        );

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        currentPage: json["currentPage"],
        totalPages: json["totalPages"],
        totalItems: json["totalItems"],
        itemsPerPage: json["itemsPerPage"],
    );

    Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "totalPages": totalPages,
        "totalItems": totalItems,
        "itemsPerPage": itemsPerPage,
    };
}

class Product {
    final int? productId;
    final String? productName;
    final String? description;
    final String? shortDescription;
    final double? price;
    final int? stock;
    final String? sku;
    final double? rating;
    final int? reviewCount;
    final bool? isFeatured;
    final bool? isPhysical;
    final bool? requiresShipping;
    final List<ImageList>? images;
    final Category? category;

    Product({
        this.productId,
        this.productName,
        this.description,
        this.shortDescription,
        this.price,
        this.stock,
        this.sku,
        this.rating,
        this.reviewCount,
        this.isFeatured,
        this.isPhysical,
        this.requiresShipping,
        this.images,
        this.category,
    });

    Product copyWith({
        int? productId,
        String? productName,
        String? description,
        String? shortDescription,
        double? price,
        int? stock,
        String? sku,
        double? rating,
        int? reviewCount,
        bool? isFeatured,
        bool? isPhysical,
        bool? requiresShipping,
        List<ImageList>? images,
        Category? category,
    }) => 
        Product(
            productId: productId ?? this.productId,
            productName: productName ?? this.productName,
            description: description ?? this.description,
            shortDescription: shortDescription ?? this.shortDescription,
            price: price ?? this.price,
            stock: stock ?? this.stock,
            sku: sku ?? this.sku,
            rating: rating ?? this.rating,
            reviewCount: reviewCount ?? this.reviewCount,
            isFeatured: isFeatured ?? this.isFeatured,
            isPhysical: isPhysical ?? this.isPhysical,
            requiresShipping: requiresShipping ?? this.requiresShipping,
            images: images ?? this.images,
            category: category ?? this.category,
        );

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["ProductID"],
        productName: json["ProductName"],
        description: json["Description"],
        shortDescription: json["ShortDescription"],
        price: json["Price"]?.toDouble(),
        stock: json["Stock"],
        sku: json["SKU"],
        rating: json["Rating"]?.toDouble(),
        reviewCount: json["ReviewCount"],
        isFeatured: json["IsFeatured"],
        isPhysical: json["IsPhysical"],
        requiresShipping: json["RequiresShipping"],
        images: json["Images"] == null ? [] : List<ImageList>.from(json["Images"]!.map((x) => ImageList.fromJson(x))),
        category: json["Category"] == null ? null : Category.fromJson(json["Category"]),
    );

    Map<String, dynamic> toJson() => {
        "ProductID": productId,
        "ProductName": productName,
        "Description": description,
        "ShortDescription": shortDescription,
        "Price": price,
        "Stock": stock,
        "SKU": sku,
        "Rating": rating,
        "ReviewCount": reviewCount,
        "IsFeatured": isFeatured,
        "IsPhysical": isPhysical,
        "RequiresShipping": requiresShipping,
        "Images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
        "Category": category?.toJson(),
    };
}

class Category {
    final int? categoryId;
    final String? categoryName;

    Category({
        this.categoryId,
        this.categoryName,
    });

    Category copyWith({
        int? categoryId,
        String? categoryName,
    }) => 
        Category(
            categoryId: categoryId ?? this.categoryId,
            categoryName: categoryName ?? this.categoryName,
        );

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
    );

    Map<String, dynamic> toJson() => {
        "CategoryID": categoryId,
        "CategoryName": categoryName,
    };
}

class ImageList {
    final int? imageId;
    final String? imageUrl;

    ImageList({
        this.imageId,
        this.imageUrl,
    });

    ImageList copyWith({
        int? imageId,
        String? imageUrl,
    }) => 
        ImageList(
            imageId: imageId ?? this.imageId,
            imageUrl: imageUrl ?? this.imageUrl,
        );

    factory ImageList.fromJson(Map<String, dynamic> json) => ImageList(
        imageId: json["ImageID"],
        imageUrl: json["ImageURL"],
    );

    Map<String, dynamic> toJson() => {
        "ImageID": imageId,
        "ImageURL": imageUrl,
    };
}
