// // ignore_for_file: deprecated_member_use

// import 'package:astrology/app/core/config/theme/app_colors.dart';
// import 'package:flutter/material.dart';


// class NoItemFound extends StatefulWidget {
//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final bool showButton;
//   final String buttonText;
//   final VoidCallback? onButtonPressed;

//   const NoItemFound({
//     super.key,
//     this.title = "No Transactions Found",
//     this.subtitle = "You haven't made any transactions yet.",
//     this.icon = Icons.receipt_long_outlined,
//     this.showButton = false,
//     this.buttonText = "Continue Shopping",
//     this.onButtonPressed,
//   });

//   @override
//   State<NoItemFound> createState() => _NoItemFoundState();
// }

// class _NoItemFoundState extends State<NoItemFound>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
//     ));

//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
//     ));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.3),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
//     ));

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
//           child: AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, child) {
//               return FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Animated Icon with Glow Effect
//                     ScaleTransition(
//                       scale: _scaleAnimation,
//                       child: Container(
//                         padding: const EdgeInsets.all(24),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [
//                               AppColors.primaryColor.withOpacity(0.1),
//                               AppColors.accentColor.withOpacity(0.1),
//                             ],
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.primaryColor.withOpacity(0.1),
//                               blurRadius: 20,
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: AppColors.surfaceColor,
//                             border: Border.all(
//                               color: AppColors.primaryColor.withOpacity(0.2),
//                               width: 2,
//                             ),
//                           ),
//                           child: Icon(
//                             widget.icon,
//                             size: 48,
//                             color: AppColors.primaryColor.withOpacity(0.7),
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // Animated Title
//                     SlideTransition(
//                       position: _slideAnimation,
//                       child: Column(
//                         children: [
//                           Text(
//                             widget.title,
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: AppColors.textPrimary,
//                               letterSpacing: 0.5,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 12),

//                           // Decorative line
//                           Container(
//                             height: 3,
//                             width: 60,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(2),
//                               gradient: LinearGradient(
//                                 colors: [
//                                   AppColors.primaryColor,
//                                   AppColors.accentColor,
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Animated Subtitle
//                     SlideTransition(
//                       position: _slideAnimation,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Text(
//                           widget.subtitle,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: AppColors.textSecondary,
//                             height: 1.5,
//                             letterSpacing: 0.2,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ),

//                     // Animated Button
//                     if (widget.showButton) ...[
//                       const SizedBox(height: 36),
//                       SlideTransition(
//                         position: _slideAnimation,
//                         child: _buildAnimatedButton(),
//                       ),
//                     ],

//                     const SizedBox(height: 24),

//                     // Floating particles effect
//                     _buildFloatingParticles(),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedButton() {
//     return TweenAnimationBuilder<double>(
//       duration: const Duration(milliseconds: 300),
//       tween: Tween<double>(begin: 0, end: 1),
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: 0.95 + (0.05 * value),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   AppColors.primaryColor,
//                   AppColors.accentColor,
//                 ],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primaryColor.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(16),
//                 onTap: widget.onButtonPressed,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 32,
//                     vertical: 16,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Icons.arrow_forward_rounded,
//                         color: AppColors.white,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         widget.buttonText,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.white,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFloatingParticles() {
//     return SizedBox(
//       height: 100,
//       child: Stack(
//         children: List.generate(6, (index) {
//           return AnimatedBuilder(
//             animation: _animationController,
//             builder: (context, child) {
//               final delay = index * 0.1;
//               final animationValue = (_animationController.value - delay).clamp(0.0, 1.0);

//               return Positioned(
//                 left: (index * 60.0) % 200,
//                 top: 20 + (index * 15.0) % 40,
//                 child: Transform.translate(
//                   offset: Offset(0, -animationValue * 20),
//                   child: Opacity(
//                     opacity: (animationValue * 0.3).clamp(0.0, 0.3),
//                     child: Container(
//                       width: 4 + (index % 3) * 2,
//                       height: 4 + (index % 3) * 2,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: index % 2 == 0
//                           ? AppColors.primaryColor
//                           : AppColors.accentColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }}
