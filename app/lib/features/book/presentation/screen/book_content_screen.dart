import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/widget/FloatingButtonSwitch.dart';
import 'package:app/features/book/presentation/widget/ReadInterface.dart';
import 'package:app/features/book/presentation/widget/book_audio.dart';
import 'package:app/features/book/presentation/widget/book_content_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookContentPage extends ConsumerStatefulWidget {
  final String contentId;

  const BookContentPage({super.key, required this.contentId});

  @override
  ConsumerState<BookContentPage> createState() => _BookContentPageState();
}

class _BookContentPageState extends ConsumerState<BookContentPage> {
  // 🚀 FIXED: State variable must live here, outside the build method layer!
  bool _isAudioMode = false;

  

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    print("🔍 BookContentPage built — contentId: ${widget.contentId}");
    final bookContentAsync = ref.watch(
      singleBookContentProvider(widget.contentId),
    );
    


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 11, 22, 30),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.format_size, color: colors.primary),
            onPressed: () => print("Adjust text size configuration options"),
          ),
        ],
      ),
      body: bookContentAsync.when(
        loading: () => const Center(child: BookContentLoader()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              textAlign: TextAlign.center,
              'Failed to load text: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        data: (bookContent) {
          // 🎯 FIXED: Changed to a Stack layout to allow Positioned overlay positioning
          return Stack(
            children: [
              // 1. THE VIEW INTERFACE VIEWPORT CANVAS
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isAudioMode
                      ? BookAudioInterface(
                          // Key matches the exact widget class runtime type signature
                          key: const ValueKey('AudioModeCanvas'),
                          bookId: bookContent.bookId,
                        )
                      : buildReadInterface(context, bookContent,bookContent.bookId),
                ),
              ),

// Text("ajay",style: TextStyle(color: Colors.white),),
              // 2. THE FLOATING CONTROLLER INTERACTIVE CAPSULE BAR
              Positioned(
                left: 0,
                right: 0,
                bottom: 104, // Sits elegantly right above the bottom margin line
                child: SafeArea(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                      color: const Color.fromARGB(174, 87, 87, 87),
                        borderRadius: BorderRadius.circular(30),
                        border: BoxBorder.all(color: const Color.fromARGB(90, 255, 255, 255),width: 1)
                      ),
                      height: 45,
                      width: 90,
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: !_isAudioMode
                                  ? colors.primary
                                  : Colors.transparent,
                              foregroundColor: Colors.white,
                              fixedSize: const Size(30, 30),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              setState(() {
                                _isAudioMode=false;
                              });
                            },
                            icon: const Icon(Icons.menu_book_rounded, size: 25),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: _isAudioMode
                                  ? colors.primary
                                  : Colors.transparent,
                              foregroundColor: Colors.white,
                              fixedSize: const Size(30, 30),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.headphones_rounded, size: 25),
                            onPressed: () {
                               setState(() {
                                _isAudioMode=true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
