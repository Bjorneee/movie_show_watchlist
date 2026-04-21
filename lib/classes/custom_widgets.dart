import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/media.dart';



/* ======================================================
 * 
 *                  CONTAINERS TO USE
 * 
 ======================================================== */



/* =================== Movie Card =====================
 * 
 * General template for a movie/show card to
 * be used on all pages. Though there are width/height
 * fields, sizes should be responsive for the app (
 * determined by parent container)
 * 
 * Home:  Used as list items representing 
 *        media instances. Can be clicked to redirect
 *        to item details page. Should display movie
 *        cover image or title if no image exists.
 * 
 * Add:   Used to display the cover of the 
 *        selected movie from search. If no item is
 *        searched, then can be clicked to prompt
 *        the user to add an image. (Since mediaItem
 *        is required, you can create a media instance
 *        with title: '+' to match figma design)
 * 
 * Details: Displays the current movie cover or
 *          title if no cover exists.
 * 
 */

class MediaCard extends StatelessWidget {

  final double? width;
  final double? height;
  final Media mediaItem;
  final Function()? onClick;

  const MediaCard ({
    super.key,
    this.width,
    this.height,
    required this.mediaItem,
    this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Card(
        child: Stack(
          children: [

            Container(
              width: width,
              height: height,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x262563EB),
                    offset: Offset(0, 1),
                    blurRadius: 20,
                    blurStyle: .outer,
                    spreadRadius: 0
                  ),
                  BoxShadow(
                    color: Color(0x66000000),
                    offset: Offset(0, 2),
                    blurRadius: 30,
                    blurStyle: .outer,
                    spreadRadius: 0
                  )
                ]
              ),
              child: Center(
                child: (mediaItem.coverImagePath != null) 
                  ? Image.asset(mediaItem.coverImagePath!) 
                  : Text(
                    mediaItem.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  )
              ),
            ),

            Positioned.fill(
              child: (mediaItem.status != Status.notWatched)
                ? MediaCardOverlay(status: mediaItem.status)
                : Text(''),
            )

          ],
        )
      )
    );
  }
}



/* ======================================================
 * 
 *                  HELPERS (DO NOT USE)
 * 
 ======================================================== */



class MediaCardOverlay extends StatelessWidget {

  final Status status;

  const MediaCardOverlay ({
    super.key,
    required this.status
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath (
      clipper: RightTriangleClipper(),
      child: Container(
        padding: EdgeInsets.all(10),
        color: status.color.withAlpha(0x3F),
        child: Align(
          alignment: .bottomRight,
          child: Text(
            status.string,
            style: TextStyle(
              fontSize: 24,
              color: Color(0x3FFFFFFF)
            ),
          ),
        )
      )
    );
  }
}

class RightTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}