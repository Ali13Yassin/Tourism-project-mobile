import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_practice/Styles/colors.dart';
import 'package:getx_practice/controllers/cart_controller.dart';
import 'package:getx_practice/controllers/attractions_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController cartController = Get.put(CartController());
  final AttractionsController attractionsController = Get.find<AttractionsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Obx(() {
          if (cartController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with back button
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: icons,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: primary),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.shopping_bag_outlined),
                      const SizedBox(width: 8),
                      Text(
                        'My Cart',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Clear cart button
                      if (cartController.cartItems.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _showClearCartDialog(context),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Cart Items or Empty State
                  if (cartController.cartItems.isEmpty)
                    _buildEmptyCart(context)
                  else
                    ...[
                      // Cart Items List
                      ...cartController.cartItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildCartItem(context, item),
                      )),
                      
                      const SizedBox(height: 20),
                      
                      // Total Section
                      _buildTotalSection(context),
                      
                      const SizedBox(height: 30),

                      // Payment Method Section
                      _buildPaymentSection(context),
                      
                      const SizedBox(height: 40),
                        
                      // Checkout Button
                      _buildCheckoutButton(context),
                    ],
                ],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: attractionsController.currentNavIndex.value,
          onTap: attractionsController.changeNavIndex,
          backgroundColor: background,
          selectedItemColor: primary,
          unselectedItemColor: secondary,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tickets'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: secondary,
          ),
          const SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: secondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add some attractions to get started!',
            style: TextStyle(
              color: secondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              'Browse Attractions',
              style: TextStyle(color: icons, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, cartItem) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Attraction Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: cartItem.attractionImage != null
                  ? CachedNetworkImage(
                      imageUrl: cartItem.attractionImage!,
                      height: 70,
                      width: 90,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 70,
                        width: 90,
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 70,
                        width: 90,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    )
                  : Container(
                      height: 70,
                      width: 90,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
            ),
            const SizedBox(width: 15),
            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.attractionTitle ?? 'Unknown Attraction',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${cartItem.date}',
                    style: TextStyle(color: secondary, fontSize: 12),
                  ),
                  Text(
                    'Time: ${cartItem.time}',
                    style: TextStyle(color: secondary, fontSize: 12),
                  ),
                  Text(
                    'Type: ${cartController.getTicketTypeName(cartItem.ticketTypeId)}',
                    style: TextStyle(color: secondary, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${(cartItem.attractionPrice ?? 0).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      // Remove button
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        onPressed: () => cartController.removeFromCart(cartItem.cartItemId),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Column(
              children: [
                _buildQuantityButton(Icons.add, () => cartController.incrementQuantity(cartItem.cartItemId)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Text(
                    cartItem.quantity.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _buildQuantityButton(Icons.remove, () => cartController.decrementQuantity(cartItem.cartItemId)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: primary ?? Colors.black),
        ),
        child: Icon(icon, size: 18, color: primary),
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal (${cartController.cartItems.length} items)',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                '\$${cartController.cartTotal.value.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Taxes & Fees', style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text(
                '\$${(cartController.cartTotal.value * 0.1).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${(cartController.cartTotal.value * 1.1).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  // Show payment method selection
                  _showPaymentMethodDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),                  decoration: BoxDecoration(
                    border: Border.all(color: secondary ?? Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.credit_card, color: primary),
                      const SizedBox(width: 15),
                      Text('Select Payment Method'),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 16, color: secondary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: cartController.cartItems.isEmpty
            ? null
            : () => _showCheckoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: cartController.isCheckingOut.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Checkout - \$${(cartController.cartTotal.value * 1.1).toStringAsFixed(2)}',
                style: TextStyle(color: icons, fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your phone number to complete the checkout:'),
            const SizedBox(height: 15),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixText: '+20 ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {              final phone = phoneController.text.trim();
              if (phone.isNotEmpty) {
                Get.back();
                cartController.checkout(phoneNumber: phone);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primary),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              cartController.clearCart();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Method"),
        content: const Text(
          "Payment integration will be implemented with the payment gateway. For now, checkout will proceed with cash on delivery.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("OK"),
          ),
        ],
      ),
    );  }
}
