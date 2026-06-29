
// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// Widget buildReadInterface(BuildContext context, dynamic bookContent) {


//     // final updatedState = ref.watch(bookTitleControllerProvider(bookId));
//     return SingleChildScrollView(
//       key: const ValueKey('ReadView'),
//       child: SafeArea(
//             top: false,
//             child: Container(
//               constraints: const BoxConstraints(maxWidth: 650),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Chapter ${bookContent.position}",
//                       style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                         color: const Color.fromARGB(179, 225, 221, 221),
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.5,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       bookContent.title,
//                       style: Theme.of(context).textTheme.titleLarge
//                           ?.copyWith(
//                             fontWeight: FontWeight.w700,
//                             color: const Color.fromARGB(228, 255, 255, 255),
//                             letterSpacing: 1.3,
//                             wordSpacing: 2
//                           ),
//                     ),
//                     // const SizedBox(height: 8),
                    
//                     const Divider(
//                       thickness: 1,
//                       color: Color.fromARGB(255, 44, 44, 44),
//                     ),
//                     const SizedBox(height: 8),

//                     // ✒️ Clean Document Markdown Layout Stream
//                     MarkdownBody(
//                       data: bookContent.content,
//                       selectable: true,
//                       styleSheet:
//                           MarkdownStyleSheet.fromTheme(
//                             Theme.of(context),
//                           ).copyWith(
//                             // ── Your existing styles — unchanged ──────────────────────────
//                             p: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               height: 1.75,
//                               color: const Color.fromARGB(234, 255, 255, 255),
//                               fontSize: 17,
//                             ),
//                             h1: Theme.of(context).textTheme.headlineMedium
//                                 ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                             h2: Theme.of(context).textTheme.headlineMedium
//                                 ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                             h3: Theme.of(context).textTheme.headlineSmall
//                                 ?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                             listBullet: Theme.of(context).textTheme.bodyLarge
//                                 ?.copyWith(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                             listBulletPadding: const EdgeInsets.only(
//                               right: 12,
//                               top: 2,
//                             ),
//                             blockSpacing: 20.0,

//                             // ── Added styles ──────────────────────────────────────────────

//                             // **bold text**
//                             strong: Theme.of(context).textTheme.bodyLarge
//                                 ?.copyWith(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 17,
//                                 ),

//                             // *italic text*
//                             em: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               color: const Color.fromARGB(210, 255, 255, 255),
//                               fontStyle: FontStyle.italic,
//                               fontSize: 17,
//                             ),

//                             // > blockquote text
//                             blockquote: Theme.of(context).textTheme.bodyLarge
//                                 ?.copyWith(
//                                   height: 1.75,
//                                   color: const Color.fromARGB(
//                                     180,
//                                     255,
//                                     255,
//                                     255,
//                                   ),
//                                   fontStyle: FontStyle.italic,
//                                   fontSize: 17,
//                                 ),

//                             // Left border + background on blockquotes
//                             blockquoteDecoration: BoxDecoration(
//                               color: const Color.fromARGB(25, 74, 143, 232),
//                               border: Border(
//                                 left: BorderSide(
//                                   color: const Color(
//                                     0xFF4A8FE8,
//                                   ).withValues(alpha: 0.7),
//                                   width: 3.5,
//                                 ),
//                               ),
//                             ),

//                             blockquotePadding: const EdgeInsets.fromLTRB(
//                               16,
//                               10,
//                               16,
//                               10,
//                             ),

//                             // --- horizontal rule
//                             horizontalRuleDecoration: BoxDecoration(
//                               border: Border(
//                                 top: BorderSide(
//                                   color: const Color.fromARGB(
//                                     60,
//                                     255,
//                                     255,
//                                     255,
//                                   ),
//                                   width: 1,
//                                 ),
//                               ),
//                             ),

//                             // `inline code`
//                             code: Theme.of(context).textTheme.bodyMedium
//                                 ?.copyWith(
//                                   color: const Color(0xFF4AE88A),
//                                   backgroundColor: const Color(0xFF0D1F18),
//                                   fontSize: 15,
//                                   fontFamily: 'monospace',
//                                 ),

