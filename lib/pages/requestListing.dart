import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../models/bookingRequest.dart';
import '../widgets/ProgressWidget.dart';
import '../widgets/customAppBar.dart';
import '../widgets/footer.dart';
import '../widgets/requestCard.dart';

class RequestListing extends StatefulWidget {
  const RequestListing({Key? key}) : super(key: key);

  @override
  State<RequestListing> createState() => _RequestListingState();
}

class _RequestListingState extends State<RequestListing> {
  final ScrollController _controller = ScrollController();

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
                              "Booking Requests",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4,
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
                                  " Booking Requests",
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                          ],
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("bookingRequests")
                              .limit(15)
                              //.orderBy("timestamp", descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return circularProgress();
                            } else {
                              List<BookingRequest> requests = [];

                              snapshot.data!.docs.forEach((element) {
                                BookingRequest request =
                                    BookingRequest.fromDocument(element);
                                requests.add(request);
                              });

                              return requests.isEmpty
                                  ? const Center(
                                      child: Text("No Requests Available"),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(requests.length,
                                          (index) {
                                        BookingRequest req = requests[index];

                                        return RequestCard(
                                          request: req,
                                        );
                                      }),
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
