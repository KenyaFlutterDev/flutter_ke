import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/models/channels/message.dart';
import 'package:mobile/providers/auth/auth_notifier_provider.dart';
import 'package:mobile/providers/channels/channels_notifier_provider.dart';
import 'package:mobile/providers/channels/messages_notifier_provider.dart';
import 'package:mobile/router/app_router.gr.dart';
import 'package:mobile/services/error_logger/error_logger.dart';
import 'package:mobile/ui/home/widgets/message_bubble.dart';
import 'package:mobile/ui/home/widgets/message_input_bar.dart';
import 'package:mobile/ui/home/widgets/profile_image.dart';
import 'package:mobile/ui/shared_widgets/empty_state.dart';
import 'package:mobile/ui/shared_widgets/error_state.dart';
import 'package:mobile/ui/shared_widgets/loading_indicator.dart';
import 'package:mobile/ui/theme/app_spacing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _logoutMutation = Mutation<void>();

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const HomeAppBar(),
      body: const ChannelsBody(),
    );
  }
}

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final channelsAsync = ref.watch(channelsProvider);
    final logoutState = ref.watch(_logoutMutation);

    Future<void> signOut() => _logoutMutation.run(ref, (tsx) async {
      final router = context.router;
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      try {
        await tsx.get(authProvider.notifier).signOut();
        await router.replaceAll([const SignInRoute()]);
      } catch (e, stackTrace) {
        ErrorLoggerService.instance.logError(e, stackTrace: stackTrace);
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('An error occurred during signing out'),
          ),
        );
      }
    });

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 5,
      titleSpacing: 0,
      centerTitle: false,
      title: channelsAsync.when(
        loading: () => Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Text(
            'Loading channel...',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
        error: (error, _) => const Padding(
          padding: EdgeInsets.only(left: AppSpacing.md),
          child: Text(
            'Channel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        data: (channels) {
          if (channels.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(left: AppSpacing.md),
              child: Text(
                'No Channel',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final channel = channels.first;

          return Row(
            children: [
              const SizedBox(width: AppSpacing.md),
              ProfileImage(
                size: 40,
                image: channel.avatarUrl,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      channel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      channel.description ?? '${channel.memberCount} members',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: switch (logoutState) {
            MutationPending() => const LoadingIndicator(),
            _ => const Icon(Icons.logout, color: Colors.white),
          },
          onPressed: switch (logoutState) {
            MutationPending() => null,
            _ => signOut,
          },
        ),
      ],
    );
  }
}

class ChannelMessages extends ConsumerWidget {
  const ChannelMessages({
    required this.channelId,
    super.key,
  });

  final String channelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final messagesAsync = ref.watch(messagesProvider(channelId));
    final authAsync = ref.watch(authProvider);
    final errorText = Text(
      'Failed to load messages',
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
    );
    final emptyText = Text(
      'No messages',
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
    );

    return switch ((messagesAsync, authAsync)) {
      (AsyncData(value: []), AsyncData(value: final _)) => EmptyState(
        message: emptyText,
      ),
      (AsyncData(value: final messages), AsyncData(value: final user)) =>
        MessagesList(
          messages: messages,
          user: user,
        ),
      (AsyncError(), AsyncError()) => ErrorState(message: errorText),
      _ => const Center(child: LoadingIndicator()),
    };
  }
}

class ChannelsBody extends ConsumerWidget {
  const ChannelsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final channelsAsync = ref.watch(channelsProvider);
    final authAsync = ref.watch(authProvider);
    final errorText = Text(
      'Failed to load channel',
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
    );
    final emptyText = Text(
      'No messages',
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
    );

    return Column(
      children: [
        Expanded(
          child: switch (channelsAsync) {
            AsyncData(value: []) => EmptyState(message: emptyText),
            AsyncData(value: [final channel, ...]) => ChannelMessages(
              channelId: channel.id,
            ),
            AsyncError() => ErrorState(message: errorText),
            _ => const Center(child: LoadingIndicator()),
          },
        ),
        switch ((channelsAsync, authAsync)) {
          (AsyncData(value: [final channel, ...]), AsyncData(value: final user))
              when user != null =>
            MessageInputBar(
              channelId: channel.id,
              userId: user.id,
            ),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({
    required this.messages,
    this.user,
    super.key,
  });

  final List<Message> messages;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      physics: const BouncingScrollPhysics(),
      padding: AppSpacing.paddingList,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageBubble(
          sender: user?.id == message.userId ? 'Me' : 'Other',
          text: message.content ?? '',
          isMe: user?.id == message.userId,
          time: message.createdAt ?? DateTime.now(),
        );
      },
    );
  }
}
