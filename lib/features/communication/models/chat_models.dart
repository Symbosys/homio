import 'package:flutter/material.dart';

enum ChatChannel {
  whatsapp(label: 'WhatsApp', color: Color(0xFF25D366), icon: Icons.chat_rounded),
  sms(label: 'SMS', color: Color(0xFF3B82F6), icon: Icons.sms_rounded);

  final String label;
  final Color color;
  final IconData icon;

  const ChatChannel({
    required this.label,
    required this.color,
    required this.icon,
  });
}

enum ClientStage {
  lead(label: 'New Lead', color: Color(0xFFF59E0B)),
  design(label: 'Design Phase', color: Color(0xFF8B5CF6)),
  execution(label: 'Site Execution', color: Color(0xFF3B82F6)),
  handover(label: 'Handover & Warranty', color: Color(0xFF10B981));

  final String label;
  final Color color;

  const ClientStage({required this.label, required this.color});
}

class ChatMessage {
  final String id;
  final String sender; // 'customer' | 'agent' | 'bot' | 'system'
  final String text;
  final String timestamp;
  final bool isRead;
  final bool isDelivered;
  final String? attachmentUrl;
  final String? attachmentType; // 'image', 'pdf', 'audio'
  final String? audioDuration;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isRead = true,
    this.isDelivered = true,
    this.attachmentUrl,
    this.attachmentType,
    this.audioDuration,
  });
}

class ChatThread {
  final String id;
  final String customerName;
  final String customerPhone;
  final String? customerAvatar;
  final ChatChannel channel;
  final ClientStage stage;
  final String projectTitle;
  final String propertyLocation;
  final double budget;
  final String assignedAgent;
  int unreadCount;
  bool isPinned;
  final List<ChatMessage> messages;
  final List<String> tags;

  ChatThread({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    this.customerAvatar,
    this.channel = ChatChannel.whatsapp,
    required this.stage,
    required this.projectTitle,
    required this.propertyLocation,
    required this.budget,
    required this.assignedAgent,
    this.unreadCount = 0,
    this.isPinned = false,
    required this.messages,
    this.tags = const [],
  });

  ChatMessage get lastMessage => messages.isNotEmpty
      ? messages.last
      : const ChatMessage(id: '0', sender: 'system', text: '', timestamp: '');
}

