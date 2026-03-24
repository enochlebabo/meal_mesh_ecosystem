import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorManagementView extends StatelessWidget {
  const VendorManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Vendor Management", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...", style: TextStyle(color: Colors.grey));
                final docs = snapshot.data!.docs;
                final pendingCount = docs.where((doc) => !(doc['isApproved'] as bool? ?? false)).length;
                return Text("Total: ${docs.length} ($pendingCount Pending)", style: const TextStyle(color: Colors.grey));
              }
            ),
            const SizedBox(height: 32),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.orange));
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No vendors registered."));

                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.black12),
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;
                      bool isApproved = data['isApproved'] ?? false;

                      return ListTile(
                        title: Text(data['name'] ?? 'Unnamed Vendor', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(data['address'] ?? 'No address provided'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isApproved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isApproved ? Colors.green : Colors.orange),
                              ),
                              child: Text(isApproved ? "LIVE" : "PENDING", style: TextStyle(color: isApproved ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 16),
                            Switch(
                              value: isApproved,
                              activeColor: Colors.green,
                              onChanged: (val) => FirebaseFirestore.instance.collection('restaurants').doc(doc.id).update({'isApproved': val}),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => FirebaseFirestore.instance.collection('restaurants').doc(doc.id).delete(),
                            ),
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
}
