import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.onChanged, 
    this.onFieldSubmitted, 
    this.validator, 
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40)
    );

    const borderRadius = Radius.circular(15);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: borderRadius, bottomLeft: borderRadius, bottomRight: borderRadius ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0,5)
          )
        ]
      ),
      child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle( fontSize: 20, color: Colors.black54 ),
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
