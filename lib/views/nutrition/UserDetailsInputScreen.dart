import 'package:flutter/material.dart';
import 'package:lung_life/views/nutrition/chat_bot.dart'; // Import ChatScreen

class UserDetailsInputScreen extends StatefulWidget {
  @override
  _UserDetailsInputScreenState createState() => _UserDetailsInputScreenState();
}

class _UserDetailsInputScreenState extends State<UserDetailsInputScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _exerciseDaysController = TextEditingController();
  final TextEditingController _healthStatusController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _exerciseDaysController.dispose();
    _healthStatusController.dispose();
    super.dispose();
  }

  void _sendToAIBot() {
    final String weight = _weightController.text.trim();
    final String height = _heightController.text.trim();
    final String age = _ageController.text.trim();
    final String exerciseDays = _exerciseDaysController.text.trim();
    final String healthStatus = _healthStatusController.text.trim();

    if (weight.isEmpty || height.isEmpty || age.isEmpty || exerciseDays.isEmpty || healthStatus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    final String formattedMessage = "My details are: Weight: $weight kg, Height: $height cm, Age: $age years, Exercise Days per week: $exerciseDays, Health Status: $healthStatus. Based on these details, please provide nutrition plan.";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(initialMessage: formattedMessage), // Pass initial message
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1C1B29),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Enter Your Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF1C1B29),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(_weightController, 'Weight (kg)', TextInputType.number),
            SizedBox(height: 15),
            _buildTextField(_heightController, 'Height (cm)', TextInputType.number),
            SizedBox(height: 15),
            _buildTextField(_ageController, 'Age', TextInputType.number),
            SizedBox(height: 15),
            _buildTextField(_exerciseDaysController, 'Number of Exercise Days per week', TextInputType.number),
            SizedBox(height: 15),
            _buildTextField(_healthStatusController, 'Current Health Status (e.g., healthy, diabetic, heart condition)', TextInputType.text),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _sendToAIBot,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Color(0xFF5B2D50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Send to AI Diet Assistant",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white), // Text input color
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[400]), // Label color
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[600]!), // Border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF5B2D50), width: 2), // Focused border color
        ),
        fillColor: Color(0xFF2C2B3A), // Text field background
        filled: true,
      ),
    );
  }
} 