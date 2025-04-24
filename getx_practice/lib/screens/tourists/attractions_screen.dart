import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/attractions_controller.dart';
import 'widgets/destination_card.dart';
import 'widgets/experience_item.dart';
import 'widgets/filter_button.dart';

class AttractionsScreen extends GetView<AttractionsController> {
  const AttractionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: Obx(() => BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tickets'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan'),
        ],
      )),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildTravelGuide(),
              _buildTopAttractions(),
              _buildCulturalAttractions(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 280,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.menu, color: Colors.black),
                Icon(Icons.person, color: Colors.black),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 90,
          child: const Text(
            'Discover Attractions',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 70,
          child: const Text(
            'Explore Egypt\'s Wonders at Your Fingertips',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.orange),
                hintText: 'Where do you wanna go?',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelGuide() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Essential Travel Guide',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'For those seeking a new, responsible way to travel',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              controller.filterOptions.length,
              (index) => Obx(() => FilterButton(
                label: controller.filterOptions[index],
                isSelected: controller.selectedFilterIndex.value == index,
                onPressed: () => controller.changeFilter(index),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAttractions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Attractions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (controller.attractionsList.isEmpty)
            Text('No attractions found'),
          ...controller.attractionsList.map((attraction) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: DestinationCard(
              image: attraction.image ?? 'https://via.placeholder.com/150',
              title: attraction.name,
              price: attraction.price ?? 'Free',
              type: attraction.type ?? attraction.location ?? 'Unknown',
              onExplore: () => controller.exploreAttraction(attraction.name),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildCulturalAttractions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cultural Attractions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (controller.attractionsList.isEmpty)
            Text('No attractions found'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.attractionsList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final attraction = controller.attractionsList[index];
              return ExperienceItem(
                image: attraction.image ?? 'https://via.placeholder.com/150',
                title: attraction.name,
                date: attraction.date ?? attraction.description ?? 'No description',
              );
            },
          ),
        ],
      ),
    );
  }
}