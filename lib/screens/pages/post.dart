import 'package:colabs_mobile/components/attachement_viewer.dart';
import 'package:colabs_mobile/components/connections_grid_view.dart';
import 'package:colabs_mobile/controllers/content_controller.dart';
import 'package:colabs_mobile/controllers/restservice.dart';
import 'package:colabs_mobile/types/connections_view_layout_options.dart';
import 'package:colabs_mobile/utils/filter_tags.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:colabs_mobile/fonts/colabs_icons.dart';

class PostPage extends StatelessWidget {
  final PageController pageController;
  final TextEditingController postController = TextEditingController();
  PostPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ContentController contentController =
        Provider.of<ContentController>(context);
    RESTService restService = Provider.of<RESTService>(context);

    return SafeArea(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: const Text('Create Post', style: TextStyle(fontSize: 30))),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Row(children: <Widget>[
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: const CircleAvatar(radius: 25)),
          const Text('User')
        ]),
        Row(children: <Widget>[
          contentController.getIsPublic
              ? const FaIcon(FontAwesomeIcons.globe,
                  color: Colors.blue, size: 20)
              : const FaIcon(FontAwesomeIcons.eyeSlash,
                  color: Colors.grey, size: 20),
          const SizedBox(width: 20),
          contentController.getIsDonatable
              ? const Icon(ColabsIcons.donatable, color: Colors.green, size: 25)
              : const Icon(ColabsIcons.undonatable,
                  color: Colors.grey, size: 25),
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (String value) {
                    switch (value) {
                      case 'Clear':
                        contentController.clearInputs();
                        break;
                      case 'Visibility':
                        contentController.setIsPublic =
                            !contentController.getIsPublic;
                        break;
                      case 'Donatable':
                        contentController.setIsDonatable =
                            !contentController.getIsDonatable;
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                            value: 'Visibility',
                            child: ListTile(
                                title: (!contentController.getIsPublic)
                                    ? Row(children: const <Widget>[
                                        FaIcon(FontAwesomeIcons.globe,
                                            color: Colors.blue),
                                        SizedBox(width: 15),
                                        Text('Public')
                                      ])
                                    : Row(children: const <Widget>[
                                        FaIcon(FontAwesomeIcons.eyeSlash),
                                        SizedBox(width: 15),
                                        Text('Only for you')
                                      ]))),
                        PopupMenuItem<String>(
                            value: 'Donatable',
                            child: ListTile(
                                title: (!contentController.getIsDonatable)
                                    ? Row(children: const <Widget>[
                                        Icon(ColabsIcons.donatable,
                                            color: Colors.green),
                                        SizedBox(width: 15),
                                        Text('Donatable')
                                      ])
                                    : Row(children: const <Widget>[
                                        Icon(ColabsIcons.undonatable,
                                            color: Colors.grey),
                                        SizedBox(width: 15),
                                        Text('Undonatable')
                                      ]))),
                        PopupMenuItem<String>(
                            value: 'Clear',
                            child: Row(children: <Widget>[
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: const FaIcon(FontAwesomeIcons.trashCan,
                                      color:
                                          Color.fromARGB(255, 218, 102, 94))),
                              const Text('Clear')
                            ]))
                      ]))
        ])
      ]),
      Column(children: <Widget>[
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Stack(children: <Widget>[
              TextField(
                  controller: postController,
                  minLines: 5,
                  maxLines: 15,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 70),
                      hintText: "What's on your mind?",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)))),
              (contentController.getSelectedTags.isNotEmpty)
                  ? Positioned(
                      bottom: 1,
                      child: Container(
                          height: 30,
                          padding: const EdgeInsets.all(5),
                          width: screenWidth * .925,
                          decoration: const BoxDecoration(
                              color: Color(0x805521B5),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Text(contentController.getTags.join(' '))),
                    )
                  : const SizedBox()
            ])),
        Container(
            margin: const EdgeInsets.all(10),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
              SizedBox(
                  width: 50,
                  child: Stack(clipBehavior: Clip.none, children: <Widget>[
                    ...contentController.getTaggedUsers
                        .sublist(
                            0,
                            contentController.getTaggedUsers.length > 3
                                ? 3
                                : contentController.getTaggedUsers.length)
                        .map((String value) => Positioned(
                            top: 4,
                            right: 50 -
                                (contentController.getTaggedUsers
                                            .indexOf(value) +
                                        1) *
                                    10,
                            //TODO: Add user pictures
                            child: const CircleAvatar())),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            shape: const CircleBorder(),
                            backgroundColor:
                                const Color.fromARGB(255, 233, 223, 255)),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return const ConnectionsGridView(
                                    layoutOption: ConnectionsLayoutOptions.tag);
                              });
                        },
                        child: const Icon(Icons.person_add_alt_rounded,
                            color: Color(0xFF5521B5)))
                  ])),
              Stack(children: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                        backgroundColor:
                            const Color.fromARGB(255, 233, 223, 255)),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) =>
                              const AttachementViewer());
                    },
                    child: const Icon(Icons.attachment_rounded,
                        color: Color(0xFF5521B5))),
                (contentController.getAttachments.isNotEmpty)
                    ? Positioned(
                        bottom: 1,
                        right: 5,
                        child: Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF5521B5))),
                      )
                    : const SizedBox()
              ]),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        if (postController.text.isEmpty &&
                            contentController.getAttachments.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('There is nothing to post')));
                          return;
                        }

                        List<String>? filteredTags =
                            filterTags(postController.text, contentController);

                        restService.isPosting = true;
                        pageController.animateToPage(0,
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOut);

                        restService.postContentRequest(<String, dynamic>{
                          'textContent': postController.text,
                          'imageContent':
                              contentController.getAttachments.join(','),
                          'tags': (filteredTags != null)
                              ? <String>[
                                  ...filteredTags,
                                  ...contentController.getSelectedTags
                                ].join(',')
                              : '',
                          'visibility':
                              contentController.getIsPublic.toString(),
                          'taggedUsers':
                              contentController.getTaggedUsers.join(',')
                        }).timeout(const Duration(seconds: 15), onTimeout: () {
                          //TODO: warn user of request failure
                          //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
                          return Future<bool>.value(false);
                        }).whenComplete(() {
                          restService.isPosting = false;
                          contentController.clearInputs();
                        });
                      },
                      child: const Text('Post')))
            ])),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 244, 239, 255)),
            width: screenWidth * .95,
            height: screenHeight * .35,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(15),
                      child: const Text('Related Topics',
                          style: TextStyle(fontSize: 20))),
                  Expanded(
                      child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: contentController.getTags.length,
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisExtent: 40,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 10,
                                  maxCrossAxisExtent: 150),
                          itemBuilder: (BuildContext context, int index) {
                            List<String> tags = contentController.getTags;

                            return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: (contentController
                                            .getSelectedTags
                                            .contains(tags[index]))
                                        ? const Color(0xFF5521B5)
                                        : null,
                                    side: const BorderSide(
                                        color: Color(0xFF5521B5))),
                                child: Text(tags[index],
                                    style: TextStyle(
                                        color: (contentController
                                                .getSelectedTags
                                                .contains(tags[index]))
                                            ? Colors.white
                                            : const Color(0xFF5521B5))),
                                onPressed: () {
                                  (!contentController.getSelectedTags
                                          .contains(tags[index]))
                                      ? contentController.selectTag(tags[index])
                                      : contentController
                                          .unselectTag(tags[index]);
                                  contentController.refresh();
                                });
                          }))
                ])),
        const SizedBox(height: 110)
      ])
    ])));
  }
}
