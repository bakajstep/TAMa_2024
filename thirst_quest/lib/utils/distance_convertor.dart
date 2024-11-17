String distanceToDisplay(double distance) {
  if (distance < 1000) {
    return '${distance.toStringAsFixed(0)} m';
  } else {
    return '${(distance / 1000).toStringAsFixed(1)} km';
  }
}
