import 'package:flutter/material.dart';

void main() => runApp(const ReelImageApp());

class ReelImageApp extends StatelessWidget {
  const ReelImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageReelsPage(),
    );
  }
}

class ImageReelsPage extends StatefulWidget {
  const ImageReelsPage({super.key});

  @override
  State<ImageReelsPage> createState() => _ImageReelsPageState();
}

class _ImageReelsPageState extends State<ImageReelsPage> {
  final PageController _controller = PageController();
  final List<String> _images = [];
  int _imageIndex = 102; // starting id for picsum images

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  Future<void> _loadMore() async {
    await Future.delayed(const Duration(seconds: 1));

    final newImages = List.generate(
      5,
      (i) => 'https://picsum.photos/id/${_imageIndex + i}/1080/1920',
    );

    setState(() {
      _images.addAll(newImages);
      _imageIndex += newImages.length; // increment for next batch
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: _images.length,
        onPageChanged: (i) {
          if (i >= _images.length - 2) _loadMore();
        },
        itemBuilder: (_, i) => Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _images[i],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[900],
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image_rounded,
                  color: Colors.white54,
                  size: 60,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: Text(
                'Image ${i + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 6, color: Colors.black)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
