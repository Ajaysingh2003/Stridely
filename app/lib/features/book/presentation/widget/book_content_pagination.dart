import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/book/presentation/screen/book_content_screen.dart';
import 'package:app/features/book/presentation/provider/book_data_provider.dart';

class ChapterSwitcherButton extends StatelessWidget {
  const ChapterSwitcherButton({
    super.key,
    required this.currentContentId,
    required this.chapters,
    required this.ref,
  });

  final String currentContentId;
  final List<Map<String, String>> chapters;
  final WidgetRef ref;

  static const _accent = Color(0xFF4A8FE8);
  static const _textMuted = Color(0xFF6B7E8F);

  int get _currentPosition =>
      chapters.indexWhere((c) => c['uid'] == currentContentId);

  @override
  Widget build(BuildContext context) {
    final position = _currentPosition;
    final total = chapters.length;
    final label = position >= 0
        ? 'Chapter ${position + 1} of $total'
        : 'Chapters';

    return GestureDetector(
      onTap: () => _showChapterDrawer(context, position),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(127, 87, 87, 87),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: _accent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.keyboard_arrow_up_rounded,
              color: _textMuted,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  void _showChapterDrawer(BuildContext context, int position) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ChapterDrawer(
        updatedState: chapters,
        currentPosition: position,
        onSelect: (uid) {
          ref.invalidate(singleBookContentProvider(uid));
          Navigator.of(context)
            ..pop()
            ..pushReplacement(
              MaterialPageRoute(
                builder: (_) => BookContentPage(
                  key: ValueKey(uid),
                  contentId: uid,
                ),
              ),
            );
        },
      ),
    );
  }
}

class _ChapterDrawer extends StatelessWidget {
  const _ChapterDrawer({
    required this.updatedState,
    required this.currentPosition,
    required this.onSelect,
  });

  final List<Map<String, String>> updatedState;
  final int currentPosition;
  final void Function(String uid) onSelect;

  // ── White + sky blue palette ───────────────────────────────────────
  static const _bg           = Color(0xFFFFFFFF);
  static const _border       = Color(0xFFE4EDF7);
  static const _accent       = Color(0xFF38A8F0);          // sky blue
  static const _accentLight  = Color(0xFFE8F5FE);          // sky blue tint
  static const _accentMid    = Color(0xFFB8DFF9);          // sky blue mid
  static const _textPrimary  = Color(0xFF0F1A24);          // near-black
  static const _textMuted    = Color(0xFF8BA3B8);          // slate

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: _border, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            decoration: BoxDecoration(
              color: _accentMid,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chapters',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _accentLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${updatedState.length} chapters',
                    style: const TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: _border),

          // Chapter list
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.55,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: updatedState.length,
              itemBuilder: (context, index) {
                final item = updatedState[index];
                final isActive = index == currentPosition;
                final title = item['title'] ?? 'Chapter ${index + 1}';
                final uid = item['uid'] ?? '';

                return InkWell(
                  onTap: isActive ? null : () => onSelect(uid),
                  splashColor: _accentLight,
                  highlightColor: _accentLight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    color: isActive ? _accentLight : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        // Number badge
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isActive ? _accent : _border,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : _textMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Title
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: isActive ? _accent : const Color.fromARGB(255, 41, 44, 46),
                              fontSize: 13,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Active check
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: isActive ? 1 : 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _accent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}


