import 'package:flex/helper/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatefulWidget {

  final String title;
  final String error;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String prefixText;
  final String suffixText;
  final List<TextInputFormatter> formatter;
  final String initialValue;
  final ValueSetter<String> onChange;
  final bool shouldRebuild;
  final bool enabled;
  final int maxLines;
  final bool currencyFormat;
  final bool obscureText;
  final String Function(String) validator;


  CustomTextField({
    @required this.title,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.prefixText,
    this.suffixText,
    this.error,
    this.formatter,
    this.initialValue = "",
    this.onChange,
    this.shouldRebuild = false,
    this.enabled = true,
    this.currencyFormat = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();

  static String defaultFormat(String value){
    final format = NumberFormat.decimalPattern('en_US');
    return format.format(int.parse(value.split('.').first.replaceAll(',', ''))) + '.' + value.split('.').last;
  }

}

class _CustomTextFieldState extends State<CustomTextField> {

  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);

    if(widget.currencyFormat){
      _textEditingController.addListener(() {
        var string = _textEditingController.text;
        int prevlenght = string.length;
        bool contain = false;
        TextSelection previousSelection = _textEditingController.selection;
        var splitnum;

        if (string.isEmpty) {
          string = '0.00';
        }

        if (string.contains('-')) {
          string = string.replaceAll('-', '');
        }

        if (string.contains(' ')) {
          string = string.replaceAll(' ', '');
        }

        if (string.contains('.')) {
          var split = string.split('.');

          //checking the whole number is empty
          if (split[0].isEmpty) {
            split[0] = '0';
          }

          // format whole number with thousand separator
          splitnum = '${_formatNumber(split[0].replaceAll(',', ''))}';

          //Controlling decimal number up to 2 digits
          if (split[1].length < 2) {
            string = '${splitnum + '.' + split[1]}';
          } else {
            string = '${splitnum + '.' + split[1].substring(0, 2)}';
          }
        } else {
          // Keep the currency format 0.00 at the beginning
          string = '${_formatNumber(string.replaceAll(',', '')) + '.' + '00'}';
        }

        // managing the changes occar when thousand seprator adding and removing
        if (prevlenght == (string.length + 1) ||
            prevlenght == (string.length - 1)) {
          var selectionValue;

          if (prevlenght > string.length) {
            selectionValue =
                previousSelection.end - 1; // setting selectionValue when deleting
          } else {
            selectionValue =
                previousSelection.end + 1; // setting selectionValue when deleting
          }

          // check whether adding or deleting done inside the text
          if (_textEditingController.selection.end < string.length) {
            contain = true;
          }

          // setting selection when thousand seprator is  added
          _textEditingController.value = _textEditingController.value.copyWith(
            text: string,
            selection: TextSelection(
                baseOffset: contain ? selectionValue : string.length,
                extentOffset: contain ? selectionValue : string.length),
            composing: TextRange.empty,
          );
        } else {
          // setting selection when thousand seprator is not added
          _textEditingController.value = _textEditingController.value
              .copyWith(text: string, selection: previousSelection);
        }
      });
    }

  }

  String _formatNumber(String string) {
    final format = NumberFormat.decimalPattern('en_US');
    return format.format(int.parse(string));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.shouldRebuild){
      _textEditingController = TextEditingController(text: widget.initialValue);
    }

    return TextFormField(
      controller: _textEditingController,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      cursorColor: PRIMARY_COLOR,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: PRIMARY_COLOR),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 0.5),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        labelText: widget.title,
        contentPadding: widget.maxLines == 1 ? EdgeInsets.only() : EdgeInsets.only(bottom: 8.0),
        labelStyle: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
          fontSize: 16.0,
          color: PRIMARY_COLOR,
          fontWeight: FontWeight.w300,
        ),
        prefixText: widget.prefixText,
        prefixStyle: Theme.of(context).primaryTextTheme.title.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
        suffixText: widget.suffixText,
        suffixStyle: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: PRIMARY_COLOR,
        ),
        errorText: widget.error,
        errorStyle: Theme.of(context).primaryTextTheme.bodyText1.copyWith(
          fontSize: 12.0,
          color: Colors.red,
        ),
      ),
      style: widget.enabled ? Theme.of(context).primaryTextTheme.bodyText1.copyWith(
        fontSize: 16.0,
        color: PRIMARY_COLOR,
        fontWeight: FontWeight.w400,
      ) : Theme.of(context).primaryTextTheme.bodyText1.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        color: PRIMARY_COLOR,
      ),
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      inputFormatters: widget.formatter,
      validator: widget.validator,
      onChanged: (_) => widget.onChange(_textEditingController.text),
    );
  }
}
