import 'package:flutter/material.dart';
import 'dart:math' as math;

class SDFPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (double y = 0; y < size.height; y++) {
      for (double x = 0; x < size.width; x++) {
        final uv = Point3D((x / size.width) * 2 - 1, (y / size.height) * 2 - 1, 0.5).normalize();
        final ray = Ray(Point3D(0, 0, -5), uv);
        final hit = rayMarch(ray, 100.0, 0.001, 100);

        if (hit != null) {
          paint.color = calculateColor(hit);
          canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class Point3D {
  final double x, y, z;

  Point3D(this.x, this.y, this.z);

  Point3D operator -(Point3D other) => Point3D(x - other.x, y - other.y, z - other.z);
  Point3D operator +(Point3D other) => Point3D(x + other.x, y + other.y, z + other.z);
  Point3D operator *(double scalar) => Point3D(x * scalar, y * scalar, z * scalar);
  Point3D abs() => Point3D(x.abs(), y.abs(), z.abs());
  double get length => math.sqrt(x * x + y * y + z * z);
  Point3D normalize() {
    double len = length;
    return Point3D(x / len, y / len, z / len);
  }
  double dot(Point3D other) => x * other.x + y * other.y + z * other.z;
  Point3D max(double v) => Point3D(math.max(x, v), math.max(y, v), math.max(z, v));
  Point3D operator -() => Point3D(-x, -y, -z); // Unary minus operator

  @override
  String toString() => 'Point3D(x: $x, y: $y, z: $z)';
}

class Ray {
  final Point3D origin, direction;

  Ray(this.origin, this.direction);
}

double boxSDF(Point3D p, Point3D size) {
  Point3D d = (p.abs() - size).max(0.0);
  return d.length + math.min(math.max(d.x, math.max(d.y, d.z)), 0.0);
}

Point3D? rayMarch(Ray ray, double maxDistance, double epsilon, int maxSteps) {
  double distanceTravelled = 0.0;
  Point3D currentPoint = ray.origin;

  for (int i = 0; i < maxSteps; i++) {
    double distance = boxSDF(currentPoint, Point3D(1.0, 1.0, 1.0)); // Box size is (1, 1, 1)

    if (distance < epsilon) {
      return currentPoint;
    }

    distanceTravelled += distance;
    currentPoint = currentPoint + ray.direction * distance;

    if (distanceTravelled > maxDistance) {
      break;
    }
  }

  return null; // Return null if no intersection is found
}

Color calculateColor(Point3D point) {
  return Colors.green; // Green color for the box
}