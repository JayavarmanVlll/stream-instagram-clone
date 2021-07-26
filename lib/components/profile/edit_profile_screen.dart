import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../app/app.dart';
import '../home/widgets/widgets.dart';

/// {@template edit_profile_page}
/// Screen to edit a user's profile info.
/// {@endtemplate}
class EditProfileScreen extends StatelessWidget {
  /// {@macro edit_profile_page}
  const EditProfileScreen({
    Key? key,
  }) : super(key: key);

  /// Custom route to this screen. Animates from the bottom up.
  static Route get route => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const EditProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutQuint));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
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
        backgroundColor: AppColors.background,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.primaryText),
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
              child: Avatar.big(userData: userData),
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
                    'Username',
                    style: AppTextStyle.textStyleBold,
                  ),
                ),
                Text(
                  '${context.feedState.user.id} ',
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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await context.feedState.updateProfilePhoto(pickedFile.path);
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
