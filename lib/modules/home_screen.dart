import 'package:flutter/material.dart';
import 'package:movie_application/model/movie_model.dart';
import 'package:movie_application/modules/movie_screen.dart';

import '../widgets/movie_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MovieModel> movies = MovieModel.movies;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130.0,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: _CustomClipper(),
          child: Container(
            color: const Color(0xff000b49),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 25.0,
                ),
                child: Text(
                  'Explore',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headline6,
                  children: [
                    TextSpan(
                      text: 'Featured ',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(
                      text: 'Movies',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              for (final movie in movies)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieScreen(
                          movie: movie,
                        ),
                      ),
                    );
                  },
                  child: MovieListItems(
                    information:
                    '${movie.year} | ${movie.category} | ${movie.duration.inHours}h | ${movie.duration.inMinutes.remainder(60)}m',
                       name: movie.name,
                    imageUrl: movie.imagePath,
                  ),
                ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 65);
    path.quadraticBezierTo(width / 2, height, width, height - 65);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
