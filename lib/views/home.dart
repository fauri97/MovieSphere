import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/controllers/movie_controller.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/routes/app_routes.dart';
import 'package:movie_app/widgets/appbar/navigation_drawer.dart';
import 'package:movie_app/widgets/home_view/home_cinema_listview.dart';
import 'package:movie_app/widgets/home_view/home_popular_listview.dart';
import 'package:movie_app/widgets/home_view/home_upcoming_listview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final movieController = Get.find<MovieController>();
  bool _isContainerVisible = false;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
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
          'MovieSphere',
          style: TextStyle(
            color: Colors.white,
            fontFamily: GoogleFonts.francoisOne().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
      ),
      drawer: const CustomNavigationDrawer(),
      body: GestureDetector(
        onTap: () {
          if (_isContainerVisible) {
            setState(() {
              _isContainerVisible = false;
              _overlayEntry?.remove();
            });
          }
        },
        child: Container(
          color: const Color.fromARGB(221, 49, 44, 44),
          child: RefreshIndicator(
            onRefresh: () => refreshMovies(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 16),
                    child: Text(
                      'Filmes populares',
                      style: TextStyle(
                        fontFamily: GoogleFonts.francoisOne().fontFamily,
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 250, child: PopularListView()),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 16),
                    child: Text(
                      'Em breve',
                      style: TextStyle(
                        fontFamily: GoogleFonts.francoisOne().fontFamily,
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 250, child: UpcomingListView()),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 16),
                    child: Text(
                      'Nos cinemas',
                      style: TextStyle(
                        fontFamily: GoogleFonts.francoisOne().fontFamily,
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 250, child: CinemaListView()),
                ],
              ),
            ),
          ),
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

  Future<void> refreshMovies() async {
    await movieController.fetchData(true);
  }

  Future<void> searchMovies(String query) async {
    if (query.length > 2) {
      List<Movie> movies = await movieController.getMoviesByQuery(query);
      Get.toNamed(Routes.SEARCH, arguments: movies);
    } else {
      Get.snackbar(
        'Erro',
        'Digite o nome do filme',
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
      );
    }
  }
}
