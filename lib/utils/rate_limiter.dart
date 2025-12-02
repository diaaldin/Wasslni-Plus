import 'dart:collection';

/// Rate limiter to prevent abuse of API calls
class RateLimiter {
  final Map<String, Queue<DateTime>> _requests = {};
  final int maxRequests;
  final Duration timeWindow;

  RateLimiter({
    this.maxRequests = 10,
    this.timeWindow = const Duration(minutes: 1),
  });

  /// Check if an action is allowed for a given identifier (e.g., user ID, action type)
  bool isAllowed(String identifier) {
    final now = DateTime.now();

    // Get or create queue for this identifier
    if (!_requests.containsKey(identifier)) {
      _requests[identifier] = Queue<DateTime>();
    }

    final queue = _requests[identifier]!;

    // Remove expired requests
    while (queue.isNotEmpty && now.difference(queue.first) > timeWindow) {
      queue.removeFirst();
    }

    // Check if limit exceeded
    if (queue.length >= maxRequests) {
      return false;
    }

    // Add current request
    queue.add(now);
    return true;
  }

  /// Get remaining requests for an identifier
  int getRemainingRequests(String identifier) {
    if (!_requests.containsKey(identifier)) {
      return maxRequests;
    }

    final now = DateTime.now();
    final queue = _requests[identifier]!;

    // Remove expired requests
    while (queue.isNotEmpty && now.difference(queue.first) > timeWindow) {
      queue.removeFirst();
    }

    return maxRequests - queue.length;
  }

  /// Get time until next request is allowed
  Duration? getTimeUntilNextRequest(String identifier) {
    if (!_requests.containsKey(identifier)) {
      return null;
    }

    final now = DateTime.now();
    final queue = _requests[identifier]!;

    if (queue.isEmpty || queue.length < maxRequests) {
      return null;
    }

    final oldestRequest = queue.first;
    final timeElapsed = now.difference(oldestRequest);

    if (timeElapsed >= timeWindow) {
      return null;
    }

    return timeWindow - timeElapsed;
  }

  /// Clear rate limit for an identifier
  void clear(String identifier) {
    _requests.remove(identifier);
  }

  /// Clear all rate limits
  void clearAll() {
    _requests.clear();
  }
}

/// Global rate limiters for different operations
class AppRateLimiters {
  // Login attempts: 5 per 15 minutes
  static final login = RateLimiter(
    maxRequests: 5,
    timeWindow: const Duration(minutes: 15),
  );

  // Registration: 3 per hour
  static final registration = RateLimiter(
    maxRequests: 3,
    timeWindow: const Duration(hours: 1),
  );

  // Parcel creation: 20 per hour
  static final parcelCreation = RateLimiter(
    maxRequests: 20,
    timeWindow: const Duration(hours: 1),
  );

  // Status updates: 50 per hour
  static final statusUpdate = RateLimiter(
    maxRequests: 50,
    timeWindow: const Duration(hours: 1),
  );

  // Search: 30 per minute
  static final search = RateLimiter(
    maxRequests: 30,
    timeWindow: const Duration(minutes: 1),
  );

  // Password reset: 3 per hour
  static final passwordReset = RateLimiter(
    maxRequests: 3,
    timeWindow: const Duration(hours: 1),
  );

  /// Clear all rate limiters
  static void clearAll() {
    login.clearAll();
    registration.clearAll();
    parcelCreation.clearAll();
    statusUpdate.clearAll();
    search.clearAll();
    passwordReset.clearAll();
  }
}
