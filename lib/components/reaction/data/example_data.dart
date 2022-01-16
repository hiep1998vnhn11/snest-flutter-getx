import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

final defaultInitialReaction = Reaction<String>(
  value: '0',
  icon: _buildReactionsIcon(
    'assets/reactions/no-react.png',
    const Text(
      'Thích',
    ),
  ),
);

final reactions = [
  Reaction<String>(
    value: '1',
    title: _buildTitle('Thích'),
    previewIcon: _buildReactionsPreviewIcon('assets/reactions/like.png'),
    icon: _buildReactionsIcon(
      'assets/reactions/like.png',
      const Text(
        'Thích',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '2',
    title: _buildTitle('Yêu thích'),
    previewIcon: _buildReactionsPreviewIcon('assets/reactions/love.png'),
    icon: _buildReactionsIcon(
      'assets/reactions/love.png',
      const Text(
        'Yêu thích',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '3',
    title: _buildTitle('Thương thương'),
    previewIcon: _buildReactionsPreviewIcon('assets/reactions/care.png'),
    icon: _buildReactionsIcon(
      'assets/reactions/care.png',
      const Text(
        'Thương thương',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '4',
    title: _buildTitle('Haha'),
    previewIcon: _buildReactionsPreviewIcon('assets/reactions/haha.png'),
    icon: _buildReactionsIcon(
      'assets/reactions/haha.png',
      const Text(
        'Haha',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: '5',
    title: _buildTitle('Wow'),
    previewIcon: _buildReactionsPreviewIcon('assets/reactions/wow.png'),
    icon: _buildReactionsIcon(
      'assets/reactions/wow.png',
      const Text(
        'Wow',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  // Reaction<String>(
  //   value: '6',
  //   title: _buildTitle('Buồn'),
  //   previewIcon: _buildReactionsPreviewIcon('assets/reactions/sad.png'),
  //   icon: _buildReactionsIcon(
  //     'assets/reactions/sad.png',
  //     const Text(
  //       'Buồn',
  //       style: TextStyle(
  //         color: Color(0XFFf05766),
  //       ),
  //     ),
  //   ),
  // ),
  // Reaction<String>(
  //   value: '7',
  //   title: _buildTitle('Giận dữ'),
  //   previewIcon: _buildReactionsPreviewIcon('assets/reactions/angry.png'),
  //   icon: _buildReactionsIcon(
  //     'assets/reactions/angry.png',
  //     const Text(
  //       'Giận dữ',
  //       style: TextStyle(
  //         color: Color(0XFFf05766),
  //       ),
  //     ),
  //   ),
  // ),
];

Container _buildTitle(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.8),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
    child: Image.asset(path, height: 40),
  );
}

Container _buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(
          path,
          height: 20,
          width: 20,
        ),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}

class PostBuilder {
  static Widget buildLikeItem(Map<String, dynamic> like) {
    if (like['status'] == 1) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/reactions/like.png'),
        radius: 9,
      );
    }
    if (like['status'] == 2) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/reactions/love.png'),
        radius: 9,
      );
    }
    if (like['status'] == 3) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/reactions/care.png'),
        radius: 9,
      );
    }
    if (like['status'] == 4) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/reactions/haha.png'),
        radius: 9,
      );
    }
    if (like['status'] == 5) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/reactions/wow.png'),
        radius: 9,
      );
    }
    if (like['status'] == 6) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/reactions/sad.png'),
        radius: 9,
      );
    }
    if (like['status'] == 7) {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/reactions/angry.png'),
        radius: 9,
      );
    }
    return const CircleAvatar(
      backgroundImage: AssetImage('assets/reactions/like.png'),
      radius: 9,
    );
  }
}
