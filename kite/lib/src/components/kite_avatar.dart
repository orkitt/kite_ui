// Kite UI Components
// Copyright (c) 2026 Kite UI Contributors.
// Licensed under the MIT License. Keep this notice in substantial copies.
// Learn more: https://kite.orkitt.dev
import 'package:flutter/material.dart';

import '../design/design.dart';

class KiteAvatar extends StatelessWidget {
  const KiteAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = Dimensions.touchTarget,
    this.badge,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.kolors;
    final initials = _initials(name);

    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: ColoredBox(
              color: colors.primarySoft,
              child: imageUrl == null
                  ? Center(
                      child: Text(
                        initials,
                        style: context.typography.label.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    )
                  : Image.network(
                      imageUrl!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Center(
                        child: Text(
                          initials,
                          style: context.typography.label.copyWith(
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          if (badge != null)
            Positioned(
              right: -Dimensions.s2,
              bottom: -Dimensions.s2,
              child: badge!,
            ),
        ],
      ),
    );
  }

  String _initials(String? value) {
    if (value == null || value.trim().isEmpty) return '?';
    final parts = value.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((e) => e[0].toUpperCase()).join();
  }
}