class ChatMockData {
  static final List<ChatThread> threads = [
    ChatThread(
      id: 'CHT-101',
      customerName: 'Aditya & Neha Singhania',
      customerPhone: '+91 98101 22849',
      stage: ClientStage.design,
      projectTitle: '4BHK DLF Camellias Penthouse',
      propertyLocation: 'Golf Course Road, Gurugram',
      budget: 8500000.0,
      assignedAgent: 'Ar. Sanjana Kapoor',
      unreadCount: 2,
      isPinned: true,
      tags: ['VIP Luxury', 'Italian Marble', 'Modular Kitchen'],
      messages: [
        const ChatMessage(
          id: 'm1',
          sender: 'customer',
          text: 'Hi Sanjana, we reviewed the 3D walkthrough you sent on Tuesday. We love the master bedroom color palette!',
          timestamp: '11:15 AM',
        ),
        const ChatMessage(
          id: 'm2',
          sender: 'agent',
          text: 'Thank you Neha! The warm greige with fluted paneling complements the morning light on the 14th floor perfectly.',
          timestamp: '11:18 AM',
        ),
        const ChatMessage(
          id: 'm3',
          sender: 'customer',
          text: 'Can we check if the walk-in wardrobe has integrated LED profiles for the accessory drawer?',
          timestamp: '11:22 AM',
        ),
        const ChatMessage(
          id: 'm4',
          sender: 'agent',
          text: 'Yes absolutely! Attached is the detailed joinery section drawing showing the concealed Hafele motion sensors and velvet jewelry trays.',
          timestamp: '11:25 AM',
          attachmentType: 'image',
          attachmentUrl: 'https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?w=600',
        ),
        const ChatMessage(
          id: 'm5',
          sender: 'customer',
          text: 'This looks stunning! Could you also share the final revised BOQ for the modular woodwork?',
          timestamp: '11:32 AM',
          isRead: false,
        ),
      ],
    ),
    ChatThread(
      id: 'CHT-102',
      customerName: 'Vikramaditya Mehta',
      customerPhone: '+91 98205 11920',
      stage: ClientStage.execution,
      projectTitle: '3BHK Duplex Sea-Facing Villa',
      propertyLocation: 'Bandra West, Mumbai',
      budget: 6200000.0,
      assignedAgent: 'Er. Rajeshwar Menon',
      unreadCount: 1,
      isPinned: true,
      tags: ['Civil Works', 'Waterproofing', 'Hettich Hardware'],
      messages: [
        const ChatMessage(
          id: 'm201',
          sender: 'agent',
          text: 'Good morning Mr. Mehta. Waterproofing test for the master ensuite sunken slab has passed 72-hour ponding inspection.',
          timestamp: '09:40 AM',
        ),
        const ChatMessage(
          id: 'm202',
          sender: 'customer',
          text: 'Excellent! When is the Italian marble dry-lay planned at the workshop?',
          timestamp: '10:05 AM',
        ),
        const ChatMessage(
          id: 'm203',
          sender: 'agent',
          text: 'Scheduled for tomorrow 3 PM at the Kurla depot. Our marble specialist will assist with vein-matching layout.',
          timestamp: '10:12 AM',
        ),
      ],
    ),
    ChatThread(
      id: 'CHT-103',
      customerName: 'Pooja & Rohan Deshmukh',
      customerPhone: '+91 99200 44556',
      stage: ClientStage.lead,
      projectTitle: '3BHK Premium High-Rise',
      propertyLocation: 'Indiranagar, Bengaluru',
      budget: 3800000.0,
      assignedAgent: 'Megha Agarwal',
      unreadCount: 0,
      tags: ['New Lead', 'Vastu Friendly', 'Possession Dec 2026'],
      messages: [
        const ChatMessage(
          id: 'm301',
          sender: 'customer',
          text: 'Hi Homio team, we received your Vastu guidelines handbook. We want an East-facing main door layout.',
          timestamp: 'Yesterday',
        ),
        const ChatMessage(
          id: 'm302',
          sender: 'agent',
          text: 'Hello Pooja! We have designed 12+ homes in your society with compliant Brahmasthan grids. Would Saturday 4 PM suit you for a 3D VR consultation?',
          timestamp: 'Yesterday',
        ),
        const ChatMessage(
          id: 'm303',
          sender: 'customer',
          text: 'Saturday 4 PM works great for us. See you then!',
          timestamp: 'Yesterday',
        ),
      ],
    ),
    ChatThread(
      id: 'CHT-104',
      customerName: 'Col. Ranjit Verma',
      customerPhone: '+91 98110 55412',
      stage: ClientStage.handover,
      projectTitle: 'Independent 4BHK Villa',
      propertyLocation: 'Nirvana Country, Gurugram',
      budget: 5400000.0,
      assignedAgent: 'Karan Mehra',
      unreadCount: 0,
      tags: ['Handover Done', '10-Yr Warranty', 'Happy Client'],
      messages: [
        const ChatMessage(
          id: 'm401',
          sender: 'agent',
          text: 'Dear Col. Verma, sharing the digital warranty certificate and keys handover docket for your records.',
          timestamp: '3 days ago',
          attachmentType: 'pdf',
          attachmentUrl: 'https://cdn.homiocrm.com/dockets/verma-villa-warranty.pdf',
        ),
        const ChatMessage(
          id: 'm402',
          sender: 'customer',
          text: 'Received with thanks. The finishing of the teak wood staircase railing is commendable. Thank you team Homio!',
          timestamp: '3 days ago',
        ),
      ],
    ),
  ];
}
