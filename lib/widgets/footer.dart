import 'package:flutter/material.dart';
import 'package:mickeyadmin/common.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => const FooterMobile(),
      tablet: (BuildContext context) => const FooterMobile(),
      desktop: (BuildContext context) => const FooterDesktop(),
      watch: (BuildContext context) => Container(color: Colors.white),
    );
  }
}

class FooterDesktop extends StatelessWidget {
  const FooterDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: const Color.fromRGBO(19, 28, 46, 1.0),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [MenuList(), ContactInfo(), SocialLinks()],
          ),
          const SizedBox(
            height: 10.0,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("\u00a9 Mickey Tours & Travel",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
              Text("All Rights Reserved.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}

class PaymentInfo extends StatelessWidget {
  const PaymentInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/mpesa.png",
          width: 60.0,
          //height: 25.0,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Buy Goods & Services",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "5470133",
              style: TextStyle(color: Colors.white),
            ),
          ],
        )
      ],
    );
  }
}

class FooterMobile extends StatelessWidget {
  const FooterMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: const Color.fromRGBO(19, 28, 46, 1.0),
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 30.0,
            ),
            const MenuList(),
            const SizedBox(
              height: 30.0,
            ),
            const ContactInfo(),
            const SizedBox(
              height: 30.0,
            ),
            const SocialLinks(),
            const SizedBox(
              height: 30.0,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("\u00a9 Mickey Tours & Travel",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                  Text("All Rights Reserved.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

class SocialLinks extends StatelessWidget {
  const SocialLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("FOLLOW US",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .apply(color: Colors.pink, fontWeightDelta: 5)),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          height: 2.0,
          width: 40.0,
          color: Colors.pink,
        ),
        const SizedBox(
          height: 20.0,
        ),
        TextButton.icon(
          icon: Image.asset(
            "assets/social/ig.png",
            height: 20.0,
            width: 20.0,
            fit: BoxFit.contain,
          ),
          onPressed: () {
            Common.openUrl("https://instagram.com/mickey_tours_and_travel");
          },
          label: const Text(
            "Instagram",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton.icon(
          icon: Image.asset(
            "assets/social/fb.png",
            height: 20.0,
            width: 20.0,
            fit: BoxFit.contain,
          ),
          onPressed: () {
            Common.openUrl("https://facebook.com/");
          },
          label: const Text(
            "Facebook",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton.icon(
          icon: Image.asset(
            "assets/social/tw.png",
            height: 20.0,
            width: 20.0,
            fit: BoxFit.contain,
          ),
          onPressed: () {
            Common.openUrl("https://twitter.com/Mokaya04349621");
          },
          label: const Text(
            "Twitter",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class ContactInfo extends StatelessWidget {
  const ContactInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("CONTACT US",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .apply(color: Colors.pink, fontWeightDelta: 2)),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          height: 2.0,
          width: 40.0,
          color: Colors.pink,
        ),
        const SizedBox(
          height: 20.0,
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.phone,
            color: Colors.white,
          ),
          onPressed: () => launch("tel:+254702846342"),
          label: const Text(
            "+254702846342",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.email_outlined,
            color: Colors.white,
          ),
          onPressed: () => launch("mailto:info@mickeytoursandtravel.com"),
          label: const Text(
            "info@mickeytoursandtravel.com",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        const PaymentInfo(),
      ],
    );
  }
}

class MenuList extends StatelessWidget {
  const MenuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("MENU",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .apply(color: Colors.pink, fontWeightDelta: 2)),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          height: 2.0,
          width: 40.0,
          color: Colors.pink,
        ),
        const SizedBox(
          height: 20.0,
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.home,
            color: Colors.white,
          ),
          onPressed: () {
            Common.openUrl("https://mickeytoursandtravel.com");
          },
          label: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.flight,
            color: Colors.white,
          ),
          onPressed: () {
            Common.openUrl("https://mickeytoursandtravel.com/safaries");
          },
          label: const Text(
            "Safaries",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.cottage,
            color: Colors.white,
          ),
          onPressed: () {
            Common.openUrl("https://mickeytoursandtravel.com/holiday_homes");
          },
          label: const Text(
            "Holiday Homes",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
