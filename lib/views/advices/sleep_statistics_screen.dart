import 'package:flutter/material.dart';
import '../../models/sleep_prediction_request.dart';

class SleepStatisticsScreen extends StatelessWidget {
  final SleepPredictionResponse response;
  final SleepPredictionRequest request;

  const SleepStatisticsScreen({
    Key? key,
    required this.response,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1B29),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with gradient
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B00FF), Color(0xFFFFD700)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.nightlight_round,
                        size: 150,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Sleep Analysis',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Your Personalized Sleep Insights',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Sleep Quality Score Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8B00FF).withOpacity(0.2), Color(0xFFFFD700).withOpacity(0.2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sleep Quality Score',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getSleepQualityColor(response.advice),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_getSleepQualityScore(response.advice)}/10',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      LinearProgressIndicator(
                        value: _getSleepQualityScore(response.advice) / 10,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(_getSleepQualityColor(response.advice)),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _getSleepQualityDescription(response.advice),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Input Summary Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Sleep Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 1.5,
                      children: [
                        _buildMetricCard(
                          'Sleep Duration',
                          '${request.sleepDuration} hours',
                          Icons.timer,
                          _getSleepDurationColor(request.sleepDuration),
                        ),
                        _buildMetricCard(
                          'Stress Level',
                          '${request.stressLevel}/10',
                          Icons.psychology,
                          _getStressColor(request.stressLevel),
                        ),
                        _buildMetricCard(
                          'Physical Activity',
                          '${request.physicalActivityLevel}/10',
                          Icons.fitness_center,
                          _getActivityColor(request.physicalActivityLevel),
                        ),
                        _buildMetricCard(
                          'Heart Rate',
                          '${request.heartRate} BPM',
                          Icons.favorite,
                          _getHeartRateColor(request.heartRate),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Advice Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personalized Recommendations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    ...response.advice.map((advice) => _buildAdviceCard(advice)).toList(),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Additional Tips Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B00FF).withOpacity(0.2), Color(0xFFFFD700).withOpacity(0.2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Color(0xFFFFD700)),
                        SizedBox(width: 10),
                        Text(
                          'Pro Tips',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      '• Track your sleep patterns for better insights\n'
                      '• Maintain a consistent sleep schedule\n'
                      '• Create a relaxing bedtime routine\n'
                      '• Keep your bedroom cool and dark\n'
                      '• Limit screen time before bed',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard(String advice) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF8B00FF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.tips_and_updates,
              color: Color(0xFFFFD700),
              size: 20,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              advice,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSleepDurationColor(double duration) {
    if (duration < 6) return Colors.red;
    if (duration > 9) return Colors.orange;
    return Colors.green;
  }

  Color _getStressColor(double level) {
    if (level > 7) return Colors.red;
    if (level > 4) return Colors.orange;
    return Colors.green;
  }

  Color _getActivityColor(double level) {
    if (level < 3) return Colors.red;
    if (level > 7) return Colors.orange;
    return Colors.green;
  }

  Color _getHeartRateColor(int rate) {
    if (rate > 100) return Colors.red;
    if (rate > 85) return Colors.orange;
    return Colors.green;
  }

  int _getSleepQualityScore(List<String> advice) {
    if (advice.any((a) => a.contains('sleep quality is below average'))) return 4;
    if (advice.any((a) => a.contains('sleep quality is excellent'))) return 9;
    if (advice.any((a) => a.contains('sleep duration is significantly below recommended'))) return 5;
    if (advice.any((a) => a.contains('high stress levels detected'))) return 6;
    return 7; // Default score for moderate sleep quality
  }

  Color _getSleepQualityColor(List<String> advice) {
    int score = _getSleepQualityScore(advice);
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.orange;
    return Colors.red;
  }

  String _getSleepQualityDescription(List<String> advice) {
    int score = _getSleepQualityScore(advice);
    if (score >= 8) return 'Excellent sleep quality! Keep maintaining your healthy sleep habits.';
    if (score >= 6) return 'Good sleep quality, but there\'s room for improvement.';
    return 'Your sleep quality needs attention. Follow the recommendations below to improve it.';
  }
} 