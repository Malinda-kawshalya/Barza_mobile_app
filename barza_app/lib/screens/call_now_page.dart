import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  String phoneNumber = '0771111150'; // Auto-selected number

  Future<void> _makeCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void _cancelCall() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 238, 238),
      appBar: AppBar(
        title: const Text('Call Now'),
        backgroundColor: Color(0xFF0C969C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              phoneNumber,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _makeCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0C969C),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Call', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: _cancelCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0C969C),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}