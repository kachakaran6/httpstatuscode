import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/status_code_model.dart';
import '../../core/constants.dart';

/// Loads and serves HTTP status code data from the bundled JSON asset.
///
/// Implements a simple in-memory cache so the asset is only parsed once
/// per app session, keeping subsequent reads O(1).
class StatusRepository {
  StatusCodesData? _cache;

  /// Returns parsed data, loading from asset on first call.
  Future<StatusCodesData> getData() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString(AppConstants.statusCodesAsset);
    final decoded = json.decode(raw) as Map<String, dynamic>;
    _cache = StatusCodesData.fromJson(decoded);
    return _cache!;
  }

  /// Returns all categories (cached).
  Future<List<CategoryModel>> getCategories() async {
    final data = await getData();
    return data.categories;
  }

  /// Returns all codes flattened (cached).
  Future<List<StatusCodeModel>> getAllCodes() async {
    final data = await getData();
    return data.allCodes;
  }

  /// Searches codes by code number, title, or description.
  /// Pure in-memory filtering — no external packages.
  Future<List<StatusCodeModel>> search(String query) async {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return [];

    final allCodes = await getAllCodes();
    return allCodes.where((c) {
      return c.code.toString().contains(q) ||
          c.title.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.shortDescription.toLowerCase().contains(q);
    }).toList(growable: false);
  }

  /// Finds a single code by its unique [id].
  Future<StatusCodeModel?> findById(String id) async {
    final allCodes = await getAllCodes();
    try {
      return allCodes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Finds a category that contains the given code id.
  Future<CategoryModel?> categoryForCode(String codeId) async {
    final categories = await getCategories();
    try {
      return categories
          .firstWhere((cat) => cat.codes.any((c) => c.id == codeId));
    } catch (_) {
      return null;
    }
  }

  /// Clears the in-memory cache (useful for testing).
  void clearCache() => _cache = null;
}
