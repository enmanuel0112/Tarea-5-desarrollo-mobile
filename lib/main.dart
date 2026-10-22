import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'game_screen.dart';
import 'theme.dart';

void main() => runApp(const GravityFallsApp());

class GravityFallsApp extends StatelessWidget {
  const GravityFallsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.dark,
      surface: panel,
    );
    return MaterialApp(
      title: 'Gravity Falls · Archivo 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: ink,
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: paper,
          centerTitle: false,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF111A16),
          indicatorColor: gold.withValues(alpha: .18),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected) ? gold : muted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: panel,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: paper,
            fontWeight: FontWeight.w900,
            height: 1.0,
          ),
          headlineMedium: TextStyle(color: paper, fontWeight: FontWeight.w800),
          titleLarge: TextStyle(color: paper, fontWeight: FontWeight.w800),
          titleMedium: TextStyle(color: paper, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(color: paper, height: 1.5),
          bodyMedium: TextStyle(color: muted, height: 1.45),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class PersonEntry {
  const PersonEntry({
    required this.name,
    required this.role,
    required this.voice,
    required this.image,
    required this.color,
    required this.description,
    required this.symbol,
  });

  final String name;
  final String role;
  final String voice;
  final String image;
  final Color color;
  final String description;
  final String symbol;
}

const people = <PersonEntry>[
  PersonEntry(
    name: 'Dipper Pines',
    role: 'El investigador',
    voice: 'Jason Ritter',
    image: 'assets/images/dipper.png',
    color: Color(0xFF5D8EB3),
    symbol: '03',
    description: 'Curioso, observador y decidido a descubrir qué esconden los misterios del pueblo. Su diario se convierte en la guía para entender las criaturas y los símbolos de Gravity Falls.',
  ),
  PersonEntry(
    name: 'Mabel Pines',
    role: 'La chispa del verano',
    voice: 'Kristen Schaal',
    image: 'assets/images/mabel.png',
    color: Color(0xFFD47EAF),
    symbol: '☆',
    description: 'La hermana gemela de Dipper afronta lo extraño con imaginación, humor y mucha energía. Su optimismo suele convertir cualquier plan en una aventura inolvidable.',
  ),
  PersonEntry(
    name: 'Stan Pines',
    role: 'Dueño de la Cabaña del Misterio',
    voice: 'Alex Hirsch',
    image: 'assets/images/stan.png',
    color: Color(0xFFC58C45),
    symbol: '\$',
    description: 'El tío abuelo de los gemelos dirige una atracción turística llena de rarezas. Es gruñón, astuto y guarda secretos que conectan con la historia del pueblo.',
  ),
];

class MomentEntry {
  const MomentEntry({
    required this.title,
    required this.episode,
    required this.image,
    required this.videoId,
    required this.description,
    required this.tag,
  });

  final String title;
  final String episode;
  final String image;
  final String videoId;
  final String description;
  final String tag;
}

const moments = <MomentEntry>[
  MomentEntry(
    title: 'Una noche de Summerween',
    episode: 'Temporada 1 · Episodio 12',
    image: 'assets/images/summerween.jpg',
    videoId: 'FPREqUO4nBY',
    tag: 'TRADICIÓN EXTRAÑA',
    description: 'Gravity Falls celebra Halloween en pleno verano. Entre calabazas, disfraces y una regla muy peculiar, Dipper y Mabel descubren que la noche puede ponerse más aterradora de lo esperado.',
  ),
  MomentEntry(
    title: 'El misterio del tatuaje de Stan',
    episode: 'Dipper’s Guide · Corto',
    image: 'assets/images/stan.png',
    videoId: 'aQsV8yCULMM',
    tag: 'PISTA OCULTA',
    description: 'Dipper descubre un símbolo extraño en Stan e intenta averiguar de dónde salió. Una pista pequeña basta para abrir otro misterio en el pueblo.',
  ),
  MomentEntry(
    title: 'Weirdmageddon',
    episode: 'Temporada 2 · Trilogía final',
    image: 'assets/images/weirdmageddon_video.jpg',
    videoId: 'WCjZe2tph3w',
    tag: 'EL MISTERIO SE DESBORDA',
    description: 'La realidad del pueblo cambia por completo y Dipper corre contra el tiempo. Este momento reúne el humor, la acción y el misterio que definen el final de la serie.',
  ),
];

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  void _openPage(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomeScreen(
        onPeople: () => setState(() => selectedIndex = 1),
        onMoments: () => setState(() => selectedIndex = 2),
        onGame: () => setState(() => selectedIndex = 3),
        onOpenMoment: (moment) => _openPage(MomentDetailScreen(moment: moment)),
      ),
      PeopleScreen(
        onOpen: (person) => _openPage(PersonDetailScreen(person: person)),
      ),
      MomentsScreen(
        onOpen: (moment) => _openPage(MomentDetailScreen(moment: moment)),
      ),
      const MysteryGameScreen(),
      MoreScreen(
        onAbout: () => _openPage(const AboutScreen()),
        onContact: () => _openPage(const ContactScreen()),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 18,
        title: Row(
          children: [
            const Icon(Icons.travel_explore, color: gold, size: 22),
            const SizedBox(width: 9),
            Text(
              'ARCHIVO 03',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: paper,
                letterSpacing: 2.1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: pine,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFF89CB78), size: 8),
                  SizedBox(width: 6),
                  Text(
                    'EN LÍNEA',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Portada',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Personajes',
          ),
          NavigationDestination(
            icon: Icon(Icons.photo_library_outlined),
            selectedIcon: Icon(Icons.photo_library),
            label: 'Momentos',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports),
            label: 'Juega',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Más',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.onPeople,
    required this.onMoments,
    required this.onGame,
    required this.onOpenMoment,
  });
  final VoidCallback onPeople;
  final VoidCallback onMoments;
  final VoidCallback onGame;
  final ValueChanged<MomentEntry> onOpenMoment;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 28),
      children: [
        _HeroCard(onExplore: onPeople),
        const SizedBox(height: 25),
        const Eyebrow('EXPEDIENTE DE CAMPO · OREGÓN'),
        const SizedBox(height: 7),
        Text(
          'Nada es normal\npor aquí.',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontSize: 30, height: 1.05),
        ),
        const SizedBox(height: 9),
        const Text(
          'Una guía para los misterios, personajes y momentos que hacen de Gravity Falls un verano imposible de olvidar.',
          style: TextStyle(color: muted, height: 1.55),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _QuickLink(
                icon: Icons.people_alt_outlined,
                label: 'Conoce al equipo',
                onTap: onPeople,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickLink(
                icon: Icons.sports_esports,
                label: 'Juega conmigo',
                onTap: onGame,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(
              title: 'Páginas destacadas',
              subtitle: 'Tres momentos del archivo',
            ),
            TextButton(
              onPressed: onMoments,
              child: const Text(
                'VER TODO',
                style: TextStyle(
                  color: gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 196,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: moments.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: 250,
              child: MomentCard(
                moment: moments[index],
                onTap: () => onOpenMoment(moments[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const _SeriesStats(),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onExplore});
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: pine,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/gravity_falls_poster.jpeg',
            fit: BoxFit.cover,
            alignment: const Alignment(0, -.2),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  ink.withValues(alpha: .05),
                  ink.withValues(alpha: .2),
                  ink.withValues(alpha: .96),
                ],
                stops: const [0, .38, 1],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _Tag(label: 'GUÍA INTERACTIVA', icon: Icons.auto_stories),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 23,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BIENVENIDO A',
                  style: TextStyle(
                    color: gold,
                    fontSize: 10,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'GRAVITY\nFALLS',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 39,
                    letterSpacing: 1.1,
                    shadows: [
                      const Shadow(color: Colors.black54, blurRadius: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 9),
                const Text(
                  'El pueblo más raro de Oregón te espera.',
                  style: TextStyle(color: paper, fontSize: 13),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onExplore,
                  icon: const Icon(Icons.arrow_forward, size: 17),
                  label: const Text('ABRIR EL EXPEDIENTE'),
                  style: FilledButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: ink,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key, required this.onOpen});
  final ValueChanged<PersonEntry> onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
      children: [
        const SectionTitle(
          title: 'Personajes',
          subtitle: 'Las personas detrás de cada misterio',
        ),
        const SizedBox(height: 18),
        for (final person in people) ...[
          _PersonCard(person: person, onTap: () => onOpen(person)),
          const SizedBox(height: 12),
        ],
        const _NoteCard(
          icon: Icons.touch_app_outlined,
          text: 'Toca una ficha para abrir su foto y conocer su historia.',
        ),
      ],
    );
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard({required this.person, required this.onTap});
  final PersonEntry person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: SizedBox(
          height: 124,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(22),
                ),
                child: Image.asset(
                  person.image,
                  width: 108,
                  height: 124,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 14, 10, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        person.role.toUpperCase(),
                        style: TextStyle(
                          color: person.color,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        person.name,
                        style: const TextStyle(
                          color: paper,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Voz: ${person.voice}',
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(Icons.chevron_right, color: muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonDetailScreen extends StatelessWidget {
  const PersonDetailScreen({super.key, required this.person});
  final PersonEntry person;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ficha de personaje')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: SizedBox(
              height: 360,
              child: Image.asset(
                person.image,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Eyebrow(person.role.toUpperCase(), color: person.color),
          const SizedBox(height: 5),
          Text(
            person.name,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 29),
          ),
          const SizedBox(height: 9),
          _DetailChip(
            icon: Icons.mic_none,
            text: 'Voz original: ${person.voice}',
          ),
          const SizedBox(height: 18),
          const SectionTitle(
            title: 'En el expediente',
            subtitle: 'Perfil del personaje',
          ),
          const SizedBox(height: 9),
          Text(
            person.description,
            style: const TextStyle(color: muted, fontSize: 15, height: 1.65),
          ),
        ],
      ),
    );
  }
}

class MomentsScreen extends StatelessWidget {
  const MomentsScreen({super.key, required this.onOpen});
  final ValueChanged<MomentEntry> onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
      children: [
        const SectionTitle(
          title: 'Momentos',
          subtitle: 'Escenas para volver a investigar',
        ),
        const SizedBox(height: 17),
        for (final moment in moments) ...[
          MomentCard(
            moment: moment,
            onTap: () => onOpen(moment),
            expanded: true,
          ),
          const SizedBox(height: 13),
        ],
        const _NoteCard(
          icon: Icons.play_circle_outline,
          text: 'Los videos se reproducen aquí mismo. Necesitas conexión a internet para cargarlos.',
        ),
      ],
    );
  }
}

class MomentCard extends StatelessWidget {
  const MomentCard({
    super.key,
    required this.moment,
    required this.onTap,
    this.expanded = false,
  });
  final MomentEntry moment;
  final VoidCallback onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: expanded ? 236 : 196,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(moment.image, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .02),
                      Colors.black.withValues(alpha: .82),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 14,
                child: _Tag(label: moment.tag, icon: Icons.bookmark_outline),
              ),
              Positioned(
                left: 16,
                right: 14,
                bottom: 15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            moment.episode.toUpperCase(),
                            style: const TextStyle(
                              color: gold,
                              fontSize: 9,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            moment.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: gold,
                      foregroundColor: ink,
                      radius: 21,
                      child: Icon(Icons.play_arrow_rounded, size: 25),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MomentDetailScreen extends StatefulWidget {
  const MomentDetailScreen({super.key, required this.moment});
  final MomentEntry moment;

  @override
  State<MomentDetailScreen> createState() => _MomentDetailScreenState();
}

class _MomentDetailScreenState extends State<MomentDetailScreen> {
  late final YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController.fromVideoId(
      videoId: widget.moment.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showControls: true,
        strictRelatedVideos: true,
      ),
    );
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Momento del archivo')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(controller: controller),
            ),
          ),
          const SizedBox(height: 17),
          Eyebrow(widget.moment.episode.toUpperCase()),
          const SizedBox(height: 6),
          Text(
            widget.moment.title,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 27),
          ),
          const SizedBox(height: 13),
          Text(
            widget.moment.description,
            style: const TextStyle(color: muted, fontSize: 15, height: 1.65),
          ),
          const SizedBox(height: 18),
          const _NoteCard(
            icon: Icons.info_outline,
            text: 'Reproductor integrado con video oficial de Disney Channel Animation. El clip carga con conexión a internet.',
          ),
        ],
      ),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key, required this.onAbout, required this.onContact});
  final VoidCallback onAbout;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
      children: [
        const SectionTitle(
          title: 'Más información',
          subtitle: 'Datos del universo y del creador',
        ),
        const SizedBox(height: 18),
        _MenuCard(
          icon: Icons.menu_book_rounded,
          title: 'Acerca de la serie',
          subtitle: 'Creador, historia y temporadas',
          onTap: onAbout,
        ),
        const SizedBox(height: 12),
        _MenuCard(
          icon: Icons.badge_outlined,
          title: 'Contrátame',
          subtitle: 'Conoce al creador de esta app',
          onTap: onContact,
        ),
        const SizedBox(height: 20),
        const _NoteCard(
          icon: Icons.auto_awesome,
          text: 'Abre una ficha para ver todos los detalles.',
        ),
        const SizedBox(height: 25),
        const Center(
          child: Text(
            'GRAVITY FALLS · ARCHIVO 03',
            style: TextStyle(
              color: moss,
              letterSpacing: 2,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de Gravity Falls')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/gravity_falls_poster.jpeg',
              height: 270,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          const SizedBox(height: 18),
          const Eyebrow('SERIE ANIMADA · MISTERIO · COMEDIA'),
          const SizedBox(height: 7),
          Text(
            'El verano más extraño de Oregón',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 10),
          const Text(
            'Los gemelos Dipper y Mabel pasan sus vacaciones con su tío abuelo Stan en Gravity Falls. Mientras ayudan en la Cabaña del Misterio, descubren criaturas, códigos y secretos que desafían todo lo normal.',
            style: TextStyle(color: muted, fontSize: 15, height: 1.65),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: _FactTile(
                  icon: Icons.movie_creation_outlined,
                  value: '2',
                  label: 'TEMPORADAS',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _FactTile(
                  icon: Icons.calendar_month_outlined,
                  value: '2012',
                  label: 'ESTRENO',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _FactTile(
            icon: Icons.edit_note_rounded,
            value: 'Alex Hirsch',
            label: 'CREADOR DE LA SERIE',
          ),
        ],
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _openGithub() async {
    final uri = Uri.parse('https://github.com/enmanuel0112');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contrátame')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/cesar_ogando.jpg',
                    width: 168,
                    height: 168,
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -.15),
                  ),
                ),
                const SizedBox(height: 17),
                const Eyebrow('DESARROLLADOR EN FORMACIÓN'),
                const SizedBox(height: 6),
                Text(
                  'Cesar Enmanuel\nOgando Perdomo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontSize: 23, height: 1.15),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Matrícula 2024-2485 · ITLA',
                  style: TextStyle(color: muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: pine,
                child: Icon(Icons.code_rounded, color: gold),
              ),
              title: const Text(
                'GitHub',
                style: TextStyle(color: paper, fontWeight: FontWeight.w800),
              ),
              subtitle: const Text(
                'github.com/enmanuel0112',
                style: TextStyle(color: muted),
              ),
              trailing: const Icon(Icons.open_in_new, color: gold),
              onTap: _openGithub,
            ),
          ),
          const SizedBox(height: 12),
          const _NoteCard(
            icon: Icons.lightbulb_outline,
            text: '¿Tienes una idea para una app? Conversemos y la convertimos en un proyecto.',
          ),
        ],
      ),
    );
  }
}

