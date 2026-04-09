import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/providers/channels/messages_notifier_provider.dart';
import 'package:mobile/services/error_logger/error_logger.dart';
import 'package:mobile/ui/shared_widgets/loading_indicator.dart';

final _messageMutation = Mutation<void>();

class MessageInputBar extends HookConsumerWidget {
  const MessageInputBar({
    required this.channelId,
    required this.userId,
    super.key,
  });
  final String channelId;
  final String userId;

  static const _hintColor = Color(0xff6b6580);
  static const Color _textColor = Colors.white;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final messageController = useTextEditingController();
    final messageState = ref.watch(_messageMutation);
    final theme = Theme.of(context);

    Future<void> sendMessage() async {
      final content = messageController.text.trim();
      if (content.isEmpty) return;

      await _messageMutation.run(ref, (tsx) async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        try {
          final notifier = tsx.get(messagesProvider(channelId).notifier);
          await notifier.sendMessage(
            channelId: channelId,
            content: messageController.text.trim(),
            userId: userId,
          );
          messageController.clear();
        } on Exception catch (error, stackTrace) {
          ErrorLoggerService.instance.logError(
            error,
            message: 'Error sending message',
            stackTrace: stackTrace,
          );
          scaffoldMessenger.showSnackBar(
            SnackBar(
              backgroundColor: theme.colorScheme.error,
              content: const Text('An error occurred during sending message'),
            ),
          );
        }
      });
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: 16,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xff2d2640),
            ),
          ),
          child: ListenableBuilder(
            listenable: focusNode,
            builder: (_, _) => TextField(
              focusNode: focusNode,
              controller: messageController,
              style: const TextStyle(
                color: _textColor,
                height: 1.35,
              ),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: const TextStyle(
                  color: _hintColor,
                ),
                suffixIconColor: focusNode.hasFocus
                    ? theme.colorScheme.tertiary
                    : _hintColor,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                suffixIcon: switch (messageState) {
                  MutationPending() => Container(
                    width: 24,
                    height: 24,
                    alignment: .center,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: theme.colorScheme.tertiary,
                    ),
                    child: const LoadingIndicator(),
                  ),
                  _ => SizedBox.square(
                    dimension: 24,
                    child: InkWell(
                      onTap: switch (messageState) {
                        MutationPending() => null,
                        _ => () async => sendMessage(),
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: const Icon(Icons.send),
                    ),
                  ),
                },
              ),
              minLines: 1,
              maxLines: 5,
              textCapitalization: .sentences,
              textInputAction: TextInputAction.newline,
            ),
          ),
        ),
      ),
    );
  }
}
