import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DashBoardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData data;
  final Color color;
  const DashBoardCard({
    required this.title,
    required this.subtitle,
    required this.data,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.3,
      width: width * 0.215,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(5)),
        color: Colors.white,
        elevation: 5,
        shadowColor: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          textBaseline: TextBaseline.alphabetic,
          
          children: [
            Container(
              width: width * 0.003,
              decoration: BoxDecoration(
                color: color.withAlpha(200),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AutoSizeText(title),

                      Container(
                        decoration: BoxDecoration(
                          color: color.withAlpha(50),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: height * 0.05,
                        width: width * 0.05,
                        child: Icon(
                          data,
                          size: height * 0.035,
                          color: color.withAlpha(500),
                        ),
                      ),
                    ],
                  ),
                ),
                AutoSizeText(
                  subtitle,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
