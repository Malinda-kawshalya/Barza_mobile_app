import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeAppbar {
  static AppBar buildHomeAppbar(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
      backgroundColor: const Color(0xFF0C969C),
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 100,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "BarZar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 30),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            Positioned(
              right: 5,
              top: 5,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .where('read', isEqualTo: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${snapshot.data!.docs.length}',
                        style: TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    );
                  } else {
                    return Container(); // No badge when no unread notifications
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}