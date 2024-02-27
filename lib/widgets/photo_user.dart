part of 'widgets.dart';

class PhotoUser extends StatelessWidget {
  final String avatarUrl;
  final int photoVersion;
  final double size;

  const PhotoUser({
    Key? key,
    required this.avatarUrl,
    required this.photoVersion,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size,
      height: this.size,
      decoration: BoxDecoration(
          color: Helpers.darken(akScaffoldBackgroundColor, 0.05),
          // border: Border.all(color: Colors.black26, width: 2),
          borderRadius: BorderRadius.circular(10.0),
          image: avatarUrl.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(avatarUrl + '?v=$photoVersion'),
                  fit: BoxFit.cover)
              : DecorationImage(
                  image: AssetImage('assets/img/default_avatar.png'),
                  fit: BoxFit.cover)),
    );
  }
}
