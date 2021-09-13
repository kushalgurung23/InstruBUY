import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/categoryCard.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/titleText.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';

double defaultSize = SizeConfig.defaultSize;

class CategoryProducts extends StatelessWidget {
  const CategoryProducts({
    Key key,
    this.image,
    this.category_name,
    this.onTap,
    this.textWidget,
  }) : super(key: key);

  final String image;
  final String category_name;
  final Function onTap;
  final Widget textWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(defaultSize * 1.4),
        child: SizedBox(
          width: defaultSize * 20.5, //205
          //creates a widget with specific aspect ratio
          child: AspectRatio(
            aspectRatio: 0.83,
            //In Stack, widgets are aligned in top left corner by default
            //Stack help us to use other icons over other widgets, example icons over image
            child: Stack(
              //It helps to keep new widgets at Center from bottom
              alignment: Alignment.bottomCenter,
              children: [
                //This is custom shape container, so we will use ClipPath
                ClipPath(
                  clipper: CategoryCustomShape(),
                  child: AspectRatio(
                    aspectRatio: 1.025,
                    child: Container(
                      padding: EdgeInsets.all(defaultSize * 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.deepPurpleAccent, Colors.blue]),
                      ),
                      //color: kContainerColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TitleText(
                            title: category_name,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: defaultSize,
                          ),
                          textWidget,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AspectRatio(
                    aspectRatio: 1.15,
                    child: CachedNetworkImage(
                      imageUrl:
                      image,
                      placeholder: (context,
                          url) =>
                          Padding(
                            padding: EdgeInsets.fromLTRB(defaultSize * 8, defaultSize * 9, defaultSize * 8, defaultSize * 4.5),
                            child: new CircularProgressIndicator(
                              color: kPrimaryColor,
                              backgroundColor: kPrimaryLightColor,
                            ),
                          ),
                      errorWidget: (context, url,
                          error) =>
                      new Icon(Icons.error),
                    )
                    //Image.network(image),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}