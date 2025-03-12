import 'package:flutter/material.dart';

class PrivacyPermissionsScreen extends StatelessWidget {
  const PrivacyPermissionsScreen({Key? key}) : super(key: key);

  // App color scheme
  final Color primaryColor = Colors.teal; // Primary blue color
  final Color accentColor = const Color(0xFF4CAF50); // Secondary green color
  final Color backgroundColor = const Color(0xFFF5F5F5); // Light background
  final Color cardColor = Colors.white;
  final Color textPrimaryColor = const Color(0xFF212121); // Dark text
  final Color textSecondaryColor = const Color(0xFF757575); // Grey text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Privacy & Permissions'),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy & App Permissions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Introduction'),
            _buildParagraph(
              'Welcome to Barza. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you about how we look after your personal data when you use our application and tell you about your privacy rights.',
            ),
            _buildSectionTitle('Permissions We Request'),
            _buildPermissionItem(
              Icons.photo_library,
              'Photos & Media',
              'To allow you to upload and share photos and media files.',
              'Read and write access to your media files.',
            ),
            _buildPermissionItem(
              Icons.location_on,
              'Location',
              'To provide location-based services and features.',
              'Access to your device\'s location when using the app.',
            ),
            _buildPermissionItem(
              Icons.camera,
              'Camera',
              'To take photos and videos within the app.',
              'Access to your device\'s camera.',
            ),
            _buildPermissionItem(
              Icons.mic,
              'Microphone',
              'For voice recording and audio features.',
              'Access to your device\'s microphone.',
            ),
            _buildPermissionItem(
              Icons.storage,
              'Storage',
              'To save files and cache data locally.',
              'Read and write access to your device\'s storage.',
            ),
            _buildPermissionItem(
              Icons.notifications,
              'Notifications',
              'To send you important updates and alerts.',
              'Permission to send push notifications to your device.',
            ),
            _buildSectionTitle('Data Collection and Use'),
            _buildParagraph(
              'We collect information that you provide directly to us, such as when you create an account, fill in forms, or communicate with us. We also collect data automatically when you use our app, including usage data and device information.',
            ),
            _buildParagraph(
              'We use this information to provide, maintain, and improve our services, communicate with you, and protect our services and users.',
            ),
            _buildSectionTitle('Data Sharing and Disclosure'),
            _buildParagraph(
              'We do not sell your personal information. We may share your information with third-party service providers who perform services on our behalf, such as hosting, data analysis, and customer service.',
            ),
            _buildSectionTitle('Your Rights'),
            _buildParagraph(
              'You have the right to access, correct, or delete your personal information. You can also object to processing of your personal information or request restriction of processing.',
            ),
            _buildSectionTitle('Security'),
            _buildParagraph(
              'We have implemented appropriate security measures to prevent your personal information from being accidentally lost, used, or accessed in an unauthorized way.',
            ),
            _buildSectionTitle('Changes to This Privacy Policy'),
            _buildParagraph(
              'We may update our privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page.',
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child:
                    const Text('I Understand', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: textPrimaryColor),
      ),
    );
  }

  Widget _buildPermissionItem(
      IconData icon, String title, String description, String details) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: accentColor),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16, color: textPrimaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              details,
              style: TextStyle(
                fontSize: 14,
                color: textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
