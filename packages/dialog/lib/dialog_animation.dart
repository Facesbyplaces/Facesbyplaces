part of dialog;

enum AnimationEntry {
  /// Appears in Center, standard Material dialog entrance animation, i.e. slow fade-in in the center of the screen.
  standard,

  /// Enters screen horizontally from the left
  left,

  /// Enters screen horizontally from the right
  right,

  /// Enters screen horizontally from the top
  top,

  /// Enters screen horizontally from the bottom
  bottom,

  /// Enters screen from the top left corner
  topLeft,

  /// Enters screen from the top right corner
  topRight,

  /// Enters screen from the bottom left corner
  bottomLeft,

  /// Enters screen from the bottom right corner
  bottomRight,
}