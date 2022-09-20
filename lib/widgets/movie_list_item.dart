import 'package:flutter/material.dart';

class MovieListItems extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String information;
  final GlobalKey backgroundImageKey = GlobalKey();

  MovieListItems({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.information,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 14.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          15.0,
        ),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Stack(
            children: [
              Flow(
                delegate: _ParallaxFlowDelegate(
                  listItemContext: context,
                  scrollable: Scrollable.of(context)!,
                  backgroundImageKey: backgroundImageKey,
                ),
                children: [
                  Image.network(
                    width: double.infinity,
                    key: backgroundImageKey,
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(
                          .7,
                        ),
                      ],
                      stops: const [0.5, 0.8],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      information,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}

class _ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  _ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: constraints.maxWidth);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
    (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect = verticalAlignment.inscribe(
      backgroundSize,
      Offset.zero & listItemSize,
    );

    // Paint the background.
    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(
          0.0,
          childRect.top,
        ),
      ).transform,
    );
  }

  @override
  bool shouldRepaint(_ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}
