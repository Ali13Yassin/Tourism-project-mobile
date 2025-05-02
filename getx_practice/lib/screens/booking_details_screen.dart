import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting

class BookingDetailsController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var tourists = 2.obs;
  var kids = 2.obs;
  var differentlyAbled = 2.obs;
  var currentNavIndex = 0.obs;

  void updateDate(DateTime date) => selectedDate.value = date;
  void updateTourists(int value) => tourists.value = value;
  void updateKids(int value) => kids.value = value;
  void updateDifferentlyAbled(int value) => differentlyAbled.value = value;
  void changeNavIndex(int index) => currentNavIndex.value = index;
}

class BookingDetailsScreen extends StatelessWidget {
  final BookingDetailsController controller = Get.put(BookingDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Dropdown
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: InputBorder.none,
                  ),
                  value: 'Luxor, Nile River Valley',
                  items: [
                    'Luxor, Nile River Valley',
                    'Cairo, Giza Pyramids',
                    'Aswan, Aswan High Dam',
                    'Alexandria, Bibliotheca Alexandrina',
                    'Sharm El Sheikh, Red Sea',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Date Picker
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: controller.selectedDate.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color.fromARGB(255, 210, 172, 113),
                              onPrimary: Colors.white,
                            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) controller.updateDate(picked);
                  },
                  child: Obx(() => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select date',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('EEE, MMM d').format(controller.selectedDate.value),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.edit, color: Colors.grey),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Guest Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Guests',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    _buildGuestRow('Tourists', controller.tourists, controller.updateTourists),
                    const Divider(),
                    _buildGuestRow('Kids', controller.kids, controller.updateKids),
                    const Divider(),
                    _buildGuestRow('Differently abled', controller.differentlyAbled, controller.updateDifferentlyAbled),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Find Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 210, 172, 113),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Find',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          onTap: controller.changeNavIndex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Navigate'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Tickets'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestRow(String label, RxInt value, Function(int) updateFunction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                onPressed: () => updateFunction(value.value > 0 ? value.value - 1 : 0),
              ),
              Obx(() => Text('${value.value}')),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.grey),
                onPressed: () => updateFunction(value.value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}