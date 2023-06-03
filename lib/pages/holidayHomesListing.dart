import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mickeyadmin/models/coverPhoto.dart';
import 'package:mickeyadmin/pages/postDetails.dart';
import 'package:mickeyadmin/pages/uploadHolidayHome.dart';
import 'package:mickeyadmin/widgets/ProgressWidget.dart';
import 'package:mickeyadmin/widgets/customAppBar.dart';
import 'package:mickeyadmin/widgets/customButton.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/post.dart';
import '../widgets/footer.dart';

class HolidayHomesListing extends StatefulWidget {
  const HolidayHomesListing({Key? key}) : super(key: key);

  @override
  State<HolidayHomesListing> createState() => _HolidayHomesListingState();
}

class _HolidayHomesListingState extends State<HolidayHomesListing> {
  final ScrollController _controller = ScrollController();
  bool deleting = false;
  int limit = 15;

  void deletePost(Post post) async {
    setState(() {
      deleting = true;
    });

    List<dynamic> imageUrls = [];
    String id = "";

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.postId!)
        .collection("other images")
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs[0].exists) {
        setState(() {
          imageUrls = querySnapshot.docs[0]["urls"];
          id = querySnapshot.docs[0].id;
        });
      }
    });

    if (id.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(post.postId)
          .collection("other images")
          .doc(id)
          .delete();
    }

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(post.postId)
        .delete();

    if (imageUrls.isNotEmpty) {
      imageUrls.forEach((url) {
        FirebaseStorage.instance.refFromURL(url).delete();
      });
    }

    Fluttertoast.showToast(msg: "Deleted Successfully");

    setState(() {
      deleting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(size.width, 50.0),
          child: const CustomAppBar(
            isShrink: true,
          )),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          bool isMobile = sizingInformation.isMobile;

          return RawScrollbar(
            controller: _controller,
            isAlwaysShown: true,
            radius: const Radius.circular(6.0),
            thumbColor: Colors.pink,
            thickness: 12.0,
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1000.0,
                      minWidth: 450.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Holiday Homes",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Admin ",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.grey,
                                  size: 12.0,
                                ),
                                Text(
                                  " Holiday Homes",
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                CustomButton(
                                  title: "Upload",
                                  color: Colors.pink,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UploadHolidayHome()));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("posts")
                              .where("ownerId",
                                  isEqualTo: "DUxn3LLKj4e0QF9aijMOwpf9Qlr1")
                              .orderBy("timestamp", descending: true)
                              .limit(limit)
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return circularProgress();
                            } else {
                              List<Post> posts = [];

                              snapshot.data!.docs.forEach((element) {
                                Post post = Post.fromDocument(element);

                                posts.add(post);
                              });

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: posts.length,
                                    itemBuilder: (context, index) {
                                      Post post = posts[index];

                                      return ListingItem(
                                        post: post,
                                        onPressDelete: () {
                                          if (!deleting) {
                                            deletePost(post);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  CustomButton(
                                    title: "Load More",
                                    color: Colors.pink,
                                    onTap: () {
                                      setState(() {
                                        limit = limit + 10;
                                      });
                                    },
                                  )
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const Footer()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListingItem extends StatefulWidget {
  final Post? post;
  final Function()? onPressDelete;
  const ListingItem({Key? key, this.post, this.onPressDelete})
      : super(key: key);

  @override
  State<ListingItem> createState() => _ListingItemState();
}

class _ListingItemState extends State<ListingItem> {
  bool onHover = false;
  bool addingToCover = false;

  void addToCover() async {
    setState(() {
      addingToCover = true;
    });

    int timestamp = DateTime.now().millisecondsSinceEpoch;

    CoverPhoto coverPhoto = CoverPhoto(
      id: timestamp.toString(),
      imageUrl: widget.post!.imageUrl!,
      name: widget.post!.name!,
      city: widget.post!.city!,
      country: widget.post!.country!,
      description: widget.post!.description!,
      cost: widget.post!.price!,
      currency: widget.post!.currency!,
      timestamp: timestamp,
    );

    await FirebaseFirestore.instance
        .collection("coverPhotos")
        .doc(coverPhoto.id)
        .set(coverPhoto.toMap())
        .then((value) {
      Fluttertoast.showToast(msg: "Added to Cover Photos Successfully");
    });

    setState(() {
      addingToCover = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile = sizingInformation.isMobile;

        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetails(
                          post: widget.post!,
                        )));
          },
          hoverColor: Colors.transparent,
          onHover: (v) {
            setState(() {
              onHover = v;
            });
          },
          child: Card(
            color: Colors.white,
            shadowColor: Colors.black,
            elevation: onHover ? 10.0 : 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: isMobile ? 150.0 : 300.0,
              //padding: const EdgeInsets.all(10.0),
              width: size.width,
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.horizontal(left: Radius.circular(10.0))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(10.0)),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/blank_image.png",
                      image: widget.post!.imageUrl!,
                      height: size.height,
                      width: isMobile ? 150.0 : 300.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post!.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.post!.city! +
                                    ", " +
                                    widget.post!.country!,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          Text(
                            widget.post!.description!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 1.0,
                                width: size.width,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomButton(
                                        title: addingToCover
                                            ? "Adding..."
                                            : "Add to Cover Photos",
                                        color: Colors.pink,
                                        onTap: () {
                                          if (!addingToCover) {
                                            addToCover();
                                          }
                                        },
                                      ),
                                      CustomButton(
                                        title: "Delete",
                                        color: Colors.red,
                                        onTap: widget.onPressDelete,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
