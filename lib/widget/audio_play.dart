import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:question/utils/const.dart';

class AudioPlay extends StatefulWidget {
  AudioPlay({Key key, @required this.path}) : super(key: key);

  final String path;

  @override
  AudioPlayState createState() => AudioPlayState();
}

class AudioPlayState extends State<AudioPlay> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    try {
      player.setUrl(widget.path);
      // player.setUrl(
      //     "https://usercontent.stantabcorp.com/questionne-moi-2020/01fd960ad8424b9b981ae361d92fd45b");
      // player.setUrl(
      //     "https://usercontent.stantabcorp.com/questionne-moi-2020/aba59894ec0b4a569dda014c0f058b70");
    } catch (e) {
      print(e);
    }

    player.playerStateStream.listen((event) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () async {
          if (player.playing) {
            await player.stop();
          } else {
            await player.play();
          }
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: COLOR.BLUE.withOpacity(0.6),
          child: Icon(
            (player.playing) ? Icons.stop_rounded : Icons.play_arrow_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  void stopPlayer() async {
    if (player.playing) {
      await player.stop();
    }
  }
}
