import 'package:flutter/widgets.dart';

class ForwardOnlyPagePhysics extends ScrollPhysics {
  const ForwardOnlyPagePhysics({super.parent});

  @override
  ForwardOnlyPagePhysics applyTo(ScrollPhysics? ancestor) {
    return ForwardOnlyPagePhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Positive offset = swiping right (backward) — block it
    if (offset > 0) {
      return 0;
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }
}
