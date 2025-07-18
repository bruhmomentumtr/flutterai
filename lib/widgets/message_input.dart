// Default location: lib/widgets/message_input.dart
// Message input widget for typing and sending messages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../languages/languages.dart';

class MessageInput extends StatefulWidget {
  final Function(String, File?) onSendMessage;
  final bool isLoading;

  const MessageInput({
    Key? key,
    required this.onSendMessage,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    // İlk yüklemede input alanına fokus ver
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for prepared messages from ChatProvider
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    if (chatProvider.preparedMessage != null) {
      _textController.text = chatProvider.preparedMessage!;
      setState(() {
        _isComposing = _textController.text.isNotEmpty;
      });
      // Move cursor to the end of the text
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if ((text.trim().isEmpty && _selectedImage == null) || widget.isLoading) {
      return;
    }

    // Mesajı göndermeden önce kontroller
    bool isFirstMessage = true; // Track if it's the first message
    setState(() {
      _isComposing = false;
    });

    // Text kontrolünden önce üstteki setState tetiklensin
    Future.microtask(() {
      // Clear the input
      _textController.clear();

      // Send message and image
      widget.onSendMessage(text, _selectedImage);

      // Clear selected image after sending
      if (isFirstMessage) {
        // Logic to create topic header
        String topicHeader = "Topic: ${text.trim()}"; // Example header
        // You may want to send this header to the chat provider or handle it accordingly
        print(topicHeader); // For demonstration, replace with actual handling
        isFirstMessage = false; // Set to false after the first message
      }
      setState(() {
        _selectedImage = null;
      });

      // Mesaj gönderildikten sonra input'a fokus et
      _focusNode.requestFocus();
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        // Dosyanın var olup olmadığını kontrol et
        if (await imageFile.exists()) {
          setState(() {
            _selectedImage = imageFile;
            _isComposing = true;
          });

          // Görsel seçildikten sonra input alanına fokus et
          _focusNode.requestFocus();
        } else {
          _showErrorSnackbar(Languages.msgSelectedImageNotFound);
        }
      }
    } catch (e) {
      debugPrint('$Languages.msgImageLoadError $e');
      _showErrorSnackbar(Languages.msgErrorPickingImage);
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        // Dosyanın var olup olmadığını kontrol et
        if (await imageFile.exists()) {
          setState(() {
            _selectedImage = imageFile;
            _isComposing = true;
          });

          // Fotoğraf çekildikten sonra input alanına fokus et
          _focusNode.requestFocus();
        } else {
          _showErrorSnackbar(Languages.msgTakenPhotoNotSaved);
        }
      }
    } catch (e) {
      debugPrint('$Languages.msgImageLoadError $e');
      _showErrorSnackbar(Languages.msgErrorTakingPhoto);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImage = null;
      // Görsel kaldırıldığında, metin alanı boşsa _isComposing durumunu güncelle
      _isComposing = _textController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withAlpha(13),
            offset: const Offset(0, -1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          // Display selected image preview
          if (_selectedImage != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              height: 120,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 120,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('$Languages.msgImageLoadError $error');
                        return Container(
                          width: double.infinity,
                          height: 120,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
                              SizedBox(height: 4),
                              Text(Languages.msgImageNotLoaded,
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.error, fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(4),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                      onPressed: _clearSelectedImage,
                      constraints: const BoxConstraints(
                        minHeight: 32,
                        minWidth: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              // Gallery button
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: widget.isLoading ? null : _pickImage,
                tooltip: Languages.tooltipAddImage, // Languages sınıfından çağrıldı
              ),

              // Camera button
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: widget.isLoading ? null : _takePhoto,
                tooltip: Languages.tooltipTakePhoto, // Languages sınıfından çağrıldı
              ),

              // Text field
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: Languages.hintTextMessage, // Languages sınıfından çağrıldı
                    border: InputBorder.none,
                    enabled: !widget.isLoading,
                  ),
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                  onSubmitted: _handleSubmitted,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),

              // Send button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: widget.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.send,
                          color: _isComposing || _selectedImage != null
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                        onPressed: _isComposing || _selectedImage != null
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
