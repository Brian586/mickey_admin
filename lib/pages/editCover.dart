import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mickeyadmin/models/coverPhoto.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../widgets/customAppBar.dart';
import '../widgets/customButton.dart';
import '../widgets/customTextField.dart';
import '../widgets/footer.dart';

class EditCoverPhoto extends StatefulWidget {
  final CoverPhoto? coverPhoto;
  const EditCoverPhoto({Key? key, this.coverPhoto}) : super(key: key);

  @override
  State<EditCoverPhoto> createState() => _EditCoverPhotoState();
}

class _EditCoverPhotoState extends State<EditCoverPhoto> {
  TextEditingController name = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController currency = TextEditingController();
  final ScrollController _controller = ScrollController();
  bool updating = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      name.text = widget.coverPhoto!.name!;
      city.text = widget.coverPhoto!.city!;
      country.text = widget.coverPhoto!.country!;
      description.text = widget.coverPhoto!.description!;
      cost.text = widget.coverPhoto!.cost!;
      currency.text = widget.coverPhoto!.currency!;
    });
  }

  void proceedToUpdate() async {
    setState(() {
      updating = true;
    });

    CoverPhoto coverPhoto = CoverPhoto(
      id: widget.coverPhoto!.id,
      imageUrl: widget.coverPhoto!.imageUrl,
      name: name.text.trim(),
      city: city.text.trim(),
      country: country.text.trim(),
      description: description.text,
      cost: cost.text.trim(),
      currency: currency.text,
      timestamp: widget.coverPhoto!.timestamp,
    );

    await FirebaseFirestore.instance
        .collection("coverPhotos")
        .doc(widget.coverPhoto!.id)
        .update(coverPhoto.toMap())
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
                                "Edit Cover Photo",
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
                                    " Cover Photos ",
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.grey,
                                    size: 12.0,
                                  ),
                                  Text(
                                    " Edit Cover Photo",
                                    style: Theme.of(context).textTheme.caption,
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Image.network(
                            widget.coverPhoto!.imageUrl!,
                            width: size.width,
                            height: size.height * 0.4,
                            fit: BoxFit.cover,
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
