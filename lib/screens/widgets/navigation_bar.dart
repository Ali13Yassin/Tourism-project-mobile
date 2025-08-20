import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationBar extends StatelessWidget {
  final RxInt currentIndex;
  final Function(int) onTap;

  const NavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: currentIndex.value,
          onTap: onTap,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tickets'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout), label: 'Cart'),
          ],
        ));
  }
}
