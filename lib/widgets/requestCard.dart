import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mickeyadmin/models/bookingRequest.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestCard extends StatelessWidget {
  final BookingRequest? request;
  const RequestCard({Key? key, this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(request!.name!),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request!.email!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(request!.phone!)
                ],
              ),
              trailing: Text(DateFormat("HH:mm, dd MMM").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      int.parse(request!.requestID!)))),
            ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey,
                  )),
              child: ListTile(
                //contentPadding: EdgeInsets.zero,
                leading: Image.network(
                  request!.post!["url"],
                  height: size.height,
                  width: 70.0,
                  fit: BoxFit.cover,
                ),
                title: Text(request!.post!["name"]),
                subtitle: Text(
                    request!.post!["city"] + ", " + request!.post!["country"]),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Message:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(request!.message!),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Period:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text("From: " +
                DateFormat("dd MMM yyyy").format(
                    DateTime.fromMillisecondsSinceEpoch(request!.startDate!))),
            Text("To: " +
                DateFormat("dd MMM yyyy").format(
                    DateTime.fromMillisecondsSinceEpoch(request!.endDate!))),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 1.0,
              width: size.width,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Adults: " + request!.adultsNo.toString()),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text("Children: " + request!.childrenNo.toString()),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => launch("mailto:${request!.email}"),
                      icon: const Icon(
                        Icons.email_outlined,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    IconButton(
                      onPressed: () => launch("tel:${request!.phone}"),
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
