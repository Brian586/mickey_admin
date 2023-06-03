import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mickeyadmin/models/safari.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/ProgressWidget.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customButton.dart';
import '../widgets/customTextField.dart';
import '../widgets/footer.dart';

class SafariDetails extends StatefulWidget {
  final Safari? safari;
  const SafariDetails({Key? key, this.safari}) : super(key: key);

  @override
  State<SafariDetails> createState() => _SafariDetailsState();
}

class _SafariDetailsState extends State<SafariDetails> {
  final ScrollController _controller = ScrollController();
  TextEditingController name = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController days = TextEditingController();
  TextEditingController nights = TextEditingController();
  TextEditingController currency = TextEditingController();
  bool updating = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      name.text = widget.safari!.name!;
      city.text = widget.safari!.city!;
      country.text = widget.safari!.country!;
      description.text = widget.safari!.description!;
      cost.text = widget.safari!.cost!;
      days.text = widget.safari!.days!.toString();
      nights.text = widget.safari!.nights!.toString();
      currency.text = widget.safari!.currency!;
    });
  }

  void proceedToUpdate() async {
    setState(() {
      updating = true;
    });

    Safari safari = Safari(
      safariID: widget.safari!.safariID,
      name: name.text.trim(),
      city: city.text.trim(),
      country: country.text.trim(),
      description: description.text,
      cost: cost.text.trim(),
      days: int.parse(days.text.trim()),
      nights: int.parse(nights.text.trim()),
      currency: currency.text.trim(),
      imageUrl: widget.safari!.imageUrl,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    await FirebaseFirestore.instance
        .collection("safaries")
        .doc(widget.safari!.safariID)
        .update(safari.toMap())
        .then((value) => Fluttertoast.showToast(
            msg: "Updated. Changes will take a few minutes to propagate.",
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
                                "Edit Safari",
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
                                    " Safaries ",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 12.0,
                                  ),
                                  Text(
                                    " Edit Safari",
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SafariImages(
                            safari: widget.safari,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          CustomTextField(
                            title: "Title *",
                            controller: name,
                            hintText: "Title",
                            inputType: TextInputType.name,
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
                          CustomTextField(
                            title: "Number of Days *",
                            controller: days,
                            hintText: "1",
                            inputType: TextInputType.number,
                          ),
                          CustomTextField(
                            title: "Number of Nights *",
                            controller: nights,
                            hintText: "1",
                            inputType: TextInputType.number,
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
                            title: "Cost per Night",
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

class SafariImages extends StatefulWidget {
  final Safari? safari;
  const SafariImages({Key? key, this.safari}) : super(key: key);

  @override
  State<SafariImages> createState() => _SafariImagesState();
}

class _SafariImagesState extends State<SafariImages> {
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
              "Safari Photos/${widget.safari!.safariID}/photo_$fileName.${image.extension}")
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
            .collection("safaries")
            .doc(widget.safari!.safariID!)
            .collection("images")
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
        .collection("safaries")
        .doc(widget.safari!.safariID!)
        .collection("images")
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
            .collection("safaries")
            .doc(widget.safari!.safariID!)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          } else {
            Safari safari = Safari.fromDocument(snapshot.data!);

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
                  safari.imageUrl!,
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
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("safaries")
                      .doc(widget.safari!.safariID!)
                      .collection("images")
                      .limit(1)
                      .get(),
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
                              bool isCover =
                                  imageUrls[index] == safari.imageUrl;

                              return SafariImageLayout(
                                safari: safari,
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

class SafariImageLayout extends StatefulWidget {
  final Safari? safari;
  final String? url;
  final bool? isCover;
  final Function()? onPressDelete;
  const SafariImageLayout(
      {Key? key, this.safari, this.url, this.isCover, this.onPressDelete})
      : super(key: key);

  @override
  State<SafariImageLayout> createState() => _SafariImageLayoutState();
}

class _SafariImageLayoutState extends State<SafariImageLayout> {
  bool isSetting = false;

  void setAsCover() async {
    setState(() {
      isSetting = true;
    });

    await FirebaseFirestore.instance
        .collection("safaries")
        .doc(widget.safari!.safariID)
        .update({
      "imageUrl": widget.url,
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
