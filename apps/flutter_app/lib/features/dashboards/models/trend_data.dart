import 'package:json_annotation/json_annotation.dart';

part 'trend_data.g.dart';

/// Model for trend data points (for charts)
@JsonSerializable()
class TrendDataPoint {
  final DateTime period;
  final int count;

  TrendDataPoint({
    required this.period,
    required this.count,
  });

  factory TrendDataPoint.fromJson(Map<String, dynamic> json) =>
      _$TrendDataPointFromJson(json);

  Map<String, dynamic> toJson() => _$TrendDataPointToJson(this);
}

/// Model for cases by program data
@JsonSerializable()
class CasesByProgram {
  final String programId;
  final String status;
  @JsonKey(name: '_count')
  final CountData count;

  CasesByProgram({
    required this.programId,
    required this.status,
    required this.count,
  });

  factory CasesByProgram.fromJson(Map<String, dynamic> json) =>
      _$CasesByProgramFromJson(json);

  Map<String, dynamic> toJson() => _$CasesByProgramToJson(this);
}

@JsonSerializable()
class CountData {
  final int id;

  CountData({required this.id});

  factory CountData.fromJson(Map<String, dynamic> json) =>
      _$CountDataFromJson(json);

  Map<String, dynamic> toJson() => _$CountDataToJson(this);
}

/// Model for cases by worker data
@JsonSerializable()
class CasesByWorker {
  final String? assignedWorkerId;
  @JsonKey(name: '_count')
  final CountData count;

  CasesByWorker({
    this.assignedWorkerId,
    required this.count,
  });

  factory CasesByWorker.fromJson(Map<String, dynamic> json) =>
      _$CasesByWorkerFromJson(json);

  Map<String, dynamic> toJson() => _$CasesByWorkerToJson(this);
}

