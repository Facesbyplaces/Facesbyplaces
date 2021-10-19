// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// class EasyRichTextPattern {
//   ///target string that you want to format
//   final dynamic targetString;

//   ///Style of target text
//   final TextStyle? style;

//   ///GestureRecognizer
//   final GestureRecognizer? recognizer;

//   ///match first, last, or all [0, 1, 'last']
//   ///defalut match all
//   final dynamic matchOption;

//   EasyRichTextPattern({Key? key, required this.targetString, this.style = const TextStyle(color: Color(0xff000000), fontFamily: 'NexaBold',), this.recognizer, this.matchOption = 'all',});

//   EasyRichTextPattern copyWith({targetString, style, recognizer, matchOption, }){
//     return EasyRichTextPattern(
//       targetString: targetString ?? this.targetString,
//       style: style ?? this.style,
//       recognizer: recognizer ?? this.recognizer,
//       matchOption: matchOption ?? this.matchOption,
//     );
//   }
// }


// class EasyRichText extends StatelessWidget{
//   ///The orginal text
//   final String text;

//   ///The list of target strings and their styles.
//   final List<EasyRichTextPattern>? patternList;

//   ///The default text style.
//   final TextStyle? defaultStyle;

//   /// How the text should be aligned horizontally.
//   final TextAlign textAlign;

//   /// The directionality of the text.
//   ///
//   /// This decides how [textAlign] values like [TextAlign.start] and
//   /// [TextAlign.end] are interpreted.
//   ///
//   /// This is also used to disambiguate how to render bidirectional text. For
//   /// example, if the [text] is an English phrase followed by a Hebrew phrase,
//   /// in a [TextDirection.ltr] context the English phrase will be on the left
//   /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
//   /// context, the English phrase will be on the right and the Hebrew phrase on
//   /// its left.
//   ///
//   /// Defaults to the ambient [Directionality], if any. If there is no ambient
//   /// [Directionality], then this must not be null.
//   final TextDirection? textDirection;

//   /// Whether the text should break at soft line breaks.
//   ///
//   /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
//   final bool softWrap;

//   /// How visual overflow should be handled.
//   final TextOverflow overflow;

//   /// The number of font pixels for each logical pixel.
//   ///
//   /// For example, if the text scale factor is 1.5, text will be 50% larger than
//   /// the specified font size.
//   final double textScaleFactor;

//   /// An optional maximum number of lines for the text to span, wrapping if necessary.
//   /// If the text exceeds the given number of lines, it will be truncated according
//   /// to [overflow].
//   ///
//   /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
//   /// edge of the box.
//   final int? maxLines;

//   /// Used to select a font when the same Unicode character can
//   /// be rendered differently, depending on the locale.
//   ///
//   /// It's rarely necessary to set this property. By default its value
//   /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
//   ///
//   /// See [RenderParagraph.locale] for more information.
//   final Locale? locale;

//   /// {@macro flutter.painting.textPainter.strutStyle}
//   final StrutStyle? strutStyle;

//   /// {@macro flutter.widgets.text.DefaultTextStyle.textWidthBasis}
//   final TextWidthBasis textWidthBasis;

//   ///case sensitive match
//   ///default true
//   final bool caseSensitive;

//   ///selectable text, default false
//   final bool selectable;

//   @override
//   const EasyRichText(
//     this.text, {
//     Key? key,
//     this.patternList,
//     this.defaultStyle = const TextStyle(fontFamily: 'NexaRegular', fontSize: 18, color: Color(0xff000000),),
//     this.textAlign = TextAlign.start,
//     this.textDirection,
//     this.softWrap = true,
//     this.overflow = TextOverflow.clip,
//     this.textScaleFactor = 1.0,
//     this.maxLines,
//     this.locale,
//     this.strutStyle,
//     this.textWidthBasis = TextWidthBasis.parent,
//     this.caseSensitive = true,
//     this.selectable = false,
//   }) : super(key: key);

//   List<String> processStrList(List<EasyRichTextPattern> patternList, String temText){
//     List<String> strList = [];
//     List<List<int>> positions = [];

//     patternList.asMap().forEach((index, pattern){
//       String thisRegExPattern;
//       String targetString = pattern.targetString;

//       thisRegExPattern = '($targetString)';
//       RegExp exp = RegExp(thisRegExPattern, caseSensitive: caseSensitive,);
//       var allMatches = exp.allMatches(temText);

//       int matchesLength = allMatches.length;
//       List<int> matchIndexList = [];
//       var matchOption = pattern.matchOption;
//       if(matchOption is String){
//         switch (matchOption) {
//           case 'all': matchIndexList = List<int>.generate(matchesLength, (i) => i); break;
//           case 'first': matchIndexList = [0]; break;
//           case 'last': matchIndexList = [matchesLength - 1]; break;
//           default: matchIndexList = List<int>.generate(matchesLength, (i) => i);
//         }
//       }else if (matchOption is List<dynamic>){
//         for(var option in matchOption){
//           switch (option) {
//             case 'all': matchIndexList = List<int>.generate(matchesLength, (i) => i); break;
//             case 'first': matchIndexList.add(0); break;
//             case 'last': matchIndexList.add(matchesLength - 1); break;
//             default: if (option is int) matchIndexList.add(option);
//           }
//         }
//       }

//       ///eg. positions = [[7,11],[26,30],]
//       allMatches.toList().asMap().forEach((index, match) {
//         if (matchIndexList.contains(index)) {
//           positions.add([match.start, match.end]);
//         }
//       });
//     });

//     //in some cases the sorted result is still disordered;need re-sort the 1d list;
//     positions.sort((a, b) => a[0].compareTo(b[0]));

