import 'package:flutter/material.dart';

class PatientCard extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String age;
  final String condition;
  final String lastSeen;
  final int sessionsCount;
  final VoidCallback? onNewChat;
  final VoidCallback? onTap;

  const PatientCard({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.condition,
    required this.lastSeen,
    required this.sessionsCount,
    this.onNewChat,
    this.onTap,
  });

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    return name
        .split(' ')
        .map((e) => e[0])
        .take(1)
        .join()
        .toUpperCase();
  }

  Color _getConditionColor(String condition) {
    if (condition.toLowerCase().contains('depressive')) return Colors.red[100]!;
    if (condition.toLowerCase().contains('anxiety')) return Colors.orange[100]!;
    if (condition.toLowerCase().contains('ptsd')) return Colors.purple[100]!;
    if (condition.toLowerCase().contains('sleep')) return Colors.blue[100]!;
    return Colors.green[100]!;
  }

  List<Color> get _avatarColorPalette => [
    const Color(0xFF3D9970), // Vert
    const Color(0xFF2E7D32), // Vert foncé
    const Color(0xFF0277BD), // Bleu
    const Color(0xFF1565C0), // Bleu foncé
    const Color(0xFF6A1B9A), // Purple
    const Color(0xFFC2185B), // Pink
    const Color(0xFFD32F2F), // Rouge
    const Color(0xFFF57C00), // Orange
    const Color(0xFFE65100), // Orange foncé
    const Color(0xFF455A64), // Gris bleu
  ];

  Color _getAvatarColor(String name) {
    // Utiliser la première lettre du nom pour déterminer la couleur
    final firstLetter = name.isEmpty ? 'A' : name[0].toUpperCase();
    final index = firstLetter.codeUnitAt(0) % _avatarColorPalette.length;
    return _avatarColorPalette[index];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                  blurRadius: _isHovered ? 12 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey[50]!,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header avec avatar et actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      _getAvatarColor(widget.patientName),
                                      _getAvatarColor(widget.patientName)
                                          .withOpacity(0.7),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getAvatarColor(widget.patientName)
                                          // ignore: deprecated_member_use
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.transparent,
                                  child: Text(
                                    _getInitials(widget.patientName),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.patientName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1F2937),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getConditionColor(
                                            widget.condition),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        widget.condition,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_horiz),
                          onPressed: () {},
                          tooltip: 'Plus d\'options',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Divider
                    Container(
                      height: 1,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(height: 12),
                    // Infos en grille
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem(
                          icon: Icons.cake_outlined,
                          label: 'Âge',
                          value: widget.age,
                        ),
                        _buildInfoItem(
                          icon: Icons.schedule,
                          label: 'Dernière visite',
                          value: widget.lastSeen,
                        ),
                        _buildInfoItem(
                          icon: Icons.chat_bubble_outline,
                          label: 'Sessions',
                          value: '${widget.sessionsCount}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Bouton New Chat
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: widget.onNewChat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D9970),
                          foregroundColor: Colors.white,
                          elevation: _isHovered ? 6 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          shadowColor: const Color(0xFF3D9970).withOpacity(0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Nouveau Chat',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF3D9970),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
