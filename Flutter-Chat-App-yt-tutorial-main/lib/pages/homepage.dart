import 'package:chatapp_yt/dataModel/userprofile.dart';
import 'package:chatapp_yt/database_services.dart';
import 'package:chatapp_yt/pages/chat.dart';
import 'package:chatapp_yt/pages/chatTile.dart';
import 'package:chatapp_yt/pages/userauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance;
  final currentuser = FirebaseAuth.instance.currentUser;
  final Database _database = Database();
  UserProfile? _profile;
  bool _isLoading = true;

  Future<void> _loadimg() async {
    if (currentuser != null) {
      final userprofile = await _database.getprofileimg(currentuser!.uid);
      setState(() {
        _profile = userprofile;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadimg();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text(
            'CHATS',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(7.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: _profile?.pfpURL != null
                  ? NetworkImage(
                      _profile!.pfpURL!,
                    )
                  : null,
              child: _profile?.pfpURL == null ? const Icon(Icons.person) : null,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  user.signOut();
                  Get.off(() => const UserAuth());
                },
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                  color: Colors.white,
                ))
          ],
        ),
        body: Chatlist(context),
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget Chatlist(BuildContext context) {
    return StreamBuilder(
        stream: _database.getuserProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            final users = snapshot.data!.docs;
            if (users.isEmpty) {
              return const Center(
                child: Text('No Users Found!!'),
              );
            }
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserProfile userProfile = users[index].data();
                  return ChatTile(
                      userProfile: userProfile,
                      ontap: () async {
                        final chatexists = await _database.checkuserid(
                            user.currentUser!.uid, userProfile.uid!);
                        if (!chatexists) {
                          await _database.createnewchat(
                              user.currentUser!.uid, userProfile.uid!);
                        }
                        Get.to(() => Chatpage(
                              userProfile: userProfile,
                            ));
                      });
                });
          }
          return const Center(
            child: Text('No Data Found'),
          );
        });
  }
}
