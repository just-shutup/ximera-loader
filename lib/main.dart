import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const XimeraApp());
}

class XimeraApp extends StatelessWidget {
  const XimeraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<XimeraVisualTheme>(
      valueListenable: AppThemes.controller,
      builder: (context, visualTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ximera Loader',
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: visualTheme.background.last,
            colorScheme: ColorScheme.dark(
              primary: visualTheme.accent,
              secondary: visualTheme.secondary,
              surface: AppPalette.panel,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
              },
            ),
            textSelectionTheme: TextSelectionThemeData(cursorColor: visualTheme.accent),
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}

class AppPalette {
  static const voidBlack = Color(0xFF050506);
  static const black = Color(0xFF090A0D);
  static const panel = Color(0xFF12151C);
  static const panelLight = Color(0xFF1B202A);
  static const ice = Color(0xFFF8FAFC);
  static const porcelain = Color(0xFFE5E7EB);
  static const steel = Color(0xFF94A3B8);
  static const muted = Color(0xFF64748B);
  static const border = Color(0x26FFFFFF);
  static const success = Color(0xFF8FFFD2);
  static const warning = Color(0xFFFFD089);
  static const danger = Color(0xFFFF8F8F);
}

class XimeraVisualTheme {
  final String name;
  final String subtitle;
  final Color accent;
  final Color secondary;
  final List<Color> background;
  final List<Color> aurora;
  final List<Color> glass;

  const XimeraVisualTheme({
    required this.name,
    required this.subtitle,
    required this.accent,
    required this.secondary,
    required this.background,
    required this.aurora,
    required this.glass,
  });
}

class AppThemes {
  static const themes = <XimeraVisualTheme>[
    XimeraVisualTheme(
      name: 'Noir Glass',
      subtitle: 'Deep black, ice borders, clean premium contrast.',
      accent: Color(0xFFF8FAFC),
      secondary: Color(0xFF94A3B8),
      background: [Color(0xFF030305), Color(0xFF0D1017), Color(0xFF171B24), Color(0xFF050506)],
      aurora: [Color(0xFFF8FAFC), Color(0xFF94A3B8), Color(0xFF64748B)],
      glass: [Color(0x33FFFFFF), Color(0x12FFFFFF)],
    ),
    XimeraVisualTheme(
      name: 'Cyber Emerald',
      subtitle: 'Black carbon panels with neon green tactical glow.',
      accent: Color(0xFF70FFB3),
      secondary: Color(0xFF22D3A6),
      background: [Color(0xFF020704), Color(0xFF05140E), Color(0xFF0B2B1B), Color(0xFF020403)],
      aurora: [Color(0xFF70FFB3), Color(0xFF16A34A), Color(0xFF0EA5A4)],
      glass: [Color(0x2A70FFB3), Color(0x0FFFFFFF)],
    ),
    XimeraVisualTheme(
      name: 'Royal Violet',
      subtitle: 'Purple bloom, graphite cards, streamer-style depth.',
      accent: Color(0xFFC084FC),
      secondary: Color(0xFF818CF8),
      background: [Color(0xFF05030A), Color(0xFF120A24), Color(0xFF2E1065), Color(0xFF07030F)],
      aurora: [Color(0xFFC084FC), Color(0xFF7C3AED), Color(0xFF38BDF8)],
      glass: [Color(0x2AC084FC), Color(0x0FFFFFFF)],
    ),
    XimeraVisualTheme(
      name: 'Solar Gold',
      subtitle: 'Warm gold accents over dark cinematic surfaces.',
      accent: Color(0xFFFFD166),
      secondary: Color(0xFFFF9F1C),
      background: [Color(0xFF070503), Color(0xFF1B1004), Color(0xFF3A2507), Color(0xFF050302)],
      aurora: [Color(0xFFFFD166), Color(0xFFFF9F1C), Color(0xFFFFE08A)],
      glass: [Color(0x2AFFD166), Color(0x0FFFFFFF)],
    ),
    XimeraVisualTheme(
      name: 'Arctic Blue',
      subtitle: 'Cold blue light, frosted panels, high-tech dashboard mood.',
      accent: Color(0xFF7DD3FC),
      secondary: Color(0xFF38BDF8),
      background: [Color(0xFF020617), Color(0xFF071426), Color(0xFF0C4A6E), Color(0xFF020617)],
      aurora: [Color(0xFF7DD3FC), Color(0xFF38BDF8), Color(0xFFBAE6FD)],
      glass: [Color(0x2A7DD3FC), Color(0x0FFFFFFF)],
    ),
    XimeraVisualTheme(
      name: 'Crimson Ops',
      subtitle: 'Red tactical UI with aggressive cinematic shadows.',
      accent: Color(0xFFFF6B6B),
      secondary: Color(0xFFFB7185),
      background: [Color(0xFF080202), Color(0xFF1F0707), Color(0xFF450A0A), Color(0xFF050101)],
      aurora: [Color(0xFFFF6B6B), Color(0xFFEF4444), Color(0xFFFFA3A3)],
      glass: [Color(0x2AFF6B6B), Color(0x0FFFFFFF)],
    ),
  ];

