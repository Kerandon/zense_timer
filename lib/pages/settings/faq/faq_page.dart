import 'package:flutter/material.dart';
import '../../../data/faq_panels.dart';
import '../../../models/panel.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _renderFAQPanels(size),
        ),
      ),
    );
  }

  Widget _renderFAQPanels(Size size) {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          faqPanels[index].isExpanded = !isExpanded;
        });
      },
      children: faqPanels.map<ExpansionPanel>((Panel step) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Padding(
                padding: EdgeInsets.all(size.width * 0.03),
                child: Text(step.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
            );
          },
          body: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: ListTile(
              title: Text(step.body),
            ),
          ),
          isExpanded: step.isExpanded,
        );
      }).toList(),
    );
  }
}
