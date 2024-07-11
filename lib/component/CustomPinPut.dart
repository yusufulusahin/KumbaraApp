import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPinPut extends StatefulWidget {
  const CustomPinPut(
      {super.key,
      required this.c0,
      required this.c1,
      required this.c2,
      required this.c3});

  final TextEditingController c0;
  final TextEditingController c1;
  final TextEditingController c2;
  final TextEditingController c3;

  @override
  State<CustomPinPut> createState() => _CustomPinPutState();
}

class _CustomPinPutState extends State<CustomPinPut> {
  final bool v1 = false;
  final bool v2 = false;
  final bool v3 = false;
  final bool v4 = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //1.TEXTFİELD
        SizedBox(
          height: 100,
          width: 80,
          child: TextFormField(
            validator: (value) => value == null ? '' : null,
            controller: widget.c0,
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: InputDecoration(
                errorText: v1 ? 'Kutucuk Boş Bırakılamaz' : null),
            style: Theme.of(context).textTheme.displayLarge,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
        //2.TEXTFİELD
        SizedBox(
          height: 100,
          width: 80,
          child: TextFormField(
            validator: (value) => value == null ? '' : null,
            controller: widget.c1,
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: InputDecoration(
                errorText: v2 ? 'Kutucuk Boş Bırakılamaz' : null),
            style: Theme.of(context).textTheme.displayLarge,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        //3.TEXTFİELD
        SizedBox(
          height: 100,
          width: 80,
          child: TextFormField(
            validator: (value) => value == null ? '' : null,
            controller: widget.c2,
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: InputDecoration(
                errorText: v3 ? 'Kutucuk Boş Bırakılamaz' : null),
            style: Theme.of(context).textTheme.displayLarge,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        ),
        //4.TEXTFİELD
        SizedBox(
          height: 100,
          width: 80,
          child: TextFormField(
            validator: (value) => value == null ? '' : null,
            controller: widget.c3,
            onChanged: (value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            },
            decoration: InputDecoration(
                errorText: v4 ? 'Kutucuk Boş Bırakılamaz' : null),
            style: Theme.of(context).textTheme.displayLarge,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
        )
      ],
    ));
  }
}
