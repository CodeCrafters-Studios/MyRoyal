import 'package:flutter/scheduler.dart';

class TicckerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
