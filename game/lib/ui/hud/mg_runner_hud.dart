import 'package:flutter/material.dart';
import 'package:mg_common_game/core/ui/mg_ui.dart';

/// MG UI 기반 러너 게임 HUD
/// mg_common_game의 공통 UI 컴포넌트 활용
class MGRunnerHud extends StatelessWidget {
  final int score;
  final int highScore;
  final int distance;
  final int coins;
  final bool isPaused;
  final VoidCallback? onPause;
  final VoidCallback? onResume;

  const MGRunnerHud({
    super.key,
    required this.score,
    this.highScore = 0,
    this.distance = 0,
    this.coins = 0,
    this.isPaused = false,
    this.onPause,
    this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding;

    return Positioned.fill(
      child: Column(
        children: [
          // 상단 HUD: 일시정지 + 점수 + 코인
          Container(
            padding: EdgeInsets.only(
              top: safeArea.top + MGSpacing.hudMargin,
              left: safeArea.left + MGSpacing.hudMargin,
              right: safeArea.right + MGSpacing.hudMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 일시정지 버튼
                MGIconButton(
                  icon: isPaused ? Icons.play_arrow : Icons.pause,
                  onPressed: isPaused ? onResume : onPause,
                  size: 44,
                  backgroundColor: Colors.black54,
                  color: Colors.white,
                ),

                // Life Display (Heart Icons)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/icon_heart.png',
                    height: 24, // Assuming 8px height * 3 scale
                    fit: BoxFit
                        .contain, // Shows all 3 hearts (Full, Half, Empty) as a "Life Bar" style?
                    // actually the sheet has [Full, Half, Empty]. Using it as "Health Bar" static image is fine for now.
                    // It looks like: ❤️ 💔 ♡
                  ),
                ),

                // 점수 표시
                _buildScoreDisplay(),

                // 코인 표시
                MGResourceBar(
                  icon: Icons.monetization_on,
                  value: _formatNumber(coins),
                  iconColor: MGColors.gold,
                  onTap: null,
                ),
              ],
            ),
          ),

          MGSpacing.vSm,

          // 거리 표시
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: safeArea.left + MGSpacing.hudMargin,
            ),
            child: _buildDistanceDisplay(),
          ),

          // 중앙 영역 확장 (게임 영역)
          const Expanded(child: SizedBox()),

          // 하단: 최고 점수 (필요시)
          if (highScore > 0)
            Container(
              padding: EdgeInsets.only(
                bottom: safeArea.bottom + MGSpacing.hudMargin,
                left: safeArea.left + MGSpacing.hudMargin,
                right: safeArea.right + MGSpacing.hudMargin,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 20,
                    ),
                    MGSpacing.hXs,
                    Text(
                      'Best: $highScore',
                      style: MGTextStyles.hudSmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/ui_panel.png'),
          fit: BoxFit.fill,
          // centerSlice seems safer if we knew exact insets, but fill works for now
        ),
      ),
      child: Text(
        '$score',
        style: MGTextStyles.display.copyWith(
          color: const Color(0xFFF4D03F), // Gold text color matching retro feel
          fontWeight: FontWeight.bold,
          fontSize: 32,
          shadows: [
            const Shadow(
              offset: Offset(2, 2),
              blurRadius: 0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.directions_run, color: Colors.lightBlue, size: 20),
          MGSpacing.hXs,
          Text(
            '${_formatNumber(distance)}m',
            style: MGTextStyles.hud.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
