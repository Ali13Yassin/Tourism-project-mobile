import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_practice/Styles/colors.dart';
<<<<<<< Updated upstream
import '../../Styles/colors.dart';
=======
import 'package:getx_practice/controllers/cart_controller.dart';
import 'package:getx_practice/models/cart.dart';
>>>>>>> Stashed changes

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // Removed cartController field; will use a local variable in build()

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (cartController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      const SizedBox(width: 8),
                      Text(
                        'My Cart (${cartController.itemCount.value})',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Cart Items
                  if (cartController.cartItems.isEmpty)
                    const Center(child: Text('Your cart is empty'))
                  else
                    ...cartController.cartItems.map((item) => Column(
                          children: [
                            _buildCartItem(
                              context,
                              item: item,
                              onIncrement: () => cartController.updateCartItem(
                                cartItemId: item.id,
                                quantity: item.quantity + 1,
                              ),
                              onDecrement: () => cartController.updateCartItem(
                                cartItemId: item.id,
                                quantity: item.quantity - 1,
                              ),
                              onRemove: () => cartController.removeCartItem(item.id),
                            ),
                            const SizedBox(height: 10),
                          ],
                        )),

                  const SizedBox(height: 30),

                  // Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${cartController.total.value.toStringAsFixed(2)} LE',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Payment Method Section
                  Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Payment Method"),
                                content: const Text(
                                  "You've selected Visa as your payment method.",
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: secondary ?? Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            color: background,
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/images.jpg', height: 30),
                              const SizedBox(width: 5),
                              const Text('Visa'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          // Handle MasterCard selection
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: secondary ?? Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/images.jpg', height: 30),
                              const SizedBox(width: 5),
                              const Text('MasterCard'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        size: 40,
                        color: secondary ?? Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('************7890'),
                          Text(
                            'Your card id',
                            style: TextStyle(
                              color: secondary ?? Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Card number',
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _CardExpiryFormatter(),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'MM/YY',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: VerticalDivider(color: secondary, thickness: 1),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            border: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: secondary,
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: MaterialButton(
                      onPressed: cartController.cartItems.isEmpty
                          ? null
                          : () {
                              cartController.checkout();
                            },
                      color: const Color(0xFFD4B98A),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Pay now',
                        style: TextStyle(fontSize: 18, color: icons),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context, {
    required CartItem item,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required VoidCallback onRemove,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                item.attractionImage,
                height: 60,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 60,
                  width: 80,
                  color: Colors.grey,
                  child: const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.attractionName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${item.price.toStringAsFixed(2)} LE',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: primary,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Subtotal: ${item.subtotal.toStringAsFixed(2)} LE',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onRemove,
                  iconSize: 18,
                ),
                Row(
                  children: [
                    _buildQuantityButton(
                      Icons.remove,
                      onDecrement,
                      disabled: item.quantity <= 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item.quantity.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    _buildQuantityButton(Icons.add, onIncrement),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
    IconData icon,
    VoidCallback onPressed, {
    bool disabled = false,
  }) {
    return InkWell(
      onTap: disabled ? null : onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: disabled ? Colors.grey : primary ?? Colors.black),
        ),
        child: Icon(icon,
            size: 18, color: disabled ? Colors.grey : primary),
      ),
    );
  }
}

class _CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    if (newText.isEmpty) {
      return newValue;
    }

    if (newText.length > 5) {
      return oldValue;
    }

    if (newText.isNotEmpty) {
      if (newText[0] != '0' && newText[0] != '1') {
        return oldValue;
      }

      if (newText.length >= 2) {
        int month;
        try {
          month = int.parse(newText.substring(0, 2));
        } catch (_) {
          return oldValue;
        }

        if (month < 1 || month > 12) {
          return oldValue;
        }
      }
    }

    StringBuffer newString = StringBuffer();

    for (int i = 0; i < newText.length; i++) {
      if (i == 2 && newText[i] != '/') {
        newString.write('/');
      }
      newString.write(newText[i]);
    }

    return TextEditingValue(
      text: newString.toString(),
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}