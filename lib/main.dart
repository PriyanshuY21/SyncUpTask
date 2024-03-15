import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CustomThemeType { light, dark }

class CustomThemeProvider with ChangeNotifier {
  ThemeData _customThemeData = lightCustomTheme;
  CustomThemeType _customThemeType = CustomThemeType.light;

  // Getter for theme type
  CustomThemeType get themeType => _customThemeType;

  // Getter for current theme data
  ThemeData get themeData => _customThemeData;

  // Function to toggle between light and dark themes
  void toggleTheme() {
    _customThemeType = _customThemeType == CustomThemeType.light
        ? CustomThemeType.dark
        : CustomThemeType.light;
    _customThemeData = _customThemeType == CustomThemeType.light
        ? lightCustomTheme
        : darkCustomTheme;
    notifyListeners(); // Notify listeners about the change
  }
}

final ThemeData lightCustomTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
);

final ThemeData darkCustomTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);

void main() {
  runApp(
    ChangeNotifierProvider<CustomThemeProvider>(
      create: (_) => CustomThemeProvider(),
      child: CustomApp(),
    ),
  );
}

class CustomApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'App',
          theme: themeProvider.themeData,
          darkTheme: darkCustomTheme,
          themeMode: themeProvider.themeType == CustomThemeType.light
              ? ThemeMode.light
              : ThemeMode.dark,
          initialRoute: '/',
          routes: {
            '/': (context) => CustomFeedScreen(),
            '/chat': (context) => CustomChatScreen(),
            '/profile': (context) => CustomProfileScreen(),
          },
        );
      },
    );
  }
}

class CustomFeedScreen extends StatefulWidget {
  @override
  _CustomFeedScreenState createState() => _CustomFeedScreenState();
}

class _CustomFeedScreenState extends State<CustomFeedScreen> {
  List<bool> _likedStatusList = List.filled(5, false);

  List<String> profileNames = [
    'username1',
    'username2',
    'username3',
    'username4',
    'username5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AppName',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 32,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.live_tv),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          List<String> imageUrls = [
            'https://images.lifestyleasia.com/wp-content/uploads/sites/2/2023/03/31113559/lamborghini-revuelto-v12-hybrid-hpev-high-performance-electrified-vehicle-hero-22.jpg',
            'https://r4.wallpaperflare.com/wallpaper/650/368/979/green-lamborghini-huracan-huracan-performante-lamborghini-huracan-performance-hd-wallpaper-5abc5f2d4fbb471bfb37caa458e5a556.jpg',
            'https://th.bing.com/th/id/OIP.HaZ9gazhg4-tspfSmeSVdQHaHa?rs=1&pid=ImgDetMain',
            'https://th.bing.com/th/id/OIP.1osF8wIAJgcETcvTAiw5kgHaE8?rs=1&pid=ImgDetMain',
            'https://www.hdcarwallpapers.com/download/lamborghini_huracan_sterrato_2023_8k-5120x2880.jpg',
          ];

          List<String> captions = [
            'Thunder roars even louder downtown. Lamborghini Revuelto harnesses hybrid power to elevate performance to dizzying heights. With its V12 aspirated engine and three high-density electric motors, you have never truly felt speed like this.',
            'Here are countless types of driver.Those who wish to speed on the tarmac.Others who appreciate a calming cruise.The guide and the passenger.Huracán Tecnica embodies all of these souls.',
            'The W16 MISTRAL: one of the automotive industry greatest engineering balancing acts ever.',
            'Valhalla is pure driving mastery',
            'No terrain truly challenges a Huracán Sterrato',
          ];
          String imageUrl = imageUrls[index % imageUrls.length];
          String caption = captions[index % captions.length];
          String profileName = profileNames[index % profileNames.length];

          return CustomPostItem(
            imageUrl: imageUrl,
            caption: caption,
            isLiked: _likedStatusList[index],
            onLiked: () {
              setState(() {
                _likedStatusList[index] = !_likedStatusList[index];
              });
            },
            profileName: profileName,
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              IconButton(
                icon: Icon(Icons.brightness_4), // Theme switch icon
                onPressed: () {
                  Provider.of<CustomThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPostItem extends StatelessWidget {
  final String imageUrl;
  final String caption;
  final bool isLiked;
  final VoidCallback onLiked;
  final String profileName;

  CustomPostItem({
    required this.imageUrl,
    required this.caption,
    required this.isLiked,
    required this.onLiked,
    required this.profileName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHE4vcD6O1-GAxEU2CDLEQlD140pQI94q5qA&usqp=CAU',
                ),
              ),
              SizedBox(width: 8),
              Text(
                profileName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          height: 300,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: isLiked
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                color: isLiked ? Colors.red : null,
                onPressed: onLiked,
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {},
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            caption,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomChatScreen extends StatefulWidget {
  @override
  _CustomChatScreenState createState() => _CustomChatScreenState();
}

class _CustomChatScreenState extends State<CustomChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return CustomMessageItem(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.brightness_4), // Theme switch icon
                  onPressed: () {
                    Provider.of<CustomThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      sendMessage(_messageController.text);
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String message) {
    setState(() {
      _messages.add(message);
      _messages.add('Automated Response: Thanks for your message!');
    });
  }
}

class CustomMessageItem extends StatelessWidget {
  final String message;

  CustomMessageItem(this.message);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final boxColor = isDarkTheme
        ? Color.fromARGB(255, 125, 10, 10)
        : Color.fromARGB(255, 135, 174, 183);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(message),
          ),
        ],
      ),
    );
  }
}

class CustomProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4), // Theme switch icon
            onPressed: () {
              Provider.of<CustomThemeProvider>(context, listen: false)
                  .toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHE4vcD6O1-GAxEU2CDLEQlD140pQI94q5qA&usqp=CAU'),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'priyanshu___gangwar___',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Text('Edit Profile'),
                                ),
                                SizedBox(width: 10),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: Text('View Archive'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(' posts'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '296',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(' followers'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '325',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(' following'),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'IITK\'25\n'
                          'Veni Vidi Vici\n',
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Photos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 9, // Change the number of photos as needed
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Text(
                        'Photo ${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
