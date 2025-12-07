import 'package:flutter/material.dart';

/// 평점 표시 위젯
/// 병원의 평균 별점과 리뷰 개수를 표시
class RatingDisplay extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double starSize;
  final TextStyle? ratingTextStyle;
  final TextStyle? reviewCountTextStyle;
  final bool showReviewCount;

  const RatingDisplay({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.starSize = 16,
    this.ratingTextStyle,
    this.reviewCountTextStyle,
    this.showReviewCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star,
          size: starSize,
          color: Colors.amber,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: ratingTextStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (showReviewCount) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: reviewCountTextStyle ??
                TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
          ),
        ],
      ],
    );
  }
}

/// 별점 바 위젯
/// 5개의 별로 평점을 표시
class StarRating extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool allowHalfStars;

  const StarRating({
    super.key,
    required this.rating,
    this.starSize = 20,
    this.activeColor,
    this.inactiveColor,
    this.allowHalfStars = true,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? Colors.amber;
    final inactive = inactiveColor ?? Colors.grey[300]!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData iconData;

        if (allowHalfStars) {
          if (rating >= starValue) {
            iconData = Icons.star;
          } else if (rating >= starValue - 0.5) {
            iconData = Icons.star_half;
          } else {
            iconData = Icons.star_border;
          }
        } else {
          iconData = rating >= starValue ? Icons.star : Icons.star_border;
        }

        return Icon(
          iconData,
          size: starSize,
          color: rating >= starValue - 0.5 ? active : inactive,
        );
      }),
    );
  }
}
