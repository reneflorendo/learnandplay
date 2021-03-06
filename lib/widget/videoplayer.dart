import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
class LandPVideoPlayer extends StatefulWidget{
  final VideoPlayerController videoPlayerController;
  final bool looping;
  LandPVideoPlayer({
    required this.videoPlayerController,
    required this.looping,

}): super();

  @override
  _LandPVideoPlayerState createState() => _LandPVideoPlayerState();

}

class _LandPVideoPlayerState extends State<LandPVideoPlayer>{
  late ChewieController _chewieController;

  @override
  void initState(){
    super.initState();
    _chewieController = ChewieController(videoPlayerController: widget.videoPlayerController
    , aspectRatio: 16/9,
    autoInitialize: true,
    looping: widget.looping,
    errorBuilder: (context, errorMessage){
      return Center(
        child: Text(
          errorMessage,
          style: TextStyle(color:Colors.white),
        )
      );
    }
    );
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(controller:_chewieController),
    );
  }

  @override
  void dispose(){
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}