import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() => runApp(FingerprintAuthApp());

class FingerprintAuthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FingerprintAuthScreen(),
    );
  }
}

class FingerprintAuthScreen extends StatefulWidget {
  @override
  _FingerprintAuthScreenState createState() => _FingerprintAuthScreenState();
}

class _FingerprintAuthScreenState extends State<FingerprintAuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _authenticated = false;

  // Fingerprint Authentication Logic
  Future<void> _authenticateWithFingerprint() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _authenticated = authenticated;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            _buildTextField(
              labelText: 'Email Address',
              prefixIcon: Icons.email,
            ),
            SizedBox(height: 20),
            _buildTextField(
              labelText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 40),
            _buildLoginButton(),
            SizedBox(height: 20),
            Text(
              'Forget Password?',
              style: TextStyle(color: Colors.grey[500]),
            ),
            Spacer(),
            GestureDetector(
              onTap: _authenticateWithFingerprint,
              child: Column(
                children: [
                  _buildFingerprintIcon(),
                  SizedBox(height: 10),
                  Text(
                    'Fingerprint Authentication',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Helper method to build the login button
  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        backgroundColor: Colors.orangeAccent, // Updated property name
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        'Login',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  // Helper method to build the fingerprint icon
  Widget _buildFingerprintIcon() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.orangeAccent, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(15),
      child: Icon(
        Icons.fingerprint,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}
