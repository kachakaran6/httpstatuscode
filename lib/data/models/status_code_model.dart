import 'dart:convert';

/// Represents a single HTTP status code entry.
class StatusCodeModel {
  final String id;
  final int code;
  final String title;
  final String shortDescription;
  final String description;
  final List<String> whenToUse;
  final Map<String, dynamic> exampleResponse;
  final String bestPractice;

  const StatusCodeModel({
    required this.id,
    required this.code,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.whenToUse,
    required this.exampleResponse,
    required this.bestPractice,
  });

  factory StatusCodeModel.fromJson(Map<String, dynamic> json) {
    return StatusCodeModel(
      id: json['id'] as String,
      code: json['code'] as int,
      title: json['title'] as String,
      shortDescription: json['short_description'] as String,
      description: json['description'] as String,
      whenToUse: List<String>.from(json['when_to_use'] as List),
      exampleResponse:
          Map<String, dynamic>.from(json['example_response'] as Map),
      bestPractice: json['best_practice'] as String,
    );
  }

  /// Returns formatted JSON string for copying to clipboard.
  String get formattedExampleResponse {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(exampleResponse);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is StatusCodeModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// Represents a category grouping of HTTP status codes.
class CategoryModel {
  final String id;
  final String title;
  final String colorHex;
  final String description;
  final List<StatusCodeModel> codes;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.colorHex,
    required this.description,
    required this.codes,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      colorHex: json['color'] as String,
      description: json['description'] as String? ?? '',
      codes: (json['codes'] as List)
          .map((c) => StatusCodeModel.fromJson(c as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is CategoryModel && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// Top-level wrapper for the JSON asset.
class StatusCodesData {
  final List<CategoryModel> categories;

  const StatusCodesData({required this.categories});

  factory StatusCodesData.fromJson(Map<String, dynamic> json) {
    return StatusCodesData(
      categories: (json['categories'] as List)
          .map((c) => CategoryModel.fromJson(c as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  /// Flat list of all status codes across all categories.
  List<StatusCodeModel> get allCodes =>
      categories.expand((cat) => cat.codes).toList(growable: false);
}
