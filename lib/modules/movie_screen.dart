import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_application/model/movie_model.dart';
import 'package:video_player/video_player.dart';

class MovieScreen extends StatelessWidget {
  MovieScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);
  MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          ..._buildBackground(context, movie),

          /// Spread Object
          _buildMovie(context),
          _buildActions(context),
        ],
      ),
    );
  }

  List<Widget> _buildBackground(context, movie) {
    return [
      Container(
        height: double.infinity,
        color: const Color(0xFF000b49),
      ),
      Image.network(
        movie.imagePath,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .5,
        fit: BoxFit.cover,
      ),
      const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Color(0xFF000b49),
              ],
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
              stops: [0.3, 0.5],
            ),
          ),
        ),
      ),
    ];
  }

  Positioned _buildMovie(context) {
    return Positioned(
      bottom: 150.0,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              movie.name,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              '${movie.year} | ${movie.category} | ${movie.duration.inHours}h | ${movie.duration.inMinutes.remainder(60)}m',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            RatingBar.builder(
              initialRating: 3.3,
              minRating: 1,
              maxRating: 5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: true,
              itemCount: 5,
              itemSize: 30,
              unratedColor: Colors.white,
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
            const SizedBox(height: 20),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
              maxLines: 8,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(height: 1.75, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildActions(context) {
    return Positioned(
      bottom: 60.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * .425,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  'Add To Watchlist',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width * .425,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => _MoviePlayer(
                        movie: movie,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Start Watching',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoviePlayer extends StatefulWidget {
  const _MoviePlayer({
    Key? key,
    required this.movie,
  }) : super(key: key);
  final MovieModel movie;

  @override
  State<_MoviePlayer> createState() => _MoviePlayerState();
}

class _MoviePlayerState extends State<_MoviePlayer> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset(
      widget.movie.videoPath,
    )..initialize().then((value) {
        setState(() {});
      });

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Chewie(
          controller: chewieController,
        ),
      ),
    );
  }
}
