import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const TripdetailsScreen());

class C {
  static const bg       = Color(0xFFF5F3EE);
  static const surface  = Color(0xFFFFFFFF);
  static const primary  = Color(0xFF1A1A2E);
  static const accent   = Color(0xFFE24B4A);
  static const border   = Color(0xFFE0DDD6);
  static const textSec  = Color(0xFF888780);
  static const greenBg  = Color(0xFFEAF3DE);
  static const green    = Color(0xFF3B6D11);
  static const blueBg   = Color(0xFFE6F1FB);
  static const blue     = Color(0xFF185FA5);
}

enum StopStatus { done, current, upcoming }
enum TripStatus { current, upcoming, past }

class TrainStop {
  final String name, time;
  final StopStatus status;
  final LatLng loc;
  const TrainStop(this.name, this.time, this.status, this.loc);
}

class Trip {
  final String train, from, to, dep, arr, dist, loc, remain;
  final double progress;
  final TripStatus status;
  final List<TrainStop> stops;
  final LatLng fromLL, toLL;
  final String? date, seat, cls;
  const Trip({
    required this.train, required this.from, required this.to,
    required this.dep, required this.arr, required this.dist,
    required this.loc, required this.remain, required this.progress,
    required this.status, required this.stops,
    required this.fromLL, required this.toLL,
    this.date, this.seat, this.cls,
  });
}

final _currentTrip = Trip(
  train: 'قطار 982', from: 'أسوان', to: 'القاهرة',
  dep: '08:00 ص', arr: '04:30 م', dist: '900 كم',
  loc: 'الأقصر', remain: 'س10 د5', progress: 0.55,
  status: TripStatus.current,
  fromLL: LatLng(24.0889, 32.8998),
  toLL: LatLng(30.0444, 31.2357),
  stops: [
    TrainStop('أسوان',           '08:00 ص', StopStatus.done,     LatLng(24.0889, 32.8998)),
    TrainStop('الأقصر',          '11:20 ص', StopStatus.current,  LatLng(25.6872, 32.6396)),
    TrainStop('سوهاج',           '01:45 م', StopStatus.upcoming, LatLng(26.5569, 31.6948)),
    TrainStop('القاهرة — رمسيس', '04:30 م', StopStatus.upcoming, LatLng(30.0621, 31.2497)),
  ],
);

final _upcomingTrips = [
  Trip(
    train: 'قطار 1001', from: 'القاهرة', to: 'الإسكندرية',
    dep: '07:00 ص', arr: '09:30 ص', dist: '220 كم',
    loc: '', remain: '', progress: 0, status: TripStatus.upcoming,
    date: 'بعد يومين', seat: '14A', cls: 'الأولى',
    fromLL: LatLng(30.0444, 31.2357), toLL: LatLng(31.2001, 29.9187),
    stops: [],
  ),
  Trip(
    train: 'قطار 55', from: 'أسيوط', to: 'القاهرة',
    dep: '02:00 م', arr: '07:15 م', dist: '375 كم',
    loc: '', remain: '', progress: 0, status: TripStatus.upcoming,
    date: 'الجمعة',
    fromLL: LatLng(27.1809, 31.1837), toLL: LatLng(30.0444, 31.2357),
    stops: [],
  ),
];

final _pastTrips = [
  Trip(
    train: 'قطار 88', from: 'القاهرة', to: 'أسوان',
    dep: '06:00 ص', arr: '06:00 م', dist: '900 كم',
    loc: '', remain: '', progress: 1.0, status: TripStatus.past,
    date: 'منذ أسبوع',
    fromLL: LatLng(30.0444, 31.2357), toLL: LatLng(24.0889, 32.8998),
    stops: [],
  ),
];

