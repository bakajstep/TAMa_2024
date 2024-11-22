bool DoubleEquals(double a, double b) {
  return (a - b).abs() < 0.00005;
}