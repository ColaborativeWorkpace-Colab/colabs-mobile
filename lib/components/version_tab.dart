import 'package:colabs_mobile/components/project_version_list_view.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/utils/expand_nodes.dart';
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
    TreeViewController treeViewController = TreeViewController(
        children: (files != null) ? expandNode(files!) : <Node<dynamic>>[]);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (layoutController.getSelectedVersionIndex == null && files != null) {
      layoutController.setSelectedVersionIndex(files!.length, listen: false);
    }

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
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 20),
                              child: const Text('File Manager',
                                  style: TextStyle(fontSize: 20)),
                            ),
                            (restService.isFetching)
                                ? const SizedBox(
                                    height: 50,
                                    width: 30,
                                    child: CircularProgressIndicator())
                                : const SizedBox()
                          ],
                        )),
                    TreeView(
                        shrinkWrap: true,
                        onExpansionChanged: (String sha, bool isExpanded) {
                          if (isExpanded) restService.getTrees(projectId, sha);
                        },
                        controller: treeViewController)
                  ]))),
      ProjectVersionListView(
          projectId: projectId,
          files: restService.commits.reversed.toList(),
          layoutController: layoutController,
          treeViewController: treeViewController)
    ]);
  }
}
