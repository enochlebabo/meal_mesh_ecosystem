import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/vendor_controller.dart';
import '../services/vendor_auth_service.dart';
import 'vendor_catalog_view.dart'; // Imports your High-Fidelity Catalog

class VendorDashboardView extends StatefulWidget {
  const VendorDashboardView({super.key});
  @override
  State<VendorDashboardView> createState() => _VendorDashboardViewState();
}

class _VendorDashboardViewState extends State<VendorDashboardView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(VendorController());
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(c),
                Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(40), child: _getPage(_selectedIndex, c))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() => Container(
    width: 260, color: const Color(0xFF111827),
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    child: Column(children: [
      const Text("MEALMESH", style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 40),
      _navItem(0, Icons.analytics, "Overview"),
      _navItem(1, Icons.kitchen, "Live Kitchen"),
      _navItem(2, Icons.restaurant_menu, "Menu Catalog"), // RESTORED CATALOG TAB
      const Spacer(),
      ListTile(
        leading: const Icon(Icons.logout, color: Colors.red), 
        title: const Text("Sign Out", style: TextStyle(color: Colors.red)),
        onTap: () => VendorAuthService.to.logout()
      ),
    ]),
  );

  Widget _navItem(int i, IconData icon, String l) => ListTile(
    onTap: () => setState(() => _selectedIndex = i),
    leading: Icon(icon, color: _selectedIndex == i ? Colors.orange : Colors.grey),
    title: Text(l, style: TextStyle(color: _selectedIndex == i ? Colors.white : Colors.grey)),
    tileColor: _selectedIndex == i ? Colors.orange.withOpacity(0.1) : Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  Widget _buildHeader(VendorController c) => Container(
    height: 80, color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Obx(() => Text(c.restaurantData['name'] ?? "Vendor Console", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      Obx(() => Row(
        children: [
          Text((c.restaurantData['isOpen'] ?? false) ? "STORE IS LIVE" : "STORE CLOSED", 
            style: TextStyle(color: (c.restaurantData['isOpen'] ?? false) ? Colors.green : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(width: 12),
          Switch(value: c.restaurantData['isOpen'] ?? false, activeColor: Colors.green, onChanged: (v) => c.toggleStore(v)),
        ],
      )),
    ]),
  );

  Widget _getPage(int i, VendorController c) {
    if (i == 0) return _buildOverview(c);
    if (i == 1) return _buildKitchen(c);
    if (i == 2) return const VendorCatalogView(); // LOADS YOUR PHOTO/DESC CATALOG
    return _buildOverview(c);
  }

  // --- OVERVIEW & ANALYTICS ---

  Widget _buildOverview(VendorController c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("Business Intelligence", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnalyticsCard(c),
          const SizedBox(width: 24),
          _buildQuickStats(c),
        ],
      ),
    ],
  );

  Widget _buildAnalyticsCard(VendorController c) => Container(
    width: 400,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
    child: Column(
      children: [
        const Text("Top Selling Items", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: Obx(() {
            // FIXED THE BLANK CHART ISSUE
            if (c.salesData.isEmpty) {
              return const Center(child: Text("Waiting for first order to generate chart...", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)));
            }
            return PieChart(
              PieChartData(
                sections: c.salesData.entries.map((e) => PieChartSectionData(
                  value: e.value.toDouble(), title: e.key,
                  color: Colors.orange.withOpacity(0.5 + (0.1 * c.salesData.keys.toList().indexOf(e.key))),
                  radius: 50, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)
                )).toList(),
              ),
            );
          }),
        ),
      ],
    ),
  );

  Widget _buildQuickStats(VendorController c) => Expanded(
    child: Column(
      children: [
        _miniCard("Total Revenue", "₹${(c.orders.length * 250).toString()}", Icons.account_balance_wallet, Colors.green),
        const SizedBox(height: 16),
        _miniCard("Active Orders", c.orders.where((o) => o['status'] != 'Ready').length.toString(), Icons.receipt_long, Colors.blue),
      ],
    ),
  );

  Widget _miniCard(String t, String v, IconData i, Color color) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
    child: Row(
      children: [
        Icon(i, color: color, size: 32),
        const SizedBox(width: 20),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ]),
      ],
    ),
  );

  // --- KITCHEN DISPLAY SYSTEM ---

  Widget _buildKitchen(VendorController c) => Obx(() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _kitchenColumn("PENDING", c.orders.where((o) => o['status'] == 'Pending').toList(), Colors.orange, c),
      const SizedBox(width: 20),
      _kitchenColumn("PREPARING", c.orders.where((o) => o['status'] == 'Preparing').toList(), Colors.blue, c),
      const SizedBox(width: 20),
      _kitchenColumn("READY", c.orders.where((o) => o['status'] == 'Ready').toList(), Colors.green, c),
    ],
  ));

  Widget _kitchenColumn(String title, List orders, Color color, VendorController c) => Expanded(
    child: Column(children: [
      Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)), child: Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      const SizedBox(height: 16),
      if (orders.isEmpty) Padding(padding: const EdgeInsets.all(20), child: Text("No $title orders", style: TextStyle(color: Colors.grey.shade400))),
      ...orders.map((o) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text("Order #${o['id'].toString().substring(0, 4)}", style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(o['items'].join(", "), style: const TextStyle(height: 1.5)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => _showStatusUpdate(o, c),
        ),
      )),
    ]),
  );

  void _showStatusUpdate(Map o, VendorController c) {
    Get.bottomSheet(Container(
      color: Colors.white, padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("Update Order Progress", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 20),
        ListTile(leading: const Icon(Icons.microwave, color: Colors.blue), title: const Text("Move to Preparing"), onTap: () { c.updateOrderStatus(o['id'], "Preparing"); Get.back(); }),
        ListTile(leading: const Icon(Icons.check_circle, color: Colors.green), title: const Text("Move to Ready"), onTap: () { c.updateOrderStatus(o['id'], "Ready"); Get.back(); }),
      ]),
    ));
  }
}
