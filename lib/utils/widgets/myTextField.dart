import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/color_theme.dart';


class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.suffixIcon,
    this.onTap,
    this.focusNode,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final bool obscureText;
  final IconButton suffixIcon;
  final Function()? onTap;
  final ValueChanged<String>? onChanged;
  //VoidCallback(String)? onChanged;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.08,
      child: TextFormField(
        autofocus: true,
        focusNode: widget.focusNode,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          hintText: widget.labelText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 13,
          ),
          filled: true,
          fillColor: kTextWhiteColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: kPrimaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: kPrimaryColor,
              width: 2,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color:kErrorColor,
            ),
          ),
        ),
      ),
    );
  }
}