import 'package:davar/src/data/models/models.dart';
import 'package:davar/src/providers/providers.dart';
import 'package:davar/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class PaginatedItemsList extends StatefulWidget {
  const PaginatedItemsList({Key? key}) : super(key: key);

  @override
  State<PaginatedItemsList> createState() => _PaginatedItemsListState();
}

class _PaginatedItemsListState extends State<PaginatedItemsList> {
  late Stream<List<Word>?>? stream;

  @override
  void initState() {
    super.initState();
    stream = Provider.of<FilteredWordsProvider>(context, listen: false).filteredWordsStream();
  }

  void loadMore() {
    setState(() {
      stream = Provider.of<FilteredWordsProvider>(context, listen: false).filteredWordsStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasData = Provider.of<FilteredWordsProvider>(context, listen: false).isMoreItems;
    return StreamBuilder<List<Word>?>(
        stream: stream,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<Word>?> snapshot) {
          if (snapshot.hasError) utils.showSnackBarInfo(context, msg: snapshot.error.toString());
          if (!snapshot.hasData) {
            return TextButton(
              child: Text("!snapshot.hasData"),
              onPressed: () => loadMore(),
            );
          }
          final List<Word> data = snapshot.data ?? [];

          if (data.isEmpty) {
            return TextButton(
              child: Text("data.isEmpty"),
              onPressed: () => loadMore(),
            );
          }
          return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                final bool isExtent =
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent;
                final bool isLastData =
                    !Provider.of<FilteredWordsProvider>(context, listen: false).isMoreItems;
                if (!isExtent || isLastData) return isExtent;
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    loadMore();
                  });
                });
                return isExtent;
              },
              child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    return (index == data.length)
                        ? Center(
                            // color: Colors.greenAccent,
                            child: TextButton(
                              child: const Text('Load More'),
                              onPressed: () => loadMore(),
                            ),
                          )
                        : ListTile(
                            title: Text('${data[index].catchword}. ${data[index].category}'),
                          );
                  }));
        });
  }
}
