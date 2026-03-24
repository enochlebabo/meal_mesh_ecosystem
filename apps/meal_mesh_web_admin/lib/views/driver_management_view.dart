import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverManagementView extends StatelessWidget {
  const DriverManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Driver Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  onPressed: () {}, 
                  icon: const Icon(Icons.campaign), 
                  label: const Text("BROADCAST")
                )
              ],
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('drivers').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...");
                
                final docs = snapshot.data!.docs;
                final pendingCount = docs.where((doc) => !(doc['isApproved'] as bool? ?? false)).length;
                
                return Text("Total: ${docs.length} ($pendingCount Pending)", style: const TextStyle(color: Colors.grey));
              }
            ),
            const SizedBox(height: 32),
            
            // DATA TABLE
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('drivers').orderBy('createdAt', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.orange));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No drivers registered yet.", style: TextStyle(color: Colors.grey)));
                  }

                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.black12),
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      
                      String name = data['name'] ?? 'Unknown';
                      String email = data['email'] ?? 'No email';
                      String vehicle = data['vehicle'] ?? 'Pending Details';
                      bool isApproved = data['isApproved'] ?? false;
                      String docId = doc.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            )),
                            Expanded(flex: 2, child: Text(vehicle, style: const TextStyle(color: Colors.black87))),
                            Expanded(flex: 1, child: _buildStatusBadge(isApproved)),
                            Expanded(flex: 1, child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(isApproved ? Icons.check_circle : Icons.check_circle_outline, color: isApproved ? Colors.green : Colors.grey),
                                  tooltip: isApproved ? "Revoke Access" : "Approve Driver",
                                  onPressed: () {
                                    // TOGGLE APPROVAL STATUS
                                    FirebaseFirestore.instance.collection('drivers').doc(docId).update({'isApproved': !isApproved});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  tooltip: "Delete Driver",
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection('drivers').doc(docId).delete();
                                  },
                                ),
                              ],
                            )),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isApproved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isApproved ? Colors.green : Colors.orange, width: 1),
      ),
      child: Text(
        isApproved ? "LIVE" : "PENDING",
        style: TextStyle(
          color: isApproved ? Colors.green : Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
