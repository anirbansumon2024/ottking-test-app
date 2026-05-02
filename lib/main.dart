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
      title: 'Live TV App',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.dark),
      ),
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

  // এখানে আপনার চ্যানেল লিষ্ট বসাবেন
  final List<Map<String, String>> channelList = [
    {
      "name": "DASH Sample Stream",
      "url": "https://dash.akamaized.net/envivio/EnvivioDash3/manifest.mpd",
      "type": "DASH (.mpd)"
    },
    {
      "name": "HLS Sample Stream",
      "url": "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
      "type": "HLS (.m3u8)"
    },
    {
      "name": "Big Buck Bunny DASH",
      "url": "http://tvsen3.ottking.top/CloudTV/live/1928374650.m3u8",
      "type": "HLS (.m3u8)"
    }
  ];

  int currentChannelIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupPlayer(channelList[0]['url']!);
  }

  void _setupPlayer(String url) {
    // আগের প্লেয়ার রিলিজ করা
    if (_betterPlayerController != null) {
      _betterPlayerController!.dispose();
    }

    // কনফিগারেশন সেটআপ
    BetterPlayerConfiguration betterPlayerConfiguration = const BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: false,
      allowedScreenSleep: false,
      // নিচের কন্ট্রোলগুলো কাস্টমাইজ করা যায়
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableFullscreen: true,
        enableMute: true,
        enableProgressBar: true,
        enableAudioTracks: true,
      ),
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      // DASH/HLS অটো ডিটেকশনের জন্য এটি যথেষ্ট
      bufferingConfiguration: const BetterPlayerBufferingConfiguration(
        minBufferMs: 5000,
        maxBufferMs: 30000,
        bufferForPlaybackMs: 2500,
        bufferForPlaybackAfterRebufferMs: 5000,
      ),
    );

    _betterPlayerController = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );
    
    setState(() {});
  }

  void _changeChannel(int index) {
    if (currentChannelIndex == index) return;
    
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
      appBar: AppBar(
        title: const Text("Live TV - DASH & HLS"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // ভিডিও প্লেয়ার কন্টেইনার
          Container(
            color: Colors.black,
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _betterPlayerController != null
                  ? BetterPlayer(controller: _betterPlayerController!)
                  : const Center(child: CircularProgressIndicator(color: Colors.red)),
            ),
          ),
          
          const Divider(height: 1, color: Colors.grey),
          
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.list, color: Colors.red),
                SizedBox(width: 10),
                Text("চ্যানেল লিষ্ট", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // চ্যানেল লিষ্ট স্ক্রল অংশ
          Expanded(
            child: ListView.separated(
              itemCount: channelList.length,
              separatorBuilder: (context, index) => const Divider(color: Colors.white10),
              itemBuilder: (context, index) {
                bool isSelected = currentChannelIndex == index;
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red : Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.tv, color: isSelected ? Colors.white : Colors.grey),
                  ),
                  title: Text(
                    channelList[index]['name']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.red : Colors.white,
                    ),
                  ),
                  subtitle: Text(channelList[index]['type']!, style: const TextStyle(fontSize: 12)),
                  trailing: isSelected ? const Icon(Icons.play_circle_fill, color: Colors.red) : null,
                  onTap: () => _changeChannel(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