//                             // ```code blocks```
//                             codeblockDecoration: BoxDecoration(
//                               color: const Color(0xFF0D1A14),
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(
//                                 color: const Color.fromARGB(60, 255, 255, 255),
//                               ),
//                             ),

//                             codeblockPadding: const EdgeInsets.all(16),

//                             // [links](url)
//                             a: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                               color: const Color(0xFF4A8FE8),
//                               fontSize: 17,
//                               decoration: TextDecoration.underline,
//                               decorationColor: const Color.fromARGB(
//                                 100,
//                                 74,
//                                 143,
//                                 232,
//                               ),
//                             ),
//                           ),
//                     ),


//                     Container(
//                       child: ,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           )
//       );
//   }



import 'package:app/features/book/presentation/provider/book_data_provider.dart';
import 'package:app/features/book/presentation/widget/book_content_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget buildReadInterface(BuildContext context, dynamic bookContent, String bookId) {
  return SingleChildScrollView(
    child: Consumer(
      builder: (context, ref, child) {
        // Now you can use lowercase 'ref' to watch your provider
        final updatedState = ref.watch(bookTitleControllerProvider(bookId)).titles;
        
        print(bookContent);
        

  return SingleChildScrollView(
      key: const ValueKey('ReadView'),
      child: SafeArea(
            top: false,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 650),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chapter ${bookContent.position}",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color.fromARGB(179, 225, 221, 221),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      bookContent.title,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color.fromARGB(228, 255, 255, 255),
                            letterSpacing: 1.3,
                            wordSpacing: 2
                          ),
                    ),
                    // const SizedBox(height: 8),
                    
                    const Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 44, 44, 44),
                    ),
                    const SizedBox(height: 8),

                    // ✒️ Clean Document Markdown Layout Stream
                    MarkdownBody(
                      data: bookContent.content,
                      selectable: true,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(
                            Theme.of(context),
                          ).copyWith(
                            // ── Your existing styles — unchanged ──────────────────────────
                            p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.75,
                              color: const Color.fromARGB(234, 255, 255, 255),
                              fontSize: 17,
                            ),
                            h1: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            h2: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            h3: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                            listBullet: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            listBulletPadding: const EdgeInsets.only(
                              right: 12,
                              top: 2,
                            ),
                            blockSpacing: 20.0,

                            // ── Added styles ──────────────────────────────────────────────

                            // **bold text**
                            strong: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                ),

                            // *italic text*
                            em: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color.fromARGB(210, 255, 255, 255),
                              fontStyle: FontStyle.italic,
                              fontSize: 17,
                            ),

                            // > blockquote text
                            blockquote: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  height: 1.75,
                                  color: const Color.fromARGB(
                                    180,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 17,
                                ),

                            // Left border + background on blockquotes
                            blockquoteDecoration: BoxDecoration(
                              color: const Color.fromARGB(25, 74, 143, 232),
                              border: Border(
                                left: BorderSide(
                                  color: const Color(
                                    0xFF4A8FE8,
                                  ).withValues(alpha: 0.7),
                                  width: 3.5,
                                ),
                              ),
                            ),

                            blockquotePadding: const EdgeInsets.fromLTRB(
                              16,
                              10,
                              16,
                              10,
                            ),

                            // --- horizontal rule
                            horizontalRuleDecoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: const Color.fromARGB(
                                    60,
                                    255,
                                    255,
                                    255,
                                  ),
                                  width: 1,
                                ),
                              ),
                            ),

                            // `inline code`
                            code: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: const Color(0xFF4AE88A),
                                  backgroundColor: const Color(0xFF0D1F18),
                                  fontSize: 15,
                                  fontFamily: 'monospace',
                                ),

                            // ```code blocks```
                            codeblockDecoration: BoxDecoration(
                              color: const Color(0xFF0D1A14),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color.fromARGB(60, 255, 255, 255),
                              ),
                            ),

                            codeblockPadding: const EdgeInsets.all(16),

                            // [links](url)
                            a: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFF4A8FE8),
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color.fromARGB(
                                100,
                                74,
                                143,
                                232,
                              ),
                            ),
                          ),
                    ),

// print(bookContent);
SizedBox(height: 20,),
                    Center(
                      child: ChapterSwitcherButton(ref: ref,chapters: updatedState,currentContentId: bookContent.uid,),
                    )

                  ],
                ),
              ),
            ),
          )
      );
      },
    ),
  );
}