class _SeriesStats extends StatelessWidget {
  const _SeriesStats();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: pine.withValues(alpha: .55),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: moss.withValues(alpha: .28)),
    ),
    child: const Row(
      children: [
        Icon(Icons.auto_awesome, color: gold, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UN PUEBLO, MUCHOS SECRETOS',
                style: TextStyle(
                  color: paper,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .6,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Creada por Alex Hirsch · 2 temporadas',
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: panel,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: gold, size: 20),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: paper,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 12, color: muted),
          ],
        ),
      ),
    ),
  );
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
      leading: CircleAvatar(
        backgroundColor: pine,
        foregroundColor: gold,
        child: Icon(icon),
      ),
      title: Text(
        title,
        style: const TextStyle(color: paper, fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: muted, fontSize: 12),
      ),
      trailing: const Icon(Icons.chevron_right, color: muted),
      onTap: onTap,
    ),
  );
}

class _FactTile extends StatelessWidget {
  const _FactTile({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: panel,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Icon(icon, color: gold),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: paper,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: muted,
                  fontSize: 9,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: gold, size: 16),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(
              color: paper,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF1B271F),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: moss.withValues(alpha: .22)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: gold, size: 19),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: muted, fontSize: 12, height: 1.5),
          ),
        ),
      ],
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium
            ?.copyWith(fontSize: 25),
      ),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(color: muted, fontSize: 13)),
    ],
  );
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color = gold});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: 9,
      letterSpacing: 1.8,
      fontWeight: FontWeight.w900,
    ),
  );
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.icon});
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: ink.withValues(alpha: .78),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: paper.withValues(alpha: .18)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: gold, size: 12),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: paper,
            fontSize: 8,
            letterSpacing: 1,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}
