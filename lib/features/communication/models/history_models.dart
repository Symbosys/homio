enum CommunicationChannel {
  phoneCall,
  aiCall,
  whatsappVoice,
  whatsappVideo,
  sms,
}

enum CallDirection {
  inbound,
  outbound,
}

enum CallOutcome {
  answered,
  missed,
  busy,
  voicemail,
}

enum SentimentRating {
  positive,
  neutral,
  frustrated,
}

class TranscriptLine {
  final String speaker;
  final String time;
  final String text;

  const TranscriptLine({
    required this.speaker,
    required this.time,
    required this.text,
  });
}

class CallHistoryItem {
  final String id;
  final String contactName;
  final String phoneNumber;
  final String projectTitle;
  final CommunicationChannel channel;
  final CallDirection direction;
  final DateTime timestamp;
  final int durationSec;
  final CallOutcome outcome;
  final String agentName;
  final SentimentRating sentiment;
  final String summary;
  final List<String> keyTakeaways;
  final List<String> actionItems;
  final List<TranscriptLine> transcript;

  const CallHistoryItem({
    required this.id,
    required this.contactName,
    required this.phoneNumber,
    required this.projectTitle,
    required this.channel,
    required this.direction,
    required this.timestamp,
    required this.durationSec,
    required this.outcome,
    required this.agentName,
    required this.sentiment,
    required this.summary,
    required this.keyTakeaways,
    required this.actionItems,
    required this.transcript,
  });

  String get durationFormatted {
    final m = durationSec ~/ 60;
    final s = durationSec % 60;
    if (m == 0) return '${s}s';
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }
}

