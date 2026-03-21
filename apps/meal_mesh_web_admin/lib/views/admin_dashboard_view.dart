import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import '../services/admin_auth_service.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});
  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _viewIndex = 0; // 0 for Vendors, 1 for Customers

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AdminController());

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 260, color: const Color(0xFF111827),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("MEALMESH", style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                const Text("MANAGEMENT", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.5)),
                const SizedBox(height: 10),
                _sidebarItem(0, Icons.store, "Vendors"),
                _sidebarItem(1, Icons.people, "Customers"),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text("Sign Out", style: TextStyle(color: Colors.redAccent)),
                  onTap: () => AdminAuthService.to.logout(),
                ),
              ],
            ),
          ),

          // MAIN CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopHeader(c),
                  const SizedBox(height: 30),
                  Expanded(child: _viewIndex == 0 ? _vendorList(c) : _customerList(c)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(AdminController c) => Obx(() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_viewIndex == 0 ? "Vendor Management" : "Customer Directory", 
               style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(_viewIndex == 0 ? "Total: ${c.vendorCount} (${c.pendingVendorCount} Pending)" : "Total Customers: ${c.customerCount}",
               style: const TextStyle(color: Colors.grey)),
        ],
      ),
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        onPressed: () => _showBroadcast(c),
        icon: const Icon(Icons.campaign, color: Colors.white),
        label: const Text("BROADCAST", style: TextStyle(color: Colors.white)),
      )
    ],
  ));

  Widget _vendorList(AdminController c) => Container(
    width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Obx(() => DataTable(
      columns: const [DataColumn(label: Text('BUSINESS')), DataColumn(label: Text('STATUS')), DataColumn(label: Text('ACTIONS'))],
      rows: c.allRestaurants.map((res) => DataRow(cells: [
        DataCell(Text(res['name'] ?? 'Unnamed')),
        DataCell(_statusChip(res['isApproved'] == true)),
        DataCell(Row(children: [
          IconButton(icon: Icon(Icons.verified, color: res['isApproved'] == true ? Colors.green : Colors.grey), onPressed: () => c.toggleApproval(res['id'], res['isApproved'] ?? false)),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => c.deleteEntity('restaurants', res['id'])),
        ])),
      ])).toList(),
    )),
  );

  Widget _customerList(AdminController c) => Container(
    width: double.infinity, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    child: Obx(() {
      final customers = c.allUsers.where((u) => u['role'] == 'customer').toList();
      return DataTable(
        columns: const [DataColumn(label: Text('NAME')), DataColumn(label: Text('EMAIL')), DataColumn(label: Text('CONTROL'))],
        rows: customers.map((u) => DataRow(cells: [
          DataCell(Text(u['name'] ?? 'Guest')),
          DataCell(Text(u['email'] ?? 'N/A')),
          DataCell(IconButton(icon: const Icon(Icons.person_remove, color: Colors.red), onPressed: () => c.deleteEntity('users', u['id']))),
        ])).toList(),
      );
    }),
  );

  Widget _sidebarItem(int index, IconData icon, String label) {
    bool active = _viewIndex == index;
    return ListTile(
      onTap: () => setState(() => _viewIndex = index),
      leading: Icon(icon, color: active ? Colors.orange : Colors.grey),
      title: Text(label, style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      tileColor: active ? Colors.orange.withOpacity(0.1) : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _statusChip(bool approved) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: approved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
    child: Text(approved ? "LIVE" : "PENDING", style: TextStyle(color: approved ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
  );

  void _showBroadcast(AdminController c) {
    Get.defaultDialog(title: "System Alert", content: TextField(controller: c.broadcastController), onConfirm: () { c.sendBroadcast(); Get.back(); });
  }
}
