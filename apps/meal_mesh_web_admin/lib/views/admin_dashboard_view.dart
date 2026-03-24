import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Properly importing the modular views
import 'vendor_management_view.dart';
import 'customer_management_view.dart';
import 'driver_management_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const VendorManagementView(),
    const CustomerManagementView(),
    const DriverManagementView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 250,
            color: const Color(0xFF1E222D),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text("MEALMESH", style: TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text("MANAGEMENT", style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
                const SizedBox(height: 16),
                
                _buildNavItem(0, "Vendors", Icons.storefront),
                _buildNavItem(1, "Customers", Icons.people_outline),
                _buildNavItem(2, "Drivers", Icons.sports_motorsports),
                
                const Spacer(),
                
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text("Sign Out", style: TextStyle(color: Colors.redAccent, fontSize: 14)),
                  onTap: () {
                    Get.snackbar("Logged Out", "Returning to login screen.");
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String title, IconData icon) {
    bool isActive = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: isActive ? Colors.orange : Colors.transparent, width: 4)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Icon(icon, color: isActive ? Colors.orange : Colors.white54),
          title: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.white54, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 15)),
        ),
      ),
    );
  }
}
