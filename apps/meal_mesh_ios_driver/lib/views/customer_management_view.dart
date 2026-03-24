import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerManagementView extends StatelessWidget {
  const CustomerManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Customer Directory", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text("Loading...", style: TextStyle(color: Colors.grey));
                return Text("Total Customers: ${snapshot.data!.docs.length}", style: const TextStyle(color: Colors.grey));
              }
            ),
            const SizedBox(height: 32),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.orange));
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("No customers registered."));

                  return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => const Divider(color: Colors.black12),
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.orange.shade100, child: const Icon(Icons.person, color: Colors.orange)),
                        title: Text(data['name'] ?? 'Unknown User', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${data['email'] ?? 'No email'} • ${data['phone'] ?? 'No phone'}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => FirebaseFirestore.instance.collection('users').doc(doc.id).delete(),
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
