// lib/widgets/message_input.dart
// Modern floating message input widget

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../languages/languages.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

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

class _MessageInputState extends State<MessageInput>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isComposing = false;
  bool _showAttachMenu = false;
  late AnimationController _attachMenuController;
  late Animation<double> _attachMenuAnimation;

  @override
  void initState() {
    super.initState();
    _attachMenuController = AnimationController(
      vsync: this,
      duration: AppSpacing.animFast,
    );
    _attachMenuAnimation = CurvedAnimation(
      parent: _attachMenuController,
      curve: Curves.easeOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final chatProvider = Provider.of<ChatProvider>(context, listen: true);
    if (chatProvider.preparedMessage != null) {
      _textController.text = chatProvider.preparedMessage!;
      setState(() {
        _isComposing = _textController.text.isNotEmpty;
      });
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _attachMenuController.dispose();
    super.dispose();
  }

  void _toggleAttachMenu() {
    setState(() {
      _showAttachMenu = !_showAttachMenu;
      if (_showAttachMenu) {
        _attachMenuController.forward();
      } else {
        _attachMenuController.reverse();
      }
    });
  }

  void _handleSubmitted(String text) {
    if ((text.trim().isEmpty && _selectedImage == null) || widget.isLoading) {
      return;
    }

    setState(() {
      _isComposing = false;
    });

    Future.microtask(() {
      _textController.clear();
      widget.onSendMessage(text, _selectedImage);

      setState(() {
        _selectedImage = null;
        _showAttachMenu = false;
      });
      _attachMenuController.reverse();
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
        if (await imageFile.exists()) {
          setState(() {
            _selectedImage = imageFile;
            _isComposing = true;
            _showAttachMenu = false;
          });
          _attachMenuController.reverse();
          _focusNode.requestFocus();
        } else {
          _showErrorSnackbar(Languages.msgSelectedImageNotFound);
        }
      }
    } catch (e) {
      debugPrint('${Languages.msgImageLoadError} $e');
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
        if (await imageFile.exists()) {
          setState(() {
            _selectedImage = imageFile;
            _isComposing = true;
            _showAttachMenu = false;
          });
          _attachMenuController.reverse();
          _focusNode.requestFocus();
        } else {
          _showErrorSnackbar(Languages.msgTakenPhotoNotSaved);
        }
      }
    } catch (e) {
      debugPrint('${Languages.msgImageLoadError} $e');
      _showErrorSnackbar(Languages.msgErrorTakingPhoto);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImage = null;
      _isComposing = _textController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Attach menu
            if (_showAttachMenu) _buildAttachMenu(theme),

            // Image preview
            if (_selectedImage != null) _buildImagePreview(theme),

            // Input row
            _buildInputRow(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachMenu(ThemeData theme) {
    return SizeTransition(
      sizeFactor: _attachMenuAnimation,
      child: Container(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildAttachOption(
              icon: Icons.photo_library_rounded,
              label: 'Gallery',
              color: AppColors.secondary,
              onTap: widget.isLoading ? null : _pickImage,
            ),
            const SizedBox(width: AppSpacing.md),
            _buildAttachOption(
              icon: Icons.camera_alt_rounded,
              label: 'Camera',
              color: AppColors.accent,
              onTap: widget.isLoading ? null : _takePhoto,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.borderRadiusMd,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      height: 100,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: AppSpacing.borderRadiusMd,
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 100,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: theme.colorScheme.error),
                      const SizedBox(height: 4),
                      Text(
                        Languages.msgImageNotLoaded,
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: AppSpacing.xs,
            right: AppSpacing.xs,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                onPressed: _clearSelectedImage,
                constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow(ThemeData theme, bool isDark) {
    final bool canSend =
        (_isComposing || _selectedImage != null) && !widget.isLoading;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: _focusNode.hasFocus
              ? theme.colorScheme.primary.withOpacity(0.5)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attach button
          IconButton(
            icon: AnimatedRotation(
              turns: _showAttachMenu ? 0.125 : 0,
              duration: AppSpacing.animFast,
              child: Icon(
                _showAttachMenu ? Icons.close : Icons.add,
                color: _showAttachMenu
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onPressed: widget.isLoading ? null : _toggleAttachMenu,
            tooltip: Languages.tooltipAddImage,
          ),

          // Text field
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: Languages.hintTextMessage,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.md,
                ),
                enabled: !widget.isLoading,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 15,
              ),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: _handleSubmitted,
              textInputAction: TextInputAction.send,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              minLines: 1,
            ),
          ),

          // Send button
          Padding(
            padding: const EdgeInsets.only(
                right: AppSpacing.xs, bottom: AppSpacing.xs),
            child: widget.isLoading
                ? Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  )
                : AnimatedContainer(
                    duration: AppSpacing.animFast,
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: canSend ? AppColors.primaryGradient : null,
                      color: canSend
                          ? null
                          : theme.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_upward_rounded,
                        color: canSend
                            ? Colors.white
                            : theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.5),
                        size: 20,
                      ),
                      onPressed: canSend
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                      padding: EdgeInsets.zero,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
