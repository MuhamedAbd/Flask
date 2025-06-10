// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_prediction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SleepPredictionRequest _$SleepPredictionRequestFromJson(
        Map<String, dynamic> json) =>
    SleepPredictionRequest(
      age: (json['age'] as num).toInt(),
      sleepDuration: (json['sleepDuration'] as num).toDouble(),
      stressLevel: (json['stressLevel'] as num).toDouble(),
      physicalActivityLevel: (json['physicalActivityLevel'] as num).toDouble(),
      heartRate: (json['heartRate'] as num).toInt(),
    );

Map<String, dynamic> _$SleepPredictionRequestToJson(
        SleepPredictionRequest instance) =>
    <String, dynamic>{
      'age': instance.age,
      'sleepDuration': instance.sleepDuration,
      'stressLevel': instance.stressLevel,
      'physicalActivityLevel': instance.physicalActivityLevel,
      'heartRate': instance.heartRate,
    };

SleepPredictionResponse _$SleepPredictionResponseFromJson(
        Map<String, dynamic> json) =>
    SleepPredictionResponse(
      advice:
          (json['advice'] as List<dynamic>).map((e) => e as String).toList(),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$SleepPredictionResponseToJson(
        SleepPredictionResponse instance) =>
    <String, dynamic>{
      'advice': instance.advice,
      'error': instance.error,
    };
