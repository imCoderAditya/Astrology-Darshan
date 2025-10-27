import 'dart:convert';
import 'dart:developer';

import 'package:astrology/app/data/models/astrologer/live_astrologer_model.dart';
import 'package:astrology/app/modules/liveAstro/controllers/live_astro_controller.dart';
import 'package:astrology/app/modules/liveAstro/views/live_astro_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_astrology_controller.dart';

class LiveAstrologyView extends StatefulWidget {
  final LiveAstrologer? liveAstrologer;
  const LiveAstrologyView({super.key, this.liveAstrologer});

  @override
  State<LiveAstrologyView> createState() => _LiveAstrologyViewState();
}

class _LiveAstrologyViewState extends State<LiveAstrologyView> {
  final liveController = Get.put(LiveAstroController());
  final controller = Get.put(LiveAstrologyController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.liveAstrologer == null) {
        liveController.liveAstrologer= widget.liveAstrologer;
        await controller.liveAstrologerAPI();
        final astrologers =
            controller.liveAstrologerModel.value?.liveAstrologer;
        await liveController.joinLive(
          channelName: astrologers?.firstOrNull?.streamKey.toString(),
          userName: astrologers?.firstOrNull?.displayName ?? "",
        );
      } else {
        log("--------${json.encode(widget.liveAstrologer)}");
        await liveController.joinLive(
          channelName: widget.liveAstrologer?.streamKey ?? "",
          userName: widget.liveAstrologer?.displayName ?? "",
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveAstrologyController>(
      init: LiveAstrologyController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final astrologers =
                controller.liveAstrologerModel.value?.liveAstrologer;

            if (astrologers == null || astrologers.isEmpty) {
              return const Center(
                child: Text(
                  'No astrologers are live now.',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            if (widget.liveAstrologer != null) {
              return ViewerView(liveAstrologer: widget.liveAstrologer!);
            }
            return PageView.builder(
              itemCount: astrologers.length,
              controller: PageController(viewportFraction: 1),
              onPageChanged: (value) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await liveController.leaveLive();
                  await liveController.joinLive(
                    channelName: astrologers[value].streamKey.toString(),
                    userName: astrologers[value].displayName ?? "",
                  );
                });
              },
              itemBuilder: (context, index) {
                final astrologer = astrologers[index];
                return ViewerView(
                  liveAstrologer: astrologer,
                ); // Assuming ViewerView expects data
              },
            );
          }),
        );
      },
    );
  }
}

// import 'package:astrology/app/modules/liveAstro/views/live_astro_view.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/live_astrology_controller.dart';

// class LiveAstrologyView extends GetView<LiveAstrologyController> {
//   const LiveAstrologyView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<LiveAstrologyController>(
//       init: LiveAstrologyController(),
//       builder: (controller) {
//         final astrologers =
//             controller.liveAstrologerModel.value?.liveAstrologer;
//         return Scaffold(
//           appBar: AppBar(title: Text('Live Astrologers'), centerTitle: true),
//           body:
//               controller.isLoading.value
//                   ? const Center(child: CircularProgressIndicator())
//                   : (astrologers == null || astrologers.isEmpty)
//                   ? const Center(
//                     child: Text(
//                       'No astrologers are live now.',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   )
//                   : ListView.builder(
//                     padding: const EdgeInsets.all(12),
//                     itemCount: astrologers.length,
//                     itemBuilder: (context, index) {
//                       final astrologer = astrologers[index];
//                       return Card(
//                         elevation: 3,
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             radius: 28,
//                             backgroundColor: Colors.grey[200],
//                             backgroundImage:
//                                 astrologer.profilePicture != null
//                                     ? NetworkImage(astrologer.profilePicture!)
//                                     : null,
//                             child:
//                                 astrologer.profilePicture == null
//                                     ? const Icon(Icons.person, size: 28)
//                                     : null,
//                           ),
//                           title: Text(
//                             astrologer.displayName ?? '',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (astrologer.rating != null)
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.star,
//                                       color: Colors.amber,
//                                       size: 16,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       astrologer.rating!.toStringAsFixed(1),
//                                       style: const TextStyle(fontSize: 14),
//                                     ),
//                                     // if (astrologer.totalRatings != null)
//                                     //   Text(
//                                     //     ' (${astrologer.totalRatings})',
//                                     //     style: const TextStyle(fontSize: 12),
//                                     //   ),
//                                   ],
//                                 ),
//                               if (astrologer.specializations != null &&
//                                   astrologer.specializations!.isNotEmpty)
//                                 Text(
//                                   astrologer.specializations ?? "",
//                                   style: const TextStyle(fontSize: 12),
//                                 ),
//                             ],
//                           ),
//                           trailing:
//                               astrologer.isOnline == true
//                                   ? Container(
//                                     width: 10,
//                                     height: 10,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green,
//                                       shape: BoxShape.circle,
//                                     ),
//                                   )
//                                   : null,
//                           onTap: () {
//                             Get.to(ViewerView());
//                           },
//                         ),
//                       );
//                     },
//                   ),
//         );
//       },
//     );
//   }
// }