//     //remove invalid positions
//     List<List<int>> postionsToRemove = [];
//     for (var i = 1; i < positions.length; i++) {
//       if (positions[i][0] < positions[i - 1][1]) {
//         postionsToRemove.add(positions[i]);
//       }
//     }
//     for (var position in postionsToRemove){
//       positions.remove(position);
//     }

//     //convert positions to 1d list
//     List<int> splitPositions = [0];
//     for(var position in positions){
//       splitPositions.add(position[0]);
//       splitPositions.add(position[1]);
//     }
    
//     splitPositions.add(temText.length);
//     splitPositions.sort();

//     splitPositions.asMap().forEach((index, splitPosition){
//       if(index != 0){
//         strList.add(temText.substring(splitPositions[index - 1], splitPosition));
//       }
//     });
//     return strList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     String temText = text;
//     List<EasyRichTextPattern>? tempPatternList = patternList;
//     List<EasyRichTextPattern> finalTempPatternList = [];
//     List<EasyRichTextPattern> finalTempPatternList2 = [];
//     List<String> strList = [];

//     if(tempPatternList == null){
//       strList = [temText];
//     }else{
//       tempPatternList.asMap().forEach((index, pattern){
//         if(pattern.targetString is List<String>){
//           pattern.targetString.asMap().forEach((index, eachTargetString){
//             finalTempPatternList.add(pattern.copyWith(targetString: eachTargetString));
//           });
//         }else{
//           finalTempPatternList.add(pattern);
//         }
//       });

//       finalTempPatternList.asMap().forEach((index, pattern){
//         finalTempPatternList2.add(pattern);
//       });

//       strList = processStrList(finalTempPatternList2, temText);
//     }

//     List<InlineSpan> textSpanList = [];
//     for (var str in strList) {
//       TextSpan inlineSpan;
//       int targetIndex = -1;
//       RegExpMatch? match;

//       if (tempPatternList != null) {
//         finalTempPatternList2.asMap().forEach((index, pattern) {
//           String targetString = pattern.targetString;

//           //\$, match end
//           RegExp targetStringExp = RegExp('^$targetString\$', caseSensitive: caseSensitive,);
//           match = targetStringExp.firstMatch(str);

//           if(match is RegExpMatch){
//             targetIndex = index;
//           }
//         });
//       }

//       ///If str is targetString
//       if(targetIndex > -1){
//         var pattern = finalTempPatternList2[targetIndex];
//         inlineSpan = TextSpan(text: str, recognizer: pattern.recognizer, style: pattern.style);

//       }else{
//         inlineSpan = TextSpan(text: str,);
//       }
//       textSpanList.add(inlineSpan);
//     }

//     if(selectable){
//       return SelectableText.rich(
//         TextSpan(style: defaultStyle, children: textSpanList),
//         maxLines: maxLines,
//         strutStyle: strutStyle,
//         textAlign: textAlign,
//         textDirection: textDirection,
//         textScaleFactor: textScaleFactor,
//         textWidthBasis: textWidthBasis,
//       );
//     }else{
//       return RichText(
//         text: TextSpan(style: defaultStyle, children: textSpanList),
//         locale: locale,
//         maxLines: maxLines,
//         overflow: overflow,
//         softWrap: softWrap,
//         strutStyle: strutStyle,
//         textAlign: textAlign,
//         textDirection: textDirection,
//         textScaleFactor: textScaleFactor,
//         textWidthBasis: textWidthBasis,
//       );
//     }
//   }
// }

// class NewTest extends StatefulWidget{
//   const NewTest({Key? key}) : super(key: key);

//   @override
//   NewTestState createState() => NewTestState();
// }

// class NewTestState extends State<NewTest>{
//   List<String> items = [
//     'Home Help',
//     'Carpentry/Wodowork',
//     'Mechanic/Car Help',
//     'Electrical',
//     'Plumbing',
//     'Computer/Electronics',
//     'Lawn/Garden',
//     'Childcare/Family',
//     'Packing and Moving',
//     'Extra Pair of Hands',
//     'Web Design and Tech',
//     'Artistic or Creative',
//   ];

//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         // child: EasyRichText(
//         //   text,
//         //   patternList: [
//         //     EasyRichTextPattern(
//         //       targetString: 'dummy',
//         //       matchOption: 'first',
//         //       style: const TextStyle(color: Colors.red),
//         //     ),
//         //   ],
//         //   // defaultStyle: const TextStyle(color: Color(0xff000000),),
//         // )
//         child: Wrap(
//           spacing: 5.0,
//           children: List.generate(
//             items.length,
//             (index) => TextButton.icon(
//               onPressed: (){}, 
//               icon: const Icon(Icons.person),
//               label: EasyRichText(
//                 items[index],
//                 patternList: [
//                   EasyRichTextPattern(
//                     targetString: 'Plumbing',
//                     matchOption: 'first',
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ],
//                 defaultStyle: const TextStyle(color: Colors.blue),
//               ),
//             ),
//           ),
//         ),

//         // child: Wrap(
//         //   spacing: 5.0,
//         //   children: List.generate(
//         //     items.length,
//         //     (index) => TextButton.icon(
//         //       onPressed: (){}, 
//         //       icon: const Icon(Icons.person), 
//         //       // label: Text(items[index]),
//         //       label: EasyRichText(
//         //         items[index],
//         //         patternList: [
//         //           EasyRichTextPattern(
//         //             targetString: items[index],
//         //             matchOption: 'Lawn/Garden',
//         //             // style: const TextStyle(color: Colors.red),
//         //           ),
//         //         ],
//         //         // defaultStyle: const TextStyle(color: Colors.green),
//         //       ),
//         //     ),
//         //   ),
//         // ),
//       ),
//     );
//   }
// }