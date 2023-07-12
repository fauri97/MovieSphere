import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/routes/app_routes.dart';
import 'package:movie_app/widgets/movie/movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final movieController = Get.find<MovieController>();
  bool _isContainerVisible = false;
  OverlayEntry? _overlayEntry;
  List<Movie> movies = Get.arguments;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(Routes.INITIAL);
          },
        ),
        backgroundColor: Colors.amber,
        actions: [
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.MYMOVIES);
            },
            child: const Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 255, 6, 6),
              size: 35,
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isContainerVisible = !_isContainerVisible;
              });

              if (_isContainerVisible) {
                _overlayEntry = OverlayEntry(builder: (context) {
                  return overlaySearchWidget(context);
                });

                Overlay.of(context).insert(_overlayEntry!);
              } else {
                _overlayEntry?.remove();
              }
            },
            child: const Icon(Icons.search, color: Colors.white70),
          ),
        ],
        iconTheme: const IconThemeData(
          color: Color.fromARGB(204, 255, 252, 252),
          size: 35,
        ),
        elevation: 3,
        title: Text(
          'Procurar',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.francoisOne().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(221, 49, 44, 44),
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
          itemCount: movies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            return MovieCard(movie: movies[index]);
          },
        ),
      ),
    );
  }

  Widget overlaySearchWidget(BuildContext context) {
    TextEditingController searchQueryController = TextEditingController();
    return Positioned(
      top: kToolbarHeight + 60,
      left: 5,
      right: 5,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isContainerVisible = false;
              _overlayEntry?.remove();
            });
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 80,
                  child: TextField(
                    controller: searchQueryController,
                    style: TextStyle(
                        fontFamily: GoogleFonts.lato().fontFamily,
                        fontSize: 22),
                    autocorrect: false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      label: Text(
                        'Filme',
                        style: TextStyle(
                            fontFamily: GoogleFonts.lato().fontFamily),
                      ),
                      labelStyle: TextStyle(
                          fontFamily: GoogleFonts.lato().fontFamily,
                          color: Colors.grey),
                    ),
                    onSubmitted: (value) {
                      searchMovies(value);
                      setState(() {
                        _isContainerVisible = false;
                      });
                      _overlayEntry?.remove();
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    searchMovies(searchQueryController.text);
                    setState(() {
                      _isContainerVisible = false;
                    });
                    _overlayEntry?.remove();
                  },
                  child: const Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> searchMovies(String query) async {
    List<Movie> movies = await movieController.getMoviesByQuery(query);
    Get.offAllNamed(Routes.SEARCH, arguments: movies);
  }
}
