import 'package:json_annotation/json_annotation.dart';

part 'sleep_prediction_request.g.dart';

@JsonSerializable()
class SleepPredictionRequest {
  final int age;
  final double sleepDuration;
  final double stressLevel;
  final double physicalActivityLevel;
  final int heartRate;

  SleepPredictionRequest({
    required this.age,
    required this.sleepDuration,
    required this.stressLevel,
    required this.physicalActivityLevel,
    required this.heartRate,
  });

  factory SleepPredictionRequest.fromJson(Map<String, dynamic> json) =>
      _$SleepPredictionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SleepPredictionRequestToJson(this);
}

@JsonSerializable()
class SleepPredictionResponse {
  final List<String> advice;
  final String? error;

  SleepPredictionResponse({
    required this.advice,
    this.error,
  });

  factory SleepPredictionResponse.fromJson(Map<String, dynamic> json) =>
      _$SleepPredictionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SleepPredictionResponseToJson(this);
} 