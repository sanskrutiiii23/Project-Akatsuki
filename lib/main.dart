import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const FoodReelsApp());
}

class FoodReelsApp extends StatelessWidget {
  const FoodReelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const FeedScreen(),
    );
  }
}

class Reel {
  final String title;
  final String restaurant;
  final String description;
  final String videoUrl;
  final String likes;
  final String saves;
  final double rating;
  final double distance;
  final int deliveryTime;
  final int price;

  Reel({
    required this.title,
    required this.restaurant,
    required this.description,
    required this.videoUrl,
    required this.likes,
    required this.saves,
    required this.rating,
    required this.distance,
    required this.deliveryTime,
    required this.price,
  });
}

final List<Reel> foodList = [
  Reel(
    title: "Truffle Burger",
    restaurant: "Burger Farm",
    description:
        "Juicy grilled patty with truffle mayo, cheddar melt & crispy onions.",
    videoUrl:
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    likes: "1.2K",
    saves: "892",
    rating: 4.8,
    distance: 2.1,
    deliveryTime: 20,
    price: 299,
  ),
  Reel(
    title: "Loaded Pizza",
    restaurant: "Pizza Hub",
    description:
        "Wood-fired pizza loaded with cheese and fresh toppings.",
    videoUrl:
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    likes: "2.5K",
    saves: "1.1K",
    rating: 4.7,
    distance: 1.8,
    deliveryTime: 18,
    price: 349,
  ),
];

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  int index = 0;
  int selectedTab = 0;
  Set<int> likedItems = {};
  Set<int> savedItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: foodList.length,
        onPageChanged: (index) {
          setState(() {
            this.index = index;
          });
        },
        itemBuilder: (context, index) {
          return ReelCard(
            reel: foodList[index],
            isActive: selectedTab == 1 && this.index == index,
            isLiked: likedItems.contains(index),
            isSaved: savedItems.contains(index),
            onLike: () {
              setState(() {
                if (likedItems.contains(index)) {
                  likedItems.remove(index);
                } else {
                  likedItems.add(index);
                }
              });
            },
            onSave: () {
              setState(() {
                if (savedItems.contains(index)) {
                  savedItems.remove(index);
                } else {
                  savedItems.add(index);
                }
              });
            },
            selectedTab: selectedTab,
            onHomeTap: () {
              setState(() {
                selectedTab = 0;
              });
            },
            onReelsTap: () {
              setState(() {
                selectedTab = 1;
              });
            },
          );
        },
      ),
    );
  }
}

class ReelCard extends StatefulWidget {
  final Reel reel;
  final bool isActive;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final int selectedTab;
  final VoidCallback onHomeTap;
  final VoidCallback onReelsTap;

  const ReelCard({
    super.key,
    required this.reel,
    required this.isActive,
    required this.isLiked,
    required this.isSaved,
    required this.onLike,
    required this.onSave,
    required this.selectedTab,
    required this.onHomeTap,
    required this.onReelsTap,
  });

  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  late VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();

    videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.reel.videoUrl),
    )
      ..initialize().then((_) {
        videoController.setLooping(true);

        if (widget.isActive) {
          videoController.play();
        }

        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant ReelCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive) {
      videoController.play();
    } else {
      videoController.pause();
    }
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!videoController.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [

        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: VideoPlayer(videoController),
        ),

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black45,
                Colors.transparent,
                Colors.black54,
                Colors.black87,
              ],
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on,size:18),
                            SizedBox(width: 4),
                            Text(
                              "Jaipur",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text("Trending near you 🔥"),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.more_vert),
                    )
                  ],
                ),

                const Spacer(),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Best Seller ₹${widget.reel.price}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            widget.reel.title,
                            style: const TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                widget.reel.restaurant,
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified,
                                color: Colors.orange,
                                size: 18,
                              )
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            widget.reel.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text("${widget.reel.rating}"),
                              const SizedBox(width: 20),
                              Text("${widget.reel.distance} km"),
                              const SizedBox(width: 20),
                              Text("${widget.reel.deliveryTime} mins"),
                            ],
                          ),

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),

                    Column(
                      children: [

                        IconButton(
                          onPressed: widget.onLike,
                          icon: Icon(
                            widget.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: widget.isLiked ? Colors.red : Colors.white,
                            size: 34,
                          ),
                        ),

                        Text(widget.reel.likes),

                        const SizedBox(height: 20),

                        IconButton(
                          onPressed: widget.onSave,
                          icon: Icon(
                            widget.isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: widget.isSaved ? Colors.orange : Colors.white,
                            size: 34,
                          ),
                        ),

                        Text(widget.reel.saves),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "View Menu",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.white12,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: [

                      GestureDetector(
                        onTap: widget.onHomeTap,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home,
                              color: widget.selectedTab == 0 ? Colors.orange : Colors.white,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(
                                color: widget.selectedTab == 0 ? Colors.orange : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: widget.onReelsTap,
                        child: Icon(
                          Icons.movie_creation_outlined,
                          color: widget.selectedTab == 1 ? Colors.orange : Colors.white,
                        ),
                      ),

                      Container(
                        width: 55,
                        height: 55,
                        decoration: const BoxDecoration(
                          color: Colors.deepOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 30,
                        ),
                      ),

                      const Icon(Icons.bookmark_border),

                      const Icon(Icons.person_outline),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}