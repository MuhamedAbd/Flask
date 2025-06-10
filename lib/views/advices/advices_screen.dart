import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../models/sleep_prediction_request.dart';
import '../../services/sleep_prediction_service.dart';
import 'sleep_statistics_screen.dart';

class AdvicesScreen extends StatefulWidget {
  const AdvicesScreen({super.key});

  @override
  State<AdvicesScreen> createState() => _AdvicesScreenState();
}

class _AdvicesScreenState extends State<AdvicesScreen> {
  final _sleepService = SleepPredictionService();
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _ageController = TextEditingController();
  final _sleepDurationController = TextEditingController();
  double _sleepDuration = 7.0;
  double _stressLevel = 5.0;
  double _physicalActivityLevel = 5.0;
  final _heartRateController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _ageController.dispose();
    _sleepDurationController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  Future<void> _getSleepAdvice() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('Form validation failed');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('Getting sleep advice...');
      final request = SleepPredictionRequest(
        age: int.parse(_ageController.text),
        sleepDuration: double.parse(_sleepDurationController.text),
        stressLevel: _stressLevel,
        physicalActivityLevel: _physicalActivityLevel,
        heartRate: int.parse(_heartRateController.text),
      );

      debugPrint('Created request: ${request.toJson()}');
      final response = await SleepPredictionService().getSleepAdvice(request);
      debugPrint('Got response: ${response.toJson()}');

      if (!mounted) return;

      if (response.error != null) {
        _showErrorDialog(response.error!);
      } else {
        // Navigate to statistics screen instead of showing dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SleepStatisticsScreen(
              response: response,
              request: request,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting sleep advice: $e');
      if (!mounted) return;
      _showErrorDialog('Failed to get sleep advice. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String error) {
    debugPrint('Showing error dialog: $error');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D3E),
        title: const Text(
          'Error',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          error,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF6366F1)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B29),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1B29),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sleep Insights',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3A1078), Color(0xFF4E31AA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sleep Health Analysis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Get personalized sleep advice based on your health data',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Age Input
                  TextFormField(
                    controller: _ageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6366F1)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2A2D3E),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age < 1 || age > 120) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Sleep Duration Input
                  TextFormField(
                    controller: _sleepDurationController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Sleep Duration (hours)',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8B00FF)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your sleep duration';
                      }
                      final sleepDuration = double.tryParse(value);
                      if (sleepDuration == null) {
                        return 'Please enter a valid number';
                      }
                      if (sleepDuration < 0 || sleepDuration > 24) {
                        return 'Sleep duration must be between 0 and 24 hours';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Heart Rate Input
                  TextFormField(
                    controller: _heartRateController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Heart Rate (bpm)',
                      labelStyle: const TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6366F1)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2A2D3E),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your heart rate';
                      }
                      final rate = int.tryParse(value);
                      if (rate == null || rate < 40 || rate > 200) {
                        return 'Please enter a valid heart rate';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Stress Level Slider
                  _buildSliderSection(
                    title: 'Stress Level (0-10)',
                    value: _stressLevel,
                    onChanged: (value) => setState(() => _stressLevel = value),
                  ),
                  const SizedBox(height: 24),

                  // Physical Activity Level Slider
                  _buildSliderSection(
                    title: 'Physical Activity Level (0-10)',
                    value: _physicalActivityLevel,
                    onChanged: (value) => setState(() => _physicalActivityLevel = value),
                  ),
                  const SizedBox(height: 32),

                  // Get Sleep Advice Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _getSleepAdvice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8B00FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Get Sleep Advice',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6366F1),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 8),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value.toInt().toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF6366F1),
            inactiveTrackColor: const Color(0xFF2A2D3E),
            thumbColor: const Color(0xFF6366F1),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
} 