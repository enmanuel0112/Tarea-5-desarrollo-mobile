import 'dart:async';

import 'package:flutter/material.dart';

import 'theme.dart';

class MysteryGameScreen extends StatefulWidget {
  const MysteryGameScreen({super.key});

  @override
  State<MysteryGameScreen> createState() => _MysteryGameScreenState();
}

class _MysteryGameScreenState extends State<MysteryGameScreen> {
  static const int size = 6;
  static const String shack = '5,0';
  static const Set<String> originalPages = {'0,1', '2,3', '5,4'};
  static const Set<String> trees = {'0,3', '1,1', '1,4', '2,1', '3,3'};

  String player = shack;
  String cipher = '0,5';
  Set<String> pages = {...originalPages};
  int seconds = 60;
  int lives = 3;
  int moves = 0;
  bool running = false;
  bool finished = false;
  bool won = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  (int, int) _point(String value) {
    final parts = value.split(',').map(int.parse).toList();
    return (parts[0], parts[1]);
  }

  String _key(int row, int col) => '$row,$col';

  void _start() {
    timer?.cancel();
    setState(() {
      player = shack;
      cipher = '0,5';
      pages = {...originalPages};
      seconds = 60;
      lives = 3;
      moves = 0;
      running = true;
      finished = false;
      won = false;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || !running) return;
      if (seconds <= 1) {
        timer?.cancel();
        setState(() {
          seconds = 0;
          running = false;
          finished = true;
          won = false;
        });
      } else {
        setState(() => seconds--);
      }
    });
  }

  void _moveBy(int rowDelta, int colDelta) {
    if (!running) return;
    final (row, col) = _point(player);
    final nextRow = row + rowDelta;
    final nextCol = col + colDelta;
    if (nextRow < 0 || nextRow >= size || nextCol < 0 || nextCol >= size)
      return;
    final next = _key(nextRow, nextCol);
    if (trees.contains(next)) return;
    _moveTo(nextRow, nextCol);
  }

  void _moveTo(int row, int col) {
    if (!running) return;
    final (currentRow, currentCol) = _point(player);
    if ((currentRow - row).abs() + (currentCol - col).abs() != 1) return;
    final destination = _key(row, col);
    if (trees.contains(destination)) return;

    setState(() {
      player = destination;
      moves++;
      pages.remove(destination);
      if (destination == cipher) {
        lives--;
        cipher = '0,5';
      }
      if (pages.isEmpty && player == shack) {
        _finish(true);
      }
      if (lives <= 0) {
        _finish(false);
      }
    });
    if (running) _moveCipher();
  }

  void _moveCipher() {
    final (pr, pc) = _point(player);
    final (cr, cc) = _point(cipher);
    final candidates = <(int, int)>[];
    if (cr != pr) candidates.add((cr + (pr > cr ? 1 : -1), cc));
    if (cc != pc) candidates.add((cr, cc + (pc > cc ? 1 : -1)));
    if (candidates.isEmpty) return;
    candidates.sort((a, b) {
      final da = (a.$1 - pr).abs() + (a.$2 - pc).abs();
      final db = (b.$1 - pr).abs() + (b.$2 - pc).abs();
      return da.compareTo(db);
    });
    final next = candidates.firstWhere(
      (point) => !trees.contains(_key(point.$1, point.$2)),
      orElse: () => candidates.first,
    );
    setState(() {
      cipher = _key(next.$1, next.$2);
      if (cipher == player) {
        lives--;
        cipher = '0,5';
        if (lives <= 0) _finish(false);
      }
    });
  }

  void _finish(bool didWin) {
    timer?.cancel();
    running = false;
    finished = true;
    won = didWin;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 28),
      children: [
        const Text(
          'JUEGA CONMIGO',
          style: TextStyle(
            color: gold,
            fontSize: 9,
            letterSpacing: 2,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Recupera las páginas',
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 6),
        const Text(
          'Recorre el bosque, reúne las 3 páginas del diario y vuelve a la Cabaña antes de que Bill te alcance.',
          style: TextStyle(color: muted, height: 1.5, fontSize: 13),
        ),
        const SizedBox(height: 15),
        _StatusBar(
          seconds: seconds,
          lives: lives,
          found: originalPages.length - pages.length,
          moves: moves,
        ),
        const SizedBox(height: 13),
        _GameBoard(
          size: size,
          player: player,
          cipher: cipher,
          pages: pages,
          trees: trees,
          active: running,
          onMove: _moveTo,
        ),
        const SizedBox(height: 13),
        if (finished)
          _EndPanel(won: won, moves: moves, onRestart: _start)
        else if (!running)
          _StartPanel(onStart: _start)
        else
          _DirectionPad(onMove: _moveBy),
        const SizedBox(height: 13),
        const _GameLegend(),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.seconds,
    required this.lives,
    required this.found,
    required this.moves,
  });
  final int seconds;
  final int lives;
  final int found;
  final int moves;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _StatPill(
          icon: Icons.timer_outlined,
          label: 'TIEMPO',
          value: '${seconds}s',
          warning: seconds <= 15,
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: _StatPill(
          icon: Icons.auto_stories_outlined,
          label: 'PÁGINAS',
          value: '$found/3',
        ),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: _StatPill(
          icon: Icons.favorite_outline,
          label: 'VIDAS',
          value: '$lives',
        ),
      ),
    ],
  );
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.label,
    required this.value,
    this.warning = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool warning;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
    decoration: BoxDecoration(
      color: panel,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Icon(icon, color: warning ? Colors.redAccent : gold, size: 16),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: muted,
                  fontSize: 7,
                  letterSpacing: .7,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: warning ? Colors.redAccent : paper,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _GameBoard extends StatelessWidget {
  const _GameBoard({
    required this.size,
    required this.player,
    required this.cipher,
    required this.pages,
    required this.trees,
    required this.active,
    required this.onMove,
  });
  final int size;
  final String player;
  final String cipher;
  final Set<String> pages;
  final Set<String> trees;
  final bool active;
  final void Function(int row, int col) onMove;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color(0xFF19241E),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: moss.withValues(alpha: .3)),
    ),
    child: AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: size * size,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
        ),
        itemBuilder: (context, index) {
          final row = index ~/ size;
          final col = index % size;
          final key = '$row,$col';
          final isPlayer = key == player;
          final isCipher = key == cipher;
          final isTree = trees.contains(key);
          final isPage = pages.contains(key);
          final isShack = key == '5,0';
          final adjacent =
              active &&
              (() {
                final p = player.split(',').map(int.parse).toList();
                return (p[0] - row).abs() + (p[1] - col).abs() == 1;
              })();
          return GestureDetector(
            onTap: active ? () => onMove(row, col) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isPlayer
                    ? gold.withValues(alpha: .28)
                    : adjacent
                    ? pine
                    : (row + col).isEven
                    ? const Color(0xFF263B2E)
                    : const Color(0xFF1F3429),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isPlayer
                      ? gold
                      : adjacent
                      ? moss
                      : Colors.transparent,
                  width: isPlayer || adjacent ? 1.5 : 0,
                ),
              ),
              child: Center(
                child: Text(
                  isPlayer
                      ? '🧭'
                      : isCipher
                      ? '🔺'
                      : isPage
                      ? '📜'
                      : isTree
                      ? '🌲'
                      : isShack
                      ? '🏚️'
                      : '',
                  style: TextStyle(fontSize: isPlayer || isCipher ? 21 : 18),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _DirectionPad extends StatelessWidget {
  const _DirectionPad({required this.onMove});
  final void Function(int rowDelta, int colDelta) onMove;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton.filledTonal(
        onPressed: () => onMove(0, -1),
        icon: const Icon(Icons.chevron_left),
        tooltip: 'Mover a la izquierda',
      ),
      const SizedBox(width: 7),
      Column(
        children: [
          IconButton.filledTonal(
            onPressed: () => onMove(-1, 0),
            icon: const Icon(Icons.keyboard_arrow_up),
            tooltip: 'Mover arriba',
          ),
          const SizedBox(height: 4),
          IconButton.filledTonal(
            onPressed: () => onMove(1, 0),
            icon: const Icon(Icons.keyboard_arrow_down),
            tooltip: 'Mover abajo',
          ),
        ],
      ),
      const SizedBox(width: 7),
      IconButton.filledTonal(
        onPressed: () => onMove(0, 1),
        icon: const Icon(Icons.chevron_right),
        tooltip: 'Mover a la derecha',
      ),
    ],
  );
}

