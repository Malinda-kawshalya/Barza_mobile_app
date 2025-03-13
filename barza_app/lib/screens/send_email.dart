import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendEmailPage extends StatelessWidget {
  final String email = 'mailto:applications.support@gmail.com';

  SendEmailPage({Key? key}) : super(key: key);

  Future<void> _sendEmail() async {
    if (await canLaunch(email)) {
      await launch(email);
    } else {
      throw 'Could not launch $email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Email'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, size: 100, color: Theme.of(context).primaryColor),
              SizedBox(height: 20),
              Text(
                'Email us at applications.support@gmail.com for further assistance.',
                style: TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Email applications.support@gmail.com', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}