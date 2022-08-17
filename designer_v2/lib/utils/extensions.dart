import 'package:studyu_designer_v2/constants.dart';
import 'package:studyu_designer_v2/localization/string_hardcoded.dart';

extension EnumX on Enum {
  String toShortString() {
    return toString().split('.').last;
  }
}

extension StringX on String {
  bool get isNewId => this == Config.newModelId;

  String asId() {
    return toLowerCase().replaceAll(' ', '_');
  }

  String withDuplicateLabel({label = kDuplicateLabel}) {
    final regexStr = r"\((?:" + label + r")\s*(\d*)\)$";
    final suffixFactory =
        (n) => (n > 0) ? "($label ${n.toString()})" : "($label)";
    final regex = RegExp(regexStr);

    Iterable<RegExpMatch> matches = regex.allMatches(this);

    if (matches.isNotEmpty) {
      final matchedSuffix = matches.last;
      final matchedIncrement = matchedSuffix.group(1);
      final currentIncrement =
          (matchedIncrement == null || matchedIncrement == '')
              ? 0
              : int.parse(matchedIncrement);
      final strWithoutLabel =
          replaceRange(matchedSuffix.start, matchedSuffix.end, '').trim();
      return "$strWithoutLabel ${suffixFactory(currentIncrement + 1)}";
    }
    return "${this} ${suffixFactory(0)}";
  }

  List<String> get alphabet {
    return [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o'
    ];
  }

  String alphabetLetterFrom(int idx) {
    return alphabet[idx % alphabet.length];
  }
}

extension DateTimeAgoX on DateTime {
  String toTimeAgoString() {
    Duration diff = DateTime.now().difference(this);
    if (diff.inDays >= 1) {
      return '${diff.inDays} day(s) ago'.hardcoded;
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour(s) ago'.hardcoded;
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute(s) ago'.hardcoded;
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second(s) ago'.hardcoded;
    } else {
      return 'just now'.hardcoded;
    }
  }
}

typedef ListElementFactory<E> = E Function();

extension ListX<E> on List<E> {
  List<E> separatedBy(ListElementFactory<E> separatorBuilder) {
    final List<E> results = [];
    for (var i = 0; i < length; i++) {
      results.add(this[i]);
      if (i != length - 1) {
        results.add(separatorBuilder());
      }
    }
    return results;
  }
}