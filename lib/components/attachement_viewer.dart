import 'dart:io';
import 'package:colabs_mobile/controllers/content_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttachementViewer extends StatelessWidget {
  const AttachementViewer({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    ContentController contentController =
        Provider.of<ContentController>(context);

    return Container(
        color: Colors.grey[100],
        margin: const EdgeInsets.all(10),
        height: screenHeight * .4,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Attachements', style: TextStyle(fontSize: 20)),
                ElevatedButton(
                    child: const Text('Add Files'),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(allowMultiple: true);

                      if (result != null) {
                        List<File> files = result.paths
                            .map((String? path) => File(path!))
                            .toList();

                        contentController.addAttachements(files);
                      }
                    })
              ]),
          (contentController.getAttachments.isNotEmpty)
              ? Expanded(
                  child: ListView.builder(
                      itemCount: contentController.getAttachments.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 233, 223, 255),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.file_present)),
                              title: Text(
                                  contentController.getAttachments[index].path),
                              trailing: IconButton(
                                  onPressed: () {
                                    contentController.removeAttachement(
                                        contentController
                                            .getAttachments[index]);
                                  },
                                  icon: const Icon(Icons.close)),
                            ));
                      }))
              : Center(
                  child: Column(children: <Widget>[
                    const SizedBox(height: 50),
                    Icon(Icons.attachment, size: 100, color: Colors.grey[400]),
                    const Text('Go ahead and attach files')
                  ]),
                )
        ]));
  }
}
