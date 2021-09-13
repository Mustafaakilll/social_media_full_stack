import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/context_extension.dart';
import '../post_repository.dart';
import '../user_repository.dart';
import 'edit_profile_bloc.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView(this.user, {Key? key}) : super(key: key);

  final Map user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(context.read<PostRepository>(), context.read<UserRepository>()),
      child: Scaffold(
        appBar:
            AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const BackButton(color: Colors.black)),
        body: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(context.deviceHeight * .04),
                child: Column(
                  children: <Widget>[
                    _UsernameAndAvatar(avatar: user['avatar'], username: user['username']),
                    SizedBox(height: context.deviceHeight * .04),
                    _ProfileForm(
                      initialValue: user['username'],
                      formTitle: 'Username',
                      onValueChanged: (value) => context.read<EditProfileBloc>().add(UsernameChanged(username: value)),
                    ),
                    SizedBox(height: context.deviceHeight * .02),
                    _ProfileForm(
                      initialValue: user['email'],
                      formTitle: 'Email',
                      onValueChanged: (value) => context.read<EditProfileBloc>().add(EmailChanged(email: value)),
                    ),
                    SizedBox(height: context.deviceHeight * .02),
                    _ProfileForm(
                      initialValue: user['bio'],
                      formTitle: 'Bio',
                      onValueChanged: (value) => context.read<EditProfileBloc>().add(BioChanged(bio: value)),
                    ),
                    SizedBox(height: context.deviceHeight * .02),
                    ElevatedButton(
                        onPressed: () {
                          context.read<EditProfileBloc>().add(
                                EditProfile({
                                  'username': user['username'],
                                  'avatar': user['avatar'],
                                  'bio': user['bio'],
                                  'email': user['email']
                                }),
                              );
                          Navigator.of(context)
                              .pop({'bio': state.bio ?? user['bio'], 'avatar': state.avatar ?? user['avatar']});
                        },
                        child: const Text('Submit')),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _UsernameAndAvatar extends StatelessWidget {
  const _UsernameAndAvatar({Key? key, required this.avatar, required this.username}) : super(key: key);

  final String avatar;
  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state.isVisibleSheet) _showImageSourceSheet(context);
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _avatar(),
            SizedBox(width: context.deviceWidth * .1),
            Column(
              children: [
                Text(username, textScaleFactor: 1.2),
                TextButton(
                    onPressed: () {
                      context.read<EditProfileBloc>().add(const PickImageRequest());
                    },
                    child: const Text('Change Profile Photo')),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context.read<EditProfileBloc>().add(OpenImagePicker(imageSource));
    };

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.camera);
              },
              child: const Text('Kamera'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.gallery);
              },
              child: const Text('Galeri'),
            ),
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => IntrinsicHeight(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  selectImageSource(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo),
                label: const Text('Galeri'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  selectImageSource(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Kamera'),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget _avatar() {
    return BlocBuilder<EditProfileBloc, EditProfileState>(
      builder: (context, state) {
        return CircleAvatar(foregroundImage: NetworkImage(state.avatar ?? avatar), radius: 30);
      },
    );
  }
}

class _ProfileForm extends StatelessWidget {
  _ProfileForm({Key? key, required this.formTitle, required this.onValueChanged, this.initialValue}) : super(key: key);

  final String formTitle;
  final String? initialValue;
  final void Function(String) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(formTitle, textScaleFactor: 1.2),
        SizedBox(
          height: 40,
          width: context.deviceWidth * .57,
          child: _textField(context),
        ),
      ],
    );
  }

  Widget _textField(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onValueChanged,
      decoration: _textFieldDecoration(),
    );
  }

  InputDecoration _textFieldDecoration() {
    return const InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    );
  }
}
