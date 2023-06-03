import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mickeyadmin/models/post.dart';
import 'package:mickeyadmin/models/postType.dart';
import 'package:mickeyadmin/widgets/ProgressWidget.dart';
import 'package:mickeyadmin/widgets/customAppBar.dart';
import 'package:mickeyadmin/widgets/customButton.dart';
import 'package:mickeyadmin/widgets/customTextField.dart';
import 'package:mickeyadmin/widgets/footer.dart';
import 'package:mickeyadmin/widgets/videoCard.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:uuid/uuid.dart';

// Account mickey = Account(
//     email: "mokayamark@gmail.com",
//     phone: "0702846342",
//     url: "https://firebasestorage.googleapis.com/v0/b/project-5-97d71.appspot.com/o/Profile%20Photos%2F1613044874720.jpg?alt=media&token=a460a09b-2228-44c6-acfc-7c4186dc8e11",
//     id: "DUxn3LLKj4e0QF9aijMOwpf9Qlr1",
//     profileName: "profileName",
//     username: "mickey tours and travel"
// );

class UploadHolidayHome extends StatefulWidget {
  const UploadHolidayHome({Key? key}) : super(key: key);

  @override
  State<UploadHolidayHome> createState() => _UploadHolidayHomeState();
}

class _UploadHolidayHomeState extends State<UploadHolidayHome> {
  final ScrollController _controller = ScrollController();
  TextEditingController name = TextEditingController();
  TextEditingController tag = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController currency = TextEditingController();
  TextEditingController cost = TextEditingController();
  List<PlatformFile> images = [];
  List<PlatformFile> videos = [];
  bool loading = false;

