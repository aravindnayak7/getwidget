import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

/// The possible alignments of a [GFDrawer].
enum GFDrawerAlignment {
  /// Denotes that the [GFDrawer] is at the start side of the [Scaffold].
  ///
  /// This corresponds to the left side when the text direction is left-to-right
  /// and the right side when the text direction is right-to-left.
  start,

  /// Denotes that the [GFDrawer] is at the end side of the [Scaffold].
  ///
  /// This corresponds to the right side when the text direction is left-to-right
  /// and the left side when the text direction is right-to-left.
  end,
}

// TODO(eseidel): Draw width should vary based on device size:
// https://material.io/design/components/navigation-drawer.html#specs

// Mobile:
// Width = Screen width − 56 dp
// Maximum width: 320dp
// Maximum width applies only when using a left nav. When using a right nav,
// the panel can cover the full width of the screen.

// Desktop/Tablet:
// Maximum width for a left nav is 400dp.
// The right nav can vary depending on content.

const double _kWidth = 304.0;
const double _kEdgeDragWidth = 20.0;
const double _kMinFlingVelocity = 365.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

/// A material design panel that slides in horizontally from the edge of a
/// [Scaffold] to show navigation links in an application.
///
/// GFDrawers are typically used with the [Scaffold.drawer] property. The child of
/// the drawer is usually a [ListView] whose first child is a [GFDrawerHeader]
/// that displays status information about the current user. The remaining
/// drawer children are often constructed with [ListTile]s, often concluding
/// with an [AboutListTile].
///
/// The [AppBar] automatically displays an appropriate [IconButton] to show the
/// [GFDrawer] when a [GFDrawer] is available in the [Scaffold]. The [Scaffold]
/// automatically handles the edge-swipe gesture to show the drawer.
///
/// {@animation 350 622 https://flutter.github.io/assets-for-api-docs/assets/material/drawer.mp4}
///
/// {@tool sample}
/// This example shows how to create a [Scaffold] that contains an [AppBar] and
/// a [GFDrawer]. A user taps the "menu" icon in the [AppBar] to open the
/// [GFDrawer]. The [GFDrawer] displays four items: A header and three menu items.
/// The [GFDrawer] displays the four items using a [ListView], which allows the
/// user to scroll through the items if need be.
///
/// ```dart
/// Scaffold(
///   appBar: AppBar(
///     title: const Text('GFDrawer Demo'),
///   ),
///   drawer: GFDrawer(
///     child: ListView(
///       padding: EdgeInsets.zero,
///       children: const <Widget>[
///         GFDrawerHeader(
///           decoration: BoxDecoration(
///             color: Colors.blue,
///           ),
///           child: Text(
///             'GFDrawer Header',
///             style: TextStyle(
///               color: Colors.white,
///               fontSize: 24,
///             ),
///           ),
///         ),
///         ListTile(
///           leading: Icon(Icons.message),
///           title: Text('Messages'),
///         ),
///         ListTile(
///           leading: Icon(Icons.account_circle),
///           title: Text('Profile'),
///         ),
///         ListTile(
///           leading: Icon(Icons.settings),
///           title: Text('Settings'),
///         ),
///       ],
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// An open drawer can be closed by calling [Navigator.pop]. For example
/// a drawer item might close the drawer when tapped:
///
/// ```dart
/// ListTile(
///   leading: Icon(Icons.change_history),
///   title: Text('Change history'),
///   onTap: () {
///     // change app state...
///     Navigator.pop(context); // close the drawer
///   },
/// );
/// ```
///
/// See also:
///
///  * [Scaffold.drawer], where one specifies a [GFDrawer] so that it can be
///    shown.
///  * [Scaffold.of], to obtain the current [ScaffoldState], which manages the
///    display and animation of the drawer.
///  * [ScaffoldState.openGFDrawer], which displays its [GFDrawer].
///
class GFDrawer extends StatelessWidget {
  /// Creates a material design drawer.
  ///
  /// Typically used in the [Scaffold.drawer] property.
  ///
  /// The [elevation] must be non-negative.
  const GFDrawer({
    Key key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
    this.backgroundImage,
    this.colorFilter,
    this.gradient
  }) : assert(elevation != null && elevation >= 0.0),
        super(key: key);

  /// The z-coordinate at which to place this drawer relative to its parent.
  ///
  /// This controls the size of the shadow below the drawer.
  ///
  /// Defaults to 16, the appropriate elevation for drawers. The value is
  /// always non-negative.
  final double elevation;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [SliverList].
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  /// The semantic label of the dialog used by accessibility frameworks to
  /// announce screen transitions when the drawer is opened and closed.
  ///
  /// If this label is not provided, it will default to
  /// [MaterialLocalizations.drawerLabel].
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.namesRoute], for a description of how this
  ///    value is used.
  final String semanticLabel;

  /// Background image can be added to the [GFDrawer].
  final ImageProvider backgroundImage;

  /// A composited layer that applies a color filter to its children.
  final ColorFilter colorFilter;

  ///
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    String label = semanticLabel;
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
        label = semanticLabel;
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = semanticLabel ?? MaterialLocalizations.of(context)?.drawerLabel;
    }
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(width: _kWidth),
        child: Material(
          elevation: elevation,
          child: Container(
              decoration: new BoxDecoration(
                color: Colors.teal,
                gradient: gradient,
                image: backgroundImage != null ? new DecorationImage(
                  image: backgroundImage,
                  fit: BoxFit.cover,
                  colorFilter: colorFilter,
                ) : null,
              ),
              child: child
          ),
        ),
      ),
    );
  }
}