  static final controller = ValueNotifier<XimeraVisualTheme>(themes.first);

  static void setByName(String name) {
    controller.value = themes.firstWhere((theme) => theme.name == name, orElse: () => themes.first);
  }
}

extension XimeraThemeX on BuildContext {
  XimeraVisualTheme get visualTheme => AppThemes.controller.value;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController(text: 'ximera');
  final _passwordController = TextEditingController(text: '123');

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool _rememberMe = true;
  bool _hidePassword = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 680),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(begin: const Offset(0, .045), end: Offset.zero).animate(_fade);
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _openMainScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 720),
        reverseTransitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: const MainScreen(),
        ),
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutExpo);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(.055, .035), end: Offset.zero).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 860;
                        return FrostPanel(
                          radius: 34,
                          padding: EdgeInsets.all(wide ? 18 : 14),
                          child: wide
                              ? Row(
                                  children: [
                                    const Expanded(child: LoginHeroPanel()),
                                    const SizedBox(width: 18),
                                    Expanded(child: _LoginFormCard(parent: this)),
                                  ],
                                )
                              : Column(
                                  children: [
                                    const LoginHeroPanel(compact: true),
                                    const SizedBox(height: 14),
                                    _LoginFormCard(parent: this),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginFormCard extends StatelessWidget {
  final _LoginScreenState parent;

  const _LoginFormCard({required this.parent});

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 30,
      blur: 30,
      opacity: .10,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const XimeraMark(size: 52),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Ximera Access', style: AppText.titleSmall),
                    SizedBox(height: 3),
                    Text('Secure loader interface', style: AppText.caption),
                  ],
                ),
              ),
              const StatusChip(text: 'v2.0', icon: Icons.auto_awesome_rounded),
            ],
          ),
          const SizedBox(height: 34),
          const Text('Welcome back', style: AppText.display),
          const SizedBox(height: 8),
          Text(
            'Enter your credentials to open the dashboard.',
            style: AppText.body.copyWith(color: AppPalette.steel),
          ),
          const SizedBox(height: 28),
          XimeraField(
            label: 'Username',
            hint: 'ximera',
            icon: Icons.person_outline_rounded,
            controller: parent._usernameController,
          ),
          const SizedBox(height: 14),
          XimeraField(
            label: 'Password',
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            controller: parent._passwordController,
            obscureText: parent._hidePassword,
            trailing: IconButton(
              onPressed: () => parent.setState(() => parent._hidePassword = !parent._hidePassword),
              icon: Icon(
                parent._hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppPalette.steel,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: parent._rememberMe,
                  onChanged: (value) => parent.setState(() => parent._rememberMe = value ?? false),
                  activeColor: AppPalette.ice,
                  checkColor: AppPalette.black,
                  side: const BorderSide(color: AppPalette.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(width: 10),
              const Text('Remember device', style: AppText.captionStrong),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: AppPalette.porcelain),
                child: const Text('Need help?'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryActionButton(
            label: 'Enter Dashboard',
            icon: Icons.arrow_forward_rounded,
            onTap: parent._openMainScreen,
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shield_moon_outlined, color: AppPalette.muted, size: 16),
              SizedBox(width: 7),
              Text('Private session', style: AppText.caption),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginHeroPanel extends StatelessWidget {
  final bool compact;

  const LoginHeroPanel({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: compact ? 260 : 560),
      padding: EdgeInsets.all(compact ? 24 : 34),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x1AFFFFFF), Color(0x05000000)],
        ),
        border: Border.all(color: AppPalette.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: CircuitPainter())),
          Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                StatusChip(text: 'Desktop', icon: Icons.desktop_windows_outlined),
                StatusChip(text: 'Glass UI', icon: Icons.blur_on_rounded),
                StatusChip(text: 'Responsive', icon: Icons.fit_screen_rounded),
              ],
            ),
          ),
          Align(
            alignment: compact ? Alignment.center : Alignment.bottomLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 470),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  const XimeraMark(size: 92),
                  const SizedBox(height: 24),
                  Text(
                    'A sharper command center for Ximera.',
                    textAlign: compact ? TextAlign.center : TextAlign.left,
                    style: AppText.hero.copyWith(fontSize: compact ? 34 : 52),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Deep black surfaces, crystalline borders, soft bloom, clean spacing, and premium desktop interaction patterns.',
                    textAlign: compact ? TextAlign.center : TextAlign.left,
                    style: AppText.body.copyWith(color: AppPalette.steel),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  GameEntry _selectedGame = gameLibrary.first;

  final List<NavItem> _items = const [
    NavItem('Overview', Icons.dashboard_outlined),
    NavItem('Library', Icons.grid_view_rounded),
    NavItem('Settings', Icons.tune_rounded),
    NavItem('Profile', Icons.account_circle_outlined),
    NavItem('About', Icons.info_outline_rounded),
  ];

  String get _title => _selectedIndex == 0 ? 'Overview - ${_selectedGame.title}' : _items[_selectedIndex].label;

  void _openGameOverview(GameEntry game) {
    setState(() {
      _selectedGame = game;
      _selectedIndex = 0;
    });
  }

  void _launchGame(GameEntry game) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppPalette.panelLight,
          content: Text('Launching ${game.title}...'),
        ),
      );
  }

  Widget get _page {
    switch (_selectedIndex) {
      case 0:
        return OverviewPage(game: _selectedGame, onLaunch: () => _launchGame(_selectedGame));
      case 1:
        return LibraryPage(selectedGame: _selectedGame, onGameSelected: _openGameOverview);
      case 2:
        return const SettingsPage();
      case 3:
        return const ProfilePage();
      case 4:
      default:
        return const AboutPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 920;
              return Padding(
                padding: EdgeInsets.all(compact ? 14 : 24),
                child: Row(
                  children: [
                    XimeraSidebar(
                      compact: compact,
                      selectedIndex: _selectedIndex,
                      items: _items,
                      onSelect: (index) => setState(() => _selectedIndex = index),
                    ),
                    SizedBox(width: compact ? 12 : 18),
                    Expanded(
                      child: Column(
                        children: [
                          DashboardHeader(title: _title),
                          SizedBox(height: compact ? 12 : 18),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 520),
                              reverseDuration: const Duration(milliseconds: 320),
                              switchInCurve: Curves.easeOutExpo,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutExpo);
                                return FadeTransition(
                                  opacity: curved,
                                  child: ScaleTransition(
                                    scale: Tween<double>(begin: .985, end: 1).animate(curved),
                                    child: SlideTransition(
                                      position: Tween<Offset>(begin: const Offset(.025, .012), end: Offset.zero).animate(curved),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: KeyedSubtree(
                                key: ValueKey<int>(_selectedIndex),
                                child: _page,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String label;
  final IconData icon;

  const NavItem(this.label, this.icon);
}

class XimeraSidebar extends StatelessWidget {
  final bool compact;
  final int selectedIndex;
  final List<NavItem> items;
  final ValueChanged<int> onSelect;

  const XimeraSidebar({
    super.key,
    required this.compact,
    required this.selectedIndex,
    required this.items,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      width: compact ? 82 : 260,
      radius: 30,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: compact ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              const XimeraMark(size: 46),
              if (!compact) ...[
                const SizedBox(width: 13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Ximera', style: AppText.logo),
                    Text('Loader UI', style: AppText.caption),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 28),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) => NavTile(
                item: items[index],
                compact: compact,
                selected: selectedIndex == index,
                onTap: () => onSelect(index),
              ),
            ),
          ),
          const SizedBox(height: 14),
          FrostPanel(
            radius: 22,
            blur: 18,
            opacity: .06,
            padding: EdgeInsets.all(compact ? 12 : 14),
            child: compact
                ? const Icon(Icons.power_settings_new_rounded, color: AppPalette.steel, size: 21)
                : Row(
                    children: const [
                      Icon(Icons.bolt_rounded, color: AppPalette.success, size: 20),
                      SizedBox(width: 10),
                      Expanded(child: Text('System ready', style: AppText.captionStrong)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class NavTile extends StatefulWidget {
  final NavItem item;
  final bool compact;
  final bool selected;
  final VoidCallback onTap;

  const NavTile({
    super.key,
    required this.item,
    required this.compact,
    required this.selected,
    required this.onTap,
  });

  @override
  State<NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected || _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          height: 54,
          padding: EdgeInsets.symmetric(horizontal: widget.compact ? 0 : 14),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppPalette.ice.withOpacity(.16)
                : active
                    ? AppPalette.ice.withOpacity(.075)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: widget.selected ? AppPalette.ice.withOpacity(.28) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: widget.compact ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              AnimatedScale(
                scale: active ? 1.08 : 1,
                duration: const Duration(milliseconds: 220),
                child: Icon(
                  widget.item.icon,
                  color: widget.selected ? AppPalette.ice : AppPalette.steel,
                  size: 22,
                ),
              ),
              if (!widget.compact) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: TextStyle(
                      color: widget.selected ? AppPalette.ice : AppPalette.steel,
                      fontWeight: widget.selected ? FontWeight.w800 : FontWeight.w600,
                      letterSpacing: -.1,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: widget.selected ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: AppPalette.ice, shape: BoxShape.circle),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final String title;

  const DashboardHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 28,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.title),
                const SizedBox(height: 4),
                Text(
                  'Premium black-and-glass desktop dashboard',
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(color: AppPalette.steel),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const StatusChip(text: 'Online', icon: Icons.wifi_tethering_rounded, accent: AppPalette.success),
          const SizedBox(width: 12),
          const UserAvatar(),
        ],
      ),
    );
  }
}

class OverviewPage extends StatelessWidget {
  final GameEntry game;
  final VoidCallback onLaunch;

  const OverviewPage({super.key, required this.game, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 760;
              final cards = [
                MetricCard(label: 'Status', value: game.status, icon: Icons.check_circle_outline_rounded, accent: game.accent),
                MetricCard(label: 'Selected', value: game.title, icon: game.icon, accent: game.accent),
                MetricCard(label: 'Library', value: gameLibrary.length.toString().padLeft(2, '0'), icon: Icons.grid_view_rounded),
              ];
              return narrow
                  ? Column(
                      children: cards
                          .map((card) => Padding(padding: const EdgeInsets.only(bottom: 12), child: card))
                          .toList(),
                    )
                  : Row(
                      children: [
                        for (var i = 0; i < cards.length; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: i == cards.length - 1 ? 0 : 12),
                              child: cards[i],
                            ),
                          ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 18),
          FeaturedGameCard(game: game, onLaunch: onLaunch),
        ],
      ),
    );
  }
}

class GameEntry {
  final String title;
  final String status;
  final String description;
  final String bannerUrl;
  final IconData icon;
  final Color accent;
  final List<Color> colors;

  const GameEntry({
    required this.title,
    required this.status,
    required this.description,
    required this.bannerUrl,
    required this.icon,
    required this.accent,
    required this.colors,
  });
}

const List<GameEntry> gameLibrary = [
  GameEntry(
    title: 'CS2',
    status: 'Available',
    description: 'Modern Counter-Strike 2 profile with sharp metallic contrast, smoke-light bloom, and competitive focus.',
    bannerUrl: 'https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/730/header.jpg',
    icon: Icons.my_location_rounded,
    accent: Color(0xFF9FE8FF),
    colors: [Color(0xFF1D4ED8), Color(0xFF0F172A), Color(0xFF020617)],
  ),
  GameEntry(
    title: 'CS:GO',
    status: 'Available',
    description: 'Classic Counter-Strike: Global Offensive profile with tactical noir styling and clean legacy energy.',
    bannerUrl: 'https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/730/header.jpg',
    icon: Icons.gps_fixed_rounded,
    accent: AppPalette.success,
    colors: [Color(0xFFB88A2A), Color(0xFF1E293B), Color(0xFF020617)],
  ),
  GameEntry(
    title: 'Dota 2',
    status: 'Available',
    description: 'Dark fantasy launcher tile with warm battlefield glow and premium glass depth.',
    bannerUrl: 'https://shared.cloudflare.steamstatic.com/store_item_assets/steam/apps/570/header.jpg',
    icon: Icons.auto_fix_high_rounded,
    accent: Color(0xFFFF7A70),
    colors: [Color(0xFF8B1E1E), Color(0xFF2A1114), Color(0xFF050506)],
  ),
  GameEntry(
    title: 'Minecraft',
    status: 'Available',
    description: 'Blocky adventure profile with a green overworld mood and soft cinematic lighting.',
    bannerUrl: 'https://www.minecraft.net/content/dam/minecraftnet/games/minecraft/key-art/CC-Update-Part-II_600x360.jpg',
    icon: Icons.terrain_rounded,
    accent: Color(0xFF7CFF8A),
    colors: [Color(0xFF2F7D32), Color(0xFF4B8B3B), Color(0xFF0B1F12)],
  ),
];

class LibraryPage extends StatelessWidget {
  final GameEntry selectedGame;
  final ValueChanged<GameEntry> onGameSelected;

  const LibraryPage({super.key, required this.selectedGame, required this.onGameSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1080
              ? 3
              : constraints.maxWidth > 700
                  ? 2
                  : 1;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: constraints.maxWidth > 700 ? 1.05 : 1.28,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: gameLibrary
                .map((game) => GameTile(
                      game: game,
                      selected: game.title == selectedGame.title,
                      onTap: () => onGameSelected(game),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}

class FeaturedGameCard extends StatefulWidget {
  final GameEntry game;
  final VoidCallback onLaunch;

  const FeaturedGameCard({super.key, required this.game, required this.onLaunch});

  @override
  State<FeaturedGameCard> createState() => _FeaturedGameCardState();
}

class _FeaturedGameCardState extends State<FeaturedGameCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.008 : 1,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        child: FrostPanel(
          radius: 32,
          padding: const EdgeInsets.all(24),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 780;
              final cover = GamePoster(game: widget.game, hovered: _hovered);
              final info = GameInfo(game: widget.game, hovered: _hovered, onLaunch: widget.onLaunch);
              return narrow
                  ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [cover, const SizedBox(height: 24), info])
                  : Row(children: [SizedBox(width: 310, height: 390, child: cover), const SizedBox(width: 30), Expanded(child: info)]);
            },
          ),
        ),
      ),
    );
  }
}

class GameInfo extends StatelessWidget {
  final GameEntry game;
  final bool hovered;
  final VoidCallback onLaunch;

  const GameInfo({super.key, required this.game, required this.hovered, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusChip(text: game.status, icon: Icons.verified_rounded, accent: game.accent),
        const SizedBox(height: 22),
        Text(game.title, style: AppText.hero.copyWith(fontSize: 44)),
        const SizedBox(height: 14),
        Text(
          game.description,
          style: AppText.body.copyWith(color: AppPalette.porcelain, height: 1.55),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            InfoPill(label: 'Build', value: 'UI Concept'),
            InfoPill(label: 'Mode', value: 'Desktop'),
            InfoPill(label: 'Theme', value: 'Noir Glass'),
            InfoPill(label: 'State', value: 'Ready'),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            SizedBox(
              width: 190,
              child: PrimaryActionButton(label: 'Launch', icon: Icons.play_arrow_rounded, onTap: onLaunch),
            ),
            const SizedBox(width: 12),
            RoundIconButton(icon: Icons.more_horiz_rounded, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class GamePoster extends StatelessWidget {
  final GameEntry game;
  final bool hovered;

  const GamePoster({super.key, required this.game, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      height: 390,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: game.colors,
        ),
        border: Border.all(color: AppPalette.ice.withOpacity(hovered ? .30 : .18)),
        boxShadow: [
          BoxShadow(
            color: game.accent.withOpacity(hovered ? .24 : .14),
            blurRadius: hovered ? 48 : 30,
            offset: const Offset(0, 22),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(hovered ? .50 : .36),
            blurRadius: hovered ? 44 : 28,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(child: GameBannerImage(url: game.bannerUrl, fit: BoxFit.cover)),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(.06), Colors.black.withOpacity(.78)],
                  ),
                ),
              ),
            ),
            Positioned.fill(child: CustomPaint(painter: DiagonalGridPainter())),
            Positioned(right: -44, top: -50, child: GlowOrb(size: 180, opacity: .09)),
            Positioned(left: -70, bottom: -70, child: GlowOrb(size: 220, opacity: .07)),
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: hovered ? 1.08 : 1,
                    duration: const Duration(milliseconds: 260),
                    alignment: Alignment.centerLeft,
                    child: Icon(game.icon, color: AppPalette.ice, size: 58),
                  ),
                  const SizedBox(height: 18),
                  Text(game.title.toUpperCase(), style: AppText.overline),
                  const SizedBox(height: 8),
                  Text('Premium launcher profile', style: AppText.caption.copyWith(color: AppPalette.porcelain)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameTile extends StatefulWidget {
  final GameEntry game;
  final bool selected;
  final VoidCallback onTap;

  const GameTile({super.key, required this.game, required this.selected, required this.onTap});

  @override
  State<GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.018 : 1,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          child: FrostPanel(
            radius: 28,
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: game.colors,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(child: GameBannerImage(url: game.bannerUrl, fit: BoxFit.cover)),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(.10), Colors.black.withOpacity(.82)],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(child: CustomPaint(painter: DiagonalGridPainter())),
                  Positioned(
                    top: 18,
                    left: 18,
                    right: 18,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.30),
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(color: AppPalette.ice.withOpacity(.18)),
                          ),
                          child: Icon(game.icon, color: AppPalette.ice, size: 25),
                        ),
                        const Spacer(),
                        StatusChip(
                          text: widget.selected ? 'Selected' : game.status,
                          icon: widget.selected ? Icons.check_rounded : Icons.circle,
                          accent: game.accent,
                        ),
                      ],
                    ),
                  ),
                  if (widget.selected)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: game.accent.withOpacity(.55), width: 2),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(game.title, style: AppText.titleSmall),
                        const SizedBox(height: 8),
                        Text(
                          game.description,
                          style: AppText.caption.copyWith(height: 1.45, color: AppPalette.porcelain),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameBannerImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const GameBannerImage({super.key, required this.url, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const SizedBox.expand();
      },
      errorBuilder: (context, error, stackTrace) => const SizedBox.expand(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _theme = AppThemes.controller.value.name;
  String _language = 'English';
  bool _animations = true;
  bool _blur = true;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: FrostPanel(
        radius: 32,
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Interface Settings', style: AppText.hero.copyWith(fontSize: 38)),
            const SizedBox(height: 8),
            Text('Pick a real visual theme, tune motion, and preview the dashboard shell live.', style: AppText.body.copyWith(color: AppPalette.steel)),
            const SizedBox(height: 26),
            SettingsDropdown(
              title: 'Active theme',
              value: _theme,
              values: AppThemes.themes.map((theme) => theme.name).toList(),
              onChanged: (value) {
                setState(() => _theme = value);
                AppThemes.setByName(value);
              },
            ),
            const SizedBox(height: 14),
            ThemeShowcase(
              selected: _theme,
              onChanged: (value) {
                setState(() => _theme = value);
                AppThemes.setByName(value);
              },
            ),
            const SizedBox(height: 14),
            SettingsSwitch(
              title: 'Animations',
              subtitle: 'Smooth transitions, hover lifts, and page fades.',
              value: _animations,
              onChanged: (value) => setState(() => _animations = value),
            ),
            SettingsSwitch(
              title: 'Glass blur',
              subtitle: 'Layered BackdropFilter panels and bloom highlights.',
              value: _blur,
              onChanged: (value) => setState(() => _blur = value),
            ),
            SettingsSwitch(
              title: 'Notifications',
              subtitle: 'Visual preference for dashboard alerts.',
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
            ),
            const SizedBox(height: 14),
            SettingsDropdown(
              title: 'Language',
              value: _language,
              values: const ['English', 'Русский', 'Deutsch', 'Español'],
              onChanged: (value) => setState(() => _language = value),
            ),
            const SizedBox(height: 28),
            SizedBox(width: 220, child: PrimaryActionButton(label: 'Save Settings', icon: Icons.check_rounded, onTap: () {})),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: FrostPanel(
          radius: 32,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const UserAvatar(size: 86),
              const SizedBox(height: 20),
              Text('Ximera User', style: AppText.hero.copyWith(fontSize: 36), textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'Profile preview with premium spacing, soft borders, and simple account presentation.',
                style: AppText.body.copyWith(color: AppPalette.steel),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: const [
                  InfoPill(label: 'Role', value: 'User'),
                  InfoPill(label: 'Access', value: 'Visual'),
                  InfoPill(label: 'Session', value: 'Local'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: FrostPanel(
          radius: 32,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const XimeraMark(size: 84),
              const SizedBox(height: 22),
              Text('About Ximera', style: AppText.hero.copyWith(fontSize: 38), textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'A polished Flutter interface concept focused on black glassmorphism, responsive desktop layout, visual states, and reusable component structure.',
                style: AppText.body.copyWith(color: AppPalette.steel, height: 1.55),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ThemeShowcase extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const ThemeShowcase({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 900 ? 3 : constraints.maxWidth > 560 ? 2 : 1;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: columns == 1 ? 3.7 : 2.65,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: AppThemes.themes.map((theme) {
            final active = theme.name == selected;
            return ThemeSwatchCard(theme: theme, active: active, onTap: () => onChanged(theme.name));
          }).toList(),
        );
      },
    );
  }
}

class ThemeSwatchCard extends StatefulWidget {
  final XimeraVisualTheme theme;
  final bool active;
  final VoidCallback onTap;

  const ThemeSwatchCard({super.key, required this.theme, required this.active, required this.onTap});

  @override
  State<ThemeSwatchCard> createState() => _ThemeSwatchCardState();
}

class _ThemeSwatchCardState extends State<ThemeSwatchCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active || _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.018 : 1,
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: widget.theme.background),
              border: Border.all(color: active ? widget.theme.accent.withOpacity(.68) : AppPalette.border, width: active ? 1.4 : 1),
              boxShadow: [
                BoxShadow(color: widget.theme.accent.withOpacity(active ? .22 : .08), blurRadius: active ? 28 : 14, offset: const Offset(0, 12)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(colors: widget.theme.aurora),
                    boxShadow: [BoxShadow(color: widget.theme.accent.withOpacity(.35), blurRadius: 22)],
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.theme.name, overflow: TextOverflow.ellipsis, style: AppText.captionStrong.copyWith(color: AppPalette.ice, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(widget.theme.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppText.micro.copyWith(height: 1.25, color: AppPalette.porcelain.withOpacity(.72))),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: widget.active ? 1 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(Icons.check_circle_rounded, color: widget.theme.accent, size: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitch({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsShell(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.settingTitle),
                const SizedBox(height: 5),
                Text(subtitle, style: AppText.caption.copyWith(height: 1.35)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppPalette.ice,
            activeTrackColor: AppPalette.ice.withOpacity(.22),
            inactiveThumbColor: AppPalette.steel,
            inactiveTrackColor: AppPalette.ice.withOpacity(.08),
          ),
        ],
      ),
    );
  }
}

class SettingsSegmented<T extends Object> extends StatelessWidget {
  final String title;
  final T value;
  final List<T> values;
  final ValueChanged<T> onChanged;

  const SettingsSegmented({
    super.key,
    required this.title,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsShell(
      child: Row(
        children: [
          Text(title, style: AppText.settingTitle),
          const Spacer(),
          Flexible(
            child: SegmentedButton<T>(
              segments: values.map((item) => ButtonSegment<T>(value: item, label: Text(item.toString()))).toList(),
              selected: {value},
              onSelectionChanged: (selection) => onChanged(selection.first),
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) => states.contains(MaterialState.selected) ? AppPalette.black : AppPalette.ice,
                ),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => states.contains(MaterialState.selected) ? AppPalette.ice : AppPalette.ice.withOpacity(.055),
                ),
                side: MaterialStateProperty.all(BorderSide(color: AppPalette.ice.withOpacity(.15))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsDropdown extends StatelessWidget {
  final String title;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  const SettingsDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsShell(
      child: Row(
        children: [
          Text(title, style: AppText.settingTitle),
          const Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: AppPalette.panel,
              borderRadius: BorderRadius.circular(18),
              iconEnabledColor: AppPalette.ice,
              style: const TextStyle(color: AppPalette.ice, fontWeight: FontWeight.w700),
              items: values.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
              onChanged: (item) {
                if (item != null) onChanged(item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsShell extends StatelessWidget {
  final Widget child;

  const SettingsShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppPalette.ice.withOpacity(.055),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPalette.border),
      ),
      child: child,
    );
  }
}

class FrostPanel extends StatelessWidget {
  final Widget child;
  final double radius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const FrostPanel({
    super.key,
    required this.child,
    this.radius = 24,
    this.blur = 24,
    this.opacity = .08,
    this.padding = const EdgeInsets.all(20),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final visualTheme = context.visualTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 360),
          curve: Curves.easeOutCubic,
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [visualTheme.glass.first.withOpacity(opacity + .055), AppPalette.ice.withOpacity(opacity * .55)],
            ),
            border: Border.all(color: visualTheme.accent.withOpacity(.18)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(.38), blurRadius: 38, offset: const Offset(0, 20)),
              BoxShadow(color: visualTheme.accent.withOpacity(.055), blurRadius: 32, offset: const Offset(-12, -12)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class PrimaryActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const PrimaryActionButton({super.key, required this.label, required this.icon, required this.onTap});

  @override
  State<PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<PrimaryActionButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final visualTheme = context.visualTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          height: 56,
          transform: Matrix4.translationValues(0, _pressed ? 1 : (_hovered ? -2 : 0), 0),
          decoration: BoxDecoration(
            color: _hovered ? Color.lerp(visualTheme.accent, AppPalette.ice, .30)! : visualTheme.accent,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: visualTheme.accent.withOpacity(_hovered ? .34 : .18),
                blurRadius: _hovered ? 34 : 20,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.label, style: const TextStyle(color: AppPalette.black, fontSize: 15, fontWeight: FontWeight.w900)),
              const SizedBox(width: 9),
              Icon(widget.icon, color: AppPalette.black, size: 21),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const RoundIconButton({super.key, required this.icon, required this.onTap});

  @override
  State<RoundIconButton> createState() => _RoundIconButtonState();
}

class _RoundIconButtonState extends State<RoundIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppPalette.ice.withOpacity(_hovered ? .12 : .07),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppPalette.border),
          ),
          child: Icon(widget.icon, color: AppPalette.ice),
        ),
      ),
    );
  }
}

class XimeraField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? trailing;

  const XimeraField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppPalette.ice, fontSize: 15, fontWeight: FontWeight.w600),
      cursorColor: AppPalette.ice,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: AppPalette.steel),
        hintStyle: const TextStyle(color: AppPalette.muted),
        prefixIcon: Icon(icon, color: AppPalette.steel, size: 21),
        suffixIcon: trailing,
        filled: true,
        fillColor: AppPalette.ice.withOpacity(.06),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppPalette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppPalette.ice.withOpacity(.42)),
        ),
      ),
    );
  }
}

class XimeraMark extends StatelessWidget {
  final double size;

  const XimeraMark({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final visualTheme = context.visualTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppPalette.ice, visualTheme.accent, visualTheme.secondary],
        ),
        border: Border.all(color: Colors.white.withOpacity(.55)),
        boxShadow: [BoxShadow(color: visualTheme.accent.withOpacity(.30), blurRadius: size * .42, offset: Offset(0, size * .12))],
      ),
      child: Center(
        child: Text(
          'X',
          style: TextStyle(
            color: AppPalette.black,
            fontSize: size * .50,
            fontWeight: FontWeight.w900,
            letterSpacing: -size * .035,
          ),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? accent;

  const StatusChip({super.key, required this.text, required this.icon, this.accent});

  @override
  Widget build(BuildContext context) {
    final chipAccent = accent ?? context.visualTheme.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: chipAccent.withOpacity(.11),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: chipAccent.withOpacity(.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: chipAccent, size: 14),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(color: AppPalette.ice, fontSize: 12, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final double size;

  const UserAvatar({super.key, this.size = 42});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppPalette.ice.withOpacity(.08),
        border: Border.all(color: AppPalette.border),
      ),
      child: Icon(Icons.person_outline_rounded, color: AppPalette.ice, size: size * .48),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accent = AppPalette.ice,
  });

  @override
  Widget build(BuildContext context) {
    return FrostPanel(
      radius: 26,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent.withOpacity(.10),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent.withOpacity(.22)),
            ),
            child: Icon(icon, color: accent, size: 25),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppText.caption),
              const SizedBox(height: 4),
              Text(value, style: AppText.titleSmall),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  final String label;
  final String value;

  const InfoPill({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: AppPalette.ice.withOpacity(.065),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppText.micro),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: AppPalette.ice, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class AuroraBackground extends StatefulWidget {
  final Widget child;

  const AuroraBackground({super.key, required this.child});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visualTheme = context.visualTheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final wave = math.sin(t * math.pi * 2);
        final wave2 = math.cos(t * math.pi * 2);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 620),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + wave * .16, -1),
              end: Alignment(1 + wave2 * .12, 1),
              colors: visualTheme.background,
            ),
          ),
          child: Stack(
            children: [
              Positioned(left: 44 + wave * 120, top: 26 + wave2 * 24, child: GlowOrb(size: 310, opacity: .14, color: visualTheme.aurora[0])),
              Positioned(right: 34 + wave2 * 130, bottom: 22 + wave * 30, child: GlowOrb(size: 390, opacity: .11, color: visualTheme.aurora[1])),
              Positioned(left: MediaQuery.of(context).size.width * .42 + wave * 40, top: -145, child: GlowOrb(size: 330, opacity: .075, color: visualTheme.aurora[2])),
              Positioned.fill(child: CustomPaint(painter: AuroraRibbonPainter(t, visualTheme))),
              Positioned.fill(child: CustomPaint(painter: NoiseStarPainter(t))),
              Positioned.fill(child: widget.child),
            ],
          ),
        );
      },
    );
  }
}

