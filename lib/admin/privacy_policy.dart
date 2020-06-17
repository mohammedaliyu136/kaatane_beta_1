import 'package:flutter/material.dart';


class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Privacy Policy"), centerTitle: true,),
      body: ListView(
        children: [
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
            text:"Kaatane is an online food ordering application that gives you access to delicious meals from the restaurants around you in the easiest way possible.\n\nDesigned and developed by Intija Software Solutions (",),

              TextSpan(text:"www.intija.com",style: TextStyle(color: Colors.blue),),

              TextSpan(
                  text:"), Kaatane is committed to protecting your privacy, ensuring that your personal information is handled in a safe and responsible way and we only accept information that is necessary. Ensure you understand this policy in its entirety and take your time to read it.\n\nThis policy outlines how we aim to achieve this and includes the information collected when:\n\n"),
              TextSpan(
                  text:"•	 You use our application.\n\n•	You make a booking on our application.\n\n•	You make enquiries on our website.\n\n•	Someone is interested in working with us.\n\n", style: TextStyle(height: 0.5)),
              TextSpan(
                  text:"\nHow do we collect information from you?\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              TextSpan(
                  text:"We collect information from you:\n•	When you sign up in the Kaatane application.\n•	When you order food from a restaurant using the Kaatane application.\n•	When you make an enquiry.\n•	When you sign up to marketing emails.\n\n", style: TextStyle(height: 1.7)),
              TextSpan(
                  text:"\nWhat type of information is collected from you?\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              TextSpan(
                  text:"You may be asked to submit personal information about yourself when you place an order. We will collect this information so we can fulfill your order request. In this case Kaatane collects information such as Name, Email, phone number, home or work address and payment information.\n\nWhen you access Kaatane application, there is “Device Information” about your hardware device and software that is automatically collected by Kaatane. This information can include: device type (e.g. mobile, computer, laptop, tablet), cookies, operating system, IP address, access times, settings and other data about your device to provide the services as otherwise described in this policy.\n\nIf you use Kaatane application, we may receive your generic location (such as city or neighborhood).\n\n"),
    TextSpan(
    text:"\nHow is your information used?\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(
    text:"Our use of your personal data will always have a lawful basis, either because it is necessary to complete an order, because you have consented to our use of your personal data (e.g. by subscribing to emails), or because it is in our legitimate interests.\n\n We require the information outlined in the previous section to understand your needs and provide you with a better service, and in particular for the following reasons:\n\n •	Internal record keeping.\n\n•	Send you service emails (booking confirmation and post-dining feedback).\n\n•	Improve our products and services.\n\n•	Send marketing communications if you have opted in to receive them.\n\n•	We may use the information to customize the application according to your interests."),
    TextSpan(
    text:"\n\n\nWho has access to your information?\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(
    text:"We will not sell, distribute, or lease your personal information to third parties. Any personal information we request from you will be safeguarded under current legislation.\n\nWe will only share your information with companies if necessary, to deliver services on our behalf.  For example, service providers, third-party payment processors, and other third parties to fulfil your requests, and as otherwise consented to by you or as permitted by applicable law.\n\nThird parties (including third parties whose content appears on the application) whose content appears on Kaatane may use third-party Cookies, as detailed below. Please note that we do not control the activities of such third parties, nor the data they collect and use and advise you to check the privacy policies of any such third parties.\n\n"),
    TextSpan(
    text:"\nHow and where do we store data?\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(
    text:"We only keep your personal data for as long as we need to, in order to use it as described in this privacy policy, and/or for as long as we have your permission to keep it. For reservations taken through Kaatane application, your data will only be stored in the serves of our hosting company. Kaatane data is stored securely in data centers managed by Google firebase. Furthermore, Data security is very important to us, and to protect your data we have taken suitable measures to safeguard and secure data collected through Kaatane.\n\n"),
    TextSpan(
    text:"\nWhat happens if our business changes hands?\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(
    text:"We may, from time to time, expand or reduce our business and this may involve the sale and/or the transfer of control of all or part of our business. Any personal data that you have provided will, where it is relevant to any part of our business that is being transferred, be transferred along with that part. The new owner or newly controlling party will, under the terms of this Privacy Policy, be permitted to use that data only for the same purposes for which it was originally collected by us.\n\nIn the event that any of your data is to be transferred in such a manner, you will NOT be contacted in advance and informed of the changes. When contacted you will NOT, HOWEVER, be given the choice to have your data deleted or withheld from the new owner or controller.\n\nIn addition to providing you with more customized service, we may, as permitted by applicable law, share your information with our restaurant affiliates to support operations, such as to perform analytics, tailor marketing to you, support a loyalty program that you have chosen to participate in, and improve services.\n\nFor more information, please feel free to contact us at:"),
    TextSpan(
    text:" kaatane@intija.com \n", style: TextStyle(color: Colors.blue),),
    TextSpan(
    text:"\nChanges to this statement\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(
    text:"Kaatane will occasionally update this Privacy Policy to reflect company and customer feedback. Kaatane encourages you to periodically review this statement to be informed of how Kaatane is protecting your information. This policy was last updated in May, 2020.\n\n"),
    TextSpan(
    text:"\nContact Information\n", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
    TextSpan(
    text:"Kaatane welcomes your comments regarding this Privacy Policy. If you believe that Kaatane has not adhered to this Privacy Policy, please contact Kaatane at"),
              TextSpan(
    text:" kaatane@intija.com. ", style: TextStyle(color: Colors.blue),), TextSpan(
    text:"We will aim to use commercially reasonable efforts to promptly determine and remedy the problem.")
    ])),
          ),
        ],
      )
    );
  }
}
