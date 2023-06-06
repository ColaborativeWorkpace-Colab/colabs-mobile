import 'package:flutter_treeview/flutter_treeview.dart';

// ignore: avoid_annotating_with_dynamic
List<Node<dynamic>> expandNode(List<dynamic> rawNodes) {
  return rawNodes
      // ignore: always_specify_types
      .map<Node<dynamic>>((element) => Node<dynamic>(
        // ignore: avoid_dynamic_calls
        parent: (element['type'] == 'tree') ? true : false,
          // ignore: avoid_dynamic_calls
          key: element['sha'],
          // ignore: avoid_dynamic_calls
          label: element['path'],
          // ignore: always_specify_types, avoid_dynamic_calls
          children: (element['type'] == 'tree')
              // ignore: avoid_dynamic_calls
              ? element['children'] != null
                  // ignore: avoid_dynamic_calls
                  ? expandNode(element['children'])
                  : <Node<dynamic>>[
                      const Node<dynamic>(key: 'fetch', label: 'Fetching')
                    ]
              : <Node<dynamic>>[]))
      .toList()
      .reversed
      .toList();
}
