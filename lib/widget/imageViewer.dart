import 'package:cached_network_image/cached_network_image.dart';
import 'package:elective_project/util/colors.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final String image;

  const ImageViewer({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SizedBox(
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: widget.image,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                child: CircularProgressIndicator(
                    color: mPrimaryColor, value: downloadProgress.progress),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
