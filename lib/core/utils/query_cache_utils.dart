import 'package:cached_query_flutter/cached_query_flutter.dart';

/// Centralized utility for managing CachedQuery cache invalidation and refetching.
abstract class QueryCacheUtils {
  /// Invalidate and immediately refetch queries whose key contains [keySubstr].
  ///
  /// If [refetch] is false, only marks the cache as stale without immediately
  /// executing a background network refetch.
  static void invalidateAndRefetch(String keySubstr, {bool refetch = true}) {
    CachedQuery.instance.invalidateCache(
      filterFn: (unencodedKey, key) => key.toString().contains(keySubstr),
    );
    if (refetch) {
      CachedQuery.instance.refetchQueries(
        filterFn: (unencodedKey, key) => key.toString().contains(keySubstr),
      );
    }
  }

  /// Invalidate and refetch multiple query key substrings in one call.
  static void invalidateAndRefetchMultiple(
    List<String> keySubstrings, {
    bool refetch = true,
  }) {
    for (final keySubstr in keySubstrings) {
      invalidateAndRefetch(keySubstr, refetch: refetch);
    }
  }

  /// Invalidate a specific exact key.
  static void invalidateKey(String exactKey, {bool refetch = true}) {
    CachedQuery.instance.invalidateCache(key: exactKey);
    if (refetch) {
      CachedQuery.instance.refetchQueries(
        filterFn: (unencodedKey, key) => key.toString() == exactKey,
      );
    }
  }

  /// Delete a specific exact key completely from the cache.
  static void deleteKey(String exactKey) {
    CachedQuery.instance.deleteCache(key: exactKey);
  }

  /// Reset or clear all cached queries.
  static void clearAll() {
    CachedQuery.instance.deleteCache();
  }
}
