import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mickeyadmin/models/coverPhoto.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/ProgressWidget.dart';
import '../widgets/customAppBar.dart';
import '../widgets/customButton.dart';
import '../widgets/customTextField.dart';
import '../widgets/footer.dart';

class UploadCoverPhoto extends StatefulWidget {
  const UploadCoverPhoto({Key? key}) : super(key: key);

  @override
  State<UploadCoverPhoto> createState() => _UploadCoverPhotoState();
}

class _UploadCoverPhotoState extends State<UploadCoverPhoto> {
  final ScrollController _controller = ScrollController();
  bool loading = false;
  TextEditingController name = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController currency = TextEditingController();
  TextEditingController cost = TextEditingController();
  PlatformFile? image;

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (result != null) {
      setState(() {
        image = result.files[0];
      });
    }
  }

  Future<String> uploadImage(String coverPhotoID) async {
    final storageRef = FirebaseStorage.instance.ref();

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    // Upload file and metadata to the path 'images/mountains.jpg'
    UploadTask uploadTask = storageRef
        .child("Cover Photos/$coverPhotoID/photo_$fileName.${image!.extension}")
        .putData(image!.bytes!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void proceedToUpload() async {
    if (name.text.isNotEmpty &&
        city.text.isNotEmpty &&
        country.text.isNotEmpty &&
        description.text.isNotEmpty &&
        currency.text.isNotEmpty &&
        cost.text.isNotEmpty &&
        image != null) {
      try {
        setState(() {
          loading = true;
        });

        String coverPhotoID = DateTime.now().millisecondsSinceEpoch.toString();

        String downloadUrl = await uploadImage(coverPhotoID);

        CoverPhoto coverPhoto = CoverPhoto(
          id: coverPhotoID,
          imageUrl: downloadUrl,
          name: name.text.trim(),
          city: city.text.trim(),
          country: country.text.trim(),
          description: description.text,
          cost: cost.text.trim().replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
          currency: currency.text,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );

        await FirebaseFirestore.instance
            .collection("coverPhotos")
            .doc(coverPhoto.id)
            .set(coverPhoto.toMap())
            .then((value) =>
                Fluttertoast.showToast(msg: "Uploaded Successfully!"));

        setState(() {
          loading = false;
          name.clear();
          city.clear();
          country.clear();
          description.clear();
          currency.clear();
          cost.clear();
          image = null;
        });
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: "ERROR: Fill All the Forms");
        setState(() {
          loading = false;
        });
      }
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
                                      "Upload Cover Photo",
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
                                          "Admin ",
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
                                          " Cover Photos ",
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
                                          " Upload ",
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
                                image == null
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
                                                onPressed: pickImage,
                                                icon: const Icon(
                                                    Icons.cloud_upload_outlined,
                                                    color: Colors.pink),
                                                label: const Text("Pick Image"),
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
                                                  "Pick 1 image.",
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
                                    : Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Stack(
                                          children: [
                                            Image.memory(
                                              image!.bytes!,
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
                                                    image = null;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomButton(
                                      title: "Upload Cover Photos",
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
