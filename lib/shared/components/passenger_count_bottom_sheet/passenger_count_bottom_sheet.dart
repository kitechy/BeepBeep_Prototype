import 'package:beepbeep_prototype/shared/components/passenger_count_bottom_sheet/widgets/counter_button.dart';
import 'package:flutter/material.dart';

class PassengerCountBottomSheet extends StatefulWidget {
  final int occupiedSeats;
  final int totalSeats;
  final Future<void> Function(int occupiedSeats) onUpdate;

  const PassengerCountBottomSheet({
    super.key,
    required this.occupiedSeats,
    required this.totalSeats,
    required this.onUpdate,
  });

  @override
  State<PassengerCountBottomSheet> createState() =>
      _PassengerCountBottomSheetState();
}

class _PassengerCountBottomSheetState extends State<PassengerCountBottomSheet> {
  late int _occupiedSeats;
  bool _isUpdating = false;
  int? _queuedCount;
  late int _lastSavedCount;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _occupiedSeats = widget.occupiedSeats.clamp(0, widget.totalSeats);
    _lastSavedCount = _occupiedSeats;
  }

  int get _availableSeats {
    return widget.totalSeats - _occupiedSeats;
  }

  Future<void> _updateCount(int newCount) async {
    if (newCount < 0 || newCount > widget.totalSeats) {
      return;
    }

    setState(() {
      _occupiedSeats = newCount;
      _errorMessage = null;
    });

    if (_isUpdating) {
      _queuedCount = newCount;
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      var countToSave = newCount;

      while (true) {
        await widget.onUpdate(countToSave).timeout(const Duration(seconds: 8));
        _lastSavedCount = countToSave;

        final queuedCount = _queuedCount;
        _queuedCount = null;

        if (queuedCount == null || queuedCount == _lastSavedCount) {
          break;
        }

        countToSave = queuedCount;
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _occupiedSeats = _lastSavedCount;
        _errorMessage = 'Could not update passenger count. Please try again.';
      });
      _queuedCount = null;
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _decrease() async {
    if (_occupiedSeats <= 0) return;

    await _updateCount(_occupiedSeats - 1);
  }

  Future<void> _increase() async {
    if (_occupiedSeats >= widget.totalSeats) {
      return;
    }

    await _updateCount(_occupiedSeats + 1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xffD6D2CB),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Passenger Count',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1C1A17),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: _isUpdating ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              'Update the number of passengers currently inside the jeepney.',
              style: TextStyle(fontSize: 13, color: Color(0xff8A8378)),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            const Text(
              'Occupied Seats',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xff8A8378),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CounterButton(
                  icon: Icons.remove_rounded,
                  onPressed: _occupiedSeats > 0 ? _decrease : null,
                ),

                const SizedBox(width: 28),

                SizedBox(
                  width: 70,
                  child: Text(
                    '$_occupiedSeats',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff1C1A17),
                    ),
                  ),
                ),

                const SizedBox(width: 28),

                CounterButton(
                  icon: Icons.add_rounded,
                  onPressed: _occupiedSeats < widget.totalSeats
                      ? _increase
                      : null,
                ),
              ],
            ),

            if (widget.totalSeats <= 0) ...[
              const SizedBox(height: 12),
              const Text(
                'Seat capacity is not available yet. Reload the driver profile and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],

            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xffF8F7F4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Available Seats',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1C1A17),
                      ),
                    ),
                  ),

                  if (_isUpdating)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xff0056FF),
                      ),
                    )
                  else
                    Text(
                      '$_availableSeats / ${widget.totalSeats}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff2E7D5B),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
