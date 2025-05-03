import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_practice/screens/cart_screen.dart';
import 'package:getx_practice/screens/profile_screen.dart';
import '../../controllers/attractions_controller.dart';
import 'widgets/destination_card.dart';
import 'widgets/experience_item.dart';
import 'widgets/filter_button.dart';
import 'attraction_details_screen.dart';

class AttractionsScreen extends StatelessWidget {
  const AttractionsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    if (!Get.isRegistered<AttractionsController>()) {
      Get.put(AttractionsController());
    }
    final controller = Get.find<AttractionsController>();

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
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tickets'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout), label: 'Cart'),
],
          )),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(controller),
              _buildTravelGuide(controller),
              _buildTopAttractions(controller),
              _buildArticles(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(AttractionsController controller) {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
                children: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                  Get.to(ProfileScreen());
                  },
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          left: 16,
          bottom: 90,
          child: Text(
            'Discover Attractions',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const Positioned(
          left: 16,
          bottom: 70,
          child: Text(
            'Explore Egypt\'s wonders at your fingertips',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        Positioned(
          bottom: 12,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                icon: const Icon(Icons.search, color: Color.fromARGB(255, 210, 172, 113)),
                hintText: 'Where do you wanna go?',
                border: InputBorder.none,
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: controller.clearSearch,
                      )
                    : const SizedBox.shrink()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelGuide(AttractionsController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
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
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.filterOptions.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterButton(
                      label: controller.filterOptions[index],
                      isSelected: controller.selectedFilterIndex.value == index,
                      onPressed: () => controller.changeFilter(index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAttractions(AttractionsController controller) {
    final filteredAttractions = controller.filteredAttractions;

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
          if (filteredAttractions.isEmpty)
            Center(
              child: Column(
                children: [
                  Text(
                    controller.selectedFilterIndex.value == 0
                        ? 'No attractions found'
                        : 'No attractions found for ${controller.filterOptions[controller.selectedFilterIndex.value]}',
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => controller.fetchAttractions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else
            ...filteredAttractions.map((attraction) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: DestinationCard(
                    image: attraction.image ?? '',
                    title: attraction.name,
                    price: attraction.price ?? 'Free',
                    type: attraction.type ?? attraction.location ?? 'Unknown',
                    onExplore: () {
                      Get.to(AttractionDetailsScreen(attractionName: attraction.name));
                    },
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildArticles(AttractionsController controller) {
    final filteredAttractions = controller.filteredAttractions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Latest Articles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 0),
          if (filteredAttractions.isEmpty) //TODO: Update search
            Center(
              child: Column(
                children: [
                  Text(
                    controller.selectedFilterIndex.value == 0
                        ? 'No attractions found'
                        : 'No attractions found for ${controller.filterOptions[controller.selectedFilterIndex.value]}',
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => controller.fetchAttractions(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredAttractions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final attraction = filteredAttractions[index];
                return ExperienceItem(
                  image: attraction.image ?? '',
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