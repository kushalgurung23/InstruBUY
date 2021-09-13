import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instrubuy/smallComponents/constants.dart';
import 'package:instrubuy/smallComponents/sizeConfiguration.dart';
import 'package:instrubuy/smallComponents/titleText.dart';

double defaultSize = SizeConfig.defaultSize;

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String categoryImage;
  final String categoryNumber;
  final GestureTapCallback onTap;

  CategoryCard({@required this.categoryName, @required this.categoryImage, @required this.categoryNumber, @required this.onTap});

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
                      color:  kContainerColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TitleText(
                            title: categoryName,
                            color: Colors.black,
                          ),
                          SizedBox(
                            height: defaultSize,
                          ),
                          Text(
                            categoryNumber,
                            style: TextStyle(
                              color: kMiniTextColor,
                            ),
                          )
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
                    child: Image.network(categoryImage),
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

//CustomClipper is used for making custom clips
//Path is one-dimensional subset of a plane with a number of sub-paths and a current point.
class CategoryCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;
    double cornerSize = 30;

    //path.lineTo goes downwards
    path.lineTo(0, height - cornerSize);
    //curve from 0 (x1) to whole height (y1) [reference point]. It tries to curve towards x1,y1
    path.quadraticBezierTo(0, height, cornerSize,
        height); //x1,y1 = reference points, x2,y2 = end points
    path.lineTo(width - cornerSize, height);
    path.quadraticBezierTo(width, height, width, height - cornerSize);
    path.lineTo(width, cornerSize);
    path.quadraticBezierTo(width, 0, width - cornerSize, 0);
    path.lineTo(cornerSize, cornerSize * 0.75);
    path.quadraticBezierTo(0, cornerSize, 0, cornerSize * 2);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
