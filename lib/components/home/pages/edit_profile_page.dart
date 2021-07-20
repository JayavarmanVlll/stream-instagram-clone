import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_instagram_clone/app/app.dart';
import 'package:stream_instagram_clone/components/home/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// {@template edit_profile_page}
/// Page to edit a user's profile info.
/// {@endtemplate}
class EditProfilePage extends StatelessWidget {
  /// {@macro edit_profile_page}
  const EditProfilePage({
    Key? key,
  }) : super(key: key);

  /// Bottom animation route to this screen.
  static Route get route => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const EditProfilePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutQuint));
          final ofsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: ofsetAnimation,
            child: child,
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<FeedState>().userData;
    if (userData == null) {
      return const Text('User data is empty');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.primaryTextColor),
          ),
        ),
        leadingWidth: 80,
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Center(
              child: Avatar.medium(userData: userData),
            ),
          ),
          const _ChangeProfilePictureButton(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Name',
                    style: AppTextStyle.textStyleBold,
                  ),
                ),
                Text(
                  '${userData.fullName} ',
                  style: AppTextStyle.textStyleBold,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'user',
                    style: AppTextStyle.textStyleBold,
                  ),
                ),
                Text(
                  '${userData.fullName} ',
                  style: AppTextStyle.textStyleBold,
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class _ChangeProfilePictureButton extends StatefulWidget {
  const _ChangeProfilePictureButton({
    Key? key,
  }) : super(key: key);

  @override
  __ChangeProfilePictureButtonState createState() =>
      __ChangeProfilePictureButtonState();
}

class __ChangeProfilePictureButtonState
    extends State<_ChangeProfilePictureButton> {
  final picker = ImagePicker();

  Future<void> _changePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await context.read<FeedState>().updateProfilePhoto(pickedFile.path);
    } else {
      context.removeAndShowSnackbar('No picture selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: _changePicture, child: const Text('Change Profile Photo'));
  }
}
