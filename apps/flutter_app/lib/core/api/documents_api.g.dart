// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'documents_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String,
      filename: json['filename'] as String,
      storageKey: json['storageKey'] as String,
      mimetype: json['mimetype'] as String,
      size: (json['size'] as num).toInt(),
      category: json['category'] as String,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      childId: json['childId'] as String?,
      caseId: json['caseId'] as String?,
      clientId: json['clientId'] as String?,
      assessmentId: json['assessmentId'] as String?,
      uploadedBy: json['uploadedBy'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      downloadUrl: json['downloadUrl'] as String,
      child: json['child'] == null
          ? null
          : ChildReference.fromJson(json['child'] as Map<String, dynamic>),
      case_: json['case'] == null
          ? null
          : CaseReference.fromJson(json['case'] as Map<String, dynamic>),
      client: json['client'] == null
          ? null
          : ClientReference.fromJson(json['client'] as Map<String, dynamic>),
      assessment: json['assessment'] == null
          ? null
          : AssessmentReference.fromJson(
              json['assessment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'filename': instance.filename,
      'storageKey': instance.storageKey,
      'mimetype': instance.mimetype,
      'size': instance.size,
      'category': instance.category,
      'description': instance.description,
      'tags': instance.tags,
      'childId': instance.childId,
      'caseId': instance.caseId,
      'clientId': instance.clientId,
      'assessmentId': instance.assessmentId,
      'uploadedBy': instance.uploadedBy,
      'uploadedAt': instance.uploadedAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'downloadUrl': instance.downloadUrl,
      'child': instance.child,
      'case': instance.case_,
      'client': instance.client,
      'assessment': instance.assessment,
    };

ChildReference _$ChildReferenceFromJson(Map<String, dynamic> json) =>
    ChildReference(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$ChildReferenceToJson(ChildReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

CaseReference _$CaseReferenceFromJson(Map<String, dynamic> json) =>
    CaseReference(
      id: json['id'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$CaseReferenceToJson(CaseReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
    };

ClientReference _$ClientReferenceFromJson(Map<String, dynamic> json) =>
    ClientReference(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$ClientReferenceToJson(ClientReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };

AssessmentReference _$AssessmentReferenceFromJson(Map<String, dynamic> json) =>
    AssessmentReference(
      id: json['id'] as String,
      assessmentType: json['assessmentType'] as String,
    );

Map<String, dynamic> _$AssessmentReferenceToJson(
        AssessmentReference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assessmentType': instance.assessmentType,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _DocumentsApi implements DocumentsApi {
  _DocumentsApi(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<DocumentModel>> getDocuments({
    String? childId,
    String? caseId,
    String? clientId,
    String? assessmentId,
    String? category,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'childId': childId,
      r'caseId': caseId,
      r'clientId': clientId,
      r'assessmentId': assessmentId,
      r'category': category,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<DocumentModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/documents',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => DocumentModel.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<DocumentModel> getDocument(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DocumentModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/documents/$id',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DocumentModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<void> deleteDocument(String id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    await _dio.fetch<void>(_setStreamType<void>(
        Options(method: 'DELETE', headers: _headers, extra: _extra)
            .compose(_dio.options, '/documents/$id',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  }

  @override
  Future<DocumentModel> uploadDocument({
    required MultipartFile file,
    required String category,
    String? description,
    List<String>? tags,
    String? childId,
    String? caseId,
    String? clientId,
    String? assessmentId,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry('file', file));
    _data.fields.add(MapEntry('category', category));
    if (description != null) {
      _data.fields.add(MapEntry('description', description));
    }
    if (tags != null) {
      _data.fields.addAll(tags.map((i) => MapEntry('tags', i)));
    }
    if (childId != null) {
      _data.fields.add(MapEntry('childId', childId));
    }
    if (caseId != null) {
      _data.fields.add(MapEntry('caseId', caseId));
    }
    if (clientId != null) {
      _data.fields.add(MapEntry('clientId', clientId));
    }
    if (assessmentId != null) {
      _data.fields.add(MapEntry('assessmentId', assessmentId));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DocumentModel>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, '/documents/upload',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DocumentModel.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
