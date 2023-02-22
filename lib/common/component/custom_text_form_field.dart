import 'package:flutter/material.dart';
import 'package:flutter_intermediate/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {

  final String? errorText;
  final String? hintText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    Key? key,
    this.obscureText = false,
    this.autofocus = false,
    this.onChanged,
    this.hintText,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      )
    ); // 테두리가 있는 입력하는 border

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText, // 비밀번호
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20), // textField 안에 padding 값 추가
          hintText: hintText, // hint 텍스트
          errorText: errorText, // 에러가 존재하는 경우 사용
          hintStyle: const TextStyle(
            color: BODY_TEXT_COLOR,
            fontSize: 14.0
          ),
        fillColor: INPUT_BG_COLOR,
        filled: true, // false - 색상 배경색 없음, true - 색상 배경색 있음
        border: baseBorder,
        enabledBorder: baseBorder, // 선택되지 않은 상태에서 활성화 되는 border
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          )
        ),
      ),
    );
  }
}
