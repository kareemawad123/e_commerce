import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';


class CategoryItem extends StatelessWidget {
  final String cName;
  final GestureTapCallback press;
  final Icon cIcon;
  const CategoryItem({Key? key, required this.cName, required this.press, required, required this.cIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: press,
      child: Container(
        width: size.width*0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SimpleShadow(
              child: Container(
                padding: EdgeInsets.all(15),
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: Color(0xFF99e5ff),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: cIcon,
              ),
            ),
            SizedBox(height: 5),
            Text(cName, textAlign: TextAlign.center)
          ],
        ),
      ),

    );
  }
}
