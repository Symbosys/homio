// Homio CRM — Interactive Visual Drip Campaign Workflow Canvas

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/communication_models.dart';

class DripWorkflowCanvas extends StatefulWidget {
  final List<DripNode> nodes;
  final DripTriggerType triggerType;
  final ValueChanged<DripNode>? onNodeSelected;
  final VoidCallback? onAddNode;

  const DripWorkflowCanvas({
    super.key,
    required this.nodes,
    required this.triggerType,
    this.onNodeSelected,
    this.onAddNode,
  });

  @override
  State<DripWorkflowCanvas> createState() => _DripWorkflowCanvasState();
}

class _DripWorkflowCanvasState extends State<DripWorkflowCanvas> {
  String? _selectedNodeId;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Stack(
        children: [
          // Dot Matrix Background
          Positioned.fill(
            child: CustomPaint(
              painter: _CanvasGridPainter(
                isDark: isDark,
                dotColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
              ),
            ),
          ),

          // Workflow Nodes Horizontal Scroll Area
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Initial Trigger Node
                _buildTriggerNode(isDark),
                _buildConnectorArrow(isDark),

                // 2. Sequential / Branching Canvas Nodes
                ...widget.nodes.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final node = entry.value;
                  final isLast = idx == widget.nodes.length - 1;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildWorkflowNodeCard(node, isDark),
                      if (!isLast) _buildConnectorArrow(isDark),
                    ],
                  );
                }),

                if (widget.onAddNode != null) ...[
                  _buildConnectorArrow(isDark),
                  InkWell(
                    onTap: widget.onAddNode,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 140,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, color: AppColors.primary, size: 24),
                          SizedBox(height: 6),
                          Text(
                            'Add Action Step',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Canvas Controls Toolbar (Zoom, Reset)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: () => setState(() => _scale = (_scale - 0.1).clamp(0.7, 1.4)),
                    tooltip: 'Zoom out',
                  ),
                  Text(
                    '${(_scale * 100).toInt()}%',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: () => setState(() => _scale = (_scale + 0.1).clamp(0.7, 1.4)),
                    tooltip: 'Zoom in',
                  ),
                  IconButton(
                    icon: const Icon(Icons.center_focus_strong, size: 16),
                    onPressed: () => setState(() => _scale = 1.0),
                    tooltip: 'Fit canvas',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerNode(bool isDark) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF3B82F6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.bolt, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                'CAMPAIGN TRIGGER',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.triggerType.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enrolls all contacts matching audience criteria immediately.',
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowNodeCard(DripNode node, bool isDark) {
    final isSelected = _selectedNodeId == node.id;

    return InkWell(
      onTap: () {
        setState(() => _selectedNodeId = node.id);
        widget.onNodeSelected?.call(node);
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: node.type.color.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(node.type.icon, size: 14, color: node.type.color),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    node.type.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: node.type.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              node.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              node.description,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectorArrow(bool isDark) {
    return Container(
      width: 44,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      child: Align(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.arrow_right,
          size: 16,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }
}

class _CanvasGridPainter extends CustomPainter {
  final bool isDark;
  final Color dotColor;

  _CanvasGridPainter({required this.isDark, required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..strokeWidth = 1.5;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
