part of matchtext;

class MatchText extends StatelessWidget{
  final String text;
  final List<MatchTextPattern>? patternList;
  final TextStyle? defaultStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final bool caseSensitive;
  final bool selectable;

  @override
  const MatchText(this.text, {
    Key? key,
    this.patternList,
    this.defaultStyle = const TextStyle(fontFamily: 'NexaRegular', fontSize: 18, color: Color(0xff000000),),
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.caseSensitive = true,
    this.selectable = false,
  }) : super(key: key);

  List<String> processStrList(List<MatchTextPattern> patternList, String temText){
    List<String> strList = [];
    List<List<int>> positions = [];

    patternList.asMap().forEach((index, pattern){
      String thisRegExPattern;
      String targetString = pattern.targetString;

      thisRegExPattern = '($targetString)';
      RegExp exp = RegExp(thisRegExPattern, caseSensitive: caseSensitive,);
      var allMatches = exp.allMatches(temText);

      int matchesLength = allMatches.length;
      List<int> matchIndexList = [];
      var matchOption = pattern.matchOption;
      if(matchOption is String){
        switch (matchOption) {
          case 'all': matchIndexList = List<int>.generate(matchesLength, (i) => i); break;
          case 'first': matchIndexList = [0]; break;
          case 'last': matchIndexList = [matchesLength - 1]; break;
          default: matchIndexList = List<int>.generate(matchesLength, (i) => i);
        }
      }else if (matchOption is List<dynamic>){
        for(var option in matchOption){
          switch (option) {
            case 'all': matchIndexList = List<int>.generate(matchesLength, (i) => i); break;
            case 'first': matchIndexList.add(0); break;
            case 'last': matchIndexList.add(matchesLength - 1); break;
            default: if (option is int) matchIndexList.add(option);
          }
        }
      }

      allMatches.toList().asMap().forEach((index, match) {
        if (matchIndexList.contains(index)) {
          positions.add([match.start, match.end]);
        }
      });
    });

    positions.sort((a, b) => a[0].compareTo(b[0]));

    List<List<int>> postionsToRemove = [];
    for (var i = 1; i < positions.length; i++) {
      if (positions[i][0] < positions[i - 1][1]) {
        postionsToRemove.add(positions[i]);
      }
    }
    for (var position in postionsToRemove){
      positions.remove(position);
    }

    List<int> splitPositions = [0];
    for(var position in positions){
      splitPositions.add(position[0]);
      splitPositions.add(position[1]);
    }
    
    splitPositions.add(temText.length);
    splitPositions.sort();

    splitPositions.asMap().forEach((index, splitPosition){
      if(index != 0){
        strList.add(temText.substring(splitPositions[index - 1], splitPosition));
      }
    });
    return strList;
  }

  @override
  Widget build(BuildContext context) {
    String temText = text;
    List<MatchTextPattern>? tempPatternList = patternList;
    List<MatchTextPattern> finalTempPatternList = [];
    List<MatchTextPattern> finalTempPatternList2 = [];
    List<String> strList = [];

    if(tempPatternList == null){
      strList = [temText];
    }else{
      tempPatternList.asMap().forEach((index, pattern){
        if(pattern.targetString is List<String>){
          pattern.targetString.asMap().forEach((index, eachTargetString){
            finalTempPatternList.add(pattern.copyWith(targetString: eachTargetString));
          });
        }else{
          finalTempPatternList.add(pattern);
        }
      });

      finalTempPatternList.asMap().forEach((index, pattern){
        finalTempPatternList2.add(pattern);
      });

      strList = processStrList(finalTempPatternList2, temText);
    }

    List<InlineSpan> textSpanList = [];
    for (var str in strList) {
      TextSpan inlineSpan;
      int targetIndex = -1;
      RegExpMatch? match;

      if (tempPatternList != null) {
        finalTempPatternList2.asMap().forEach((index, pattern) {
          String targetString = pattern.targetString;

          RegExp targetStringExp = RegExp('^$targetString\$', caseSensitive: caseSensitive,);
          match = targetStringExp.firstMatch(str);

          if(match is RegExpMatch){
            targetIndex = index;
          }
        });
      }

      if(targetIndex > -1){
        var pattern = finalTempPatternList2[targetIndex];
        inlineSpan = TextSpan(text: str, recognizer: pattern.recognizer, style: pattern.style);

      }else{
        inlineSpan = TextSpan(text: str,);
      }
      textSpanList.add(inlineSpan);
    }

    if(selectable){
      return SelectableText.rich(
        TextSpan(style: defaultStyle, children: textSpanList),
        maxLines: maxLines,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        textScaleFactor: textScaleFactor,
        textWidthBasis: textWidthBasis,
      );
    }else{
      return RichText(
        text: TextSpan(style: defaultStyle, children: textSpanList),
        locale: locale,
        maxLines: maxLines,
        overflow: overflow,
        softWrap: softWrap,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        textScaleFactor: textScaleFactor,
        textWidthBasis: textWidthBasis,
      );
    }
  }
}