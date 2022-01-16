import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:snest/components/reaction/data/example_data.dart' as example;

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({Key? key}) : super(key: key);
  @override
  _DiscoverTabState createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  void _showBottomSheetComments() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Text('123');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: Image.asset(
                'assets/images/card_master.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              height: 1,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ReactionButtonToggle<String>(
                        onReactionChanged: (String? value, bool isChecked) {
                          print(
                            'Selected value: $value, isChecked: $isChecked',
                          );
                        },
                        reactions: example.reactions,
                        initialReaction: example.defaultInitialReaction,
                        selectedReaction: example.reactions[1],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _showBottomSheetComments(),
                    child: Row(
                      children: [
                        Icon(
                          Icons.message,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Comment',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(
                            'Share image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.share,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Share',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              height: 1,
              color: Colors.grey[200],
            ),
          ],
        ),
      ),
    );
  }
}
