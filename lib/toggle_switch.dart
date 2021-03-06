//Credit : @Eugene (https://stackoverflow.com/questions/56340682/flutter-equvalent-android-toggle-switch

import 'package:flutter/material.dart';

typedef OnToggle = void Function(int index);

class ToggleSwitch extends StatefulWidget {
  /// Active background color
  final Color activeBgColor;

  /// Active foreground color
  final Color activeFgColor;

  /// Inactive background color
  final Color inactiveBgColor;

  /// Inactive foreground color
  final Color inactiveFgColor;

  /// List of labels
  final List<String> labels;

  /// List of icons
  final List<IconData> icons;

  /// List of active foreground colors
  final List<Color> activeBgColors;

  /// Minimum switch width
  final double minWidth;

  /// Minimum switch height
  final double minHeight;

  /// Widget's corner radius
  final double cornerRadius;

  /// Font size
  final double fontSize;

  /// Icon size
  final double iconSize;

  /// OnToggle function
  final OnToggle onToggle;

  /// Initial label index
  final int initialLabelIndex;

  ToggleSwitch({
    Key key,
    @required this.labels,
    this.activeBgColor,
    this.activeFgColor,
    this.inactiveBgColor,
    this.inactiveFgColor,
    this.onToggle,
    this.cornerRadius = 8.0,
    this.initialLabelIndex = 0,
    this.minWidth = 72.0,
    this.minHeight = 40.0,
    this.icons,
    this.activeBgColors,
    this.fontSize = 14.0,
    this.iconSize = 17.0,
  }) : super(key: key);

  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch>
    with AutomaticKeepAliveClientMixin<ToggleSwitch> {
  /// Current selected label
  int current;

  /// Active background color
  Color activeBgColor;

  /// Active foreground color
  Color activeFgColor;

  /// Inactive background color
  Color inactiveBgColor;

  /// Inctive foreground color
  Color inactiveFgColor;

  @override
  void initState() {
    /// Initialize current label with initial label index.
    current = widget.initialLabelIndex;

    super.initState();
  }

  /// Maintain selection state.
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// Assigns active background color to default primary theme color if it's null/not provided.
    activeBgColor = widget.activeBgColor == null
        ? Theme.of(context).primaryColor
        : widget.activeBgColor;

    /// Assigns active foreground color to default accent text theme color if it's null/not provided.
    activeFgColor = widget.activeFgColor == null
        ? Theme.of(context).accentTextTheme.bodyText1.color
        : widget.activeFgColor;

    /// Assigns inactive background color to default disabled theme color if it's null/not provided.
    inactiveBgColor = widget.inactiveBgColor == null
        ? Theme.of(context).disabledColor
        : widget.inactiveBgColor;

    /// Assigns inactive foreground color to default text theme color if it's null/not provided.
    inactiveFgColor = widget.inactiveFgColor == null
        ? Theme.of(context).textTheme.bodyText1.color
        : widget.inactiveFgColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.cornerRadius),
      child: Container(
        height: widget.minHeight,
        color: inactiveBgColor,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.labels.length * 2 - 1, (index) {
            /// Active if index matches current
            final active = index ~/ 2 == current;

            /// Assigns foreground color based on active status.
            ///
            /// Set active foreground color if current index is active.
            /// Set inactive foreground color if current index is inactive.
            final fgColor = active ? activeFgColor : inactiveFgColor;

            /// Default background color
            var bgColor = Colors.transparent;

            /// Changes background color if current index is active.
            ///
            /// Set same active background color for all items if active background colors list is empty.
            /// Set different active background color for current item by matching index if active background colors list is not empty
            if (active) {
              bgColor = widget.activeBgColors == null
                  ? activeBgColor
                  : widget.activeBgColors[index ~/ 2];
            }

            if (index % 2 == 1) {
              final activeDivider = active || index ~/ 2 == current - 1;

              /// Returns item divider
              return Container(
                width: 1,
                color: activeDivider ? bgColor : Colors.white30,
                margin: EdgeInsets.symmetric(vertical: activeDivider ? 0 : 8),
              );
            } else {
              /// Returns switch item
              return GestureDetector(
                onTap: () => _handleOnTap(index ~/ 2),
                child: Container(
                  constraints: BoxConstraints(minWidth: widget.minWidth),
                  alignment: Alignment.center,
                  color: bgColor,
                  child: widget.icons == null
                      ? Text(
                          widget.labels[index ~/ 2],
                          style: TextStyle(
                            color: fgColor,
                            fontSize: widget.fontSize,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Row(
                          children: <Widget>[
                            Icon(
                              widget.icons[index ~/ 2],
                              color: fgColor,
                              size: widget.iconSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                widget.labels[index ~/ 2],
                                style: TextStyle(
                                  color: fgColor,
                                  fontSize: widget.fontSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  /// Handles selection
  void _handleOnTap(int index) async {
    setState(() => current = index);
    if (widget.onToggle != null) {
      widget.onToggle(index);
    }
  }
}
