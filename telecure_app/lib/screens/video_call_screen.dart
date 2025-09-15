import 'package:flutter/material.dart';

/// Minimal placeholder for a video call screen.
/// Use:
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => VideoCallPlaceholder(
///       doctorName: 'Dr. Priya Sharma',
///       specialty: 'General Physician',
///       mode: CallMode.video, // or CallMode.audio
///     ),
///   ),
/// );
enum CallMode { video, audio }

class VideoCallPlaceholder extends StatefulWidget {
  const VideoCallPlaceholder({
    super.key,
    required this.doctorName,
    required this.specialty,
    this.mode = CallMode.video,
  });

  final String doctorName;
  final String specialty;
  final CallMode mode;

  @override
  State<VideoCallPlaceholder> createState() => _VideoCallPlaceholderState();
}

class _VideoCallPlaceholderState extends State<VideoCallPlaceholder> {
  bool micMuted = false;
  bool camOff = false;
  bool videoPausedForNetwork = false;

  @override
  Widget build(BuildContext context) {
    final isAudio = widget.mode == CallMode.audio;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.doctorName, style: const TextStyle(color: Colors.white)),
            Text(widget.specialty,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: _NetworkPill(good: true), // static “Good” for placeholder
          ),
        ],
      ),
      body: Stack(
        children: [
          // Remote video / avatar placeholder
          Positioned.fill(
            child: Container(
              color: Colors.grey.shade900,
              alignment: Alignment.center,
              child: Icon(
                isAudio || camOff ? Icons.account_circle_rounded : Icons.videocam_rounded,
                size: 160,
                color: Colors.grey.shade700,
              ),
            ),
          ),

          // Self-view PiP (dummy box)
          Positioned(
            right: 12,
            top: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 110,
                height: 156,
                color: Colors.grey.shade800,
                alignment: Alignment.center,
                child: Icon(
                  isAudio || camOff ? Icons.mic_rounded : Icons.camera_alt_rounded,
                  color: Colors.white70,
                ),
              ),
            ),
          ),

          // Bottom control bar
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RoundControl(
                    icon: micMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                    label: micMuted ? 'Unmute' : 'Mute',
                    onTap: () => setState(() => micMuted = !micMuted),
                  ),
                  _RoundControl(
                    icon: camOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                    label: camOff ? 'Cam on' : 'Cam off',
                    onTap: isAudio ? null : () => setState(() => camOff = !camOff),
                    disabled: isAudio,
                  ),
                  _RoundControl(
                    icon: Icons.cameraswitch_rounded,
                    label: 'Switch',
                    onTap: isAudio ? null : () {},
                    disabled: isAudio,
                  ),
                  _RoundControl(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chat',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chat placeholder')),
                    ),
                  ),
                  _RoundControl(
                    icon: Icons.call_end_rounded,
                    label: 'End',
                    isDanger: true,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkPill extends StatelessWidget {
  const _NetworkPill({required this.good});
  final bool good;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: good ? Colors.green.withOpacity(.2) : Colors.orange.withOpacity(.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: good ? Colors.green : Colors.orange),
      ),
      child: Text(good ? 'Good' : 'Fair',
          style: TextStyle(color: good ? Colors.green : Colors.orange)),
    );
  }
}

class _RoundControl extends StatelessWidget {
  const _RoundControl({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDanger = false,
    this.disabled = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDanger;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final bg = isDanger
        ? Colors.red
        : (disabled ? Colors.grey.shade800 : Colors.white.withOpacity(.1));
    final border = isDanger ? Colors.redAccent : Colors.white38;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(36),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(color: border),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