class GlowOrb extends StatelessWidget {
  final double size;
  final double opacity;
  final Color? color;

  const GlowOrb({super.key, required this.size, required this.opacity, this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (color ?? AppPalette.ice).withOpacity(opacity),
          boxShadow: [BoxShadow(color: (color ?? AppPalette.ice).withOpacity(opacity), blurRadius: 130, spreadRadius: 34)],
        ),
      ),
    );
  }
}


class AuroraRibbonPainter extends CustomPainter {
  final double t;
  final XimeraVisualTheme theme;

  AuroraRibbonPainter(this.t, this.theme);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final yBase = size.height * (.30 + math.sin(t * math.pi * 2) * .035);
    path.moveTo(-80, yBase);
    for (double x = -80; x <= size.width + 80; x += 80) {
      final y = yBase + math.sin((x / size.width * math.pi * 2) + t * math.pi * 2) * 38;
      path.lineTo(x, y);
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(colors: [theme.accent.withOpacity(.00), theme.accent.withOpacity(.18), theme.secondary.withOpacity(.02)]).createShader(Offset.zero & size);
    canvas.drawPath(path, paint);

    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
      ..shader = LinearGradient(colors: [theme.accent.withOpacity(.00), theme.accent.withOpacity(.08), theme.secondary.withOpacity(.00)]).createShader(Offset.zero & size);
    canvas.drawPath(path, glow);
  }

