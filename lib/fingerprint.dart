import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintAuthConfirmationScreen extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateWithFingerprint(BuildContext context) async {
    try {
      // Get list of available biometrics
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {
        // Check if fingerprint is available
        bool authenticated = await auth.authenticate(
          localizedReason: 'Scan your fingerprint to authenticate',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (authenticated) {
          // Navigate to next screen after successful authentication
          Navigator.of(context).push(MaterialPageRoute(
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
        title: Text('Fingerprint Authentication'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _authenticateWithFingerprint(context),
          child: Text('Authenticate with Fingerprint'),
        ),
      ),
    );
  }
}

class SuccessfulAuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticated'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'You have successfully authenticated!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
