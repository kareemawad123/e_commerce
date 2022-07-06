import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OffersCard extends StatelessWidget {
  final String url;
  final String offerName;
  const OffersCard({Key? key, required this.url, required this.offerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(10),
      height: size.height*0.18,
      width: size.width*0.8,
      //color: Colors.red,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: <Widget>[
            Image(
              height: size.height*0.18,
              image: CachedNetworkImageProvider(url),fit: BoxFit.cover,),
            Container(
              width: size.width*0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF343434).withOpacity(0.4),
                    Color(0xFF343434).withOpacity(0.15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: offerName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
