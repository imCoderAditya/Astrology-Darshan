// ignore_for_file: deprecated_member_use

import 'package:astrology/app/core/config/theme/app_colors.dart';
import 'package:astrology/app/core/config/theme/theme_controller.dart';
import 'package:astrology/app/data/models/reels/reels_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/reels_controller.dart';

class ReelsView extends GetView<ReelsController> {
  final bool? isPlay;
  ReelsView({super.key, this.isPlay = false});

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReelsController>(
      init: ReelsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: PageView.builder(
            pageSnapping: true,
            allowImplicitScrolling: true,
            scrollDirection: Axis.vertical,
            itemCount: controller.reelsModel.value?.data?.length,
            onPageChanged: (index) {
              controller.setCurrentIndex(index);
            },
            itemBuilder: (context, index) {
              return ReelItem(
                reel: controller.reelsModel.value?.data?[index],
                isCurrentPage: controller.currentIndex == index,
                isPlay: isPlay,
              );
            },
          ),
        );
      },
    );
  }
}

class ReelItem extends StatefulWidget {
  final ReelsData? reel;
  final bool isCurrentPage;
  final bool? isPlay;

  const ReelItem({
    super.key,
    this.reel,
    required this.isCurrentPage,
    this.isPlay = false,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem>
    with SingleTickerProviderStateMixin {
  YoutubePlayerController? _youtubeController;
  late AnimationController _animationController;
  bool _isLiked = false;
  // bool _isFollowing = false;
  bool _showHeart = false;
  ScrollController scrollController = ScrollController();
  final reelsController = Get.put(ReelsController(), permanent: true);
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _initializeVideo();
  }

  void _initializeVideo() {
    final videoId = YoutubePlayer.convertUrlToId(widget.reel?.videoUrl ?? "");

    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: true,
          enableCaption: false,
          captionLanguage: 'en',
          showLiveFullscreenButton: false,
          controlsVisibleAtStart: false,
          hideControls: true,
        ),
      );
    }

    if (_youtubeController != null) {
      reelsController.setYoutubeController(_youtubeController!);
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    setState(() {
      _isLiked = !_isLiked;
      _showHeart = true;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showHeart = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_youtubeController != null) {
      if (_youtubeController!.value.isPlaying) {
        _youtubeController?.pause();
      } else {
        _youtubeController?.play();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // YouTube Video Player
        GestureDetector(
          onDoubleTap: _onDoubleTap,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child:
                _youtubeController != null
                    ? YoutubePlayerBuilder(
                      player: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        bottomActions: const [],
                        topActions: const [],
                        aspectRatio: 9 / 16,
                        onReady: () {
                          if (widget.isCurrentPage) {
                            _youtubeController?.play();
                          }
                        },
                      ),
                      builder: (context, player) {
                        return SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: FittedBox(fit: BoxFit.cover, child: player),
                        );
                      },
                    )
                    : Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.black38,
                Colors.black54,
              ],
              stops: [0.0, 0.5, 0.8, 1.0],
            ),
          ),
        ),

        // Top Bar
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reels',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const Icon(
                //   Icons.camera_alt_outlined,
                //   color: Colors.white,
                //   size: 28,
                // ),
              ],
            ),
          ),
        ),

        // Bottom Content
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Left side content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              widget.reel?.youTubeThumbUrl ?? "",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.reel?.title ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // if (!_isFollowing)
                          //   GestureDetector(
                          //     onTap: () {
                          //       setState(() {
                          //         _isFollowing = !_isFollowing;
                          //       });
                          //     },
                          //     child: Container(
                          //       padding: const EdgeInsets.symmetric(
                          //         horizontal: 12,
                          //         vertical: 4,
                          //       ),
                          //       decoration: BoxDecoration(
                          //         border: Border.all(color: Colors.white),
                          //         borderRadius: BorderRadius.circular(4),
                          //       ),
                          //       child: const Text(
                          //         'Follow',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        widget.reel?.description ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Music/Audio
                      Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.reel?.category ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right side actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Like button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.red : Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.reel?.likeCount == 0
                                ? ""
                                : widget.reel?.likeCount.toString() ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Comment button
                    GestureDetector(
                      onTap: () {
                        _showCommentSheet(context);
                      },
                      child: Column(
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.reel?.commentCount == 0
                                ? ""
                                : widget.reel?.commentCount.toString() ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Share button
                    GestureDetector(
                      onTap: () {
                        // Handle share functionality
                      },
                      child: Column(
                        children: [
                          const Icon(Icons.send, color: Colors.white, size: 32),
                          const SizedBox(height: 4),
                          Text(
                            widget.reel?.shareCount == 0
                                ? ""
                                : widget.reel?.shareCount.toString() ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // More options
                    const Icon(Icons.more_vert, color: Colors.white, size: 32),
                    const SizedBox(height: 24),

                    // Rotating music disc
                    GestureDetector(
                      onTap: () {
                        // Handle music tap
                      },
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _animationController.value * 2 * 3.14159,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    widget.reel?.youTubeThumbUrl ?? "",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Heart animation for double tap
        if (_showHeart)
          Center(
            child: AnimatedOpacity(
              opacity: _showHeart ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: const Icon(Icons.favorite, color: Colors.red, size: 80),
            ),
          ),

        Positioned(
          left: 0,
          right: 0,
          top: 40,
          bottom: 0,
          child: IconButton(
            onPressed: _togglePlayPause,
            icon: Icon(
              (_youtubeController?.value.isPlaying ?? true)
                  ? Icons.play_arrow
                  : null,
              color: AppColors.white.withValues(alpha: 0.4),
            ),
          ),
        ),
      ],
    );
  }

  void _showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentSheet(reel: widget.reel),
    );
  }
}

class CommentSheet extends StatelessWidget {
  final ReelsData? reel;

  const CommentSheet({super.key, required this.reel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '100 comments',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.close),
              ],
            ),
          ),

          const Divider(height: 1),

          // Comments list
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Sample comments
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/32/32?random=$index',
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'user_$index ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: 'This is a sample comment'),
                      ],
                    ),
                  ),
                  subtitle: const Text('2h'),
                  trailing: const Icon(Icons.favorite_border, size: 16),
                );
              },
            ),
          ),

          // Comment input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://picsum.photos/32/32'),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const Icon(Icons.send, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Add this to your ReelsController class



