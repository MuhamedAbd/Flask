import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/auth_service.dart'; // Import AuthService
import 'package:lung_life/views/control_panel/ChangeUsernameScreen.dart';
import 'package:lung_life/views/control_panel/ChangePasswordScreen.dart';

class ControlPanelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5B2D50),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Account",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Ensure user name is fetched
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (userProvider.userName.isEmpty) {
              userProvider.getUserEmail();
            }
          });

          return Column(
            children: [
              SizedBox(height: 40),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/user_avatar.png'), // Replace with actual user image
                ),
              ),
              SizedBox(height: 10),
              Text(
                userProvider.userName.isNotEmpty ? userProvider.userName : 'Loading...',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                // Assuming email can be accessed if userName is not yet loaded or as a fallback
                AuthService().currentUser?.email ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),
              Divider(),
              ListTile(
                title: Text("Change username"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeUsernameScreen()),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text("Change password"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                  );
                },
              ),
              Divider(),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await userProvider.logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFE0E0E0),
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Log out",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 