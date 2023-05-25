import 'package:colabs_mobile/components/project_version_list_view.dart';
import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:provider/provider.dart';

class VersionTab extends StatelessWidget {
  final List<String> files;
  const VersionTab({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    LayoutController layoutController = Provider.of<LayoutController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if(layoutController.getSelectedVersionIndex == null) {
      layoutController.setSelectedVersionIndex(files.length - 1, listen: false);
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
                      child: const Text('File Manager',
                          style: TextStyle(fontSize: 20))),
                  TreeView(
                      shrinkWrap: true,
                      controller:
                          TreeViewController(children: const <Node<dynamic>>[
                        Node<dynamic>(
                            key: 'FolderKey',
                            label: 'Folder',
                            children: <Node<dynamic>>[
                              Node<dynamic>(key: 'file1Key', label: 'file1'),
                              Node<dynamic>(key: 'file2Key', label: 'file2')
                            ]),
                        Node<dynamic>(key: 'file3Key', label: 'file3')
                      ])),
                ],
              ))),
      ProjectVersionListView(files: files, layoutController: layoutController)
    ]);
  }
}
