import 'package:colabs_mobile/components/project_version_list_view.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:provider/provider.dart';

class VersionTab extends StatelessWidget {
  final String projectId;
  final List<dynamic>? files;
  const VersionTab({super.key, required this.projectId, required this.files});

  @override
  Widget build(BuildContext context) {
    LayoutController layoutController = Provider.of<LayoutController>(context);
    RESTService restService = Provider.of<RESTService>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (layoutController.getSelectedVersionIndex == null && files != null) {
      layoutController.setSelectedVersionIndex(files!.length - 1,
          listen: false);
    }
    //TODO: Use loading incdication when fetching data
    //TODO: make files null safe
    //TODO: Implement algorithm to load all directories in a project
    return Stack(children: <Widget>[
      Positioned(
          top: screenHeight * .068,
          child: Container(
              height: screenHeight * .73,
              width: screenWidth,
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: const Color(0xff5521B5))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 50,
                        width: screenWidth,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.grey[300]),
                        child: const Text('File Manager',
                            style: TextStyle(fontSize: 20))),
                    TreeView(
                        shrinkWrap: true,
                        onExpansionChanged: (String sha, bool isExpanded) {
                          if (isExpanded) restService.getTrees(projectId, sha);
                        },
                        controller: TreeViewController(
                            children: files!
                                // ignore: always_specify_types
                                .map((element) {
                                  return Node<dynamic>(
                                      // ignore: avoid_dynamic_calls
                                      key: element['sha'],
                                      // ignore: avoid_dynamic_calls
                                      label: element['path'],
                                      // ignore: always_specify_types, avoid_dynamic_calls
                                      children: (element['type'] == 'tree')
                                          // ignore: avoid_dynamic_calls
                                          ? element['children'] != null
                                              // ignore: avoid_dynamic_calls
                                              ? (element['children']
                                                      as List<dynamic>)
                                                  // ignore: always_specify_types
                                                  .map((file) => Node<dynamic>(
                                                      // ignore: avoid_dynamic_calls
                                                      key: file['sha'],
                                                      // ignore: avoid_dynamic_calls
                                                      label: file['path'],
                                                      // ignore: avoid_dynamic_calls
                                                      children: (file['type'] ==
                                                              'tree')
                                                          ? <Node<dynamic>>[
                                                              const Node<
                                                                      dynamic>(
                                                                  key: 'sample',
                                                                  label:
                                                                      'Fetching')
                                                            ]
                                                          : <Node<dynamic>>[]))
                                                  .toList()
                                              : <Node<dynamic>>[
                                                  const Node<dynamic>(
                                                      key: 'sample',
                                                      label: 'Fetching')
                                                ]
                                          : <Node<dynamic>>[]);
                                })
                                .toList()
                                .reversed
                                .toList()))
                  ]))),
      ProjectVersionListView(projectId: projectId, files: restService.commits.reversed.toList(), layoutController: layoutController)
    ]);
  }
}
