import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? fileVideo;
  final picker = ImagePicker();
  int? videoSize = 0;
  MediaInfo? compressLowVideoInfo;
  MediaInfo? compressMediumVideoInfo;
  MediaInfo? compressHighestVideoInfo;
  MediaInfo? compressDefaultVideoInfo;
  late Subscription subcription;
  double? progress = 0;

  @override
  void initState() {
    super.initState();

    subcription = VideoCompress.compressProgress$
      .subscribe((event) => setState(() => progress = event));


  }

  @override
  Widget build(BuildContext context) {
    final progressvalue = progress == null ? progress : progress !/ 100;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top:350),
        child: Column(
          children: [
            Text('Original size: $videoSize KB'),
            ElevatedButton(
              onPressed: (){
                pickVideo();
              },
              child: const Text('pick a video'),
            ),
            ElevatedButton(
              onPressed: (){
                compressVideo();
              },
              child: const Text('compress video'),
            ),
            LinearProgressIndicator(value: progressvalue),
            Text('Lowest size: ${compressLowVideoInfo?.filesize!} KB'),
            Text('Medium size: ${compressMediumVideoInfo?.filesize!} KB'),
            Text('Highest size: ${compressHighestVideoInfo?.filesize!} KB'),
            Text('Default size: ${compressDefaultVideoInfo?.filesize!} KB'),
          ],
        ),
      )
    );
  }

  Future pickVideo() async {
    final videoFile = await picker.pickVideo(source: ImageSource.gallery);

    if (videoFile == null) return;
    final file = XFile(videoFile.path);

    setState(() {
      fileVideo = file;
    });
    getVideoSize(fileVideo!);
  }

  Future getVideoSize(XFile file) async {
    final size = await file.length();

    setState(() {
      videoSize = size;
    });
  }

  Future<MediaInfo?> compressVideoToLowQuality(XFile file) async {
    try{
      await VideoCompress.setLogLevel(0);

      return VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.LowQuality,
        includeAudio: false,
      );
    } catch (e) {
      VideoCompress.cancelCompression();
    }
    return null;

  }

  Future<MediaInfo?> compressVideoToMediumQuality(XFile file) async {
    try{
      await VideoCompress.setLogLevel(0);

      return VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
        includeAudio: false,
      );
    } catch (e) {
      VideoCompress.cancelCompression();
    }
    return null;

  }

  Future<MediaInfo?> compressVideoToHighestQuality(XFile file) async {
    try{
      await VideoCompress.setLogLevel(0);

      return VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.HighestQuality,
        includeAudio: false,
      );
    } catch (e) {
      VideoCompress.cancelCompression();
    }
    return null;

  }

  Future<MediaInfo?> compressVideoToDefaultQuality(XFile file) async {
    try{
      await VideoCompress.setLogLevel(0);

      return VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.DefaultQuality,
        includeAudio: false,
      );
    } catch (e) {
      VideoCompress.cancelCompression();
    }
    return null;

  }

  Future compressVideo() async{
    final info = await compressVideoToLowQuality(fileVideo !);
    final medium_info = await compressVideoToMediumQuality(fileVideo !);
    final highest_info = await compressVideoToHighestQuality(fileVideo !);
    final default_info = await compressVideoToDefaultQuality(fileVideo !);

    setState(() {
      compressLowVideoInfo = info;
      compressMediumVideoInfo = medium_info;
      compressHighestVideoInfo = highest_info;
      compressDefaultVideoInfo = default_info;
    });
  }
}
