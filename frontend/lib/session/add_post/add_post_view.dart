import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/session/add_post/add_post_bloc.dart';
import 'package:frontend/session/post_repository.dart';
import 'package:image_picker/image_picker.dart';

class AddPostView extends StatelessWidget {
  const AddPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddPostBloc(context.read<PostRepository>()),
      child: Scaffold(
        body: Center(
          child: BlocConsumer<AddPostBloc, AddPostState>(
            listener: (context, state) {
              if (state.isVisibleSheet) _showImageSourceSheet(context);
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => context.read<AddPostBloc>().add(const PickImageRequest()),
                      child: Text('Hit me for Source')),
                  TextButton(
                      onPressed: () => context.read<AddPostBloc>().add(const CreatePost()),
                      child: Text('Hit me for Add')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context.read<AddPostBloc>().add(OpenImagePicker(imageSource));
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
}
