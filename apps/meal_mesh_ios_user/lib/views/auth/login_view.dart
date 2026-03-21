import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/auth_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final nameC = TextEditingController();
  
  bool isLogin = true;
  bool isLoading = false;

  void submit() async {
    if (emailC.text.isEmpty || passC.text.isEmpty || (!isLogin && nameC.text.isEmpty)) return;
    
    setState(() => isLoading = true);
    
    try {
      if (isLogin) {
        await AuthService.to.login(emailC.text.trim(), passC.text.trim());
      } else {
        await AuthService.to.registerCustomer(nameC.text.trim(), emailC.text.trim(), passC.text.trim());
      }
    } catch (e) {
      // Errors handled by service
    } finally {
      if (mounted) setState(() => isLoading = false); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.fastfood_rounded, size: 80.w, color: Colors.orange),
                SizedBox(height: 20.h),
                Text(
                  isLogin ? "Welcome Back" : "Join Meal Mesh",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                Text(
                  "The ultimate food delivery ecosystem.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                SizedBox(height: 40.h),

                if (!isLogin) ...[
                  TextField(
                    controller: nameC,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],

                TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 15.h),

                TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 30.h),

                SizedBox(
                  height: 55.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: isLoading ? null : submit,
                    child: isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isLogin ? "LOGIN" : "SIGN UP", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                SizedBox(height: 15.h),
                
                // THE NEW, FIXED GOOGLE BUTTON
                SizedBox(
                  height: 55.h,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    // Replaced SVG with a high-res PNG!
                    icon: Image.network(
                      'https://img.icons8.com/color/48/google-logo.png',
                      height: 24.h,
                      width: 24.w,
                    ),
                    label: Text(
                      "Continue with Google", 
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87, fontWeight: FontWeight.bold),
                      maxLines: 1, // Prevents text wrapping
                    ),
                    onPressed: isLoading ? null : () async {
                      setState(() => isLoading = true);
                      await AuthService.to.signInWithGoogle();
                      if (mounted) setState(() => isLoading = false);
                    },
                  ),
                ),
                
                SizedBox(height: 20.h),

                TextButton(
                  onPressed: () => setState(() => isLogin = !isLogin),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      children: [
                        TextSpan(text: isLogin ? "Don't have an account? " : "Already have an account? "),
                        TextSpan(text: isLogin ? "Sign Up" : "Login", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
