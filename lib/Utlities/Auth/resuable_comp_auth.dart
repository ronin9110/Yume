import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:yume/Utlities/Auth/googleauth.dart';
import 'package:yume/Theme/light_mode.dart';

void worngCred(String str, context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
          size: 50,
        ),
        title: Center(
          child: Text(
            str,
            style: const TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),
          ),
        ),
        elevation: 20,
        shadowColor: Theme.of(context).colorScheme.primary,
      );
    },
  );
}

void succsessCred(String str, context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text(
            str,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        elevation: 20,
        shadowColor: Theme.of(context).colorScheme.primary,
      );
    },
  );
}

Widget logo(double height_, double width_, context) {
  final theme = (Theme.of(context).colorScheme) == (lightMode.colorScheme);
  if (theme) {
    return Image.asset(
      'assets/LogoLight.png',
      height: height_,
      width: width_,
    );
  } else {
    return Image.asset(
      'assets/LogoDark.png',
      height: height_,
      width: width_,
    );
  }
}

Widget richText(double fontSize, String str, context) {
  return Text.rich(
    textAlign: TextAlign.center,
    TextSpan(
      style: TextStyle(
        fontSize: fontSize,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 2.000000061035156,
      ),
      children: [
        TextSpan(
          text: str,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontFamily: 'Circular book',
          ),
        ),
      ],
    ),
  );
}

Widget textInputField(
    {required Size size,
    required TextEditingController controller,
    required TextInputType inputType,
    required String hintText,
    required IconData icon,
    required context,
    ob = false,
    formatters,
    Function? onsub,
    bool? en,
    double width = 1}) {
  final textBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide:
        BorderSide(color: Theme.of(context).colorScheme.primary, width: 3),
  );

  return SizedBox(
    height: size.height / 13,
    width: size.width / width,
    child: TextField(
      enabled: en,
      inputFormatters: formatters,
      obscureText: ob,
      controller: controller,
      style: TextStyle(
        fontSize: 16.0,
        color: Theme.of(context).colorScheme.inversePrimary,
        fontFamily: 'Circular book',
      ),
      onEditingComplete: () {
        onsub!();
      },
      maxLines: 1,
      keyboardType: inputType,
      cursorColor: Theme.of(context).colorScheme.primary,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(23),
          prefixIcon: Icon(
            icon,
            size: 23,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 18.0,
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6),
            height: 1.0,
            fontWeight: FontWeight.w100,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          focusedBorder: textBorder,
          disabledBorder: textBorder,
          enabledBorder: textBorder,
          border: InputBorder.none),
    ),
  );
}

Widget styledButton(Size size, String str, context, ontap) {
  return GestureDetector(
    onTap: ontap,
    child: Container(
      alignment: Alignment.center,
      height: size.height / 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
            offset: const Offset(0, 15.0),
            blurRadius: 60.0,
          ),
        ],
      ),
      child: Text(
        str,
        style: TextStyle(
          fontSize: 20.0,
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.w900,
          height: 1.5,
          fontFamily: 'Circular book',
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget extraSignIn(context) {
  Widget contain(String str) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      height: 44.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Theme.of(context).colorScheme.primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.string(
            str,
            width: 22.44,
            height: 22.44,
          ),
          const SizedBox(
            width: 7,
          ),
          Text(
            "Sign In with Google",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      GestureDetector(
        onTap: () {
          UserCredential user = AuthService().signInWithGoggle();
        },
        child: contain(
            '<svg viewBox="11.0 11.0 22.92 22.92" ><path transform="translate(11.0, 11.0)" d="M 22.6936149597168 9.214142799377441 L 21.77065277099609 9.214142799377441 L 21.77065277099609 9.166590690612793 L 11.45823860168457 9.166590690612793 L 11.45823860168457 13.74988651275635 L 17.93386268615723 13.74988651275635 C 16.98913192749023 16.41793632507324 14.45055770874023 18.33318138122559 11.45823860168457 18.33318138122559 C 7.661551475524902 18.33318138122559 4.583295345306396 15.25492572784424 4.583295345306396 11.45823860168457 C 4.583295345306396 7.661551475524902 7.661551475524902 4.583295345306396 11.45823860168457 4.583295345306396 C 13.21077632904053 4.583295345306396 14.80519008636475 5.244435787200928 16.01918983459473 6.324374675750732 L 19.26015281677246 3.083411931991577 C 17.21371269226074 1.176188230514526 14.47633838653564 0 11.45823860168457 0 C 5.130426406860352 0 0 5.130426406860352 0 11.45823860168457 C 0 17.78605079650879 5.130426406860352 22.91647720336914 11.45823860168457 22.91647720336914 C 17.78605079650879 22.91647720336914 22.91647720336914 17.78605079650879 22.91647720336914 11.45823860168457 C 22.91647720336914 10.68996334075928 22.83741569519043 9.940022468566895 22.6936149597168 9.214142799377441 Z" fill="#ffc107" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.32, 11.0)" d="M 0 6.125000953674316 L 3.764603137969971 8.885863304138184 C 4.78324031829834 6.363905429840088 7.250198841094971 4.583294868469238 10.13710117340088 4.583294868469238 C 11.88963890075684 4.583294868469238 13.48405265808105 5.244434833526611 14.69805240631104 6.324373722076416 L 17.93901443481445 3.083411693572998 C 15.89257335662842 1.176188111305237 13.15520095825195 0 10.13710117340088 0 C 5.735992908477783 0 1.919254422187805 2.484718799591064 0 6.125000953674316 Z" fill="#ff3d00" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.26, 24.78)" d="M 10.20069408416748 9.135653495788574 C 13.16035556793213 9.135653495788574 15.8496036529541 8.003005981445312 17.88286781311035 6.161093711853027 L 14.33654403686523 3.160181760787964 C 13.14749050140381 4.064460277557373 11.69453620910645 4.553541660308838 10.20069408416748 4.55235767364502 C 7.220407009124756 4.55235767364502 4.689855575561523 2.6520094871521 3.736530303955078 0 L 0 2.878881216049194 C 1.896337866783142 6.589632034301758 5.747450828552246 9.135653495788574 10.20069408416748 9.135653495788574 Z" fill="#4caf50" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(22.46, 20.17)" d="M 11.23537635803223 0.04755179211497307 L 10.31241607666016 0.04755179211497307 L 10.31241607666016 0 L 0 0 L 0 4.583295345306396 L 6.475625038146973 4.583295345306396 C 6.023715496063232 5.853105068206787 5.209692478179932 6.962699413299561 4.134132385253906 7.774986743927002 L 4.135851383209229 7.773841857910156 L 7.682177066802979 10.77475357055664 C 7.431241512298584 11.00277233123779 11.45823955535889 8.020766258239746 11.45823955535889 2.291647672653198 C 11.45823955535889 1.523372769355774 11.37917804718018 0.773431122303009 11.23537635803223 0.04755179211497307 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>'),
      ),
    ],
  );
}

class NeoBox extends StatelessWidget {
  final Widget? widget;
  const NeoBox({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary,
              blurRadius: 5,
              offset: const Offset(1, 1),
            ),
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary,
              blurRadius: 5,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: widget,
      ),
    );
  }
}

class CustomDateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '/', oldValue);
    return newValue.copyWith(
        text: text, selection: _updateCursorPosition(text, oldValue));
  }
}

String _format(String value, String seperator, TextEditingValue old) {
  var finalString = '';
  var dd = '';
  var mm = '';
  var yyy = '';
  var oldVal = old.text;
  var temp_oldVal = oldVal;
  var temp_value = value;
  if (!oldVal.contains(seperator) ||
      oldVal.isEmpty ||
      seperator.allMatches(oldVal).length < 2) {
    oldVal += '///';
  }
  if (!value.contains(seperator) || _backSlashCount(value) < 2) {
    value += '///';
  }
  var splitArrOLD = oldVal.split(seperator);
  var splitArrNEW = value.split(seperator);
  for (var i = 0; i < 3; i++) {
    splitArrOLD[i] = splitArrOLD[i].toString().trim();
    splitArrNEW[i] = splitArrNEW[i].toString().trim();
  }
  // block erasing
  if ((splitArrOLD[0].isNotEmpty &&
          splitArrOLD[2].isNotEmpty &&
          splitArrOLD[1].isEmpty &&
          temp_value.length < temp_oldVal.length &&
          splitArrOLD[0] == splitArrNEW[0] &&
          splitArrOLD[2].toString().trim() ==
              splitArrNEW[1].toString().trim()) ||
      (_backSlashCount(temp_oldVal) > _backSlashCount(temp_value) &&
          splitArrNEW[1].length > 2) ||
      (splitArrNEW[0].length > 2 && _backSlashCount(temp_oldVal) == 1) ||
      (_backSlashCount(temp_oldVal) == 2 &&
          _backSlashCount(temp_value) == 1 &&
          splitArrNEW[0].length > splitArrOLD[0].length)) {
    finalString = temp_oldVal; // making the old date as it is
  } else {
    if (splitArrNEW[0].length > splitArrOLD[0].length) {
      if (splitArrNEW[0].length < 3) {
        dd = splitArrNEW[0];
      } else {
        for (var i = 0; i < 2; i++) {
          dd += splitArrNEW[0][i];
        }
      }
      if (dd.length == 2 && !dd.contains(seperator)) {
        dd += seperator;
      }
    } else if (splitArrNEW[0].length == splitArrOLD[0].length) {
      if (oldVal.length > value.length && splitArrNEW[1].isEmpty) {
        dd = splitArrNEW[0];
      } else {
        dd = splitArrNEW[0] + seperator;
      }
    } else if (splitArrNEW[0].length < splitArrOLD[0].length) {
      if (oldVal.length > value.length &&
          splitArrNEW[1].isEmpty &&
          splitArrNEW[0].isNotEmpty) {
        dd = splitArrNEW[0];
      } else if (temp_oldVal.length > temp_value.length &&
          splitArrNEW[0].isEmpty &&
          _backSlashCount(temp_value) == 2) {
        dd += seperator;
      } else {
        if (splitArrNEW[0].isNotEmpty) {
          dd = splitArrNEW[0] + seperator;
        }
      }
    }

    if (dd.isNotEmpty) {
      finalString = dd;
      if (dd.length == 2 &&
          !dd.contains(seperator) &&
          oldVal.length < value.length &&
          splitArrNEW[1].isNotEmpty) {
        if (seperator.allMatches(dd).isEmpty) {
          finalString += seperator;
        }
      } else if (splitArrNEW[2].isNotEmpty &&
          splitArrNEW[1].isEmpty &&
          temp_oldVal.length > temp_value.length) {
        if (seperator.allMatches(dd).isEmpty) {
          finalString += seperator;
        }
      } else if (oldVal.length < value.length &&
          (splitArrNEW[1].isNotEmpty || splitArrNEW[2].isNotEmpty)) {
        if (seperator.allMatches(dd).isEmpty) {
          finalString += seperator;
        }
      }
    } else if (_backSlashCount(temp_oldVal) == 2 && splitArrNEW[1].isNotEmpty) {
      dd += seperator;
    }
    if (splitArrNEW[0].length == 3 && splitArrOLD[1].isEmpty) {
      mm = splitArrNEW[0][2];
    }

    if (splitArrNEW[1].length > splitArrOLD[1].length) {
      if (splitArrNEW[1].length < 3) {
        mm = splitArrNEW[1];
      } else {
        for (var i = 0; i < 2; i++) {
          mm += splitArrNEW[1][i];
        }
      }
      if (mm.length == 2 && !mm.contains(seperator)) {
        mm += seperator;
      }
    } else if (splitArrNEW[1].length == splitArrOLD[1].length) {
      if (splitArrNEW[1].isNotEmpty) {
        mm = splitArrNEW[1];
      }
    } else if (splitArrNEW[1].length < splitArrOLD[1].length) {
      if (splitArrNEW[1].isNotEmpty) {
        mm = splitArrNEW[1] + seperator;
      }
    }

    if (mm.isNotEmpty) {
      finalString += mm;
      if (mm.length == 2 && !mm.contains(seperator)) {
        if (temp_oldVal.length < temp_value.length) {
          finalString += seperator;
        }
      }
    }
    if (splitArrNEW[1].length == 3 && splitArrOLD[2].isEmpty) {
      yyy = splitArrNEW[1][2];
    }

    if (splitArrNEW[2].length > splitArrOLD[2].length) {
      if (splitArrNEW[2].length < 5) {
        yyy = splitArrNEW[2];
      } else {
        for (var i = 0; i < 4; i++) {
          yyy += splitArrNEW[2][i];
        }
      }
    } else if (splitArrNEW[2].length == splitArrOLD[2].length) {
      if (splitArrNEW[2].isNotEmpty) {
        yyy = splitArrNEW[2];
      }
    } else if (splitArrNEW[2].length < splitArrOLD[2].length) {
      yyy = splitArrNEW[2];
    }

    if (yyy.isNotEmpty) {
      if (_backSlashCount(finalString) < 2) {
        if (splitArrNEW[0].isEmpty && splitArrNEW[1].isEmpty) {
          finalString = seperator + seperator + yyy;
        } else {
          finalString = finalString + seperator + yyy;
        }
      } else {
        finalString += yyy;
      }
    } else {
      if (_backSlashCount(finalString) > 1 && oldVal.length > value.length) {
        var valueUpdate = finalString.split(seperator);
        finalString = valueUpdate[0] + seperator + valueUpdate[1];
      }
    }
  }

  return finalString;
}

TextSelection _updateCursorPosition(String text, TextEditingValue oldValue) {
  var endOffset = max(
    oldValue.text.length - oldValue.selection.end,
    0,
  );
  var selectionEnd = text.length - endOffset;
  return TextSelection.fromPosition(TextPosition(offset: selectionEnd));
}

int _backSlashCount(String value) {
  return '/'.allMatches(value).length;
}

valdob(value) {
  if (value == null || value.isEmpty) {
    return 'need to inform date';
  }
  if (value.length >= 10) {
    try {
      if (int.parse(value.substring(0, 2)) > 31) {
        return 'invalid date';
      }
      if (int.parse(value.substring(3, 5)) > 12) {
        return 'invalid date';
      }
      var data = DateFormat('dd/MM/yyyy').parse(value);
//test date is between 100 old or 100 years ahead
      return ((data.isAfter(DateTime.now().add(Duration(days: 36500)))) ||
              (data.isBefore(DateTime.now().subtract(Duration(days: 36500)))))
          ? 'invalid date'
          : null;
    } catch (e) {
      return 'invalid date';
    }
  }
  return null;
}
