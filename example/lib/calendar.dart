import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cellCalendarPageController = CellCalendarPageController();
  late DateTime selectedDate;
  bool isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _closeDrawer() {
    setState(() {
      isMenuOpen = false;
    });
  }

  void _navigateToCalendar() {
    _closeDrawer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlarmStopwatchPage()),
    );
  }

  void _navigateToAlarmStopwatch() {
    _closeDrawer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlarmStopwatchPage()),
    );
  }

  void _navigateToCalculator() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalculatorScreen()),
    );
  }

  void _navigateToFolderList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CalculatorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'メニュー',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('カレンダー'),
              onTap: () {
                Navigator.pop(context);
                _toggleMenu();
              },
            ),
            ListTile(
              title: Text('アラーム・ストップウォッチ'),
              onTap: () {
                _navigateToAlarmStopwatch();
                _toggleMenu();
              },
            ),
            ListTile(
              title: Text('電卓'),
              onTap: () {
                _navigateToCalculator();
                _toggleMenu();
              },
            ),
            ListTile(
              title: Text('フォルダ'),
              onTap: () {
                _navigateToFolderList();
                _toggleMenu();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isMenuOpen = false;
              });
            },
            child: CellCalendar(
              cellCalendarPageController: cellCalendarPageController,
              daysOfTheWeekBuilder: (dayIndex) {
                final labels = ["日", "月", "火", "水", "木", "金", "土"];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    labels[dayIndex],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
              monthYearLabelBuilder: (datetime) {
                final year = datetime!.year.toString();
                final month = _getJapaneseMonth(datetime.month);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Text(
                        "$year年 $month",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                );
              },
              onCellTapped: (date) {
                setState(() {
                  selectedDate = date;
                });
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    titlePadding: EdgeInsets.zero,
                    title: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Center(
                          child: Text(
                            "${_getJapaneseMonth(date.month)} ${date.day}日",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 440,
                          width: 350,
                        ),
                      ],
                    ),
                    actions: [
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskInputPage(selectedDate: date),
                            ),
                          ).then((task) {
                            if (task != null) {}
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                );
              },
              onPageChanged: (firstDate, lastDate) {},
            ),
          ),
        ],
      ),
    );
  }

  String _getJapaneseMonth(int month) {
    final monthNames = [
      '',
      '1月',
      '2月',
      '3月',
      '4月',
      '5月',
      '6月',
      '7月',
      '8月',
      '9月',
      '10月',
      '11月',
      '12月',
    ];
    return monthNames[month];
  }

  String _getFormattedDate(DateTime date) {
    return '${date.year}年 ${date.month}月 ${date.day}日';
  }
}