class TripdetailsScreen extends StatelessWidget {
  const TripdetailsScreen({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: C.bg),
    home: const MyTripsScreen(),
  );
}

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});
  @override State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  int _nav = 2;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  Trip get _activeTrip => switch (_tab.index) {
    1 => _upcomingTrips.first,
    2 => _pastTrips.first,
    _ => _currentTrip,
  };

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final mapH = (h * 0.27).clamp(190.0, 260.0);
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(children: [

          Expanded(
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: mapH,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _MapWidget(key: ValueKey(_tab.index), trip: _activeTrip),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: _TabBar(controller: _tab),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: true,
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _TabContent(label: 'رحلة جارية', trips: [_currentTrip], showStops: true),
                    _TabContent(label: 'الرحلات القادمة', trips: _upcomingTrips),
                    _TabContent(label: 'الرحلات السابقة', trips: _pastTrips),
                  ],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: C.surface,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      const Icon(Icons.menu, color: C.textSec),
      const SizedBox(width: 12),
      const Expanded(child: Text('رحلتي',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: C.primary))),
      Stack(children: [
        IconButton(icon: const Icon(Icons.notifications_none, color: C.textSec),
            onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        Positioned(top: 0, right: 0,
            child: Container(width: 8, height: 8,
                decoration: const BoxDecoration(color: C.accent, shape: BoxShape.circle))),
      ]),
      const SizedBox(width: 8),
      IconButton(icon: const Icon(Icons.share_outlined, color: C.textSec),
          onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
    ]),
  );
}

class _MapWidget extends StatefulWidget {
  final Trip trip;
  const _MapWidget({super.key, required this.trip});
  @override State<_MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<_MapWidget> {
  final _ctrl = MapController();
  LatLng get _center => LatLng(
    (widget.trip.fromLL.latitude + widget.trip.toLL.latitude) / 2,
    (widget.trip.fromLL.longitude + widget.trip.toLL.longitude) / 2,
  );
  @override
  Widget build(BuildContext context) => Stack(children: [
    FlutterMap(
      mapController: _ctrl,
      options: MapOptions(initialCenter: _center, initialZoom: 6, minZoom: 4, maxZoom: 14),
      children: [
        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.trip'),
        if (widget.trip.stops.length >= 2)
          PolylineLayer(polylines: [Polyline(
            points: widget.trip.stops.map((s) => s.loc).toList(),
            color: C.accent.withValues(alpha: 0.85), strokeWidth: 3, isDotted: true,
          )]),
        MarkerLayer(markers: widget.trip.stops.map((s) => Marker(
          point: s.loc, width: 24, height: 24, child: _StopDot(s.status),
        )).toList()),
      ],
    ),
    Positioned(bottom: 10, left: 0, right: 0,
        child: Center(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xDD1A1A2E), borderRadius: BorderRadius.circular(20)),
          child: Text('${widget.trip.from} ← ${widget.trip.loc.isNotEmpty ? widget.trip.loc : widget.trip.to} ← ${widget.trip.to}',
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ))),
    Positioned(top: 10, left: 10, child: Column(children: [
      _ZoomBtn(Icons.add,    () => _ctrl.move(_ctrl.camera.center, _ctrl.camera.zoom + 1)),
      const SizedBox(height: 4),
      _ZoomBtn(Icons.remove, () => _ctrl.move(_ctrl.camera.center, _ctrl.camera.zoom - 1)),
    ])),
    Positioned(top: 10, right: 10,
        child: Container(width: 38, height: 38,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                border: Border.all(color: C.border)),
            child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('N', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_upward, size: 12, color: C.accent),
            ]))),
  ]);
}

class _StopDot extends StatelessWidget {
  final StopStatus status;
  const _StopDot(this.status);
  @override
  Widget build(BuildContext context) {
    final (bg, border) = switch (status) {
      StopStatus.done     => (C.primary, C.primary),
      StopStatus.current  => (Colors.white, C.accent),
      StopStatus.upcoming => (Colors.white, C.border),
    };
    return Container(
      width: 18, height: 18,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle,
          border: Border.all(color: border, width: 2)),
      child: status == StopStatus.done
          ? const Icon(Icons.check, color: Colors.white, size: 10)
          : status == StopStatus.current
          ? Center(child: Container(width: 6, height: 6,
          decoration: const BoxDecoration(color: C.accent, shape: BoxShape.circle)))
          : null,
    );
  }
}

