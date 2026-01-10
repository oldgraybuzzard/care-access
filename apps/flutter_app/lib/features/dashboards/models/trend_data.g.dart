// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trend_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrendDataPoint _$TrendDataPointFromJson(Map<String, dynamic> json) =>
    TrendDataPoint(
      period: DateTime.parse(json['period'] as String),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$TrendDataPointToJson(TrendDataPoint instance) =>
    <String, dynamic>{
      'period': instance.period.toIso8601String(),
      'count': instance.count,
    };

CasesByProgram _$CasesByProgramFromJson(Map<String, dynamic> json) =>
    CasesByProgram(
      programId: json['programId'] as String,
      status: json['status'] as String,
      count: CountData.fromJson(json['_count'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CasesByProgramToJson(CasesByProgram instance) =>
    <String, dynamic>{
      'programId': instance.programId,
      'status': instance.status,
      '_count': instance.count,
    };

CountData _$CountDataFromJson(Map<String, dynamic> json) => CountData(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$CountDataToJson(CountData instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CasesByWorker _$CasesByWorkerFromJson(Map<String, dynamic> json) =>
    CasesByWorker(
      assignedWorkerId: json['assignedWorkerId'] as String?,
      count: CountData.fromJson(json['_count'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CasesByWorkerToJson(CasesByWorker instance) =>
    <String, dynamic>{
      'assignedWorkerId': instance.assignedWorkerId,
      '_count': instance.count,
    };

