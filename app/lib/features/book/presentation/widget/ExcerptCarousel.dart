import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';



class Excerptcarousel extends StatefulWidget {
  final List<String> list;
  @override
  State<Excerptcarousel> createState() => _CarouselWrapperState();
  const Excerptcarousel({super.key, required this.list});
}

class _CarouselWrapperState extends State<Excerptcarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  static const List<List<Color>> _gradients = [
    [Color(0xFF6B3FC2), Color(0xFF3A1F8A)],
    [Color(0xFF1A6B9A), Color(0xFF0D3554)],
    [Color.fromARGB(255, 31, 122, 92), Color(0xFF0D3D2C)],
    [Color(0xFF8A3F6B), Color(0xFF3D1A2E)],
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    Future<void> _generateAndShareQuoteImage(
  BuildContext context,
  String quoteText, {
  String? bookTitle,
  String? bookAuthor,
}) async {
  try {
    const double W = 1200;
    const double textLeft = 114.0;
    const double textRight = W - 100;
    const double topStart = 120.0;
    const double bottomBarH = 72.0;
    const double verticalPad = 64.0;

    // ── Step 1: measure text BEFORE creating canvas ───────────────────
    double fontSize = 52;
    if (quoteText.length > 160) fontSize = 46;
    if (quoteText.length > 260) fontSize = 40;
    if (quoteText.length > 380) fontSize = 34;
    if (quoteText.length > 520) fontSize = 28;

    final quotePainter = TextPainter(
      text: TextSpan(
        text: quoteText,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
          height: 1.65,
          letterSpacing: 0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: textRight - textLeft);

    // Attribution block height (rule + text + spacing)
    final double attrBlockH = (bookTitle != null || bookAuthor != null) ? 72.0 : 0.0;

    // Calculate total required height, enforce minimum of 630
    final double requiredH = topStart
        + verticalPad
        + quotePainter.height
        + attrBlockH
        + verticalPad
        + bottomBarH;

    final double H = requiredH < 630 ? 630 : requiredH;

    // ── Step 2: load logo ─────────────────────────────────────────────
    final logoData = await rootBundle.load('assets/images/logo.png');
    final logoCodec = await ui.instantiateImageCodec(
      logoData.buffer.asUint8List(),
      targetWidth: 52,
      targetHeight: 52,
    );
    final logoFrame = await logoCodec.getNextFrame();
    final logoImage = logoFrame.image;

    // ── Step 3: create canvas at the correct height ───────────────────
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, W, H));

    // ── Background ────────────────────────────────────────────────────
    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(W, H),
        const [Color(0xFF0B0C12), Color(0xFF0F1018), Color(0xFF0A0B10)],
        [0.0, 0.5, 1.0],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, W, H), bgPaint);

    // Radial glow
    canvas.drawRect(
      Rect.fromLTWH(0, 0, W, H),
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(W / 2, H / 2),
          W * 0.55,
          [
            const Color(0xFF4A8FE8).withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
    );

    // Top accent rule
    canvas.drawRect(
      Rect.fromLTWH(0, 0, W, 2),
      Paint()..color = const Color(0xFF4A8FE8).withValues(alpha: 0.5),
    );

    // Giant ghost quote mark
    final openQuotePainter = TextPainter(
      text: const TextSpan(
        text: '\u201C',
        style: TextStyle(
          color: Color(0x0F4A8FE8),
          fontSize: 420,
          fontWeight: FontWeight.w900,
          height: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    openQuotePainter.paint(canvas, Offset(W - 360, H * 0.05));

    // Left accent bar — spans full content height
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(56, 80, 6, H - 80 - bottomBarH - 20),
        const Radius.circular(3),
      ),
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(56, 80),
          Offset(56, H - bottomBarH - 20),
          [
            const Color(0xFF4A8FE8).withValues(alpha: 0.0),
            const Color(0xFF4A8FE8),
            const Color(0xFF4A8FE8),
            const Color(0xFF4A8FE8).withValues(alpha: 0.0),
          ],
          [0.0, 0.15, 0.85, 1.0],
        ),
    );

    // EXCERPT label
    final excerptPainter = TextPainter(
      text: const TextSpan(
        text: 'E X C E R P T',
        style: TextStyle(
          color: Color(0xFF4A8FE8),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    excerptPainter.paint(canvas, Offset(textLeft, 76));

    // ── Quote text ────────────────────────────────────────────────────
    final double quoteTop = topStart + verticalPad;
    quotePainter.paint(canvas, Offset(textLeft, quoteTop));

    // ── Attribution ───────────────────────────────────────────────────
    if (bookTitle != null || bookAuthor != null) {
      final double attrY = quoteTop + quotePainter.height + 36;

      canvas.drawLine(
        Offset(textLeft, attrY),
        Offset(textLeft + 56, attrY),
        Paint()
          ..color = const Color(0xFF4A8FE8).withValues(alpha: 0.6)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );

      final List<TextSpan> parts = [
        if (bookTitle != null)
          TextSpan(
            text: bookTitle,
            style: const TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
            ),
          ),
        if (bookTitle != null && bookAuthor != null)
          const TextSpan(
            text: '  ·  ',
            style: TextStyle(color: Color(0x554A8FE8), fontSize: 22),
          ),
        if (bookAuthor != null)
          TextSpan(
            text: bookAuthor,
            style: const TextStyle(
              color: Color(0x884A8FE8),
              fontSize: 22,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.4,
            ),
          ),
      ];

      final attrTextPainter = TextPainter(
        text: TextSpan(children: parts),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: W - textLeft - 120);
      attrTextPainter.paint(canvas, Offset(textLeft, attrY + 18));
    }

    // ── Bottom branding bar ───────────────────────────────────────────
    final double barY = H - bottomBarH;

    canvas.drawRect(
      Rect.fromLTWH(0, barY, W, bottomBarH),
      Paint()..color = const Color(0xFF050508),
    );
    canvas.drawLine(
      Offset(0, barY),
      Offset(W, barY),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..strokeWidth = 1,
    );

    // Logo (clipped to circle)
    const double logoSize = 36;
    const double logoX = 82;
    final double logoY = barY + (bottomBarH - logoSize) / 2;

    canvas.save();
    canvas.clipRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(logoX, logoY, logoSize, logoSize),
      const Radius.circular(logoSize / 2),
    ));
    canvas.drawImageRect(
      logoImage,
      Rect.fromLTWH(
        0, 0,
        logoImage.width.toDouble(),
        logoImage.height.toDouble(),
      ),
      Rect.fromLTWH(logoX, logoY, logoSize, logoSize),
      Paint()..filterQuality = FilterQuality.high,
    );
    canvas.restore();

    // Brand name
    final brandPainter = TextPainter(
      text: const TextSpan(
        text: 'Booklsy',
        style: TextStyle(
          color: Color(0xFF4A8FE8),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    brandPainter.paint(
      canvas,
      Offset(logoX + logoSize + 10, barY + (bottomBarH - brandPainter.height) / 2),
    );

    // Tagline
    final tagPainter = TextPainter(
      text: const TextSpan(
        text: 'READ DEEPLY. THINK CLEARLY.',
        style: TextStyle(
          color: Color(0x334A8FE8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 2.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tagPainter.paint(
      canvas,
      Offset(W - tagPainter.width - 80, barY + (bottomBarH - tagPainter.height) / 2),
    );

    // Three corner dots
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        Offset(W - 80 + (i * 18.0), 72),
        3.5,
        Paint()
          ..color = const Color(0xFF4A8FE8)
              .withValues(alpha: 0.42 - (i * 0.12)),
      );
    }

    // ── Render & share ────────────────────────────────────────────────
    final picture = recorder.endRecording();
    final img = await picture.toImage(W.toInt(), H.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;
    final pngBytes = byteData.buffer.asUint8List();

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(pngBytes, mimeType: 'image/png')],
        fileNameOverrides: ['stridely_excerpt.png'],
        text: bookTitle != null
            ? '"$quoteText"\n\n— $bookTitle${bookAuthor != null ? ', $bookAuthor' : ''}\n\nRead on Booksly.'
            : 'Shared via Booksly.',
      ),
    );
  } catch (e) {
    
  }
}
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: false,
            viewportFraction: 0.92,
            height: 175,
            enableInfiniteScroll: false,
            onPageChanged: (index, _) => setState(() => _current = index),
          ),
          items: widget.list.asMap().entries.map((entry) {
            final gradient = _gradients[entry.key % _gradients.length];
            final isActive = _current == entry.key;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(right: 10.0),
              width: screenWidth * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isActive
                      ? Colors.white.withOpacity(0.25)
                      : Colors.white.withOpacity(0.07),
                  width: 0.5,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: gradient[0].withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Stack(
                  clipBehavior: Clip
                      .none, // Allows the quote to safely pop slightly out of the layout bounds if needed
                  children: [
                    // ── 🚀 THE OVERLAPPING QUOTE MARK ──
                    Positioned(
                      top:
                          -10, // 💡 Pulls the quote UP to overlap the title text boundary box
                      left:
                          -4, // 💡 Adjusts horizontal overlap alignment metrics
                      child: Text(
                        '\u201C',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize:
                              60, // 🔥 Scaled down so it sits elegantly as a designer accent mark
                          height: 1.0,
                          color: Colors.white.withOpacity(
                            0.25,
                          ), // Subtle translucent opacity rule
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    // ── 🚀 THE EXCERPT TEXT CONTENT LAYER ──
                    Padding(
                      // 💡 Added top/left padding so the first sentence lines up perfectly under/next to the float mark
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 17.5,
                          height: 1.6,
                          color: Colors.white,
                          letterSpacing: 0.15,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Note: Excerpt from the original book.",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: Colors
                                  .white60, // Cleaner subtle aesthetic context matching your dark theme
                            ),
                          ),

                          // ── Right side item (End) ──
                          IconButton(
                            onPressed: ()async{
                               await _generateAndShareQuoteImage(context, entry.value);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.ios_share,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 14),

        // ── Dots + counter ─────────────────────────────
      ],
    );
  }
}
