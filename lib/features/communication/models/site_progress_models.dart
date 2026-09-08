class SiteComment {
  final String id;
  final String authorName;
  final bool isClient;
  final String text;
  final DateTime timestamp;

  SiteComment({
    required this.id,
    required this.authorName,
    required this.isClient,
    required this.text,
    required this.timestamp,
  });
}

class SiteProgressPost {
  final String id;
  final String projectTitle;
  final String clientName;
  final String clientPhone;
  final String supervisorName;
  final String locationTag;
  final String gpsCoords;
  final DateTime timestamp;
  final String stageName;
  final String description;
  final List<String> mediaUrls;
  final List<String> tags;
  bool clientLiked;
  final List<SiteComment> comments;
  bool isBroadcastedToWhatsApp;
  final String weather;

  SiteProgressPost({
    required this.id,
    required this.projectTitle,
    required this.clientName,
    required this.clientPhone,
    required this.supervisorName,
    required this.locationTag,
    required this.gpsCoords,
    required this.timestamp,
    required this.stageName,
    required this.description,
    required this.mediaUrls,
    required this.tags,
    this.clientLiked = false,
    required this.comments,
    this.isBroadcastedToWhatsApp = true,
    required this.weather,
  });
}

class SiteProgressMockData {
  static final List<SiteProgressPost> posts = [
    SiteProgressPost(
      id: 'sp_001',
      projectTitle: 'Villa #42 - Palm Meadows',
      clientName: 'Vikram Malhotra',
      clientPhone: '+91 98201 44521',
      supervisorName: 'Kishore Kumar (Senior Site Engineer)',
      locationTag: 'Palm Meadows, Whitefield, Bengaluru',
      gpsCoords: '12.9698° N, 77.7499° E',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
      stageName: 'False Ceiling & Carpentry',
      description: 'Living room perimeter cove false ceiling framing completed using 0.55mm Ultra-Steel GI channels. Drywall gypsum board fixing in progress. LED track light routing verified with electrical drawing rev-2.1.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1600565193348-f74bd3c7ccdf?auto=format&fit=crop&w=800&q=80',
      ],
      tags: ['Ceiling Gypsum', 'Electrical Conduit', 'Track Lights', 'QA Passed'],
      clientLiked: true,
      comments: [
        SiteComment(
          id: 'c_01',
          authorName: 'Vikram Malhotra',
          isClient: true,
          text: 'Looks very neat Kishore! Please ensure the cove profile has at least 3 inches clearance for the Philips hue strips.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 50)),
        ),
        SiteComment(
          id: 'c_02',
          authorName: 'Kishore Kumar',
          isClient: false,
          text: 'Noted Vikram sir! We have maintained exact 3.5 inches recess for seamless indirect bounce.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
        ),
      ],
      isBroadcastedToWhatsApp: true,
      weather: '28°C Sunny - Bengaluru',
    ),
    SiteProgressPost(
      id: 'sp_002',
      projectTitle: 'Skyline Towers #14B',
      clientName: 'Ananya Deshmukh',
      clientPhone: '+91 97654 32190',
      supervisorName: 'Sunil Patil (Civil Supervisor)',
      locationTag: 'Skyline Pinnacle, Worli, Mumbai',
      gpsCoords: '18.9986° N, 72.8174° E',
      timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 45)),
      stageName: 'Italian Marble & Flooring',
      description: 'Dry-laying of Botticino Beige Italian marble (5ft x 3ft slabs) initiated in the formal dining zone. Book-match grain alignment checked and tagged with chalk numbers for client visual signoff.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?auto=format&fit=crop&w=800&q=80',
      ],
      tags: ['Italian Marble', 'Dry Laying', 'Book Match', 'Flooring'],
      clientLiked: false,
      comments: [
        SiteComment(
          id: 'c_03',
          authorName: 'Ananya Deshmukh',
          isClient: true,
          text: 'The bookmatch in slab #3 and #4 looks stunning! Can you also send a short video of the foyer boundary?',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
      isBroadcastedToWhatsApp: true,
      weather: '31°C Humid - Mumbai',
    ),
    SiteProgressPost(
      id: 'sp_003',
      projectTitle: 'Greenwood Penthouse 901',
      clientName: 'Rajesh Gupta',
      clientPhone: '+91 94480 12345',
      supervisorName: 'Tanmay Roy (MEP Lead)',
      locationTag: 'Greenwood Heights, Sector 54, Gurugram',
      gpsCoords: '28.4285° N, 77.1062° E',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      stageName: 'Electrical & Plumbing',
      description: 'Concealed CPVC hot and cold water plumbing pressure test conducted at 10 bar for 4 hours. Zero leakage detected in master bath diverter and wall-hung toilet cistern flush valve.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
      ],
      tags: ['Pressure Test', '10 Bar Leak Check', 'CPVC Concealed', 'QA Certified'],
      clientLiked: true,
      comments: [],
      isBroadcastedToWhatsApp: true,
      weather: '26°C Clear - Gurugram',
    ),
    SiteProgressPost(
      id: 'sp_004',
      projectTitle: 'Heritage Bungalow Resto',
      clientName: 'Dr. Alok Verma',
      clientPhone: '+91 98860 33412',
      supervisorName: 'Mahesh Gowda (Heritage Specialist)',
      locationTag: 'Sadashivanagar, Bengaluru',
      gpsCoords: '13.0068° N, 77.5813° E',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      stageName: 'Painting & Wall Finishes',
      description: 'First coat of PU primer applied on handcrafted teakwood colonnade pillars. Lime plaster smoothing on inner courtyard walls underway.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
      ],
      tags: ['Teakwood PU', 'Courtyard Restoration', 'Lime Plaster'],
      clientLiked: true,
      comments: [
        SiteComment(
          id: 'c_04',
          authorName: 'Dr. Alok Verma',
          isClient: true,
          text: 'Splendid restoration work on the old pillars. Looking forward to the matte satin finish.',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 20)),
        ),
      ],
      isBroadcastedToWhatsApp: true,
      weather: '27°C Sunny - Bengaluru',
    ),
  ];
}
