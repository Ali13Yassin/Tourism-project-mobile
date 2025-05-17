import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getx_practice/Styles/colors.dart';
import '../../Styles/colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Added SingleChildScrollView for scrollability
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                    ), // Changed icon slightly
                    const SizedBox(width: 8),
                    Text(
                      'My Cart',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        // fontFamily: 'Serif', // Example font
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Cart Items
                _buildCartItem(
                  context,
                  imageUrl: 'assets/images.jpg', // Placeholder image
                  itemName: 'Karnak Temple',
                  price: '399 LE',
                  quantity: 1,
                ),
                const SizedBox(height: 10),
                _buildCartItem(
                  context,
                  imageUrl: 'assets/images.jpg', // Example asset path
                  itemName: 'El-Fayoum',
                  price: '399 LE',
                  quantity: 1,
                ),
                const SizedBox(height: 30),

                // Payment Method Section
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    // fontFamily: 'Serif', // Example font
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Show a simple dialog to confirm card selection
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
                        // In a real app, you'd store this selection in state management
                        // Example: controller.setPaymentMethod('visa');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: secondary ?? Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color:
                              background, // Change to a highlight color when selected
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
                        Text('************7890'),
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
                // Simple representation of input fields
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Card number',
                    border: UnderlineInputBorder(),
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
                        decoration: InputDecoration(
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
                        decoration: InputDecoration(
                          labelText: 'CVV',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ), // Remove underline for cleaner look
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
                ), // Underline for the row

                const SizedBox(height: 40), // Spacer before button
                // Pay Now Button
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      // Handle payment logic
                    },
                    color: const Color(0xFFD4B98A), // Beige color
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
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context, {
    required String imageUrl,
    required String itemName,
    required String price,
    required int quantity,
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
              child: Image.asset(
                imageUrl,
                height: 60,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      // fontFamily: 'Serif', // Example font
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      // fontFamily: 'Serif', // Example font
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity Controls
            Row(
              children: [
                _buildQuantityButton(Icons.remove, () {
                  /* Decrement quantity */
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    quantity.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _buildQuantityButton(Icons.add, () {
                  /* Increment quantity */
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      // Use InkWell for tap effect
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15), // Make it circular
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
}

// Custom formatter for credit card expiry date (MM/YY format)
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

    // Keep the old value if the new value is longer than 5 characters (MM/YY)
    if (newText.length > 5) {
      return oldValue;
    }

    // Validate month input
    if (newText.isNotEmpty) {
      // First digit of month can only be 0 or 1
      if (newText[0] != '0' && newText[0] != '1') {
        return oldValue;
      }

      // Check second digit to ensure month is valid (01-12)
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

    // Add the slash after the second digit (MM/)
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
