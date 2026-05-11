// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/material.dart';
// import '../../feature/home/presentation/pages/home_screen.dart';
// import '../../feature/orders/presentation/pages/order_screen.dart';
// import '../../feature/profile/presentation/pages/wishlist_screen_board.dart';
// import '../../feature/profile/presentation/widgets/sidebar_home.dart';
// import '../../feature/search/presentation/pages/discover_full.dart';
//
// import '../resources/assets_manger.dart';
// import '../resources/colors_manger.dart';
//
// class BottomNavigation extends StatefulWidget {
//   const BottomNavigation({super.key,  this.showBottomNav=true,});
//   final bool showBottomNav;
//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }
// class _BottomNavigationState extends State<BottomNavigation> {
//   final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//
//    int curvedIndex=0 ;
//   void _changeItem(int value) {
//     setState(() {
//       curvedIndex = value;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const SidebarHomeScreen(),
//
//       bottomNavigationBar:CurvedNavigationBar(
//         buttonBackgroundColor: ColorsManger.white,
//         backgroundColor: ColorsManger.white,
//         color: ColorsManger.white,
//         height: 50,
//         items: const [
//           Icon(Icons.home_outlined, size: 22, color: ColorsManger.darkGrey),
//           Icon(Icons.search, size: 22, color: ColorsManger.darkGrey),
//           Image(
//             image: AssetImage(ImageAssets.orderIcon),
//             width: 21,
//             height: 20,
//             color: ColorsManger.darkGrey,
//           ),
//           Icon(Icons.person, size: 22, color: ColorsManger.darkGrey),
//         ],
//         onTap: _changeItem,
//         index: curvedIndex,
//       ),
//       body: IndexedStack(
//         index: curvedIndex,
//         children:  [
//           HomeScreen(analytics: analytics,),
//           DiscoverScreen(),
//             OrdersScreen(),
//             WishlistScreenBoards(),
//         ],
//       ),
//     );
//   }
// }