  @override
  bool shouldRepaint(covariant AuroraRibbonPainter oldDelegate) => oldDelegate.t != t || oldDelegate.theme != theme;
}

class CircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.075)
      ..strokeWidth = 1;
    const gap = 34.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height * .5, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + size.width * .12), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DiagonalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(.07)
      ..strokeWidth = 1;
    for (double x = -size.height; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NoiseStarPainter extends CustomPainter {
  final double t;

  NoiseStarPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(9);
    final paint = Paint()..color = Colors.white.withOpacity(.075);
    for (int i = 0; i < 70; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final pulse = .6 + math.sin((t * math.pi * 2) + i) * .4;
      canvas.drawCircle(Offset(x, y), .55 + pulse * .45, paint);
    }
  }

  @override
  bool shouldRepaint(covariant NoiseStarPainter oldDelegate) => oldDelegate.t != t;
}

class AppText {
  static const hero = TextStyle(
    color: AppPalette.ice,
    fontSize: 52,
    height: .98,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.6,
  );

  static const display = TextStyle(
    color: AppPalette.ice,
    fontSize: 34,
    height: 1.05,
    fontWeight: FontWeight.w900,
    letterSpacing: -.8,
  );

  static const title = TextStyle(
    color: AppPalette.ice,
    fontSize: 24,
    fontWeight: FontWeight.w900,
    letterSpacing: -.35,
  );

  static const titleSmall = TextStyle(
    color: AppPalette.ice,
    fontSize: 21,
    fontWeight: FontWeight.w900,
    letterSpacing: -.25,
  );

  static const logo = TextStyle(
    color: AppPalette.ice,
    fontSize: 21,
    fontWeight: FontWeight.w900,
    letterSpacing: -.3,
  );

  static const body = TextStyle(
    color: AppPalette.porcelain,
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w500,
  );

  static const caption = TextStyle(
    color: AppPalette.muted,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const captionStrong = TextStyle(
    color: AppPalette.porcelain,
    fontSize: 13,
    fontWeight: FontWeight.w800,
  );

  static const micro = TextStyle(
    color: AppPalette.muted,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: .25,
  );

  static const overline = TextStyle(
    color: AppPalette.ice,
    fontSize: 12,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.2,
  );

  static const settingTitle = TextStyle(
    color: AppPalette.ice,
    fontSize: 16,
    fontWeight: FontWeight.w900,
  );
}