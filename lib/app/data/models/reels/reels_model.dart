// To parse this JSON data, do
//
//     final reelsModel = reelsModelFromJson(jsonString);

import 'dart:convert';

ReelsModel reelsModelFromJson(String str) => ReelsModel.fromJson(json.decode(str));

String reelsModelToJson(ReelsModel data) => json.encode(data.toJson());

class ReelsModel {
    final bool? success;
    final int? total;
    final List<ReelsData>? data;

    ReelsModel({
        this.success,
        this.total,
        this.data,
    });

    ReelsModel copyWith({
        bool? success,
        int? total,
        List<ReelsData>? data,
    }) => 
        ReelsModel(
            success: success ?? this.success,
            total: total ?? this.total,
            data: data ?? this.data,
        );

    factory ReelsModel.fromJson(Map<String, dynamic> json) => ReelsModel(
        success: json["success"],
        total: json["total"],
        data: json["data"] == null ? [] : List<ReelsData>.from(json["data"]!.map((x) => ReelsData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "total": total,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class ReelsData {
    final int? reelId;
    final int? creatorId;
    final String? title;
    final String? description;
    final String? videoUrl;
    final int? duration;
    final String? category;
    final String? tags;
    final int? viewCount;
    final int? likeCount;
    final int? shareCount;
    final int? commentCount;
    final bool? isActive;
    final bool? isFeatured;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? youTubeThumbUrl;

    ReelsData({
        this.reelId,
        this.creatorId,
        this.title,
        this.description,
        this.videoUrl,
        this.duration,
        this.category,
        this.tags,
        this.viewCount,
        this.likeCount,
        this.commentCount,
        this.shareCount,
        this.isActive,
        this.isFeatured,
        this.createdAt,
        this.updatedAt,
        this.youTubeThumbUrl,
    });

    ReelsData copyWith({
        int? reelId,
        int? creatorId,
        String? title,
        String? description,
        String? videoUrl,
        int? duration,
        String? category,
        String? tags,
        int? viewCount,
        int? shareCount,
        int? likeCount,
        int? commentCount,
        bool? isActive,
        bool? isFeatured,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? youTubeThumbUrl,
    }) => 
        ReelsData(
            reelId: reelId ?? this.reelId,
            creatorId: creatorId ?? this.creatorId,
            title: title ?? this.title,
            description: description ?? this.description,
            videoUrl: videoUrl ?? this.videoUrl,
            duration: duration ?? this.duration,
            category: category ?? this.category,
            tags: tags ?? this.tags,
            viewCount: viewCount ?? this.viewCount,
            likeCount: likeCount ?? this.likeCount,
            shareCount: shareCount??this.shareCount,
            commentCount: commentCount ?? this.commentCount,
            isActive: isActive ?? this.isActive,
            isFeatured: isFeatured ?? this.isFeatured,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            youTubeThumbUrl: youTubeThumbUrl ?? this.youTubeThumbUrl,
        );

    factory ReelsData.fromJson(Map<String, dynamic> json) => ReelsData(
        reelId: json["ReelID"],
        creatorId: json["CreatorID"],
        title: json["Title"],
        description: json["Description"],
        videoUrl: json["VideoURL"],
        duration: json["Duration"],
        category: json["Category"],
        tags: json["Tags"],
        shareCount: json["ShareCount"],
        viewCount: json["ViewCount"],
        likeCount: json["LikeCount"],
        commentCount: json["CommentCount"],
        isActive: json["IsActive"],
        isFeatured: json["IsFeatured"],
        createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
        updatedAt: json["UpdatedAt"] == null ? null : DateTime.parse(json["UpdatedAt"]),
        youTubeThumbUrl: json["YouTubeThumbURL"],
    );

    Map<String, dynamic> toJson() => {
        "ReelID": reelId,
        "CreatorID": creatorId,
        "Title": title,
        "Description": description,
        "VideoURL": videoUrl,
        "Duration": duration,
        "Category": category,
        "Tags": tags,
        "ViewCount": viewCount,
        "LikeCount": likeCount,
        "CommentCount": commentCount,
        "IsActive": isActive,
        "IsFeatured": isFeatured,
        "CreatedAt": createdAt?.toIso8601String(),
        "UpdatedAt": updatedAt?.toIso8601String(),
        "YouTubeThumbURL": youTubeThumbUrl,
    };
}
