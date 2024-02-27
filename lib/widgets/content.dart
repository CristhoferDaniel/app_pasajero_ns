part of 'widgets.dart';

class Content extends StatelessWidget {
  /// Creates a container with akContentPadding in horizontal Axis.
  Content({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: akContentPadding),
      child: child,
    );
  }
}
