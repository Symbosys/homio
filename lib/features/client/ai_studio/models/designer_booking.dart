class ExpertDesignerProfile {
  final String id;
  final String name;
  final String designation;
  final int experienceYears;
  final String avatarUrl;
  final List<String> designSpecialties; // E.g. 'Luxury Penthouse', 'Space Optimization', 'Vastu'
  final double rating;
  final int reviewCount;
  final double consultationFeeInr;
  final List<String> availableSlotsToday;

  const ExpertDesignerProfile({
    required this.id,
    required this.name,
    required this.designation,
    required this.experienceYears,
    required this.avatarUrl,
    required this.designSpecialties,
    required this.rating,
    required this.reviewCount,
    required this.consultationFeeInr,
    required this.availableSlotsToday,
  });
}

enum BookingStatus {
  confirmed('Session Confirmed', 0xFF10B981),
  inProgress('Live Video Call Active', 0xFF6366F1),
  completed('Session Completed', 0xFF6B7280),
  cancelled('Cancelled', 0xFFEF4444);

  final String label;
  final int colorHex;
  const BookingStatus(this.label, this.colorHex);
}

class DesignerBooking {
  final String id;
  final ExpertDesignerProfile designer;
  final DateTime scheduledDateTime;
  final String durationText; // '30 Minutes Video + Live Whiteboard'
  final String roomTopic; // 'Living Room Layout Review'
  final BookingStatus status;
  final String? videoMeetingRoomUrl;
  final List<String> linkedAiSessionIds;
  final String? summaryActionPoints;

  const DesignerBooking({
    required this.id,
    required this.designer,
    required this.scheduledDateTime,
    this.durationText = '30 Minutes 1-on-1 Call',
    required this.roomTopic,
    this.status = BookingStatus.confirmed,
    this.videoMeetingRoomUrl,
    this.linkedAiSessionIds = const [],
    this.summaryActionPoints,
  });

  DesignerBooking copyWith({
    String? id,
    ExpertDesignerProfile? designer,
    DateTime? scheduledDateTime,
    String? durationText,
    String? roomTopic,
    BookingStatus? status,
    String? videoMeetingRoomUrl,
    List<String>? linkedAiSessionIds,
    String? summaryActionPoints,
  }) {
    return DesignerBooking(
      id: id ?? this.id,
      designer: designer ?? this.designer,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      durationText: durationText ?? this.durationText,
      roomTopic: roomTopic ?? this.roomTopic,
      status: status ?? this.status,
      videoMeetingRoomUrl: videoMeetingRoomUrl ?? this.videoMeetingRoomUrl,
      linkedAiSessionIds: linkedAiSessionIds ?? this.linkedAiSessionIds,
      summaryActionPoints: summaryActionPoints ?? this.summaryActionPoints,
    );
  }
}