// extension ReelsControllerExtension on ReelsController {
//   // int get currentIndex => _currentIndex;

//   // void setCurrentIndex(int index) {
//   //   _currentIndex = index;
//   //   update();
//   // }

//   List<ReelModel> get reels => [
//     ReelModel(
//       id: '1',
//       videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
//       userAvatar: 'https://picsum.photos/100/100?random=1',
//       username: 'astrology_user',
//       description: 'Amazing astrology facts that will blow your mind! ✨🔮 #astrology #zodiac',
//       musicName: 'Original Audio - astrology_user',
//       musicCover: 'https://picsum.photos/100/100?random=music1',
//       likesCount: 1250,
//       commentsCount: 89,
//       sharesCount: 45,
//     ),
//     // ... other ReelModel instances ...
//   ];
// }









// Native player Used to Reels Section
// // ignore_for_file: deprecated_member_use

// import 'package:astrology/app/core/config/theme/theme_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';

// import '../controllers/reels_controller.dart';

// class ReelsView extends GetView<ReelsController> {
//   ReelsView({super.key});

//   final ThemeController themeController = Get.find<ThemeController>();

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ReelsController>(
//       init: ReelsController(),
//       builder: (controller) {
//         return Scaffold(
//           backgroundColor: Colors.black,
//           body: PageView.builder(
//             scrollDirection: Axis.vertical,
//             itemCount: controller.reels.length,
//             itemBuilder: (context, index) {
//               return ReelItem(reel: controller.reels[index], isCurrentPage: false);
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class ReelItem extends StatefulWidget {
//   final ReelModel reel;
//   final bool isCurrentPage;

//   const ReelItem({super.key, required this.reel, required this.isCurrentPage});

//   @override
//   State<ReelItem> createState() => _ReelItemState();
// }

// class _ReelItemState extends State<ReelItem> with SingleTickerProviderStateMixin {
//   VideoPlayerController? _videoController;
//   late AnimationController _animationController;
//   bool _isLiked = false;
//   bool _isFollowing = false;
//   bool _showHeart = false;
//   ScrollController scrollController = ScrollController();
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(duration: const Duration(seconds: 10), vsync: this)..repeat();

//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     _videoController = VideoPlayerController.network(widget.reel.videoUrl);

//     try {
//       await _videoController!.initialize();
//       if (!mounted) return;

//       setState(() {});

//       if (widget.isCurrentPage) {
//         _videoController?.play();
//         _videoController?.setLooping(true);
//       }
//     } catch (e) {
//       debugPrint('Video init error: $e');
//     }

//     // Set controller to ReelsController
//     Get.find<ReelsController>().setController(_videoController!);
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _animationController.dispose();

//     super.dispose();
//   }

//   void _onDoubleTap() {
//     setState(() {
//       _isLiked = !_isLiked;
//       _showHeart = true;
//     });

//     Future.delayed(const Duration(milliseconds: 1000), () {
//       if (mounted) {
//         setState(() {
//           _showHeart = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Video Player
//         GestureDetector(
//           onDoubleTap: _onDoubleTap,
//           onTap: () {
//             if (_videoController!.value.isPlaying) {
//               _videoController?.pause();
//             } else {
//               _videoController?.play();
//             }
//           },
//           child: SizedBox(
//             width: double.infinity,
//             height: double.infinity,
//             child:
//                 _videoController?.value.isInitialized == true
//                     ? FittedBox(
//                       fit: BoxFit.cover,
//                       child: SizedBox(
//                         width: _videoController!.value.size.width,
//                         height: _videoController!.value.size.height,
//                         child: VideoPlayer(_videoController!),
//                       ),
//                     )
//                     : Container(
//                       color: Colors.black,
//                       child: const Center(child: CircularProgressIndicator(color: Colors.white)),
//                     ),
//           ),
//         ),

//         // Gradient Overlay
//         Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.transparent, Colors.transparent, Colors.black38, Colors.black54],
//               stops: [0.0, 0.5, 0.8, 1.0],
//             ),
//           ),
//         ),

//         // Top Bar
//         Positioned(
//           top: 50,
//           left: 0,
//           right: 0,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Reels', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
//                 const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 28),
//               ],
//             ),
//           ),
//         ),

//         // Bottom Content
//         Positioned(
//           bottom: 0,
//           left: 0,
//           right: 0,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // Left side content
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       // User info
//                       Row(
//                         children: [
//                           CircleAvatar(radius: 20, backgroundImage: NetworkImage(widget.reel.userAvatar)),
//                           const SizedBox(width: 12),
//                           Text(
//                             widget.reel.username,
//                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                           const SizedBox(width: 8),
//                           if (!_isFollowing)
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _isFollowing = !_isFollowing;
//                                 });
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.white),
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                                 child: const Text(
//                                   'Follow',
//                                   style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       // Description
//                       Text(
//                         widget.reel.description,
//                         style: const TextStyle(color: Colors.white, fontSize: 14),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 8),
//                       // Music
//                       Row(
//                         children: [
//                           const Icon(Icons.music_note, color: Colors.white, size: 16),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               widget.reel.musicName,
//                               style: const TextStyle(color: Colors.white, fontSize: 12),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Right side actions
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Like button
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _isLiked = !_isLiked;
//                         });
//                       },
//                       child: Column(
//                         children: [
//                           Icon(
//                             _isLiked ? Icons.favorite : Icons.favorite_border,
//                             color: _isLiked ? Colors.red : Colors.white,
//                             size: 32,
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             widget.reel.likesCount.toString(),
//                             style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Comment button
//                     GestureDetector(
//                       onTap: () {
//                         _showCommentSheet(context);
//                       },
//                       child: Column(
//                         children: [
//                           const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 32),
//                           const SizedBox(height: 4),
//                           Text(
//                             widget.reel.commentsCount.toString(),
//                             style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Share button
//                     GestureDetector(
//                       onTap: () {
//                         // Handle share
//                       },
//                       child: Column(
//                         children: [
//                           const Icon(Icons.send, color: Colors.white, size: 32),
//                           const SizedBox(height: 4),
//                           Text(
//                             widget.reel.sharesCount.toString(),
//                             style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // More options
//                     const Icon(Icons.more_vert, color: Colors.white, size: 32),
//                     const SizedBox(height: 24),

//                     // Rotating music disc
//                     GestureDetector(
//                       onTap: () {
//                         // Handle music tap
//                       },
//                       child: AnimatedBuilder(
//                         animation: _animationController,
//                         builder: (context, child) {
//                           return Transform.rotate(
//                             angle: _animationController.value * 2 * 3.14159,
//                             child: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(image: NetworkImage(widget.reel.musicCover), fit: BoxFit.cover),
//                                 border: Border.all(color: Colors.white, width: 2),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Heart animation for double tap
//         if (_showHeart)
//           Center(
//             child: AnimatedOpacity(
//               opacity: _showHeart ? 1.0 : 0.0,
//               duration: const Duration(milliseconds: 500),
//               child: const Icon(Icons.favorite, color: Colors.red, size: 80),
//             ),
//           ),
//       ],
//     );
//   }

//   void _showCommentSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => CommentSheet(reel: widget.reel),
//     );
//   }
// }

// class CommentSheet extends StatelessWidget {
//   final ReelModel reel;

//   const CommentSheet({super.key, required this.reel});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * 0.75,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           // Handle bar
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 12),
//             width: 40,
//             height: 4,
//             decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
//           ),

//           // Header
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   '${reel.commentsCount} comments',
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const Icon(Icons.close),
//               ],
//             ),
//           ),

//           const Divider(height: 1),

//           // Comments list
//           Expanded(
//             child: ListView.builder(
//               itemCount: 10, // Sample comments
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: CircleAvatar(
//                     radius: 16,
//                     backgroundImage: NetworkImage('https://picsum.photos/32/32?random=$index'),
//                   ),
//                   title: RichText(
//                     text: TextSpan(
//                       style: const TextStyle(color: Colors.black),
//                       children: [
//                         TextSpan(text: 'user_$index ', style: const TextStyle(fontWeight: FontWeight.bold)),
//                         const TextSpan(text: 'This is a sample comment'),
//                       ],
//                     ),
//                   ),
//                   subtitle: const Text('2h'),
//                   trailing: const Icon(Icons.favorite_border, size: 16),
//                 );
//               },
//             ),
//           ),

//           // Comment input
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               border: Border(top: BorderSide(color: Colors.grey[300]!)),
//             ),
//             child: Row(
//               children: [
//                 const CircleAvatar(radius: 16, backgroundImage: NetworkImage('https://picsum.photos/32/32')),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Add a comment...',
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ),
//                 const Icon(Icons.send, color: Colors.blue),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Sample data model
// class ReelModel {
//   final String id;
//   final String videoUrl;
//   final String userAvatar;
//   final String username;
//   final String description;
//   final String musicName;
//   final String musicCover;
//   final int likesCount;
//   final int commentsCount;
//   final int sharesCount;

//   ReelModel({
//     required this.id,
//     required this.videoUrl,
//     required this.userAvatar,
//     required this.username,
//     required this.description,
//     required this.musicName,
//     required this.musicCover,
//     required this.likesCount,
//     required this.commentsCount,
//     required this.sharesCount,
//   });
// }

// // Add this to your ReelsController
// extension ReelsControllerExtension on ReelsController {
//   List<ReelModel> get reels => [
//     ReelModel(
//       id: '1',
//       videoUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
//       userAvatar: 'https://picsum.photos/100/100?random=1',
//       username: 'astrology_user',
//       description: 'Amazing astrology facts that will blow your mind! ✨🔮 #astrology #zodiac',
//       musicName: 'Original Audio - astrology_user',
//       musicCover: 'https://picsum.photos/100/100?random=music1',
//       likesCount: 1250,
//       commentsCount: 89,
//       sharesCount: 45,
//     ),
//     ReelModel(
//       id: '2',
//       videoUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
//       userAvatar: 'https://picsum.photos/100/100?random=2',
//       username: 'cosmic_vibes',
//       description: 'Your daily horoscope is here! What does the universe have in store? 🌟',
//       musicName: 'Cosmic Meditation - Spa Music',
//       musicCover: 'https://picsum.photos/100/100?random=music2',
//       likesCount: 892,
//       commentsCount: 156,
//       sharesCount: 73,
//     ),
//     // Add more sample reels...
//   ];
// }
