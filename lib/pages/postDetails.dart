import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../models/post.dart';
import '../models/postType.dart';
import '../widgets/ProgressWidget.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customButton.dart';
import '../widgets/customTextField.dart';
import '../widgets/footer.dart';

class PostDetails extends StatefulWidget {
  final Post? post;
  const PostDetails({Key? key, this.post}) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final ScrollController _controller = ScrollController();
  TextEditingController name = TextEditingController();
  TextEditingController tag = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController currency = TextEditingController();
  TextEditingController cost = TextEditingController();
  bool updating = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      name.text = widget.post!.name!;
      tag.text = widget.post!.type!;
      city.text = widget.post!.city!;
      country.text = widget.post!.country!;
      description.text = widget.post!.description!;
      currency.text = widget.post!.currency!;
      cost.text = widget.post!.price!;
    });
  }

  void proceedToUpdate() async {
    setState(() {
      updating = true;
    });

    Post post = Post(
      postId: widget.post!.postId,
      imageUrl: widget.post!.imageUrl,
      description: description.text,
      name: name.text.trim(),
      city: city.text.trim(),
      country: country.text.trim(),
      locality: widget.post!.locality,
      payPeriod: widget.post!.payPeriod,
      price: cost.text.trim(),
      currency: currency.text,
      type: tag.text,
      address: widget.post!.address,
      latitude: widget.post!.latitude,
      longitude: widget.post!.longitude,
      username: widget.post!.username,
      phone: widget.post!.phone,
      ownerUrl: widget.post!.ownerUrl,
      userId: widget.post!.userId,
      email: widget.post!.email,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.post!.postId)
        .update(post.toMap())
        .then((value) => Fluttertoast.showToast(
            msg: "Updated. Changes will take a few minutes to propagate",
            webShowClose: true));

    setState(() {
      updating = false;
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
      body: RawScrollbar(
        controller: _controller,
        isAlwaysShown: true,
        radius: const Radius.circular(6.0),
        thumbColor: Colors.pink,
        thickness: 12.0,
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ResponsiveWrapper(
                  maxWidth: 800,
                  minWidth: 400,
                  defaultScale: true,
                  breakpoints: const [
                    ResponsiveBreakpoint.resize(480, name: MOBILE),
                    ResponsiveBreakpoint.autoScale(800, name: TABLET),
                    ResponsiveBreakpoint.resize(1000, name: DESKTOP),
                    ResponsiveBreakpoint.autoScale(2460, name: '4K'),
                  ],
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Edit Holiday Home",
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Admin ",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 12.0,
                                  ),
                                  Text(
                                    " Holiday Homes ",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 12.0,
                                  ),
                                  Text(
                                    " Edit Holiday Home",
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          PostImages(
                            post: widget.post,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          CustomTextField(
                            title: "Name *",
                            controller: name,
                            hintText: "Name",
                            inputType: TextInputType.name,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItems: true,
                              items: PostType.types,
                              dropdownSearchDecoration: const InputDecoration(
                                labelText: "Tag *",
                                hintText: "Tag",
                              ),
                              onChanged: (v) {
                                setState(() {
                                  tag.text = v!;
                                });
                              },
                              selectedItem: tag.text,
                            ),
                          ),
                          CustomTextField(
                            title: "City *",
                            controller: city,
                            hintText: "City",
                            inputType: TextInputType.text,
                          ),
                          CustomTextField(
                            title: "Country *",
                            controller: country,
                            hintText: "Country",
                            inputType: TextInputType.text,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownSearch<String>(
                              mode: Mode.MENU,
                              showSelectedItems: true,
                              items: const ["KES", "USD"],
                              dropdownSearchDecoration: const InputDecoration(
                                labelText: "Currency *",
                                hintText: "Currency",
                              ),
                              onChanged: (v) {
                                setState(() {
                                  currency.text = v!;
                                });
                              },
                              selectedItem: currency.text,
                            ),
                          ),
                          CustomTextField(
                            title: "Cost per Night *",
                            controller: cost,
                            hintText: "Cost",
                            inputType: TextInputType.number,
                          ),
                          CustomTextField(
                            title: "Description *",
                            controller: description,
                            hintText: "Type Something here...",
                            inputType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                title:
                                    updating ? "Updating..." : "Save Changes",
                                color: Colors.pink,
                                onTap: () {
                                  if (!updating) {
                                    proceedToUpdate();
                                  }
                                },
                              ),
                              const SizedBox()
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class PostImages extends StatefulWidget {
  final Post? post;
  const PostImages({
    Key? key,
    this.post,
  }) : super(key: key);

  @override
  State<PostImages> createState() => _PostImagesState();
}

class _PostImagesState extends State<PostImages> {
  bool uploading = false;

  Future<List<String>> uploadImages(List<PlatformFile> images) async {
    List<String> downloadUrls = [];
    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

    for (PlatformFile image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Upload file and metadata to the path 'images/mountains.jpg'
      UploadTask uploadTask = storageRef
          .child(
              "Post Pictures/${widget.post!.postId}/photo_$fileName.${image.extension}")
          .putData(image.bytes!);

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  void pickImages(String id, List<dynamic> imageUrls) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);

    if (result != null) {
      try {
        setState(() {
          uploading = true;
        });

        List<String> downloadUrls = await uploadImages(result.files);

        downloadUrls.forEach((url) {
          imageUrls.add(url);
        });

        await FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.post!.postId!)
            .collection("other images")
            .doc(id)
            .update({"urls": imageUrls}).then((value) =>
                Fluttertoast.showToast(msg: "Images Uploaded Successfully"));

        setState(() {
          uploading = false;
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  deleteImage(String docId, String url, List<dynamic> imageUrls) async {
    imageUrls.remove(url);

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.post!.postId!)
        .collection("other images")
        .doc(docId)
        .update({"urls": imageUrls});

    await FirebaseStorage.instance
        .refFromURL(url)
        .delete()
        .then((value) => Fluttertoast.showToast(msg: "Image Deleted"));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.post!.postId!)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          } else {
            Post post = Post.fromDocument(snapshot.data!);

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cover Photo",
                  style: Theme.of(context).textTheme.titleLarge!.apply(
                        color: Colors.pink,
                      ),
                ),
                Image.network(
                  post.imageUrl!,
                  width: size.width,
                  height: size.height * 0.5,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Other Photos",
                  style: Theme.of(context).textTheme.titleLarge!.apply(
                        color: Colors.pink,
                      ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .doc(widget.post!.postId!)
                      .collection("other images")
                      .limit(1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return linearProgress();
                    } else {
                      List<dynamic> imageUrls = [];

                      if (snapshot.data!.docs.isNotEmpty) {
                        imageUrls = snapshot.data!.docs[0]["urls"];
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(imageUrls.length, (index) {
                              bool isCover = imageUrls[index] == post.imageUrl;
                              return PostImageLayout(
                                post: widget.post,
                                url: imageUrls[index],
                                isCover: isCover,
                                onPressDelete: () {
                                  deleteImage(snapshot.data!.docs[0].id,
                                      imageUrls[index], imageUrls);
                                },
                              );
                            }),
                          ),
                          Container(
                            height: 100.0,
                            width: size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.pink.shade100,
                                  width: 1.0,
                                )),
                            child: Center(
                              child: uploading
                                  ? const Text(
                                      "Uploading...",
                                      style: TextStyle(color: Colors.pink),
                                    )
                                  : TextButton.icon(
                                      onPressed: () => pickImages(
                                          snapshot.data!.docs[0].id, imageUrls),
                                      icon: const Icon(
                                          Icons.cloud_upload_outlined,
                                          color: Colors.pink),
                                      label: const Text("Add Images"),
                                    ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            );
          }
        });
  }
}

class PostImageLayout extends StatefulWidget {
  final Post? post;
  final String? url;
  final bool? isCover;
  final Function()? onPressDelete;
  const PostImageLayout(
      {Key? key, this.post, this.url, this.isCover, this.onPressDelete})
      : super(key: key);

  @override
  State<PostImageLayout> createState() => _PostImageLayoutState();
}

class _PostImageLayoutState extends State<PostImageLayout> {
  bool isSetting = false;

  void setAsCover() async {
    setState(() {
      isSetting = true;
    });

    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.post!.postId)
        .update({
      "url": widget.url,
    });

    setState(() {
      isSetting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Image.network(
            widget.url!,
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 5.0,
            right: 5.0,
            child: widget.isCover!
                ? const Text(
                    "Cover Photo",
                    style: TextStyle(
                        color: Colors.pink, fontWeight: FontWeight.bold),
                  )
                : CustomButton(
                    title: isSetting ? "Setting..." : "Set As Cover",
                    color: Colors.pink,
                    onTap: () {
                      if (!isSetting) {
                        setAsCover();
                      }
                    },
                  ),
          ),
          widget.isCover!
              ? Container()
              : Positioned(
                  bottom: 5.0,
                  right: 5.0,
                  child: CustomButton(
                    title: "Delete",
                    color: Colors.red,
                    onTap: widget.onPressDelete,
                  ),
                ),
        ],
      ),
    );
  }
}
