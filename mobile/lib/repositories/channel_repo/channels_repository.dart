import 'package:mobile/models/channels/channel.dart';
import 'package:mobile/models/channels/message.dart';
import 'package:mobile/providers/supabase/supabase_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'channels_repository.g.dart';

class ChannelsRepository {
  ChannelsRepository({required this.client});

  final SupabaseClient client;

  Future<List<Channel>> fetchChannels() async {
    try {
      final response = await client
          .from('channels')
          .select()
          .eq('is_archived', false)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Channel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on Exception catch (_) {
      throw ChannelsRepositoryException(
        'Failed to fetch channels',
      );
    }
  }

  Stream<List<Message>> fetchMessages(String channelId) {
    try {
      final response = client
          .from('messages')
          .stream(primaryKey: ['id'])
          .eq('channel_id', channelId)
          .order('created_at')
          .map(
            (rows) => rows
                .map(Message.fromJson)
                .where((msg) => !msg.isDeleted)
                .toList(),
          );

      return response;
    } on Exception catch (_) {
      throw ChannelsRepositoryException(
        'Failed to fetch messages',
      );
    }
  }

  Future<Message> sendMessage({
    required String channelId,
    required String content,
    required String userId,
  }) async {
    try {
      final response = await client
          .from('messages')
          .insert({
            'channel_id': channelId,
            'content': content,
            'user_id': userId,
          })
          .select()
          .single();
      return Message.fromJson(response);
    } on Exception catch (_) {
      throw ChannelsRepositoryException(
        'Failed to send message',
      );
    }
  }

  Future<Channel> createChannel({
    required String name,
    String? description,
  }) async {
    try {
      final response = await client
          .from('channels')
          .insert({
            'name': name,
            'description': description,
          })
          .select()
          .single();

      return Channel.fromJson(response);
    } on Exception catch (_) {
      throw ChannelsRepositoryException(
        'Failed to create channel',
      );
    }
  }
}

class ChannelsRepositoryException implements Exception {
  ChannelsRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

@riverpod
Future<ChannelsRepository> channelsRepository(Ref ref) async {
  final supabaseClient = await ref.watch(supabaseClientProvider.future);

  return ChannelsRepository(client: supabaseClient);
}
