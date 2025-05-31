import 'package:flutter/material.dart';

class MedalIcon extends StatelessWidget {
  final int rank;
  final double size;

  const MedalIcon({
    Key? key,
    required this.rank,
    this.size = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _getGradientForRank(rank),
        boxShadow: [
          BoxShadow(
            color: _getColorForRank(rank).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Medal background
          Icon(
            Icons.workspace_premium,
            size: size * 0.8,
            color: Colors.white,
          ),
          // Rank number
          Text(
            rank.toString(),
            style: TextStyle(
              color: _getColorForRank(rank),
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColorForRank(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF6C7B7F); // Default gray
    }
  }

  LinearGradient _getGradientForRank(int rank) {
    switch (rank) {
      case 1:
        return const LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return const LinearGradient(
          colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return const LinearGradient(
          colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF6C7B7F), Color(0xFF4A5568)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}

class SimpleMedalIcon extends StatelessWidget {
  final int rank;
  final double size;

  const SimpleMedalIcon({
    Key? key,
    required this.rank,
    this.size = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColorForRank(rank),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.star,
        size: size * 0.6,
        color: Colors.white,
      ),
    );
  }

  Color _getColorForRank(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF6C7B7F); // Default gray
    }
  }
}
