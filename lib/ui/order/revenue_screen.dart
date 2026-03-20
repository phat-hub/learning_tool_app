import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../screen.dart';

enum RevenueFilterType {
  day,
  month,
  year,
}

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  RevenueFilterType _filterType = RevenueFilterType.day;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<OrdersManager>().fetchOrders();
    });
  }

  /// 🧠 TÍNH DOANH THU
  double _calculateRevenue(List<OrderItem> orders) {
    final filteredOrders = orders.where((order) {
      /// BỎ cancelled
      if (order.status == 'cancelled') return false;

      final orderDate = order.dateTime;

      switch (_filterType) {
        case RevenueFilterType.day:
          return orderDate.year == _selectedDate.year &&
              orderDate.month == _selectedDate.month &&
              orderDate.day == _selectedDate.day;

        case RevenueFilterType.month:
          return orderDate.year == _selectedDate.year &&
              orderDate.month == _selectedDate.month;

        case RevenueFilterType.year:
          return orderDate.year == _selectedDate.year;
      }
    }).toList();

    return filteredOrders.fold(0.0, (sum, item) => sum + item.amount);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: _filterType == RevenueFilterType.day
          ? 'Chọn ngày'
          : _filterType == RevenueFilterType.month
              ? 'Chọn tháng'
              : 'Chọn năm',
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
    });
  }

  String _getDateText() {
    switch (_filterType) {
      case RevenueFilterType.day:
        return DateFormat('dd/MM/yyyy').format(_selectedDate);
      case RevenueFilterType.month:
        return DateFormat('MM/yyyy').format(_selectedDate);
      case RevenueFilterType.year:
        return DateFormat('yyyy').format(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersManager>().orders;

    final revenue = _calculateRevenue(orders);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doanh thu'),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// FILTER TYPE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('Ngày'),
                  selected: _filterType == RevenueFilterType.day,
                  onSelected: (_) {
                    setState(() {
                      _filterType = RevenueFilterType.day;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Tháng'),
                  selected: _filterType == RevenueFilterType.month,
                  onSelected: (_) {
                    setState(() {
                      _filterType = RevenueFilterType.month;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Năm'),
                  selected: _filterType == RevenueFilterType.year,
                  onSelected: (_) {
                    setState(() {
                      _filterType = RevenueFilterType.year;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DATE PICKER
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(_getDateText()),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// REVENUE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Colors.orange,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Tổng doanh thu',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${NumberFormat.decimalPattern().format(revenue)} VNĐ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// DANH SÁCH ĐƠN
            Expanded(
              child: ListView(
                children: orders
                    .where((o) => o.status != 'cancelled')
                    .map((o) => ListTile(
                          title: Text('Đơn: ${o.id}'),
                          subtitle:
                              Text(DateFormat('dd/MM/yyyy').format(o.dateTime)),
                          trailing: Text(
                            '${NumberFormat.decimalPattern().format(o.amount)}',
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
