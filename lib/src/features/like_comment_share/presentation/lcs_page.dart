import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants.dart';
import '../../features.dart';

class LCSPage extends StatelessWidget {
  const LCSPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE3E3E3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    LikeSection(),
                    TitleIconWidget(
                      iconData: Icons.mode_comment_outlined,
                      title: 'Comment',
                      imageName: 'comment.png',
                    ),
                    TitleIconWidget(
                      title: 'Share',
                      iconData: FontAwesomeIcons.share,
                      imageName: 'share.png',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LikeSection extends StatefulWidget {
  const LikeSection({
    Key? key,
    // this.currentEmoji,
    // this.onEmojiChanged,
  }) : super(key: key);
  // final LikeFamilyEnum? currentEmoji;
  // final ValueSetter<LikeFamilyEnum>? onEmojiChanged;

  @override
  State<LikeSection> createState() => _LikeSectionState();
}

class _LikeSectionState extends State<LikeSection> {
  late OverlayEntry _overlayEntry;
  bool _isOpen = false;
  LikeFamilyEnum currentEmoji = LikeFamilyEnum.unkown;

  @override
  Widget build(BuildContext context) {
    final data = _enumToStringMapper();
    return TitleIconWidget(
      iconData: Icons.thumb_up_alt_outlined,
      title: data['title'],
      onTap: () {
        _togglePopup();
      },
      imageName: data['image'],
      color: data['color'],
    );
  }

  _enumToStringMapper() {
    final map = {
      LikeFamilyEnum.like: {
        'title': 'Like',
        'image': 'like_group.png',
        'color': blue,
      },
      LikeFamilyEnum.love: {
        'title': 'Love',
        'image': 'love.png',
        'color': red,
      },
      LikeFamilyEnum.angry: {
        'title': 'Angry',
        'image': 'angry.png',
        'color': orange,
      },
      LikeFamilyEnum.unkown: {
        'title': 'Like',
        'image': 'like.png',
        'color': null,
      },
    };

    return map[currentEmoji];
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy - size.height - 90;

    return OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () => _togglePopup(close: true),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx - 20,
              top: topOffset,
              child: LikeFamily(
                onTap: _onEmojiTapped,
              ),
            ),
          ],
        ),
      );
    });
  }

  _onEmojiTapped(LikeFamilyEnum familyEnum) {
    if (familyEnum == currentEmoji) {
      setState(() {
        currentEmoji = LikeFamilyEnum.unkown;
      });
    } else {
      setState(() {
        currentEmoji = familyEnum;
      });
    }
    _togglePopup(close: true);
  }

  _togglePopup({bool? close}) {
    if (_isOpen || (close ?? false)) {
      _overlayEntry.remove();
      setState(() {
        _isOpen = false;
      });
      return;
    }

    _overlayEntry = _createOverlay();
    Overlay.of(context)?.insert(_overlayEntry);
    setState(() {
      _isOpen = true;
    });
  }
}

class LikeFamily extends StatefulWidget {
  const LikeFamily({
    super.key,
    this.onTap,
  });
  final ValueSetter<LikeFamilyEnum>? onTap;

  @override
  State<LikeFamily> createState() => _LikeFamilyState();
}

class _LikeFamilyState extends State<LikeFamily> with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _widthAnimation = Tween<double>(begin: 0.0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.25, 1, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scaleX: _widthAnimation.value,
          scaleY: _widthAnimation.value,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(120),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildIcon(
              'like_group.png',
              blue,
              LikeFamilyEnum.like,
            ),
            const SizedBox(width: 10),
            buildIcon(
              'love.png',
              red,
              LikeFamilyEnum.love,
            ),
            const SizedBox(width: 10),
            buildIcon(
              'angry.png',
              orange,
              LikeFamilyEnum.angry,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIcon(
    String name,
    Color color,
    LikeFamilyEnum familyEnum,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await _animationController.reverse();
          if (widget.onTap != null) {
            widget.onTap!(familyEnum);
          }
        },
        borderRadius: BorderRadius.circular(30),
        splashColor: color,
        child: Image.asset('assets/images/$name'),
      ),
    );
  }
}

class TitleIconWidget extends StatelessWidget {
  const TitleIconWidget({
    super.key,
    required this.iconData,
    required this.imageName,
    required this.title,
    this.color,
    this.onTap,
  });
  final IconData iconData;
  final String title;
  final Color? color;
  final VoidCallback? onTap;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/$imageName',
            height: 28,
            width: 28,
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: color == null ? FontWeight.w300 : FontWeight.w500,
              height: 29.05 / 24,
            ),
          ),
        ],
      ),
    );
  }
}
