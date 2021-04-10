import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayer extends StatefulWidget {

  final String youtubeLink;
  final bool isStarted;
  YoutubeVideoPlayer(this.youtubeLink, this.isStarted);

  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {

  YoutubePlayerController _controller;
  String currentUrl;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.youtubeLink),
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: false,
        hideThumbnail: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(currentUrl != widget.youtubeLink){
      _controller.load(YoutubePlayer.convertUrlToId(widget.youtubeLink));
      currentUrl = widget.youtubeLink;
    }

    if(widget.isStarted){
      _controller.play();
    }else{
      _controller.pause();
    }

    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      progressColors: ProgressBarColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      bottomActions: <Widget>[
        const SizedBox(width: 14.0),
        CurrentPosition(),
        const SizedBox(width: 8.0),
        ProgressBar(
          isExpanded: true,
          colors: ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
        ),
        RemainingDuration(),
      ],
    );
  }
}
