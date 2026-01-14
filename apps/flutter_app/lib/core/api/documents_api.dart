import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'documents_api.g.dart';

@RestApi()
abstract class DocumentsApi {
  factory DocumentsApi(Dio dio, {String baseUrl}) = _DocumentsApi;

  @GET('/documents')
  Future<List<DocumentModel>> getDocuments({
    @Query('childId') String? childId,
    @Query('caseId') String? caseId,
    @Query('clientId') String? clientId,
    @Query('assessmentId') String? assessmentId,
    @Query('category') String? category,
  });

  @GET('/documents/{id}')
  Future<DocumentModel> getDocument(@Path('id') String id);

  @DELETE('/documents/{id}')
  Future<void> deleteDocument(@Path('id') String id);

  @POST('/documents/upload')
  @MultiPart()
  Future<DocumentModel> uploadDocument({
    @Part(name: 'file') required MultipartFile file,
    @Part(name: 'category') required String category,
    @Part(name: 'description') String? description,
    @Part(name: 'tags') List<String>? tags,
    @Part(name: 'childId') String? childId,
    @Part(name: 'caseId') String? caseId,
    @Part(name: 'clientId') String? clientId,
    @Part(name: 'assessmentId') String? assessmentId,
  });
}

@JsonSerializable()
class DocumentModel {
  final String id;
  final String organizationId;
  final String filename;
  final String storageKey;
  final String mimetype;
  final int size;
  final String category;
  final String? description;
  final List<String> tags;
  final String? childId;
  final String? caseId;
  final String? clientId;
  final String? assessmentId;
  final String uploadedBy;
  final DateTime uploadedAt;
  final DateTime updatedAt;
  final String downloadUrl;

  // Related entities (optional)
  final ChildReference? child;
  @JsonKey(name: 'case')
  final CaseReference? case_;
  final ClientReference? client;
  final AssessmentReference? assessment;

  DocumentModel({
    required this.id,
    required this.organizationId,
    required this.filename,
    required this.storageKey,
    required this.mimetype,
    required this.size,
    required this.category,
    this.description,
    required this.tags,
    this.childId,
    this.caseId,
    this.clientId,
    this.assessmentId,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.updatedAt,
    required this.downloadUrl,
    this.child,
    this.case_,
    this.client,
    this.assessment,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isImage => mimetype.startsWith('image/');
  bool get isPdf => mimetype == 'application/pdf';
  bool get isDocument =>
      mimetype.contains('word') || mimetype.contains('document');
  bool get isSpreadsheet =>
      mimetype.contains('excel') || mimetype.contains('sheet');
}

@JsonSerializable()
class ChildReference {
  final String id;
  final String firstName;
  final String lastName;

  ChildReference({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory ChildReference.fromJson(Map<String, dynamic> json) =>
      _$ChildReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ChildReferenceToJson(this);

  String get fullName => '$firstName $lastName';
}

@JsonSerializable()
class CaseReference {
  final String id;
  final String status;

  CaseReference({
    required this.id,
    required this.status,
  });

  factory CaseReference.fromJson(Map<String, dynamic> json) =>
      _$CaseReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$CaseReferenceToJson(this);
}

@JsonSerializable()
class ClientReference {
  final String id;
  final String firstName;
  final String lastName;

  ClientReference({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory ClientReference.fromJson(Map<String, dynamic> json) =>
      _$ClientReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ClientReferenceToJson(this);

  String get fullName => '$firstName $lastName';
}

@JsonSerializable()
class AssessmentReference {
  final String id;
  final String assessmentType;

  AssessmentReference({
    required this.id,
    required this.assessmentType,
  });

  factory AssessmentReference.fromJson(Map<String, dynamic> json) =>
      _$AssessmentReferenceFromJson(json);

  Map<String, dynamic> toJson() => _$AssessmentReferenceToJson(this);
}
