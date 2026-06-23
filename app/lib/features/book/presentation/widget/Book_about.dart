import 'package:flutter/material.dart';

class AuthorType {
  final String authorName;
  final String authorBio;

  const AuthorType({required this.authorName, required this.authorBio});

  factory AuthorType.fromJson(Map<String, dynamic> json) {
    return AuthorType(
      authorName: json['authorName'] ?? 'Unknown Author',
      authorBio: json['authorBio'] ?? '',
    );
  }
}

class BookAbout extends StatelessWidget {
  final String about;
  final String forWhom;
  final AuthorType author;
  const BookAbout({
    required this.about,
    required this.forWhom,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BookParagraph(header: "What's it about?", paragrpah: about),
          SizedBox(height: 30),
          BookParagraph(header: "Who is it for ?", paragrpah: forWhom),
          SizedBox(height: 30),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Meet the author",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 20),
                ),
                SizedBox(height: 10,),
                Text(
                  author.authorName,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600,),
                ),
                  SizedBox(height: 3,),
                Text(
                  author.authorBio,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookParagraph extends StatelessWidget {
  final String header;
  final String paragrpah;

  const BookParagraph({required this.header, required this.paragrpah});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          header,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontSize: 20),
        ),
        SizedBox(height: 5),
        Text(paragrpah, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
