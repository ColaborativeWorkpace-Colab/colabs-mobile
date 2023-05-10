import 'package:colabs_mobile/controllers/layout_controller.dart';
import 'package:colabs_mobile/utils/filter_tags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostPage extends StatelessWidget {
  PostPage({super.key});
  final TextEditingController postController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    LayoutController layoutController = Provider.of<LayoutController>(context);

    return SafeArea(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: const Text('Create Post', style: TextStyle(fontSize: 30))),
      Row(children: <Widget>[
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: const CircleAvatar(radius: 25)),
        const Text('User')
      ]),
      Form(
          key: formKey,
          child: Column(children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                    onSaved: (String? value) async {
                      //TODO: Return here
                      filterTags(value!, layoutController);
                    },
                    minLines: 5,
                    maxLines: 15,
                    decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))))),
            Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 233, 223, 255)),
                          onPressed: () {},
                          child: const Icon(Icons.person_add_alt_rounded,
                              color: Color(0xFF5521B5))),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              shape: const CircleBorder(),
                              backgroundColor:
                                  const Color.fromARGB(255, 233, 223, 255)),
                          onPressed: () {},
                          child: const Icon(Icons.attachment_rounded,
                              color: Color(0xFF5521B5))),
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
            //TODO: Add topics/tags
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
                            itemCount: layoutController.getTags.length,
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisExtent: 40,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 10,
                                    maxCrossAxisExtent: 150),
                            itemBuilder: (BuildContext context, int index) {
                              List<String> tags = layoutController.getTags;

                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        (false) ? Color(0xFF5521B5) : null,
                                    side: const BorderSide(
                                        color: Color(0xFF5521B5))),
                                child: Text(tags[index]),
                                onPressed: () {},
                              );
                            }),
                      )
                    ])),
            const SizedBox(height: 110)
          ]))
    ])));
  }
}
