import 'package:colabs_mobile/components/attachement_viewer.dart';
import 'package:colabs_mobile/components/connections_grid_view.dart';
import 'package:colabs_mobile/controllers/content_controller.dart';
import 'package:colabs_mobile/utils/filter_tags.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PostPage extends StatelessWidget {
  PostPage({super.key});
  final TextEditingController postController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    ContentController contentController =
        Provider.of<ContentController>(context);

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
        Container(
            margin: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String value) {
                  switch (value) {
                    case 'Clear':
                      contentController.clearInputs();
                      break;
                    default:
                      contentController.setIsPublic =
                          !contentController.getIsPublic;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                          value: contentController.getIsPublic.toString(),
                          child: ListTile(
                              title: (contentController.getIsPublic)
                                  ? Row(
                                      children: const <Widget>[
                                        FaIcon(FontAwesomeIcons.globe,
                                            color: Colors.blue),
                                        SizedBox(width: 15),
                                        Text('Public'),
                                      ],
                                    )
                                  : Row(
                                      children: const <Widget>[
                                        FaIcon(FontAwesomeIcons.eyeSlash),
                                        SizedBox(width: 15),
                                        Text('Only for you'),
                                      ],
                                    ),
                              trailing: Switch(
                                  value: contentController.getIsPublic,
                                  onChanged: (bool value) {
                                    contentController.setIsPublic = value;
                                  }))),
                      PopupMenuItem<String>(
                          value: 'Clear',
                          child: Row(children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: const FaIcon(FontAwesomeIcons.trashCan,
                                  color: Color.fromARGB(255, 218, 102, 94))
                            ),
                            const Text(
                              'Clear')
                          ]))
                    ]))
      ]),
      Form(
          key: formKey,
          child: Column(children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    onSaved: (String? value) async {
                      filterTags(value!, contentController);
                    },
                    minLines: 5,
                    maxLines: 15,
                    decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))))),
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
                                    return const ConnectionsGridView();
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
                            bool isValid = formKey.currentState!.validate();

                            if (!isValid) return;
                            formKey.currentState!.save();
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
                          child: const Text('Related Tags',
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
                                      backgroundColor:
                                          //TODO: Implement switch when tag is used
                                          (false)
                                              ? const Color(0xFF5521B5)
                                              : null,
                                      side: const BorderSide(
                                          color: Color(0xFF5521B5))),
                                  child: Text(tags[index]),
                                  onPressed: () {},
                                );
                              }))
                    ])),
            const SizedBox(height: 110)
          ]))
    ])));
  }
}