class HistoryMockData {
  static final List<CallHistoryItem> calls = [
    CallHistoryItem(
      id: 'call_001',
      contactName: 'Vikram Malhotra',
      phoneNumber: '+91 98201 44521',
      projectTitle: 'Villa #42 - Palm Meadows',
      channel: CommunicationChannel.aiCall,
      direction: CallDirection.outbound,
      timestamp: DateTime.now().subtract(const Duration(minutes: 28)),
      durationSec: 215,
      outcome: CallOutcome.answered,
      agentName: 'Homio AI Voice Agent (Bland v2.4)',
      sentiment: SentimentRating.positive,
      summary: 'AI voice agent followed up on Milestone 3 Italian marble selection & tile batch signoff. Client confirmed preference for Botticino Beige.',
      keyTakeaways: [
        'Confirmed Botticino Beige Italian Marble (800 sq.ft) for Living Room',
        'Requested digital high-res slab photos before dry lay begins',
        'Acknowledged payment schedule for Stage 4 foundation cast',
      ],
      actionItems: [
        'Site supervisor to upload slab dry-lay photos by 4 PM today',
        'Dispatch WhatsApp notification with updated invoice #INV-9021',
      ],
      transcript: const [
        TranscriptLine(speaker: 'Homio AI', time: '00:05', text: 'Hello Mr. Vikram! This is Tara from Homio Interiors. Am I speaking with Vikram Malhotra?'),
        TranscriptLine(speaker: 'Vikram', time: '00:10', text: 'Yes Tara, Vikram here. Regarding the marble batch?'),
        TranscriptLine(speaker: 'Homio AI', time: '00:16', text: 'Exactly! The sample shipment of Botticino Beige and Statuario arrived at the site. Architect Rohan asked if you had a chance to review the veining samples?'),
        TranscriptLine(speaker: 'Vikram', time: '00:32', text: 'Yes, we definitely love the Botticino Beige. Please lock that in for the entire formal living area.'),
        TranscriptLine(speaker: 'Homio AI', time: '00:44', text: 'Splendid! I have logged Botticino Beige. Rohan will arrange dry-laying photos on your live site feed. Have a wonderful day!'),
      ],
    ),
    CallHistoryItem(
      id: 'call_002',
      contactName: 'Ananya Deshmukh',
      phoneNumber: '+91 97654 32190',
      projectTitle: 'Skyline Towers #14B',
      channel: CommunicationChannel.phoneCall,
      direction: CallDirection.inbound,
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      durationSec: 462,
      outcome: CallOutcome.answered,
      agentName: 'Ar. Rohan Sen (Lead Designer)',
      sentiment: SentimentRating.neutral,
      summary: 'Client discussed false ceiling electrical drop points for magnetic track lights and requested revisions in the foyer lighting design.',
      keyTakeaways: [
        'Wants 3 additional spotlight cutouts in Master Bedroom foyer',
        'Agreed with 3000K warm white LED driver specifications',
        'Scheduling site coordination meeting on Thursday 11 AM',
      ],
      actionItems: [
        'Update 2D Electrical CAD blueprint with revised cutouts',
        'Send calendar invite for Thursday site walkthrough',
      ],
      transcript: const [
        TranscriptLine(speaker: 'Ananya', time: '00:03', text: 'Hi Rohan, I was looking at the ceiling markup you sent on WhatsApp.'),
        TranscriptLine(speaker: 'Rohan Sen', time: '00:11', text: 'Hi Ananya! Yes, the electrician is setting up the GI channels today.'),
        TranscriptLine(speaker: 'Ananya', time: '00:20', text: 'Can we add three 7W spotlights in the foyer passage? Right now it only shows two.'),
        TranscriptLine(speaker: 'Rohan Sen', time: '00:35', text: 'Certainly, we have sufficient driver capacity. I will revise the CAD drawing right away.'),
      ],
    ),
    CallHistoryItem(
      id: 'call_003',
      contactName: 'Rajesh Gupta',
      phoneNumber: '+91 94480 12345',
      projectTitle: 'Greenwood Penthouse 901',
      channel: CommunicationChannel.whatsappVoice,
      direction: CallDirection.outbound,
      timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 40)),
      durationSec: 138,
      outcome: CallOutcome.answered,
      agentName: 'Priya Sharma (Client Relations)',
      sentiment: SentimentRating.positive,
      summary: 'Confirmation of bespoke modular kitchen carcass dispatch from Pune factory. Delivery expected Wednesday morning.',
      keyTakeaways: [
        'Factory completed edge-banding and QA inspection',
        'Dispatch vehicle #MH-12-Q-4412 in transit',
        'Unloading team scheduled for Wednesday 9:30 AM',
      ],
      actionItems: [
        'Coordinate freight elevator booking with Greenwood society manager',
      ],
      transcript: const [
        TranscriptLine(speaker: 'Priya Sharma', time: '00:04', text: 'Good morning Rajesh ji! Quick update on your kitchen modules.'),
        TranscriptLine(speaker: 'Rajesh', time: '00:08', text: 'Hello Priya, is the shipment on track?'),
        TranscriptLine(speaker: 'Priya Sharma', time: '00:14', text: 'Yes sir, quality check passed yesterday and the truck just rolled out. Expected on-site Wednesday morning.'),
        TranscriptLine(speaker: 'Rajesh', time: '00:26', text: 'Superb! I will inform building security to keep the service elevator reserved.'),
      ],
    ),
    CallHistoryItem(
      id: 'call_004',
      contactName: 'Sameer Joshi',
      phoneNumber: '+91 98112 76543',
      projectTitle: 'Prestige Lakeside #304',
      channel: CommunicationChannel.phoneCall,
      direction: CallDirection.inbound,
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      durationSec: 320,
      outcome: CallOutcome.answered,
      agentName: 'Amit Verma (Site Ops)',
      sentiment: SentimentRating.frustrated,
      summary: 'Client expressed concern about dust accumulation in the adjacent hallway and requested additional zipper dust-screen barriers.',
      keyTakeaways: [
        'Demolition debris created dust in the common lobby',
        'Client was politely reminded that civil work creates temporary debris',
        'Agreed to install double-layer heavy duty zipper dust barriers immediately',
      ],
      actionItems: [
        'Install zipper dust barrier on doorway within 2 hours',
        'Site team to sweep and vacuum common passage after every evening shift',
      ],
      transcript: const [
        TranscriptLine(speaker: 'Sameer', time: '00:04', text: 'Amit, the neighbors complained about plaster dust in the lift lobby!'),
        TranscriptLine(speaker: 'Amit Verma', time: '00:15', text: 'Sincere apologies Sameer ji. We had to break the partition wall today.'),
        TranscriptLine(speaker: 'Sameer', time: '00:25', text: 'We need proper dust shields installed immediately.'),
        TranscriptLine(speaker: 'Amit Verma', time: '00:38', text: 'Understood. I am dispatching heavy duty zipper barriers right now and having the lobby deep cleaned.'),
      ],
    ),
    CallHistoryItem(
      id: 'call_005',
      contactName: 'Kavita Nair',
      phoneNumber: '+91 99001 88765',
      projectTitle: 'Sobha Royal 4BHK Duplex',
      channel: CommunicationChannel.aiCall,
      direction: CallDirection.outbound,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      durationSec: 0,
      outcome: CallOutcome.missed,
      agentName: 'Homio AI Voice Agent',
      sentiment: SentimentRating.neutral,
      summary: 'Automated milestone reminder call not answered. Triggered backup WhatsApp template message with link to review 3D renders.',
      keyTakeaways: [
        'Call rang for 45s with no answer',
        'Automated fallback WhatsApp delivered successfully',
      ],
      actionItems: [
        'Follow up if unread after 24 hours',
      ],
      transcript: const [],
    ),
    CallHistoryItem(
      id: 'call_006',
      contactName: 'Dr. Alok Verma',
      phoneNumber: '+91 98860 33412',
      projectTitle: 'Heritage Bungalow Resto',
      channel: CommunicationChannel.sms,
      direction: CallDirection.outbound,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      durationSec: 0,
      outcome: CallOutcome.answered,
      agentName: 'System Trigger',
      sentiment: SentimentRating.positive,
      summary: 'SMS OTP verification and biometric access authorization for site carpenter lead.',
      keyTakeaways: ['OTP delivered and validated within 12 seconds'],
      actionItems: [],
      transcript: const [
        TranscriptLine(speaker: 'System', time: '00:00', text: 'HOMIO: Your OTP for site biometric access for carpenter Raju is 894120. Valid for 10 mins.'),
      ],
    ),
  ];
}
