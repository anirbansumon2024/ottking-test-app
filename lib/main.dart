import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

void main() {
  runApp(const DashTVApp());
}

class DashTVApp extends StatelessWidget {
  const DashTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TVScreen(),
    );
  }
}

class TVScreen extends StatefulWidget {
  const TVScreen({super.key});

  @override
  State<TVScreen> createState() => _TVScreenState();
}

class _TVScreenState extends State<TVScreen> {
  BetterPlayerController? _betterPlayerController;

  // এখানে আপনার DASH (.mpd) এবং HLS (.m3u8) লিঙ্কগুলো দিন
  final List<Map<String, String>> channelList = [
    {
      "name": "DASH Sample Stream",
      "url": "https://dash.akamaized.net/envivio/EnvivioDash3/manifest.mpd",
      "type": "DASH"
    },
    {
      "name": "HLS Sample Stream",
      "url": "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
      "type": "HLS"
    },
    {
      "name": "Big Buck Bunny (MPD)",
      "url": "http://tvsen3.ottking.top/CloudTV/live/1928374650.m3u8",
      "type": "HLS"
    }
  ];

  int currentChannelIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupPlayer(channelList[0]['url']!);
  }

  void _setupPlayer(String url) {
    // আগের কন্ট্রোলার থাকলে তা ডিসপোজ করা
    _betterPlayerController?.dispose();

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      // DASH বা HLS নিজে থেকেই ডিটেক্ট করে নেবে, তবে চাইলে স্পেসিফিক করে দেওয়া যায়
      useAsymmetricGatekeeper: true, 
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
      ),
      betterPlayerDataSource: dataSource,
    );
    
    setState(() {});
  }

  void _changeChannel(int index) {
    setState(() {
      currentChannelIndex = index;
    });
    _setupPlayer(channelList[index]['url']!);
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DASH & HLS TV Player")),
      body: Column(
        children: [
          // ভিডিও প্লেয়ার অংশ
          Container(
            color: Colors.black,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _betterPlayerController != null
                  ? BetterPlayer(controller: _betterPlayerController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Live Channels", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          // চ্যানেল লিস্ট
          Expanded(
            child: ListView.builder(
              itemCount: channelList.length,
              itemBuilder: (context, index) {
                bool isSelected = currentChannelIndex == index;
                return ListTile(
                  leading: Icon(Icons.live_tv, color: isSelected ? Colors.red : Colors.grey),
                  title: Text(channelList[index]['name']!),
                  subtitle: Text(channelList[index]['type']!),
                  trailing: isSelected ? const Icon(Icons.equalizer, color: Colors.red) : null,
                  onTap: () => _changeChannel(index),
                  selected: isSelected,
                  tileColor: isSelected ? Colors.white10 : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
