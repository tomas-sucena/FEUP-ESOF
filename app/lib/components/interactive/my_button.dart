import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Text _text;
  final void Function()? _onTap;
  final Color? _color;

  /* CONSTRUCTOR */
  const MyButton(
      {required Text text,
      required void Function()? onTap,
      Color? color,
      Key? key})
      : _text = text,
        _onTap = onTap,
        _color = color,
        super(key: key);

  /* METHOD */
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _color ?? Theme.of(context).primaryColor,
      ),
      child: _text,
    );
  }
}
