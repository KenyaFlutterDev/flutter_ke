import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:mobile/constants/extensions.dart';
import 'package:mobile/services/helper_service/helper_service.dart';
import 'package:mobile/services/validator_service/validator_service.dart';
import 'package:mobile/ui/home/widgets/bubble_painter.dart';
import 'package:mobile/ui/theme/app_spacing.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.time,
    super.key,
  });

  final String sender;
  final String text;
  final bool isMe;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final url = ValidatorService.extractUrl(text);

    final bubbleColor = isMe
        ? theme.colorScheme.primary
        : theme.colorScheme.tertiary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: CustomPaint(
          painter: BubblePainter(
            isMe: isMe,
            color: bubbleColor,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.75,
            ),
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(
                    sender,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                if (!isMe) const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                if (ValidatorService.containsLink(text) && url != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: AnyLinkPreview(
                      onTap: () => HelperService.launchURL(url),
                      link: url,
                      previewHeight: size.height * .1,
                      displayDirection: UIDirection.uiDirectionHorizontal,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      bodyStyle: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      backgroundColor: bubbleColor.withValues(alpha: 0.9),
                      borderRadius: AppSpacing.base,
                      removeElevation: true,
                      cache: const Duration(days: 7),
                      errorWidget: const SizedBox.shrink(),
                      placeholderWidget: const SizedBox.shrink(),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      time.formattedTime,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
