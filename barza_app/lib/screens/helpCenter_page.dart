import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 232, 238, 238), // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Help Center",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C969C),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Need help?\nTalk to us!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset("assets/helpcenter.png", height: 120), 
              SizedBox(height: 20),
              Text(
                "Alternatively, call us on (021) 88888888 or email us at applications.support@gmail.com for further assistance",
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0C969C), // Call Now Button Color
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Call Now", style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Color(0xFF0C969C), width: 2),
                    ),
                    child: Text("Send Email", style: TextStyle(color: Color(0xFF0C969C), fontSize: 16)),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                     border: Border.all(color: Color(0xFF0C969C), width: 2),
                     borderRadius: BorderRadius.circular(12),
                    color: Color.fromARGB(255, 246, 248, 248)
                   
                  ),
                  child: Column(
                    children: [
                      Text(
                      "FAQ",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0C969C)),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                        
                        ),
                        child: ListView(
                        children: [
                          FAQTile(question: "What is this app about?", answer: "This app helps with bartering."),
                          FAQTile(question: "How does bartering work on this app?", answer: "Users can exchange goods or services."),
                          FAQTile(question: "Is the app free to use?", answer: "Yes, this app is completely free."),
                          FAQTile(question: "How do I create an account?", answer: "You can sign up from the login page."),
                          FAQTile(question: "How do I create an account?", answer: "You can sign up from the login page."),
                          FAQTile(question: "How do I create an account?", answer: "You can sign up from the login page."),
                        ],
                        ),
                      ),
                      ),
                    ],
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

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;
  FAQTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(question, style: TextStyle(fontWeight: FontWeight.bold)),
      children: [Padding(padding: EdgeInsets.all(10), child: Text(answer))],
    );
  }
}
