import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/vendor_auth_service.dart';

class VendorLoginView extends StatefulWidget {
  const VendorLoginView({super.key});
  @override
  State<VendorLoginView> createState() => _VendorLoginViewState();
}

class _VendorLoginViewState extends State<VendorLoginView> {
  bool isLogin = true;
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final nameC = TextEditingController();
  final addrC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827), // Deep Navy background
      body: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("MEALMESH", style: TextStyle(color: Colors.orange, fontSize: 28, fontWeight: FontWeight.bold)),
              Text(isLogin ? "Merchant Login" : "Merchant Registration", style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              
              if (!isLogin) ...[
                TextField(controller: nameC, decoration: const InputDecoration(labelText: "Restaurant Name", prefixIcon: Icon(Icons.store))),
                const SizedBox(height: 16),
                TextField(controller: addrC, decoration: const InputDecoration(labelText: "Store Address", prefixIcon: Icon(Icons.location_on))),
                const SizedBox(height: 16),
              ],
              
              TextField(controller: emailC, decoration: const InputDecoration(labelText: "Email Address", prefixIcon: Icon(Icons.email))),
              const SizedBox(height: 16),
              TextField(controller: passC, obscureText: true, decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock))),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () async {
                    if (isLogin) {
                      await VendorAuthService.to.login(emailC.text, passC.text);
                    } else {
                      await VendorAuthService.to.registerRestaurant(
                        email: emailC.text, 
                        password: passC.text, 
                        name: nameC.text, 
                        address: addrC.text
                      );
                    }
                  },
                  child: Text(isLogin ? "LOGIN" : "REGISTER", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin ? "New Merchant? Register here" : "Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
