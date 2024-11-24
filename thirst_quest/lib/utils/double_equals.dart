bool doubleEquals(double a, double b) {
  return (a - b).abs() < 0.00005;
}

bool doubleInList(List<double> list, double value) {
  for (final element in list) {
    if (doubleEquals(element, value)) {
      return true;
    }
  }
  return false;
}