class _ZoomBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ZoomBtn(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 30, height: 30,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6),
            border: Border.all(color: C.border)),
        child: Icon(icon, size: 18, color: C.primary)),
  );
}

class _TabBar extends StatelessWidget {
  final TabController controller;
  const _TabBar({required this.controller});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.border, width: 0.8)),
    child: Row(children: [
      _TabItem('الرحلة الحالية', 0, controller),
      _TabItem('القادمة', 1, controller),
      _TabItem('السابقة', 2, controller),
    ]),
  );
}

class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final TabController ctrl;
  const _TabItem(this.label, this.index, this.ctrl);
  @override
  Widget build(BuildContext context) {
    final active = ctrl.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => ctrl.animateTo(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
              color: active ? C.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10)),
          child: Text(label, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  color: active ? Colors.white : C.textSec)),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final String label;
  final List<Trip> trips;
  final bool showStops;
  const _TabContent({required this.label, required this.trips, this.showStops = false});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: C.primary)),
        const Text('تفاصيل', style: TextStyle(fontSize: 13, color: C.accent)),
      ]),
      const SizedBox(height: 8),
      ...trips.map((t) => _TripCard(trip: t, showStops: showStops)),
    ]),
  );
}

class _TripCard extends StatelessWidget {
  final Trip trip;
  final bool showStops;
  const _TripCard({required this.trip, this.showStops = false});
  @override
  Widget build(BuildContext context) {
    final isActive = trip.status == TripStatus.current;
    final isPast   = trip.status == TripStatus.past;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isActive ? C.accent : C.border, width: isActive ? 1.5 : 0.8)),
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(trip.train, style: const TextStyle(fontSize: 12, color: C.textSec)),
          if (isActive) _Badge('جارية الآن', dot: true, bg: C.greenBg, fg: C.green)
          else if (trip.status == TripStatus.upcoming)
            _Badge(trip.date ?? '', icon: Icons.calendar_today, bg: C.blueBg, fg: C.blue)
          else _Badge(trip.date ?? 'مكتملة', icon: Icons.check,
                bg: const Color(0xFFF1EFE8), fg: C.textSec),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(trip.from, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(trip.dep,  style: const TextStyle(fontSize: 11, color: C.textSec)),
          ])),
          Expanded(flex: 3, child: _ProgressBar(trip.progress, isPast)),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(trip.to,  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            Text(trip.arr, style: const TextStyle(fontSize: 11, color: C.textSec)),
          ])),
        ]),
        if (isActive) ...[
          const SizedBox(height: 10),
          Row(children: [
            _MetaCard('المسافة', trip.dist), const SizedBox(width: 6),
            _MetaCard('الموقع', trip.loc),   const SizedBox(width: 6),
            _MetaCard('متبقي', trip.remain),
          ]),
        ],
        if (trip.status == TripStatus.upcoming && trip.seat != null) ...[
          const SizedBox(height: 10),
          Row(children: [
            _MetaCard('المسافة', trip.dist), const SizedBox(width: 6),
            _MetaCard('الدرجة', trip.cls ?? ''), const SizedBox(width: 6),
            _MetaCard('المقعد', trip.seat ?? ''),
          ]),
        ],
        if (showStops && trip.stops.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Divider(height: 1, color: C.border),
          const SizedBox(height: 8),
          ...trip.stops.asMap().entries.map((e) =>
              _StopItem(e.value, isLast: e.key == trip.stops.length - 1)),
        ],
      ]),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final bool isPast;
  const _ProgressBar(this.progress, this.isPast);
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, box) {
      final filled = (box.maxWidth * progress).clamp(0.0, box.maxWidth);
      final barColor = isPast ? C.textSec : C.accent;
      return SizedBox(height: 20, child: Stack(alignment: Alignment.centerLeft, children: [
        Container(height: 4, decoration: BoxDecoration(color: C.border, borderRadius: BorderRadius.circular(2))),
        Container(width: filled, height: 4, decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(2))),
        if (!isPast && progress > 0 && progress < 1)
          Positioned(left: filled - 10,
              child: Container(width: 20, height: 20,
                  decoration: BoxDecoration(color: C.accent, borderRadius: BorderRadius.circular(4)),
                  child: const Icon(Icons.train, color: Colors.white, size: 12))),
      ]));
    },
  );
}

