import 'package:colabs_mobile/components/project_version_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';

class VersionTab extends StatelessWidget {
  final List<String> files;
  const VersionTab({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: <Widget>[
      Positioned(
        top: screenHeight * .068,
        child: Container(
          height: screenHeight * .73  ,
          width: screenWidth,
          decoration: BoxDecoration(color: const Color(0xff5521B5)),
          child: TreeView(
            shrinkWrap: true,
            controller: TreeViewController(children: const <Node<dynamic>>[
              Node<dynamic>(
                  key: 'FolderKey',
                  label: 'Folder',
                  children: <Node<dynamic>>[
                    Node<dynamic>(key: 'file1Key', label: 'file1'),
                    Node<dynamic>(key: 'file2Key', label: 'file2')
                  ]),
              Node<dynamic>(key: 'file3Key', label: 'file3'),
            ]),
          ),
        ),
      ),
      ProjectVersionListView(files: files),
    ]);
  }
}
