import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mickeyadmin/pages/editCover.dart';
import 'package:mickeyadmin/pages/uploadCoverPhoto.dart';
import 'package:mickeyadmin/widgets/ProgressWidget.dart';
import 'package:mickeyadmin/widgets/customAppBar.dart';
import 'package:mickeyadmin/widgets/footer.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../models/coverPhoto.dart';
import '../widgets/customButton.dart';

class CoverPhotos extends StatefulWidget {
  const CoverPhotos({Key? key}) : super(key: key);

  @override
  State<CoverPhotos> createState() => _CoverPhotosState();
}

class _CoverPhotosState extends State<CoverPhotos> {
  final ScrollController _controller = ScrollController();
  bool loading = false;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Cover Photos",
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Admin ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Colors.grey,
                                                size: 12.0,
                                              ),
                                              Text(
                                                " Cover Photos",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption,
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                              const UploadCoverPhoto()));
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("coverPhotos")
                                            .orderBy("timestamp",
                                                descending: true)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return circularProgress();
                                          } else {
                                            List<CoverPhoto> coverPhotos = [];

                                            snapshot.data!.docs
                                                .forEach((element) {
                                              CoverPhoto coverPhoto =
                                                  CoverPhoto.fromDocument(
                                                      element);

                                              coverPhotos.add(coverPhoto);
                                            });

                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                  coverPhotos.length, (index) {
                                                bool isFirst = index == 0;
                                                return CoverPhotoLayout(
                                                  coverPhoto:
                                                      coverPhotos[index],
                                                  isFirst: isFirst,
                                                );
                                              }),
                                            );
                                          }
                                        },
                                      )
                                    ]),
                              ),
                            )),
                      ),
                      const Footer()
                    ]),
              ),
            ),
    );
  }
}

class CoverPhotoLayout extends StatefulWidget {
  final CoverPhoto? coverPhoto;
  final bool? isFirst;
  const CoverPhotoLayout({Key? key, this.coverPhoto, this.isFirst})
      : super(key: key);

  @override
  State<CoverPhotoLayout> createState() => _CoverPhotoLayoutState();
}

class _CoverPhotoLayoutState extends State<CoverPhotoLayout> {
  bool isSetting = false;
  bool isDeleting = false;

  void setAsFirst() async {
    setState(() {
      isSetting = true;
    });

    await FirebaseFirestore.instance
        .collection("coverPhotos")
        .doc(widget.coverPhoto!.id)
        .update({"timestamp": DateTime.now().millisecondsSinceEpoch});

    setState(() {
      isSetting = false;
    });

    //this.setState(() {});
  }

  void deleteCoverPhoto() async {
    setState(() {
      isDeleting = true;
    });

    await FirebaseFirestore.instance
        .collection("coverPhotos")
        .doc(widget.coverPhoto!.id)
        .delete()
        .then((value) {
      Fluttertoast.showToast(msg: "Deleted Successfully");
    });

    setState(() {
      isDeleting = false;
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
                    builder: (context) => EditCoverPhoto(
                          coverPhoto: widget.coverPhoto,
                        )));
          },
          child: Card(
            color: Colors.white,
            shadowColor: Colors.black,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: isMobile ? 150.0 : 300.0,
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
                      image: widget.coverPhoto!.imageUrl!,
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
                                widget.coverPhoto!.name!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.coverPhoto!.city! +
                                    ", " +
                                    widget.coverPhoto!.country!,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          Text(
                            widget.coverPhoto!.description!,
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
                                  widget.isFirst!
                                      ? Container()
                                      : CustomButton(
                                          title: isSetting
                                              ? "Setting..."
                                              : "Set as First",
                                          color: Colors.pink,
                                          onTap: () {
                                            if (!isSetting) {
                                              setAsFirst();
                                            }
                                          },
                                        ),
                                  !widget.isFirst!
                                      ? CustomButton(
                                          title: isDeleting
                                              ? "Deleting..."
                                              : "Delete",
                                          color: Colors.pink,
                                          onTap: () {
                                            if (!isDeleting) {
                                              deleteCoverPhoto();
                                            }
                                          },
                                        )
                                      : Container()
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