class _StartPanel extends StatelessWidget {
  const _StartPanel({required this.onStart});
  final VoidCallback onStart;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: panel,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tu misión',
          style: TextStyle(
            color: paper,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Toca una casilla junto a tu brújula o usa las flechas. Evita los árboles, esquiva a Bill y regresa a la cabaña con las 3 páginas.',
          style: TextStyle(color: muted, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('INICIAR EXPEDICIÓN'),
            style: FilledButton.styleFrom(
              backgroundColor: gold,
              foregroundColor: ink,
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
          ),
        ),
      ],
    ),
  );
}

class _EndPanel extends StatelessWidget {
  const _EndPanel({
    required this.won,
    required this.moves,
    required this.onRestart,
  });
  final bool won;
  final int moves;
  final VoidCallback onRestart;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: won ? const Color(0xFF243B2E) : const Color(0xFF402824),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                won ? '¡Expediente recuperado!' : 'Bill ganó esta ronda',
                style: const TextStyle(
                  color: paper,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                won
                    ? 'Regresaste a la cabaña en $moves movimientos.'
                    : 'Inténtalo otra vez. Cada paso cuenta.',
                style: const TextStyle(color: muted, fontSize: 11),
              ),
            ],
          ),
        ),
        FilledButton(
          onPressed: onRestart,
          style: FilledButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: ink,
          ),
          child: const Text('JUGAR'),
        ),
      ],
    ),
  );
}

class _GameLegend extends StatelessWidget {
  const _GameLegend();
  @override
  Widget build(BuildContext context) => const Wrap(
    spacing: 13,
    runSpacing: 8,
    alignment: WrapAlignment.center,
    children: [
      _LegendItem(symbol: '🧭', label: 'Tú'),
      _LegendItem(symbol: '📜', label: 'Páginas'),
      _LegendItem(symbol: '🔺', label: 'Bill'),
      _LegendItem(symbol: '🏚️', label: 'Regreso'),
      _LegendItem(symbol: '🌲', label: 'Obstáculo'),
    ],
  );
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.symbol, required this.label});
  final String symbol;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(symbol, style: const TextStyle(fontSize: 15)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: muted, fontSize: 10)),
    ],
  );
}
