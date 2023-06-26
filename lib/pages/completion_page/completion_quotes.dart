import 'package:auto_size_text/auto_size_text.dart';
import 'package:zense_timer/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/quotes.dart';
import '../../utils/methods/get_quote_index.dart';

class CompletionQuotes extends StatefulWidget {
  const CompletionQuotes({
    super.key,
  });

  @override
  State<CompletionQuotes> createState() => _CompletionQuotesState();
}

class _CompletionQuotesState extends State<CompletionQuotes> {
  String _quote = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.15,
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.02),
        child: FutureBuilder(
          future: getQuoteIndex(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (_quote == "") {
                final index = snapshot.data as int;
                if (index < quotes.length) {
                  _quote = quotes[index];
                  SharedPreferences.getInstance().then((prefs) async {
                    prefs.setInt(kQuoteKey, index + 1);
                  });
                } else {
                  SharedPreferences.getInstance().then((prefs) async {
                    prefs.setInt(kQuoteKey, 0);
                  });
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {});
                  });
                }
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: AutoSizeText(
                    _quote,
                    minFontSize: 6,
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(begin: 0, duration: 2.seconds)
                .scaleXY(begin: 0.90, duration: 2.seconds);
          },
        ),
      ),
    );
  }
}
