import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:movie_show_watchlist/classes/media.dart';



/* ======================================================
 * 
 *                      CONTAINERS
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
 * ====================================================*/
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
                child: (mediaItem.posterPath != null) 
                  ? Image.network(mediaItem.posterPath!) 
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


class NavButton extends StatelessWidget {

  final double width;
  final double height;
  final Icon icon;

  const NavButton ({
    super.key,
    this.width = 50,
    this.height = 50,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: NavigationDestination(icon: icon, label: '', tooltip: ''),
    );
  }
}


class MediaListTile extends StatefulWidget {
  final Media mediaItem;
  final VoidCallback? onClick;

  const MediaListTile({
    super.key,
    required this.mediaItem,
    this.onClick,
  });

  @override
  State<MediaListTile> createState() => _MediaListTile();
}

class _MediaListTile extends State<MediaListTile> {

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onClick,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          height: 150,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (_isHovered)
              ? Theme.of(context).colorScheme.outlineVariant 
              : Theme.of(context).colorScheme.outline,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                width: 2
              ),
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                width: 2
              )
            )
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [

              SizedBox(
                width: 80,
                height: 120,
                child: (widget.mediaItem.posterPath != null && widget.mediaItem.posterPath != "")
                  ? Image.network(widget.mediaItem.posterPath ?? "")
                  : Icon(Icons.movie)
              ),

              Container(
                width: 275,
                height: 120,
                padding: EdgeInsets.all(10),
                alignment: .center,
                child: AutoSizeText(
                  widget.mediaItem.title,
                  minFontSize: 16,
                  maxFontSize: 24,
                  maxLines: 2,
                  overflow: .fade,
                )
              )

            ]
          )
        )
      )
    );
  }
}


/* ======================================================
 * 
 *       EXTENSIONS (Append to corresponding Widget)
 * 
 ======================================================== */



/* =================== SearchBar =====================
 * 
 * showAll(): Displays search icon and 'Search' hint
 *              text on search bar.
 * 
 * =================================================== */
extension SearchExtensions on SearchBar {

  // Ex: SearchBar(/* List any additional properties here */).showAll()
  SearchBar showAll({Function()? onTap, Function(PointerDownEvent)? onTapOutside, Function(String)? onChanged}) {
    return SearchBar(
      leading: Icon(Icons.search),
      hintText: 'Search',
      onTap: onTap,
      onTapOutside: onTapOutside,
      onChanged: onChanged,
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