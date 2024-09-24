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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back navigation
            Navigator.of(context).pop();
          },
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
            _buildLoginButton(context),
            Spacer(),
            // Positioning the forget password option at the bottom
            GestureDetector(
              onTap: () {
                // Handle forget password action
                print("Forget Password tapped");
              },
              child: Text(
                'Forget Password?',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Container to apply gradient background to the button
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 198, 48, 1),
              Color.fromRGBO(255, 179, 57, 1),
              Color.fromRGBO(254, 150, 68, 1),
              Color.fromRGBO(255, 126, 79, 1),
              Color.fromRGBO(255, 116, 83, 1),
              Color.fromRGBO(255, 93, 93, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FingerprintAuthPopupScreen(),
            ));
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 110, vertical: 15),
            backgroundColor: Colors.transparent, // Make background transparent
            elevation: 0, // Remove elevation for seamless gradient
          ),
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      SizedBox(width: 5), // Space between button and icon
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FingerprintAuthPopupScreen(),
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 198, 48, 1),
                Color.fromRGBO(255, 179, 57, 1),
                Color.fromRGBO(254, 150, 68, 1),
                Color.fromRGBO(255, 126, 79, 1),
                Color.fromRGBO(255, 116, 83, 1),
                Color.fromRGBO(255, 93, 93, 1),
              ],
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(
            Icons.fingerprint,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}


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
}
class FingerprintAuthPopupScreen extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateWithFingerprint(BuildContext context) async {
    try {
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {
        bool authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => SuccessfulAuthenticationScreen(),
          ));
        }
      } else {
        print('No biometrics available on this device.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        // title: Text('Fingerprint Authentication'),
      ),
      backgroundColor: Colors.grey[900]?.withOpacity(0.8),
      body: Center(
        child: Container(
          width: 300,
          height: 350,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fingerprint',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Authentication',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _authenticateWithFingerprint(context),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                  Color.fromRGBO(255, 198, 48, 1),
                  Color.fromRGBO(255, 179, 57, 1),
                  Color.fromRGBO(254, 150, 68, 1),
                  Color.fromRGBO(255, 126, 79, 1),
                  Color.fromRGBO(255, 116, 83, 1),
                  Color.fromRGBO(255, 93, 93, 1),
                ],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.fingerprint,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class SuccessfulAuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // title: Text('Authenticated'),
        backgroundColor: Colors.black,
      ),
      body: Center( // Center widget to align the container in the middle
        child: SingleChildScrollView( // Added scrollable feature
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 198, 48, 1),
                  Color.fromRGBO(255, 179, 57, 1),
                  Color.fromRGBO(254, 150, 68, 1),
                  Color.fromRGBO(255, 126, 79, 1),
                  Color.fromRGBO(255, 116, 83, 1),
                  Color.fromRGBO(255, 93, 93, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.all(20), // Added padding for better spacing
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize height to fit content
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'You have successfully authenticated!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[300],
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



