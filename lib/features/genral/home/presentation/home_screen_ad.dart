// import 'dart:ui';
// import 'package:flutter/material.dart';
//
// // void main() => runApp(const BonetechDemoApp());
//
// /// ------------------------------------------------------------
// /// THEME / PALETTE (colors tuned to your theme)
// /// ------------------------------------------------------------
// class BonetechPalette {
//   // Brand blue (very close to your screenshot)
//   static const primary = Color(0xFF3E7BFA); // #3E7BFA
//
//   // Deeper navy background for dark theme
//   static const bgDark = Color(0xFF0B1220); // deep navy
//
//   // Soft, cool light background for light theme
//   static const bgLight = Color(0xFFEFF3FF); // subtle cool white/blue
//
//   // Accent gradient blues for ambient glow
//   static const grad1 = Color(0xFF2F5BFF); // inner glow start
//   static const grad2 = Color(0xFF78A2FF); // outer glow end
// }
//
//
//
// // class BonetechDemoApp extends StatelessWidget {
// //   const BonetechDemoApp({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Bonetech Home Demo',
// //       debugShowCheckedModeBanner: false,
// //       theme: _lightTheme(),
// //       darkTheme: _darkTheme(),
// //       themeMode: ThemeMode.dark,
// //       home: HomePage(
// //         banners: _demoBanners,
// //         categories: _demoCategories,
// //         trending: _demoProducts.take(6).toList(),
// //         bestSellers: _demoProducts.skip(3).take(6).toList(),
// //         newArrivals: _demoProducts.reversed.take(6).toList(),
// //       ),
// //     );
// //   }
// // }
//
// /// ------------------------------------------------------------
// /// HOME PAGE
// /// ------------------------------------------------------------
// class HomePage extends StatefulWidget {
//   final List<BannerItem> banners;
//   final List<CategoryItem> categories;
//   final List<ProductItem> trending;
//   final List<ProductItem> bestSellers;
//   final List<ProductItem> newArrivals;
//
//   const HomePage({
//     super.key,
//     required this.banners,
//     required this.categories,
//     required this.trending,
//     required this.bestSellers,
//     required this.newArrivals,
//   });
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final _bannerCtrl = PageController(viewportFraction: 0.90);
//   int _bannerIndex = 0;
//   int _navIndex = 0;
//
//   static const List<NavigationDestination> _navDestinations = [
//     NavigationDestination(
//       icon: Icon(Icons.home_outlined),
//       selectedIcon: Icon(Icons.home),
//       label: 'Home',
//     ),
//     NavigationDestination(
//       icon: Icon(Icons.inventory_2_outlined),
//       selectedIcon: Icon(Icons.inventory_2),
//       label: 'Products',
//     ),
//     NavigationDestination(
//       icon: Icon(Icons.receipt_long_outlined),
//       selectedIcon: Icon(Icons.receipt_long),
//       label: 'Orders',
//     ),
//   ];
//
//   int get _safeNavIndex {
//     final max = _navDestinations.length - 1;
//     if (_navIndex < 0) return 0;
//     if (_navIndex > max) return max;
//     return _navIndex;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _bannerCtrl.addListener(() {
//       final page = _bannerCtrl.page ?? 0;
//       final i = page.round();
//       if (i != _bannerIndex) setState(() => _bannerIndex = i);
//     });
//   }
//
//   @override
//   void dispose() {
//     _bannerCtrl.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: DecoratedBox(
//               decoration: BoxDecoration(
//                 gradient: RadialGradient(
//                   center: const Alignment(-0.6, -1.2),
//                   radius: 1.4,
//                   colors: isDark
//                       ? [
//                     BonetechPalette.grad1.withOpacity(.24),
//                     Colors.transparent
//                   ]
//                       : [
//                     BonetechPalette.grad2.withOpacity(.18),
//                     Colors.transparent
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           CustomScrollView(
//             slivers: [
//               // Minimal top bar (glass) — no big "Home" title
//               SliverToBoxAdapter(
//                 child: SafeArea(
//                   bottom: false,
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
//                     child: Frost(
//                       blur: 18,
//                       opacity: .20,
//                       radius: 16,
//                       frame: Frost.outlineBorder(),
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                       child: Row(
//                         children: [
//                           Frost(
//                             blur: 16,
//                             opacity: .20,
//                             radius: 12,
//                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                             child: Row(
//                               children: [
//                                 const Icon(Icons.bubble_chart, size: 18),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   'Bonetech',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .titleSmall
//                                       ?.copyWith(fontWeight: FontWeight.w700),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Spacer(),
//                           _RoundIcon(icon: Icons.search, onTap: _onSearch),
//                           const SizedBox(width: 8),
//                           _RoundIcon(icon: Icons.shopping_bag_outlined, onTap: _onCart),
//                           const SizedBox(width: 8),
//                           _RoundIcon(icon: Icons.account_circle_outlined, onTap: _onProfile),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // BANNERS
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
//                   child: _BannerCarousel(
//                     controller: _bannerCtrl,
//                     items: widget.banners,
//                     index: _bannerIndex,
//                     onTap: _onBannerTap,
//                   ),
//                 ),
//               ),
//
//               // CATEGORIES header
//               const SliverToBoxAdapter(child: SizedBox(height: 8)),
//               SliverToBoxAdapter(
//                 child: _SectionHeader(
//                   title: 'Categories',
//                   onSeeAll: _onSeeAllCategories,
//                 ),
//               ),
//               // CATEGORIES chips
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: 66,
//                   child: ListView.separated(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     scrollDirection: Axis.horizontal,
//                     itemCount: widget.categories.length,
//                     separatorBuilder: (_, __) => const SizedBox(width: 10),
//                     itemBuilder: (context, i) => _CategoryChip(
//                       item: widget.categories[i],
//                       onTap: () => _onCategoryTap(widget.categories[i]),
//                     ),
//                   ),
//                 ),
//               ),
//
//               // TRENDING
//               _ProductRail(
//                 title: 'Trending Products',
//                 items: widget.trending,
//                 onSeeAll: () => _onSeeAllView('Trending'),
//                 onTap: _onProductTap,
//               ),
//
//               // BEST SELLERS
//               _ProductRail(
//                 title: 'Bestseller Products',
//                 items: widget.bestSellers,
//                 onSeeAll: () => _onSeeAllView('Best Seller'),
//                 onTap: _onProductTap,
//               ),
//
//               // NEW ARRIVALS
//               _ProductRail(
//                 title: 'New Arrivals',
//                 items: widget.newArrivals,
//                 onSeeAll: () => _onSeeAllView('New Arrival'),
//                 onTap: _onProductTap,
//               ),
//
//               const SliverToBoxAdapter(child: SizedBox(height: 24)),
//             ],
//           ),
//         ],
//       ),
//
//       // FROSTED BOTTOM NAV
//       bottomNavigationBar: Frost(
//         blur: 22,
//         opacity: .22,
//         radius: 18,
//         frame: Frost.outlineBorder(),
//         margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: SafeArea(
//           top: false,
//           child: NavigationBar(
//             destinations: _navDestinations,
//             selectedIndex: _safeNavIndex,
//             onDestinationSelected: (i) {
//               final max = _navDestinations.length - 1;
//               setState(() {
//                 _navIndex = i < 0 ? 0 : (i > max ? max : i);
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   // --- handlers (stubbed) ---
//   void _onSearch() {}
//   void _onCart() {}
//   void _onProfile() {}
//   void _onBannerTap(BannerItem b) {}
//   void _onSeeAllCategories() {}
//   void _onCategoryTap(CategoryItem c) {}
//   void _onSeeAllView(String view) {}
//   void _onProductTap(ProductItem p) {}
// }
//
// /// ------------------------------------------------------------
// /// BANNER CAROUSEL
// /// ------------------------------------------------------------
// class _BannerCarousel extends StatelessWidget {
//   final PageController controller;
//   final List<BannerItem> items;
//   final int index;
//   final void Function(BannerItem) onTap;
//
//   const _BannerCarousel({
//     required this.controller,
//     required this.items,
//     required this.index,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) return const SizedBox.shrink();
//
//     final theme = Theme.of(context);
//
//     return Column(
//       children: [
//         SizedBox(
//           height: 190,
//           child: PageView.builder(
//             controller: controller,
//             itemCount: items.length,
//             itemBuilder: (context, i) {
//               final b = items[i];
//               return GestureDetector(
//                 onTap: () => onTap(b),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Stack(
//                       fit: StackFit.expand,
//                       children: [
//                         Image.network(b.imageUrl, fit: BoxFit.cover),
//                         // vignette
//                         Positioned.fill(
//                           child: DecoratedBox(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.bottomCenter,
//                                 end: Alignment.topCenter,
//                                 colors: [
//                                   Colors.black.withOpacity(0.45),
//                                   Colors.transparent,
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         // label plate (glass)
//                         Positioned(
//                           left: 12,
//                           right: 12,
//                           bottom: 12,
//                           child: Frost(
//                             blur: 18,
//                             opacity: .16,
//                             radius: 14,
//                             padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//                             frame: Frost.outlineBorder(),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   b.title,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: theme.textTheme.titleMedium?.copyWith(
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                                 if (b.subtitle != null) ...[
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     b.subtitle!,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: theme.textTheme.bodySmall?.copyWith(
//                                       color: Colors.white70,
//                                     ),
//                                   ),
//                                 ]
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 10),
//         _Dots(count: items.length, index: index),
//       ],
//     );
//   }
// }
//
// class _Dots extends StatelessWidget {
//   final int count;
//   final int index;
//   const _Dots({required this.count, required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(count, (i) {
//         final active = i == index;
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 220),
//           margin: const EdgeInsets.symmetric(horizontal: 3),
//           height: 6,
//           width: active ? 16 : 6,
//           decoration: BoxDecoration(
//             color: active
//                 ? (isDark ? Colors.white : Colors.black87)
//                 : (isDark ? Colors.white38 : Colors.black26),
//             borderRadius: BorderRadius.circular(3),
//           ),
//         );
//       }),
//     );
//   }
// }
//
// /// ------------------------------------------------------------
// /// SECTION HEADER
// /// ------------------------------------------------------------
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   final VoidCallback? onSeeAll;
//   const _SectionHeader({required this.title, this.onSeeAll});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title.toUpperCase(),
//               style: theme.textTheme.titleSmall?.copyWith(
//                 letterSpacing: .6,
//                 fontWeight: FontWeight.w800,
//               ),
//             ),
//           ),
//           if (onSeeAll != null)
//             InkWell(
//               borderRadius: BorderRadius.circular(8),
//               onTap: onSeeAll,
//               child: Frost(
//                 blur: 14,
//                 opacity: .18,
//                 radius: 8,
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 child: Row(
//                   children: [
//                     Text('See all', style: theme.textTheme.bodySmall),
//                     const SizedBox(width: 2),
//                     const Icon(Icons.chevron_right, size: 16),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
// /// ------------------------------------------------------------
// /// CATEGORY CHIP (glass pill)
// /// ------------------------------------------------------------
// class _CategoryChip extends StatelessWidget {
//   final CategoryItem item;
//   final VoidCallback onTap;
//   const _CategoryChip({required this.item, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Frost(
//       blur: 14,
//       opacity: .22,
//       radius: 999,
//       frame: Frost.outlineBorder(),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(999),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 14,
//               backgroundImage: NetworkImage(item.iconUrl),
//             ),
//             const SizedBox(width: 8),
//             ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 140),
//               child: Text(
//                 item.name.toUpperCase(),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                   letterSpacing: .6,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// ------------------------------------------------------------
// /// PRODUCT RAIL + CARD
// /// ------------------------------------------------------------
// class _ProductRail extends StatelessWidget {
//   final String title;
//   final List<ProductItem> items;
//   final VoidCallback onSeeAll;
//   final void Function(ProductItem) onTap;
//
//   const _ProductRail({
//     required this.title,
//     required this.items,
//     required this.onSeeAll,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (items.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
//     return SliverToBoxAdapter(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 14),
//           _SectionHeader(title: title, onSeeAll: onSeeAll),
//           const SizedBox(height: 8),
//           SizedBox(
//             height: 230,
//             child: ListView.separated(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               scrollDirection: Axis.horizontal,
//               itemCount: items.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 12),
//               itemBuilder: (context, i) => _ProductCard(
//                 item: items[i],
//                 onTap: () => onTap(items[i]),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ProductCard extends StatelessWidget {
//   final ProductItem item;
//   final VoidCallback onTap;
//   const _ProductCard({required this.item, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(18),
//       child: Frost(
//         blur: 18,
//         opacity: .18,
//         radius: 18,
//         width: 160,
//         frame: Frost.outlineBorder(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // image
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(18),
//                 topRight: Radius.circular(18),
//               ),
//               child: AspectRatio(
//                 aspectRatio: 1,
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Image.network(item.imageUrl, fit: BoxFit.cover),
//                     Positioned(
//                       top: 8,
//                       right: 8,
//                       child: Frost(
//                         blur: 12,
//                         opacity: .22,
//                         radius: 24,
//                         padding: const EdgeInsets.all(6),
//                         child: const Icon(Icons.favorite_border, size: 18),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // content
//             Padding(
//               padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(item.name,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w700,
//                       )),
//                   const SizedBox(height: 2),
//                   Text(item.code ?? '',
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: theme.hintColor,
//                       )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// ------------------------------------------------------------
// /// SMALL ROUND ICON (glass)
// /// ------------------------------------------------------------
// class _RoundIcon extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _RoundIcon({required this.icon, required this.onTap});
//   @override
//   Widget build(BuildContext context) {
//     return Frost(
//       blur: 14,
//       opacity: .18,
//       radius: 12,
//       padding: const EdgeInsets.all(8),
//       child: InkWell(
//         onTap: onTap,
//         customBorder: const CircleBorder(),
//         child: Icon(icon, size: 20),
//       ),
//     );
//   }
// }
//
// /// ------------------------------------------------------------
// /// FROST (glass) CONTAINER
// /// ------------------------------------------------------------
// class Frost extends StatelessWidget {
//   final Widget? child;
//   final double blur;
//   final double opacity; // 0..1
//   final double radius;
//   final EdgeInsetsGeometry? padding;
//   final EdgeInsetsGeometry? margin;
//   final double? width;
//   final double? height;
//   final BoxBorder? frame; // optional outline
//
//   const Frost({
//     super.key,
//     this.child,
//     this.blur = 18,
//     this.opacity = .16,
//     this.radius = 16,
//     this.padding,
//     this.margin,
//     this.width,
//     this.height,
//     this.frame,
//   });
//
//   // ⬇️ Make the glass outline subtly blue
//   static BoxBorder outlineBorder() =>
//       Border.all(color: BonetechPalette.primary.withOpacity(.18), width: 1);
//
//   @override
//   Widget build(BuildContext context) {
//     // ⬇️ Tint the glass with brand blue while keeping a frosted look
//     final p = Theme.of(context).colorScheme.primary;
//     final clamped = opacity.clamp(0.0, 1.0).toDouble();
//     final top = Colors.white.withOpacity(clamped * 0.90);
//     final bottom = p.withOpacity(clamped * 0.60);
//
//     return Container(
//       margin: margin,
//       width: width,
//       height: height,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(radius),
//         border: frame,
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(radius),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
//           child: Container(
//             padding: padding,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [top, bottom],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// ------------------------------------------------------------
// /// DEMO MODELS & DATA
// /// ------------------------------------------------------------
// class BannerItem {
//   final String imageUrl;
//   final String title;
//   final String? subtitle;
//   BannerItem({required this.imageUrl, required this.title, this.subtitle});
// }
//
// class CategoryItem {
//   final String name;
//   final String iconUrl;
//   CategoryItem({required this.name, required this.iconUrl});
// }
//
//
// // Use non-const lists so DartPad doesn’t complain about “Invalid constant value”.
// final List<BannerItem> _demoBanners = [
//   BannerItem(
//     imageUrl: 'https://picsum.photos/1200/600?1',
//     title: 'New Titanium Series',
//     subtitle: 'Lighter • Stronger • Reliable',
//   ),
//   BannerItem(
//     imageUrl: 'https://picsum.photos/1200/600?2',
//     title: 'Festive Offers',
//     subtitle: 'Limited-time discounts on plates & screws',
//   ),
//   BannerItem(
//     imageUrl: 'https://picsum.photos/1200/600?3',
//     title: 'Now Shipping Faster',
//     subtitle: 'Priority dispatch on trending SKUs',
//   ),
// ];
//
// final List<CategoryItem> _demoCategories = [
//   CategoryItem(name: 'Spine', iconUrl: 'https://picsum.photos/80?cat=1'),
//   CategoryItem(name: 'Trauma', iconUrl: 'https://picsum.photos/80?cat=2'),
//   CategoryItem(name: 'Hip', iconUrl: 'https://picsum.photos/80?cat=3'),
//   CategoryItem(name: 'Knee', iconUrl: 'https://picsum.photos/80?cat=4'),
//   CategoryItem(name: 'Shoulder', iconUrl: 'https://picsum.photos/80?cat=5'),
// ];
//
// final List<ProductItem> _demoProducts = List<ProductItem>.generate(12, (i) {
//   return ProductItem(
//     id: 'p$i',
//     name: i.isEven ? 'Cannula for Injection' : 'Locking Screw ${i + 1}',
//     code: i.isEven ? 'BS60$i' : 'SC${600 + i}',
//     imageUrl: 'https://picsum.photos/400/400?prod=$i',
//   );
// });
