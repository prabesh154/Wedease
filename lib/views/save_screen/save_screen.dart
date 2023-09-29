/*
// shows the saved vendors services in grid view 


import 'package:wedease/consts/consts.dart';
import 'package:wedease/widgets_common/loading_indicator.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: "Saved".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestorServices.getSaved(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Nothing is Saved".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 10, // Spacing between columns
                mainAxisSpacing: 10, // Spacing between rows
                children: List.generate(data.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Image.network(
                              "${data[index]['v_imgs']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data[index]['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                              "Rs ${data[index]['price']}"
                                  .text
                                  .fontFamily(semibold)
                                  .size(12)
                                  .color(borderColor)
                                  .make(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }
        },
      ),
    );
  }
}

*/

/*
// shows vendors services in vertical form 

import 'package:wedease/consts/consts.dart';
import 'package:wedease/widgets_common/loading_indicator.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: "Saved".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestorServices.getSaved(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Nothing is Saved".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Container(
                            width: 80,
                            height: 80,
                            margin:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: Image.network(
                              "${data[index]['v_imgs']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data[index]['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                              "Rs ${data[index]['price']}"
                                  .text
                                  .fontFamily(semibold)
                                  .size(12)
                                  .color(borderColor)
                                  .make(),
                            ],
                          ),
                          trailing: const Icon(Icons.delete, color: redColor)
                              .onTap(() {
                            FirestorServices.deleteDocument(data[index].id);
                          }),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
*/
import 'package:wedease/consts/consts.dart';
import 'package:wedease/widgets_common/loading_indicator.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: "Saved".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestorServices.getSaved(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Nothing is Saved".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 15, // Spacing between columns
                mainAxisSpacing: 20, // Spacing between rows
                children: List.generate(data.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Align children at the center vertically
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Image.network(
                              "${data[index]['v_imgs']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "${data[index]['v_name']}"
                                        .text
                                        .fontFamily(semibold)
                                        .size(16)
                                        .make(),
                                    "Rs ${data[index]['v_price']}"
                                        .text
                                        .fontFamily(semibold)
                                        .size(12)
                                        .color(borderColor)
                                        .make(),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: redColor),
                                onPressed: () {
                                  FirestorServices.deleteDocument(
                                      data[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }
        },
      ),
    );
  }
}
