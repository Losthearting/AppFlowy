import 'package:appflowy/generated/locale_keys.g.dart';
import 'package:appflowy/startup/tasks/app_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flowy_infra/size.dart';
import 'package:flowy_infra_ui/style_widget/text.dart';
import 'package:flowy_infra_ui/style_widget/text_input.dart';
import 'package:flowy_infra_ui/widget/buttons/primary_button.dart';
import 'package:flowy_infra_ui/widget/buttons/secondary_button.dart';
import 'package:flowy_infra_ui/widget/dialog/styled_dialogs.dart';
import 'package:flowy_infra_ui/widget/spacing.dart';
import 'package:flutter/material.dart';

export 'package:flowy_infra_ui/widget/dialog/styled_dialogs.dart';

class NavigatorTextFieldDialog extends StatefulWidget {
  const NavigatorTextFieldDialog({
    super.key,
    required this.title,
    this.autoSelectAllText = false,
    required this.value,
    required this.onConfirm,
    this.onCancel,
    this.maxLength,
    this.hintText,
  });

  final String value;
  final String title;
  final VoidCallback? onCancel;
  final void Function(String, BuildContext) onConfirm;
  final bool autoSelectAllText;
  final int? maxLength;
  final String? hintText;

  @override
  State<NavigatorTextFieldDialog> createState() =>
      _NavigatorTextFieldDialogState();
}

class _NavigatorTextFieldDialogState extends State<NavigatorTextFieldDialog> {
  String newValue = "";
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    newValue = widget.value;
    controller.text = newValue;
    if (widget.autoSelectAllText) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: newValue.length,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StyledDialog(
      child: Column(
        children: <Widget>[
          FlowyText.medium(
            widget.title,
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: FontSizes.s16,
          ),
          VSpace(Insets.m),
          FlowyFormTextInput(
            hintText:
                widget.hintText ?? LocaleKeys.dialogCreatePageNameHint.tr(),
            controller: controller,
            textStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: FontSizes.s16),
            maxLength: widget.maxLength,
            showCounter: false,
            autoFocus: true,
            onChanged: (text) {
              newValue = text;
            },
            onEditingComplete: () {
              widget.onConfirm(newValue, context);
              AppGlobals.nav.pop();
            },
          ),
          VSpace(Insets.xl),
          OkCancelButton(
            onOkPressed: () {
              widget.onConfirm(newValue, context);
              Navigator.of(context).pop();
            },
            onCancelPressed: () {
              widget.onCancel?.call();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class NavigatorAlertDialog extends StatefulWidget {
  const NavigatorAlertDialog({
    super.key,
    required this.title,
    this.cancel,
    this.confirm,
    this.hideCancelButton = false,
  });

  final String title;
  final void Function()? cancel;
  final void Function()? confirm;
  final bool hideCancelButton;

  @override
  State<NavigatorAlertDialog> createState() => _CreateFlowyAlertDialog();
}

class _CreateFlowyAlertDialog extends State<NavigatorAlertDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StyledDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ...[
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
                maxHeight: 260,
              ),
              child: FlowyText.medium(
                widget.title,
                fontSize: FontSizes.s16,
                textAlign: TextAlign.center,
                color: Theme.of(context).colorScheme.tertiary,
                maxLines: null,
              ),
            ),
          ],
          if (widget.confirm != null) ...[
            const VSpace(20),
            OkCancelButton(
              onOkPressed: () {
                widget.confirm?.call();
                Navigator.of(context).pop();
              },
              onCancelPressed: widget.hideCancelButton
                  ? null
                  : () {
                      widget.cancel?.call();
                      Navigator.of(context).pop();
                    },
            ),
          ],
        ],
      ),
    );
  }
}

class NavigatorOkCancelDialog extends StatelessWidget {
  const NavigatorOkCancelDialog({
    super.key,
    this.onOkPressed,
    this.onCancelPressed,
    this.okTitle,
    this.cancelTitle,
    this.title,
    required this.message,
    this.maxWidth,
  });

  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;
  final String? okTitle;
  final String? cancelTitle;
  final String? title;
  final String message;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return StyledDialog(
      maxWidth: maxWidth ?? 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) ...[
            FlowyText.medium(
              title!.toUpperCase(),
              fontSize: FontSizes.s16,
            ),
            VSpace(Insets.sm * 1.5),
            Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              height: 1,
            ),
            VSpace(Insets.m * 1.5),
          ],
          FlowyText.medium(message),
          SizedBox(height: Insets.l),
          OkCancelButton(
            onOkPressed: () {
              onOkPressed?.call();
              Navigator.of(context).pop();
            },
            onCancelPressed: () {
              onCancelPressed?.call();
              Navigator.of(context).pop();
            },
            okTitle: okTitle?.toUpperCase(),
            cancelTitle: cancelTitle?.toUpperCase(),
          ),
        ],
      ),
    );
  }
}

class OkCancelButton extends StatelessWidget {
  const OkCancelButton({
    super.key,
    this.onOkPressed,
    this.onCancelPressed,
    this.okTitle,
    this.cancelTitle,
    this.minHeight,
    this.alignment = MainAxisAlignment.spaceAround,
    this.mode = TextButtonMode.big,
  });

  final VoidCallback? onOkPressed;
  final VoidCallback? onCancelPressed;
  final String? okTitle;
  final String? cancelTitle;
  final double? minHeight;
  final MainAxisAlignment alignment;
  final TextButtonMode mode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: alignment,
        children: <Widget>[
          if (onCancelPressed != null)
            SecondaryTextButton(
              cancelTitle ?? LocaleKeys.button_cancel.tr(),
              onPressed: onCancelPressed,
              mode: mode,
            ),
          if (onCancelPressed != null) HSpace(Insets.m),
          if (onOkPressed != null)
            PrimaryTextButton(
              okTitle ?? LocaleKeys.button_ok.tr(),
              onPressed: onOkPressed,
              mode: mode,
            ),
        ],
      ),
    );
  }
}
