import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/home_controller.dart';
import '../../services/auth_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller when the screen loads
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Meal Mesh Delivery", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.orange),
            onPressed: () => AuthService.to.logout(), // Uses our global Auth Service!
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text("Live Restaurants", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Obx(() {
              // 1. Handle Error State
              if (controller.hasError.value) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () => controller.onInit(),
                    child: const Text("Retry Connection"),
                  ),
                );
              }

              // 2. Handle Loading State
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.orange));
              }

              // 3. Handle Empty State
              if (controller.restaurants.isEmpty) {
                return const Center(
                  child: Text("No restaurants are currently online.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                );
              }

              // 4. Handle Success State
              return ListView.builder(
                itemCount: controller.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = controller.restaurants[index];

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    height: 200.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(image: NetworkImage(restaurant.image), fit: BoxFit.cover),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent]),
                      ),
                      padding: EdgeInsets.all(20.w),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(restaurant.name, style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.white70, size: 16),
                              SizedBox(width: 5.w),
                              Expanded(child: Text(restaurant.address, style: const TextStyle(color: Colors.white70, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