class _StopItem extends StatelessWidget {
  final TrainStop stop;
  final bool isLast;
  const _StopItem(this.stop, {required this.isLast});
  @override
  Widget build(BuildContext context) {
    final (bg, border, child) = switch (stop.status) {
      StopStatus.done     => (C.primary, C.primary, const Icon(Icons.check, color: Colors.white, size: 10) as Widget),
      StopStatus.current  => (C.accent,  C.accent,  const Icon(Icons.location_on, color: Colors.white, size: 10) as Widget),
      StopStatus.upcoming => (Colors.white, C.border, const SizedBox.shrink() as Widget),
    };
    return IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 28, child: Column(children: [
          Container(width: 22, height: 22,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle,
                  border: Border.all(color: border, width: 2)),
              child: Center(child: child)),
          if (!isLast) Expanded(child: Container(width: 2, color: C.border,
              margin: const EdgeInsets.symmetric(vertical: 2))),
        ])),
        const SizedBox(width: 10),
        Expanded(child: Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              if (stop.status == StopStatus.current)
                const Text('• الآن  ', style: TextStyle(fontSize: 13, color: C.accent)),
              Text(stop.name, style: const TextStyle(fontSize: 13, color: C.primary)),
            ]),
            Row(children: [
              if (stop.status == StopStatus.done)
                const Text('✓  ', style: TextStyle(color: C.green, fontSize: 12)),
              Text(stop.time, style: const TextStyle(fontSize: 12, color: C.textSec)),
            ]),
          ]),
        )),
      ]),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final bool dot;
  final IconData? icon;
  final Color bg, fg;
  const _Badge(this.label, {this.dot = false, this.icon, required this.bg, required this.fg});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (dot) Container(width: 7, height: 7,
          margin: const EdgeInsetsDirectional.only(end: 5),
          decoration: BoxDecoration(color: fg, shape: BoxShape.circle)),
      if (icon != null) ...[Icon(icon, size: 12, color: fg), const SizedBox(width: 4)],
      Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: fg)),
    ]),
  );
}

class _MetaCard extends StatelessWidget {
  final String label, value;
  const _MetaCard(this.label, this.value);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(color: C.bg, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(label, style: const TextStyle(fontSize: 10, color: C.textSec)),
        const SizedBox(height: 3),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: C.primary),
            textAlign: TextAlign.center),
      ]),
    ),
  );
}

class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.current, required this.onTap});
  static const _items = [
    (Icons.home_outlined,                'الرئيسية'),
    (Icons.confirmation_number_outlined, 'تذكرتي'),
    (Icons.train_outlined,               'رحلتي'),
    (Icons.person_outline,               'الملف'),
    (Icons.settings_outlined,            'الإعدادات'),
  ];
  @override
  Widget build(BuildContext context) => Container(
    color: C.surface,
    child: SafeArea(top: false, child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: _items.asMap().entries.map((e) {
        final active = current == e.key;
        return Expanded(child: GestureDetector(
          onTap: () => onTap(e.key),
          behavior: HitTestBehavior.opaque,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(e.value.$1, color: active ? C.accent : C.textSec, size: 24),
            const SizedBox(height: 2),
            Text(e.value.$2, style: TextStyle(fontSize: 10, color: active ? C.accent : C.textSec)),
            const SizedBox(height: 3),
            Container(width: 5, height: 5,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: active ? C.accent : Colors.transparent)),
          ]),
        ));
      }).toList()),
    )),
  );
}

