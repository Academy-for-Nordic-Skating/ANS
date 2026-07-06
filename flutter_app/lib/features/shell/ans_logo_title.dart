import 'package:flutter/material.dart';

const ansLogoBannerAsset = 'assets/images/ANS-logo-banner.png';

/// Intrinsic size of [ansLogoBannerAsset] (avoids 0-width layout for `Image` in AppBar on web).
const ansLogoBannerAspectRatio = 1200 / 303;

/// ANS banner used in the shared app bar.
class AnsLogoTitle extends StatelessWidget {
  const AnsLogoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: AspectRatio(
        aspectRatio: ansLogoBannerAspectRatio,
        child: Image.asset(
          ansLogoBannerAsset,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          semanticLabel: 'Academy for Nordic Skating',
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_not_supported_outlined,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
