import 'package:flutter/material.dart';

class LyricsScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;

  const LyricsScreen({
    super.key,
    this.songTitle = 'Johar Re',
    this.artistName = 'SERENG Artist',
  });

  @override
  State<LyricsScreen> createState() => _LyricsScreenState();
}

class _LyricsScreenState extends State<LyricsScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<String> lyrics = [
    'Johar Re, Johar Re',
    'Ayo re, ayo re',
    '',
    'Apna dharti, apna gaon',
    'Apna geet aur apna gaan',
    '',
    'Sarna re, Sarna re',
    'Khushiyon ka ye tyohar re',
    '',
    'Dhol baje, mandar baje',
    'Sab milkar aaj nachenge',
    '',
    'Johar Re, Johar Re',
    'Adivasi dil se Johar Re',
    '',
    'Hamari mitti, hamari pehchan',
    'Hamari bhasha, hamara maan',
    '',
    'Johar Re...',
  ];

  int currentLine = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _nextLine() {
    if (currentLine < lyrics.length - 1) {
      setState(() {
        currentLine++;
      });

      _scrollToCurrentLine();
    }
  }

  void _previousLine() {
    if (currentLine > 0) {
      setState(() {
        currentLine--;
      });

      _scrollToCurrentLine();
    }
  }

  void _scrollToCurrentLine() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        currentLine * 45.0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0B0F),
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 30,
          ),
        ),

        title: const Text(
          'Lyrics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_rounded,
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF292231),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: 28,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.songTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          widget.artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  24,
                  20,
                  24,
                  30,
                ),
                itemCount: lyrics.length,
                itemBuilder: (context, index) {
                  final isCurrent = index == currentLine;
                  final isEmpty = lyrics[index].isEmpty;

                  if (isEmpty) {
                    return const SizedBox(height: 18);
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentLine = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        style: TextStyle(
                          fontSize: isCurrent ? 25 : 21,
                          height: 1.35,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isCurrent
                              ? Colors.white
                              : Colors.white38,
                        ),
                        child: Text(
                          lyrics[index],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                18,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF111116),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${currentLine + 1}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),

                      Expanded(
                        child: Slider(
                          value: lyrics.isEmpty
                              ? 0
                              : (currentLine + 1) /
                                  lyrics.length,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            final line =
                                (value * lyrics.length)
                                    .floor()
                                    .clamp(
                                      0,
                                      lyrics.length - 1,
                                    );

                            setState(() {
                              currentLine = line;
                            });
                          },
                        ),
                      ),

                      Text(
                        '${lyrics.length}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _previousLine,
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          size: 34,
                        ),
                      ),

                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _nextLine,
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: _nextLine,
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
