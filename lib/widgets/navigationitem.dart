import "package:flutter/material.dart";
import "navigationview.dart";
class NavigatorItem extends StatelessWidget {
  const NavigatorItem({
    super.key,
    required this.height,
    required this.width,
    required this.navigationItem,
    required this.selectedIndex,
  });

  final double height;
  final double width;
  final NavigationItem navigationItem;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final primaryColor =  Theme.of(context).primaryColor;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * 0.005,
        horizontal: width * 0.002,
      ),
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      decoration: BoxDecoration(
        color: selectedIndex == navigationItem.id ? primaryColor.withAlpha(50) : Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          (selectedIndex == navigationItem.id)
              ? Container(
                  height: height * 0.03,
                  width: width * 0.002,
                  decoration: BoxDecoration(
                     color: Theme.of(context).primaryColor,
                     borderRadius: BorderRadius.circular(1)
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(width: width * 0.005),
          Icon(navigationItem.data, size:selectedIndex == navigationItem.id ?  20: 15 , color: selectedIndex == navigationItem.id ? primaryColor : Colors.black87 ,),
          SizedBox(width: width * 0.005),
          Text(navigationItem.name , style: TextStyle(fontSize:14 , color:selectedIndex == navigationItem.id ? primaryColor : Colors.black87 , )),
        ],
      ),
    );
  }
}