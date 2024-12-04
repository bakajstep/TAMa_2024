class Cache {
  static final Cache _instance = Cache._internal();

  factory Cache() {
    return _instance;
  }

  Cache._internal();

  final Map<String, dynamic> _cache = {};

  void set<T>(String key, T value) {
    _cache[key] = value;
  }

  T? get<T>(String key) {
    final value = _cache[key];
    if (value is T) {
      return value;
    }

    return null;
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }
}
