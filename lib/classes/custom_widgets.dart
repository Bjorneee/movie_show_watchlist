import 'package:flutter/material.dart';

/* =================== Movie Card =====================
 * 
 * General template for a movie/show card to
 * be used on all pages.
 * 
 * Home:  Used as list items representing 
 *        media instances. Can be clicked to redirect
 *        to item details page. Should display movie
 *        cover image or title if no image exists.
 * 
 * Add:   Used to display the cover of the 
 *        selected movie from search. If no item is
 *        searched, then can be clicked to prompt
 *        the user to add an image.
 * 
 * Details: Displays the current movie cover or
 *          title if no cover exists.
 * 
 */

class MediaCard extends StatelessWidget {

  const MediaCard ({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}