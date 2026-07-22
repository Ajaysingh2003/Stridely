import 'package:app/features/book/presentation/provider/book_data_provider.dart';
// import 'package:app/features/book/presentation/widget/FloatingButtonSwitch.dart';
import 'package:app/features/book/presentation/widget/ReadInterface.dart';
import 'package:app/features/book/presentation/widget/book_audio.dart';
import 'package:app/features/book/presentation/widget/book_content_loader.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookContentPage extends ConsumerStatefulWidget {
  final String contentId;
  final bool openAudio ;
  const BookContentPage({super.key, required this.contentId, this.openAudio  =false});

  @override
  ConsumerState<BookContentPage> createState() => _BookContentPageState();
}

class _BookContentPageState extends ConsumerState<BookContentPage> {

late bool _isAudioMode;


@override
  void initState() {
    super.initState();

    _isAudioMode = widget.openAudio;
  }
  

  @override
  Widget build(BuildContext context) {
  // bool _isAudioMode =  widget.openAudio ? true :false;
    final colors = Theme.of(context).colorScheme;
    
    final bookContentAsync = ref.watch(
      singleBookContentProvider(widget.contentId),
    );
    


    return Scaffold(
      backgroundColor: const Color(0xFF0B161E),
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
            icon: const Icon(Icons.menu_book_rounded, size: 25),
            onPressed: () {
              setState(() {
                _isAudioMode = false;
              });
            },
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
                _isAudioMode = true;
              });
            },
          ),
        ],
      ),
      body: bookContentAsync.when(
        data: (bookContent) {
          if (_isAudioMode) {
            return BookAudioInterface(
              bookId: bookContent.bookId,
            );
          }
          return buildReadInterface(context, bookContent, bookContent.bookId);
        },
        loading: () => const BookContentLoader(),
        error: (err, stack) => Center(
          child: Text(
            'Failed to load book content',
            style: TextStyle(color: colors.onSurface),
          ),
        ),
      ),
    );
  }
}
