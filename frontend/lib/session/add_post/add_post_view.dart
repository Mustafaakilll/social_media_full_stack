import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/form_status.dart';
import '../navigator/session_navigation_cubit.dart';
import '../post_repository.dart';
import 'add_post_bloc.dart';

class AddPostView extends StatelessWidget {
  const AddPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AddPostBloc(context.read<PostRepository>()),
      child: BlocBuilder<AddPostBloc, AddPostState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: _addPostPage(size),
          );
        },
      ),
    );
  }

  Widget _addPostPage(Size size) {
    return SafeArea(
      child: BlocListener<AddPostBloc, AddPostState>(
        listener: (context, state) {
          if (state.isVisibleSheet) _showImageSourceSheet(context);

          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailure) _showSnackBar(context, formStatus.exception);

          if (formStatus is SubmissionSuccess) {
            _showSnackBar(context, 'Post successfully created');
            context.read<SessionNavigationCubit>().updateIndex(0);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _postPhoto(size),
              _captionField(),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postPhoto(Size size) {
    return BlocBuilder<AddPostBloc, AddPostState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.read<AddPostBloc>().add(const PickImageRequest()),
          child: AspectRatio(
            aspectRatio: 1.3,
            child: Center(
              child: state.imageUrl != null
                  ? Image.network(state.imageUrl!, fit: BoxFit.fill)
                  : Icon(Icons.add_photo_alternate_rounded, size: size.height * .4),
            ),
          ),
        );
      },
    );
  }

  Widget _captionField() {
    return BlocBuilder<AddPostBloc, AddPostState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              maxLines: null,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                hintText: 'Your caption',
                border: InputBorder.none,
              ),
              onChanged: (v) => context.read<AddPostBloc>().add(CaptionChanged(v)),
            ),
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<AddPostBloc, AddPostState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () => context.read<AddPostBloc>().add(const CreatePost()),
          child: const Text('Submit'),
        );
      },
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

  Future<void>? _showSnackBar(BuildContext context, dynamic message) async {
    final _snackBar = SnackBar(content: Text('$message'));
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
}
