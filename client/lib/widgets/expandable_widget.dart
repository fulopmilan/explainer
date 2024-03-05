import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  const ExpandableWidget(this.child, {Key? key}) : super(key: key);
  final Widget child;

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  double maxHeight = 125;
  bool closed = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => changeCurrentBoxHeight(),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        height: closed == true ? maxHeight : null,
        child: Stack(
          children: [
            widget.child,
            Container(
              decoration: closed
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    )
                  : null,
            ),
            closed
                ? const Align(
                    alignment: Alignment.bottomCenter,
                    child: Icon(Icons.arrow_drop_down_circle_outlined),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  void changeCurrentBoxHeight() {
    setState(() {
      closed = !closed;
    });
  }
}