  void pickImages() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: true);

    if (result != null) {
      setState(() {
        images = result.files;
      });
    }
  }

  void pickVideos() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: true);

    if (result != null) {
      setState(() {
        videos = result.files;
      });
    }
  }

  Future<List<String>> uploadVideos(String postID) async {
    List<String> downloadUrls = [];
    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

    for (PlatformFile video in videos) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Upload file and metadata to the path 'images/mountains.jpg'
      UploadTask uploadTask = storageRef
          .child("Post Pictures/$postID/video_$fileName.${video.extension}")
          .putData(video.bytes!);

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  Future<List<String>> uploadImages(String postID) async {
    List<String> downloadUrls = [];
    // Create a reference to the Firebase Storage bucket
    final storageRef = FirebaseStorage.instance.ref();

    for (PlatformFile image in images) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Upload file and metadata to the path 'images/mountains.jpg'
      UploadTask uploadTask = storageRef
          .child("Post Pictures/$postID/photo_$fileName.${image.extension}")
          .putData(image.bytes!);

      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      downloadUrls.add(downloadUrl);
    }

    return downloadUrls;
  }

  void proceedToUpload() async {
    if (name.text.isNotEmpty &&
        tag.text.isNotEmpty &&
        city.text.isNotEmpty &&
        country.text.isNotEmpty &&
        description.text.isNotEmpty &&
        currency.text.isNotEmpty &&
        cost.text.isNotEmpty &&
        images.isNotEmpty) {
      try {
        setState(() {
          loading = true;
        });

        String postID = Uuid().v4();

        List<String> imageUrls = await uploadImages(postID);

        // CHECK if videos exist

        List<String> videoUrls = [];

        if (videos.isNotEmpty) {
          videoUrls = await uploadVideos(postID);
        }

        Post post = Post(
          postId: postID,
          imageUrl: imageUrls[0],
          description: description.text,
          name: name.text.trim(),
          city: city.text.trim(),
          country: country.text.trim(),
          locality: "",
          payPeriod: "Per Night",
          price: cost.text.trim().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
          currency: currency.text,
          type: tag.text,
          address: "",
          latitude: 0.0,
          longitude: 0.0,
          username: "mickey tours and travel",
          phone: "0702846342",
          ownerUrl:
              "https://firebasestorage.googleapis.com/v0/b/project-5-97d71.appspot.com/o/Profile%20Photos%2F1613044874720.jpg?alt=media&token=a460a09b-2228-44c6-acfc-7c4186dc8e11",
          userId: "DUxn3LLKj4e0QF9aijMOwpf9Qlr1",
          email: "mokayamark@gmail.com",
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );

        await FirebaseFirestore.instance
            .collection("posts")
            .doc(post.postId)
            .set(post.toMap());

        await FirebaseFirestore.instance
            .collection("posts")
            .doc(post.postId)
            .collection("other images")
            .doc(post.timestamp.toString())
            .set({
          "urls": imageUrls,
        }).then((value) => Fluttertoast.showToast(
                msg: "Holiday Home Uploaded Successfully!"));

        if (videoUrls.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection("posts")
              .doc(post.postId)
              .collection("videos")
              .doc(post.timestamp.toString())
              .set({
            "urls": videoUrls,
          }).then((value) =>
                  Fluttertoast.showToast(msg: "Videos Uploaded Successfully!"));
        }

        setState(() {
          loading = false;
          postID = Uuid().v4();
          name.clear();
          tag.clear();
          city.clear();
          country.clear();
          description.clear();
          currency.clear();
          cost.clear();
          images.clear();
          videos.clear();
        });
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: "ERROR: Please try again...");
        setState(() {
          loading = false;
        });
      }
    } else if (images.isEmpty) {
      Fluttertoast.showToast(msg: "Select Images to upload");
    } else {
      Fluttertoast.showToast(msg: "ERROR: Please Fill the form");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, 50.0),
        child: const CustomAppBar(
          isShrink: true,
        ),
      ),
      body: loading
          ? SizedBox(
              height: size.height,
              width: size.width,
              child: Center(
                child: circularProgress(),
              ),
            )
          : RawScrollbar(
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
                                      "Upload Holiday Homes",
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Mickey Tours & Travel ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey,
                                          size: 12.0,
                                        ),
                                        Text(
                                          " Admin ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.grey,
                                          size: 12.0,
                                        ),
                                        Text(
                                          " Upload Holiday Homes",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                images.isEmpty
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 200.0,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: Colors.pink.shade100,
                                                  width: 1.0,
                                                )),
                                            child: Center(
                                              child: TextButton.icon(
                                                onPressed: pickImages,
                                                icon: const Icon(
                                                    Icons.cloud_upload_outlined,
                                                    color: Colors.pink),
                                                label:
                                                    const Text("Pick Images"),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                    Icons.error_outline_rounded,
                                                    color: Colors.pink
                                                        .withOpacity(0.3)),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                const Text(
                                                  "Pick atleast 1 image.",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    : GridView.count(
                                        crossAxisCount: 2,
                                        shrinkWrap: true,
                                        childAspectRatio: 3 / 2,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: List.generate(images.length,
                                            (index) {
                                          PlatformFile image = images[index];

                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Stack(
                                              children: [
                                                Image.memory(
                                                  image.bytes!,
                                                  //height: ,
                                                  width: size.width,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  top: 5.0,
                                                  right: 5.0,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        images.remove(image);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.cancel,
                                                      color: Colors.white,
                                                      size: 15.0,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                videos.isEmpty
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 100.0,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                  color: Colors.pink.shade100,
                                                  width: 1.0,
                                                )),
                                            child: Center(
                                              child: TextButton.icon(
                                                onPressed: pickVideos,
                                                icon: const Icon(
                                                    Icons.cloud_upload_outlined,
                                                    color: Colors.pink),
                                                label:
                                                    const Text("Pick Videos"),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                    Icons.error_outline_rounded,
                                                    color: Colors.pink
                                                        .withOpacity(0.3)),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                const Text(
                                                  "Large file videos might take longer to upload",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(videos.length,
                                            (index) {
                                          PlatformFile video = videos[index];

                                          return VideoCard(
                                            video: video,
                                            onPressed: () {
                                              setState(() {
                                                videos.remove(video);
                                              });
                                            },
                                          );
                                        }),
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
                                    dropdownSearchDecoration:
                                        const InputDecoration(
                                      labelText: "Tag *",
                                      hintText: "Tag",
                                    ),
                                    onChanged: (v) {
                                      setState(() {
                                        tag.text = v!;
                                      });
                                    },
                                    //selectedItem: "KES",
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
                                    dropdownSearchDecoration:
                                        const InputDecoration(
                                      labelText: "Currency *",
                                      hintText: "Currency",
                                    ),
                                    onChanged: (v) {
                                      setState(() {
                                        currency.text = v!;
                                      });
                                    },
                                    //selectedItem: "KES",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomButton(
                                      title: "Upload Holiday Home",
                                      color: Colors.pink,
                                      onTap: proceedToUpload,
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
