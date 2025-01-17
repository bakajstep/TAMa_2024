bool doubleEquals(double a, double b) {
  return (a - b).abs() < 0.00005;
}

bool doubleLessThanOrEquals(double a, double b) {
  return a < b || doubleEquals(a, b);
}

bool doubleLessThan(double a, double b) {
  return !doubleEquals(a, b) && a < b;
}

bool doubleInList(List<double> list, double value) {
  for (final element in list) {
    if (doubleEquals(element, value)) {
      return true;
    }
  }
  return false;
}
