import 'package:flutter/material.dart';


class TermOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Terms Of Use"), centerTitle: true,),
    body:ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:16.0),
          child: RichText(
              softWrap: true,
              textAlign: TextAlign.justify,
              text: TextSpan(
                  text: "\n",
                  style: TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
              children: <TextSpan>[
          TextSpan(
            text: "Please read these terms of service (\"terms\", \"terms of service\") carefully before using any of the services operated by Intija Software Solutions (\"us\", \"we\", \"our\", \“the company\”). These include and not limited to Kaatane food ordering service ("),
          TextSpan(text: "www.kaatane.com.ng", style: TextStyle(color: Colors.blue)),
          TextSpan(text: ")."),
    TextSpan(
    text: "\n\nConditions of Use\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(
    text: "The services of Intija Software Solutions ("),
          TextSpan(text: "www.intija.com", style: TextStyle(color: Colors.blue)), TextSpan(
    text: "), with subject to the conditions stated below in this document. Every time you visit our websites, use its services, you accept the following conditions. This is why we urge you to read them carefully.\n\n"),
    TextSpan(text: "Privacy Policy\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(
    text: "Before you continue using our websites and all of our services, we advise you to read our privacy policy ["),TextSpan(text: "www.kaatane.com.ng/privacy", style: TextStyle(color: Colors.blue)),TextSpan(text: "] regarding our user data collection for our main product Kaatane. It will help you better understand our practices."),
    TextSpan(text: "\n\nCopyright\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(text: "Content published on our website (digital downloads, images, texts, graphics, logos) is the property of Intija Software Solutions and/or its content creators and protected by international copyright laws."),
    TextSpan(text: "\n\nCommunications\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(text: "The entire communication with us is electronic. Every time you send us an email, visit our website or use one of our software services, you are going to be communicating with us. You hereby consent to receive communications from us. If you subscribe to the news on our website, you are going to receive regular emails from us. We will continue to communicate with you by posting news and notices on our website and by sending you emails. You also agree that all notices, disclosures, agreements and other communications we provide to you electronically meet the legal requirements that such communications be in writing."),
    TextSpan(text: "\n\nApplicable Law\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(text: "By visiting this website, you agree that the laws of Nigeria, without regard to principles of conflict laws, will govern these terms of service, or any dispute of any sort that might come between Intija Software Solutions and you, or its business partners and associates."),
    TextSpan(text: "\n\nDisputes\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(text: "Any dispute related in any way to your visit to this website or to products you purchase from us shall be arbitrated by state or federal court in Nigeria and you consent to exclusive jurisdiction and venue of such courts."),
    TextSpan(text: "\n\nComments, Reviews, and Emails\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(text: "Visitors may post content as long as it is not obscene, illegal, defamatory, threatening, infringing of intellectual property rights, invasive of privacy or injurious in any other way to third parties. Content has to be free of software viruses, political campaign, and commercial solicitation. We reserve all rights (but not the obligation) to remove and/or edit such content. When you post your content, you grant Intija Software Solutions non-exclusive, royalty-free and irrevocable right to use, reproduce, publish, modify such content throughout the world in any media."),
    TextSpan(text: "\n\nContact Information\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(text: "Intija welcomes your comments regarding this Terms of Service or ay of our services. If you believe that Intija has not adhered to this Terms of Service or you have comments and or suggestions, please contact us at "),TextSpan(text: "hello@intija.com.", style: TextStyle(color: Colors.blue),),TextSpan(text: " We will aim to use commercially reasonable efforts to promptly determine and remedy the problem.\n\n\n\n\n")])),
        ),
      ],));
  }
}
