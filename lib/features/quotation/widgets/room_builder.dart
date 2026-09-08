import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../models/quotation_models.dart';
import 'dimension_input.dart';

/// Interactive room management component for adding and configuring spaces.
class RoomBuilder extends StatefulWidget {
  final List<RoomArea> rooms;
  final ValueChanged<List<RoomArea>> onRoomsChanged;

  const RoomBuilder({
    super.key,
    required this.rooms,
    required this.onRoomsChanged,
  });

  @override
  State<RoomBuilder> createState() => _RoomBuilderState();
}

class _RoomBuilderState extends State<RoomBuilder> {
  late List<RoomArea> _rooms;
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    _rooms = List.from(widget.rooms);
    if (_rooms.isNotEmpty) _expandedIndex = 0;
  }

  void _addPresetRoom(RoomAreaType type) {
    final newRoom = RoomArea(
      id: 'RM-${DateTime.now().millisecondsSinceEpoch}',
      roomName: type.label,
      areaType: type,
      lengthFt: 14.0,
      widthFt: 12.0,
      heightFt: 10.0,
      tier: MaterialTier.premium,
      items: const [],
    );
    setState(() {
      _rooms.add(newRoom);
      _expandedIndex = _rooms.length - 1;
    });
    widget.onRoomsChanged(_rooms);
  }

  void _removeRoom(int index) {
    setState(() {
      _rooms.removeAt(index);
      if (_expandedIndex == index) {
        _expandedIndex = _rooms.isNotEmpty ? 0 : null;
      } else if (_expandedIndex != null && _expandedIndex! > index) {
        _expandedIndex = _expandedIndex! - 1;
      }
    });
    widget.onRoomsChanged(_rooms);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header & Quick Add Presets
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.meeting_room_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Configured Spaces & Rooms (${_rooms.length})',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Total Carpet: ${_rooms.fold(0.0, (sum, r) => sum + r.carpetSqft).toStringAsFixed(0)} Sq.Ft',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'QUICK ADD ROOM PRESET',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  RoomAreaType.livingRoom,
                  RoomAreaType.masterBedroom,
                  RoomAreaType.kitchen,
                  RoomAreaType.guestBedroom,
                  RoomAreaType.diningArea,
                  RoomAreaType.balcony,
                  RoomAreaType.bathroom,
                  RoomAreaType.poojaRoom,
                ].map((type) {
                  return ActionChip(
                    avatar: Icon(type.icon, size: 13, color: AppColors.primary),
                    label: Text(
                      type.label,
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () => _addPresetRoom(type),
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : Colors.grey.shade100,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.sm),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Room accordion cards
        ..._rooms.asMap().entries.map((entry) {
          final index = entry.key;
          final room = entry.value;
          final isExpanded = _expandedIndex == index;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: AppRadius.md,
              border: Border.all(
                color: isExpanded
                    ? AppColors.primary
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                width: isExpanded ? 1.2 : 0.8,
              ),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _expandedIndex = isExpanded ? null : index;
                    });
                  },
                  borderRadius: AppRadius.md,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(room.areaType.icon, size: 14, color: AppColors.primary),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.roomName,
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '${room.carpetSqft.toStringAsFixed(0)} sq.ft • ${room.tier.title} • ${room.items.length} BOQ items',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '₹${room.roomSubtotal.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                              onPressed: () => _removeRoom(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 8),
                            Icon(isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        // Room Name and Tier
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: room.roomName,
                                decoration: InputDecoration(
                                  labelText: 'Room Display Name',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                onChanged: (val) {
                                  _rooms[index] = room.copyWith(roomName: val);
                                  widget.onRoomsChanged(_rooms);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<MaterialTier>(
                                initialValue: room.tier,
                                decoration: InputDecoration(
                                  labelText: 'Material Tier',
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  border: OutlineInputBorder(borderRadius: AppRadius.sm),
                                ),
                                items: MaterialTier.values
                                    .map((t) => DropdownMenuItem(value: t, child: Text(t.title, style: const TextStyle(fontSize: 11))))
                                    .toList(),
                                onChanged: (t) {
                                  if (t != null) {
                                    setState(() {
                                      _rooms[index] = room.copyWith(tier: t);
                                    });
                                    widget.onRoomsChanged(_rooms);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Dimensions Component
                        DimensionInput(
                          lengthFt: room.lengthFt,
                          widthFt: room.widthFt,
                          heightFt: room.heightFt,
                          onDimensionsChanged: (l, w, h) {
                            setState(() {
                              _rooms[index] = room.copyWith(lengthFt: l, widthFt: w, heightFt: h);
                            });
                            widget.onRoomsChanged(_rooms);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
