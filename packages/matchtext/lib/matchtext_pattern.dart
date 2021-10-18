part of matchtext;

class MatchTextPattern{
  final dynamic targetString;
  final TextStyle? style;
  final GestureRecognizer? recognizer;
  final dynamic matchOption;

  MatchTextPattern({Key? key, required this.targetString, this.style = const TextStyle(color: Color(0xff000000), fontFamily: 'NexaBold',), this.recognizer, this.matchOption = 'all',});

  MatchTextPattern copyWith({targetString, style, recognizer, matchOption, }){
    return MatchTextPattern(
      targetString: targetString ?? this.targetString,
      style: style ?? this.style,
      recognizer: recognizer ?? this.recognizer,
      matchOption: matchOption ?? this.matchOption,
    );
  }
}