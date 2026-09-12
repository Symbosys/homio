import 'package:flutter/material.dart';

enum AiToolCategory {
  design3D('3D & Generative Design'),
  technical('Technical & Compliance'),
  financial('Planning & Consultation');

  final String label;
  const AiToolCategory(this.label);
}

class AiToolDefinition {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color accentColor;
  final String routePath;
  final String routeName;
  final int creditCost;
  final String costLabel;
  final AiToolCategory category;
  final String badgeText;
  final bool isFeatured;

  const AiToolDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.routePath,
    required this.routeName,
    required this.creditCost,
    required this.costLabel,
    required this.category,
    this.badgeText = '',
    this.isFeatured = false,
  });
}
