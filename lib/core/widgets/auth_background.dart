import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ============================================================
        // LAYER 1: FIXED BACKGROUND BLOBS
        // ============================================================

        // Red Blob (Top Right)
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFFFFB7B2).withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Blue Blob (Bottom Left)
        Positioned(
          bottom: -50,
          left: -150,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: const Color(0xFFC7D9F9).withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // Blur Filter
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(color: Colors.transparent),
          ),
        ),

        // ============================================================
        // LAYER 2: THE CONTENT YOU PASS IN
        // ============================================================
        Positioned.fill(child: child),
      ],
    );
  }
}
