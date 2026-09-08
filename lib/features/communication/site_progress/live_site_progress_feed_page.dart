import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/site_progress_models.dart';

class LiveSiteProgressFeedPage extends StatefulWidget {
  const LiveSiteProgressFeedPage({super.key});

  @override
  State<LiveSiteProgressFeedPage> createState() => _LiveSiteProgressFeedPageState();
}

class _LiveSiteProgressFeedPageState extends State<LiveSiteProgressFeedPage> {
  String _selectedStage = 'All Stages';
  String _searchQuery = '';
  final TextEditingController _commentCtrl = TextEditingController();
  String? _activeCommentPostId;

  final List<String> _stages = [
    'All Stages',
    'False Ceiling & Carpentry',
    'Italian Marble & Flooring',
    'Electrical & Plumbing',
    'Painting & Wall Finishes',
  ];

  List<SiteProgressPost> get _filteredPosts {
    return SiteProgressMockData.posts.where((post) {
      final matchesSearch = post.projectTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.clientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));

      if (!matchesSearch) return false;

      if (_selectedStage == 'All Stages') return true;
      return post.stageName == _selectedStage;
    }).toList();
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
          _buildStageFilterBar(isDark, surfaceColor, borderColor, textPrimary, textSecondary),
          Expanded(
            child: _filteredPosts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library_outlined, size: 48, color: textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text('No site progress posts found', style: TextStyle(color: textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    itemCount: _filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = _filteredPosts[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 780),
                          child: _buildFeedCard(post, isDark, surfaceColor, borderColor, textPrimary, textSecondary),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.photo_camera_back_rounded, color: Color(0xFF10B981), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Live Site Progress Feed',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                          SizedBox(width: 4),
                          Text(
                            'Real-time WhatsApp Sync',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Daily geotagged photo updates, milestone visual signoffs & homeowner reactions',
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showNewPostModal(context, isDark, surfaceColor, borderColor, textPrimary, textSecondary),
            icon: const Icon(Icons.add_a_photo_rounded, size: 18),
            label: const Text('New Site Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageFilterBar(
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SizedBox(
                width: 240,
                height: 36,
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(fontSize: 13, color: textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search site posts & tags...',
                    hintStyle: TextStyle(fontSize: 13, color: textSecondary),
                    prefixIcon: Icon(Icons.search, size: 18, color: textSecondary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _stages.map((stage) {
                      final isSelected = _selectedStage == stage;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(stage),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _selectedStage = stage),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? Colors.white : textSecondary,
                          ),
                          selectedColor: const Color(0xFF10B981),
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeedCard(
    SiteProgressPost post,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Supervisor / Project Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                  child: Text(
                    post.supervisorName.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              post.supervisorName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              post.stageName,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 13, color: textSecondary),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${post.locationTag} (${post.gpsCoords})',
                              style: TextStyle(fontSize: 11, color: textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text('• ${_formatTimeAgo(post.timestamp)}', style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_sunny_outlined, size: 13, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 4),
                      Text(post.weather, style: TextStyle(fontSize: 11, color: textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // High-Res Media Gallery
          if (post.mediaUrls.isNotEmpty)
            _buildMediaGrid(post.mediaUrls),

          // Description & Tags
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: textPrimary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: post.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: borderColor),

          // Social Reaction & WhatsApp Actions Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Like Button
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      post.clientLiked = !post.clientLiked;
                    });
                  },
                  icon: Icon(
                    post.clientLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 18,
                    color: post.clientLiked ? const Color(0xFFEF4444) : textSecondary,
                  ),
                  label: Text(
                    post.clientLiked ? 'Client Liked' : 'Like',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: post.clientLiked ? const Color(0xFFEF4444) : textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Comment Toggle Button
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      if (_activeCommentPostId == post.id) {
                        _activeCommentPostId = null;
                      } else {
                        _activeCommentPostId = post.id;
                      }
                    });
                  },
                  icon: Icon(Icons.mode_comment_outlined, size: 18, color: textSecondary),
                  label: Text(
                    '${post.comments.length} Comments',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                ),
                const Spacer(),
                // WhatsApp Resend Button
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Site update sent to ${post.clientName} via WhatsApp!'),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded, size: 14, color: Color(0xFF10B981)),
                  label: const Text(
                    'WhatsApp Client',
                    style: TextStyle(fontSize: 12, color: Color(0xFF10B981)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF10B981)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),

          // Inline Comments Thread
          if (_activeCommentPostId == post.id || post.comments.isNotEmpty) ...[
            Divider(height: 1, color: borderColor),
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.5) : const Color(0xFFF8FAFC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...post.comments.map((comment) => _buildCommentRow(comment, isDark, textPrimary, textSecondary)),
                  const SizedBox(height: 12),
                  // Reply Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentCtrl,
                          style: TextStyle(fontSize: 12, color: textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Add team reply or site note...',
                            hintStyle: TextStyle(fontSize: 12, color: textSecondary),
                            filled: true,
                            fillColor: surfaceColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: borderColor),
                            ),
                          ),
                          onSubmitted: (val) => _submitComment(post),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: () => _submitComment(post),
                        icon: const Icon(Icons.send_rounded, size: 16),
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaGrid(List<String> mediaUrls) {
    if (mediaUrls.length == 1) {
      return InkWell(
        onTap: () => _showLightbox(mediaUrls.first),
        child: ClipRRect(
          child: Image.network(
            mediaUrls.first,
            height: 320,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(height: 240, color: Colors.grey.shade300),
          ),
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: Row(
        children: mediaUrls.map((url) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: InkWell(
                onTap: () => _showLightbox(url),
                child: Image.network(
                  url,
                  height: 280,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade300),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCommentRow(
    SiteComment comment,
    bool isDark,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: comment.isClient
                ? const Color(0xFF3B82F6).withValues(alpha: 0.15)
                : const Color(0xFF10B981).withValues(alpha: 0.15),
            child: Text(
              comment.authorName.substring(0, 1),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: comment.isClient ? const Color(0xFF3B82F6) : const Color(0xFF10B981),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.authorName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                          if (comment.isClient) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('Client', style: TextStyle(fontSize: 9, color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        _formatTimeAgo(comment.timestamp),
                        style: TextStyle(fontSize: 10, color: textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.text,
                    style: TextStyle(fontSize: 12, color: textPrimary, height: 1.3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitComment(SiteProgressPost post) {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      post.comments.add(
        SiteComment(
          id: 'c_${DateTime.now().millisecondsSinceEpoch}',
          authorName: 'Ar. Rohan Sen (Team)',
          isClient: false,
          text: text,
          timestamp: DateTime.now(),
        ),
      );
      _commentCtrl.clear();
    });
  }

  void _showLightbox(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.black,
                    child: const Center(child: Text('Image failed to load', style: TextStyle(color: Colors.white))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton.filled(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.black54, foregroundColor: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNewPostModal(
    BuildContext context,
    bool isDark,
    Color surfaceColor,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    final titleCtrl = TextEditingController(text: 'Villa #42 - Palm Meadows');
    final descCtrl = TextEditingController();
    String stage = 'False Ceiling & Carpentry';
    bool broadcastWhatsApp = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Upload New Site Progress Post',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleCtrl,
                      decoration: InputDecoration(
                        labelText: 'Project Name / Unit',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: stage,
                      decoration: InputDecoration(
                        labelText: 'Milestone / Stage',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: _stages.where((s) => s != 'All Stages').map((s) {
                        return DropdownMenuItem(value: s, child: Text(s));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => stage = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Site Observation / Progress Notes',
                        hintText: 'e.g. Living room false ceiling channels fixed. Wiring continuity checked.',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Image Upload Placeholder Button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor, style: BorderStyle.solid),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_upload_outlined, size: 32, color: Color(0xFF10B981)),
                          const SizedBox(height: 6),
                          Text('Attach Site Camera Photos / Drone Footage', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary)),
                          const SizedBox(height: 2),
                          Text('Auto-geotags GPS coordinates & timestamp', style: TextStyle(fontSize: 11, color: textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      value: broadcastWhatsApp,
                      activeThumbColor: const Color(0xFF10B981),
                      activeTrackColor: const Color(0xFF10B981).withValues(alpha: 0.5),
                      title: Text('Instant WhatsApp Broadcast to Client', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textPrimary)),
                      subtitle: Text('Delivers photos with GPS card directly to customer chat', style: TextStyle(fontSize: 11, color: textSecondary)),
                      onChanged: (val) => setModalState(() => broadcastWhatsApp = val),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          if (descCtrl.text.trim().isEmpty) return;
                          setState(() {
                            SiteProgressMockData.posts.insert(
                              0,
                              SiteProgressPost(
                                id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
                                projectTitle: titleCtrl.text,
                                clientName: 'Vikram Malhotra',
                                clientPhone: '+91 98201 44521',
                                supervisorName: 'Kishore Kumar (Lead Eng)',
                                locationTag: 'Palm Meadows, Whitefield',
                                gpsCoords: '12.9698° N, 77.7499° E',
                                timestamp: DateTime.now(),
                                stageName: stage,
                                description: descCtrl.text.trim(),
                                mediaUrls: [
                                  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
                                ],
                                tags: ['New Update', 'On Schedule'],
                                comments: [],
                                weather: '29°C Sunny',
                                isBroadcastedToWhatsApp: broadcastWhatsApp,
                              ),
                            );
                          });
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Site update published and broadcasted to client!'),
                              backgroundColor: Color(0xFF10B981),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Publish Update'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
