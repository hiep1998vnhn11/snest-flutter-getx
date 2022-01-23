import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:snest/components/reaction/data/example_data.dart' as example;

class NotificationTab extends StatefulWidget {
  const NotificationTab({Key? key}) : super(key: key);
  @override
  _NotificationTabState createState() => _NotificationTabState();
}

class _NotificationTabState extends State<NotificationTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  void _showBottomSheetComments() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Text('123');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông báo',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 40,
        centerTitle: false,
        leading: SizedBox(),
        leadingWidth: 0,
        actions: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.all_inbox),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Tất cả'),
                ],
              ),
              // icon: const Icon(Icons.directions_car),
              // text: 'Tất cả',
            ),
            Tab(
              icon: const Icon(Icons.directions_transit),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Card(
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
                              onReactionChanged:
                                  (String? value, bool isChecked) {
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
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    height: 1,
                    color: Colors.grey[200],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.red,
            height: 300,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
