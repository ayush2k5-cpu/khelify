import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../themes/khelify_theme.dart';

// ══════════════════════════════════════════════════════════
// GLASS HEADER BAR
// Blurred background + Gold logo + Icons
// ══════════════════════════════════════════════════════════

class GlassHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onDMTap;
  final VoidCallback? onNotificationTap;
  final bool hasNewNotifications;
  final bool hasNewMessages;

  const GlassHeader({
    Key? key,
    this.onProfileTap,
    this.onDMTap,
    this.onNotificationTap,
    this.hasNewNotifications = false,
    this.hasNewMessages = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: KhelifyColors.championGold,
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Profile Icon
                _buildIconButton(
                  icon: PhosphorIcons.userCircle(PhosphorIconsStyle.fill),
                  onTap: onProfileTap,
                  hasIndicator: false,
                ),
                
                // Center: KHELIFY Logo
                _buildLogo(),
                
                // Right: DM + Notification
                Row(
                  children: [
                    _buildIconButton(
                      icon: PhosphorIcons.chatCircle(PhosphorIconsStyle.duotone),
                      onTap: onDMTap,
                      hasIndicator: hasNewMessages,
                    ),
                    SizedBox(width: 16),
                    _buildIconButton(
                      icon: PhosphorIcons.bell(PhosphorIconsStyle.fill),
                      onTap: onNotificationTap,
                      hasIndicator: hasNewNotifications,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== LOGO (Image Asset) ==========
  
  Widget _buildLogo() {
    return Container(
      height: 32,
      child: Image.asset(
        'assets/images/khelify_logo.png',
        height: 32,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback if image not found
          return Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: KhelifyColors.goldGradient,
              boxShadow: [
                BoxShadow(
                  color: KhelifyColors.championGold.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.fitness_center,
              color: Colors.black,
              size: 18,
            ),
          );
        },
      ),
    );
  }

  // ========== ICON BUTTON ==========
  
  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
    bool hasIndicator = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: KhelifyColors.white,
              size: 24,
            ),
            
            // Red notification dot
            if (hasIndicator)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: KhelifyColors.persianRed,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: KhelifyColors.persianRed.withOpacity(0.8),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════
// GOLD DIVIDER LINE
// Used below header and between sections
// ══════════════════════════════════════════════════════════

class GoldDivider extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;

  const GoldDivider({
    Key? key,
    this.height = 1,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            KhelifyColors.championGold.withOpacity(0.5),
            KhelifyColors.championGold,
            KhelifyColors.championGold.withOpacity(0.5),
            Colors.transparent,
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: KhelifyColors.championGold.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
}