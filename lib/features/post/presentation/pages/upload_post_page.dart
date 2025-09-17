import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';

import 'package:my_social_media/features/auth/domain/entities/app_user.dart';
import 'package:my_social_media/features/auth/presentation/components/my_text_field.dart';
import 'package:my_social_media/responsive/constrained_scaffold.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/post.dart';
import '../cubits/post_states.dart';
import '../cubits/post_cubit.dart';
// ✅ Import ProfileCubit to be able to access it
import 'package:my_social_media/features/profile/presentation/cubits/profile_cubit.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  PlatformFile? imagePickedFile; // mobile image
  Uint8List? webImage; // web image
  final textController = TextEditingController(); //text controller for caption
  AppUser? currentUser; // current user

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // call function
  }

  // get current user
  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    setState(() {
      currentUser = authCubit.currentUser;
    });
  }

  //pick image
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: kIsWeb, // sirf web ke liye data load hoga
    );
    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;

        if (kIsWeb) {
          webImage = imagePickedFile!.bytes;
        }
      });
    }
  }

  //create and upload post
  void uploadPost() {
    if (imagePickedFile == null || textController.text.isEmpty || currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide both image and caption")),
      );
      return;
    }

    // create post object now
    final newPost = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: textController.text,
      imageUrl: '', // Cloudinary se baad me update hoga
      timestamp: DateTime.now(),
      likes: [],
      comments: [],
    );

    //post cubit
    final postCubit = context.read<PostCubit>();

    // ✅ Get ProfileCubit from context and pass it to createPost
    final profileCubit = context.read<ProfileCubit>();

    //web upload
    if (kIsWeb) {
      if (imagePickedFile?.bytes != null) {
        postCubit.createPost(
          newPost,
          imageBytes: imagePickedFile!.bytes,
          profileCubit: profileCubit, // ✅ Pass ProfileCubit
        );
      }
    }

    //mobile upload
    else {
      if (imagePickedFile?.path != null) {
        postCubit.createPost(
          newPost,
          imagePath: imagePickedFile!.path,
          profileCubit: profileCubit, // ✅ Pass ProfileCubit
        );
      }
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Bloc consumer -> Builder + Listener
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        //loading or uploading
        if (state is PostsLoading || state is PostsUploading) {
          return const ConstrainedScaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        //return build upload page
        return buildUploadPage();
      },
      //go back to previous page when upload is done & posts are loaded
      listener: (context, state) {
        if (state is PostsLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildUploadPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          //upload button
          IconButton(
            onPressed: uploadPost,
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //image preview for web
              if (kIsWeb && webImage != null) Image.memory(webImage!),

              //image preview for mobile
              if (!kIsWeb && imagePickedFile?.path != null)
                Image.file(File(imagePickedFile!.path!)),

              //pick image button
              MaterialButton(
                onPressed: pickImage,
                color: Colors.blue,
                child: const Text("Pick Image"),
              ),

              //caption text Box
              MyTextField(
                controller: textController,
                hintText: "Caption",
                obscureText: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
