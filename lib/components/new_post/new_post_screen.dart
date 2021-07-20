import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stream_feed/stream_feed.dart' as feed;
import 'package:transparent_image/transparent_image.dart';

import '../../app/app.dart';
import '../global_widgets/widgets.dart';

/// {@template new_post_screen}
/// Screen to choose photos and add a new feed post.
/// {@endtemplate}
class NewPostScreen extends StatefulWidget {
  /// {@macro new_post_screen}
  const NewPostScreen({Key? key}) : super(key: key);

  /// Material route to this screen.
  static Route get route =>
      MaterialPageRoute(builder: (_) => const NewPostScreen());

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController();

  XFile? _pickedFile;
  bool loading = false;

  final picker = ImagePicker();

  Future<void> _pickFile() async {
    _pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> _postImage() async {
    final client = context.read<FeedState>().client;
    if (_pickedFile == null) {
      context.removeAndShowSnackbar('Please select an image first');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      context.removeAndShowSnackbar('Please enter a caption');
      return;
    }
    _setLoading(true);

    final imageUrl = await client.images
        .upload(feed.AttachmentFile(path: _pickedFile!.path));

    if (imageUrl != null && client.currentUser != null) {
      final activity = feed.Activity(
        actor: client.currentUser!.ref,
        verb: 'post',
        object: _text.text,
        extraData: {'image_url': imageUrl},
        time: DateTime.now(),
      );

      final userFeed = client.flatFeed('user', client.currentUser!.userId);

      await userFeed.addActivity(activity);
    }

    _setLoading(false, shouldCallSetState: false);
    context.removeAndShowSnackbar('Post created!');

    Navigator.of(context).pop();
  }

  void _setLoading(bool state, {bool shouldCallSetState = true}) {
    if (loading != state) {
      loading = state;
      if (shouldCallSetState) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TapFadeIcon(
          onTap: () => Navigator.pop(context),
          icon: Icons.close,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: GestureDetector(
                onTap: _postImage,
                child: const Text('Share', style: AppTextStyle.textStyleAction),
              ),
            ),
          )
        ],
        backgroundColor: AppColors.backgroundColor,
      ),
      body: loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Uploading...')
                ],
              ),
            )
          : ListView(
              children: [
                InkWell(
                  onTap: _pickFile,
                  child: SizedBox(
                    height: 400,
                    child: (_pickedFile != null)
                        ? FadeInImage(
                            fit: BoxFit.contain,
                            placeholder: MemoryImage(kTransparentImage),
                            image: Image.file(File(_pickedFile!.path)).image,
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    AppColors.bottomGradient,
                                    AppColors.topGradient
                                  ]),
                            ),
                            height: 300,
                            child: const Center(
                              child: Text(
                                'Tap to select an image',
                                style: TextStyle(
                                  fontSize: 18,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 1.0),
                                      blurRadius: 3.0,
                                      color: Colors.black54,
                                    ),
                                    Shadow(
                                      offset: Offset(1.0, 1.5),
                                      blurRadius: 5.0,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _text,
                      decoration: const InputDecoration(
                        hintText: 'Write a caption',
                        border: InputBorder.none,
                      ),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Caption is empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
