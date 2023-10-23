import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カレンダー',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'カレンダー'),
    );
  }
}

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
      MaterialPageRoute(builder: (context) => FolderPage()),
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

class AlarmStopwatchPage extends StatefulWidget {
  @override
  _AlarmStopwatchPageState createState() => _AlarmStopwatchPageState();
}

class _AlarmStopwatchPageState extends State<AlarmStopwatchPage> {
  bool isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _navigateToCalendar() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'カレンダー')),
    );
  }

  void _navigateToAlarmStopwatch() {
    Navigator.pop(context);
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
      MaterialPageRoute(builder: (context) => FolderPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アラーム・ストップウォッチ'),
      ),
      body: Center(
        child: Text(
          'アラーム・ストップウォッチ画面',
          style: TextStyle(fontSize: 24),
        ),
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
                _navigateToCalendar();
                _toggleMenu();
              },
            ),
            ListTile(
              title: Text('アラーム・ストップウォッチ'),
              onTap: () {
                Navigator.pop(context);
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
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  bool _isResultShown = false;
  bool _isOperatorEnabled = true;
  bool _isNegative = false;
  bool isMenuOpen = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == '±') {
        _toggleNegative();
        return;
      }
      if (_isResultShown && _isNumeric(buttonText)) {
        _output = buttonText;
        _isResultShown = false;
        _isOperatorEnabled = true;
      } else if (_isResultShown && _isOperator(buttonText)) {
        final lastChar = _getLastCharWithoutWhitespace();
        if (_isOperator(lastChar)) {
          _output = _output.substring(0, _output.length - 3);
        }
        _output += buttonText;
        _isOperatorEnabled = false;
        _isResultShown = false;
      } else {
        if (_output == '0' || _isResultShown) {
          _output = buttonText;
          _isResultShown = false;
          _isOperatorEnabled = true;
        } else {
          final lastChar = _getLastCharWithoutWhitespace();
          if (_isOperator(buttonText) && _isOperatorEnabled) {
            final lastChar = _getLastCharWithoutWhitespace();
            if (_isOperator(lastChar) ||
                (lastChar == '.' && !_isNumeric(buttonText))) {
              return;
            }
            if (buttonText == '(' && _isNumeric(lastChar)) {
              return;
            }
            if (buttonText == ')' && !_isOperator(lastChar)) {
              return;
            }
            _output += buttonText;
            _isOperatorEnabled = false;
          } else if (!_isOperator(buttonText)) {
            final lastChar = _getLastCharWithoutWhitespace();
            if (lastChar == ')' || _isNumeric(lastChar)) {
              _output += '$buttonText';
            } else {
              _output += buttonText;
            }
            _isOperatorEnabled = true;
          }
        }
      }
    });
  }

  void _toggleNegative() {
    setState(() {
      _isNegative = !_isNegative;
      if (_isNegative) {
        _output = '-' + _output;
      } else {
        _output = _output.substring(1);
      }
    });
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _navigateToCalendar() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'カレンダー')),
    );
  }

  void _navigateToAlarmStopwatch() {
    Navigator.pop(context);
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
      MaterialPageRoute(builder: (context) => FolderPage()),
    );
  }


  String _getLastCharWithoutWhitespace() {
    final trimmedOutput = _output.trim();
    return trimmedOutput.isNotEmpty
        ? trimmedOutput[trimmedOutput.length - 1]
        : '';
  }

  String _getLastChar() {
    if (_output.isEmpty) {
      return '';
    }
    return _output[_output.length - 1];
  }

  bool _isOperator(String str) {
    final operators = ['+', '-', '*', '/', '(', ')', '.'];
    return operators.contains(str);
  }

  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void _evaluateExpression() {
    setState(() {
      try {
        final result = eval(_output);
        _output = result.toString();
      } catch (e) {
        _output = 'Error';
      }
      _isResultShown = true;
    });
  }

  void _clearOutput() {
    setState(() {
      _output = '0';
      _isResultShown = false;
      _isOperatorEnabled = true;
    });
  }

  void _deleteLastCharacter() {
    setState(() {
      if (_isResultShown) {
        _output = '0';
      } else {
        if (_output.isNotEmpty) {
          _output = _output.substring(0, _output.length - 1);
        }
        if (_output.isEmpty) {
          _output = '0';
        }
      }
      _isOperatorEnabled = true;
    });
  }

  void _addDecimalPoint() {
    setState(() {
      final lastChar = _getLastCharWithoutWhitespace();
      if (!_output.contains('.') && !_isOperator(lastChar)) {
        _output += '.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('電卓'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: Text(
              _output,
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(height: 1.0),
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 19,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.7,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                final buttonText = _buttonLabels[index];
                return TextButton(
                  onPressed: () {
                    if (buttonText == 'C') {
                      _clearOutput();
                    } else if (buttonText == '=') {
                      _evaluateExpression();
                    } else if (buttonText == '⇦') {
                      _deleteLastCharacter();
                    } else if (buttonText == '.') {
                      _addDecimalPoint();
                    } else {
                      _buttonPressed(buttonText);
                    }
                  },
                  child: buttonText == '⇦'
                      ? Icon(Icons.backspace_outlined)
                      : Text(
                          buttonText,
                          style: TextStyle(fontSize: 18.0),
                        ),
                );
              },
            ),
          ),
        ],
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
                _navigateToCalendar();
                _toggleMenu();
              },
            ),
            ListTile(
              title: Text('アラーム・ストップウォッチ'),
              onTap: () {
                Navigator.pop(context);
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
              },
            ),
          ],
        ),
      ),
    );
  }
}

final List<String> _buttonLabels = [
  'C',
  '±',
  '⇦',
  '/',
  '7',
  '8',
  '9',
  '*',
  '4',
  '5',
  '6',
  '-',
  '1',
  '2',
  '3',
  '+',
  '0',
  '.',
  '=',
];

double eval(String expression) {
  final parser = Parser();
  final parsedExpression = parser.parse(expression);
  final contextModel = ContextModel();
  return parsedExpression.evaluate(EvaluationType.REAL, contextModel);
}

class FolderPage extends StatefulWidget {
  @override
  _FolderPageState createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  bool isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _navigateToCalendar() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: 'カレンダー')),
    );
  }

  void _navigateToAlarmStopwatch() {
    Navigator.pop(context);
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
      MaterialPageRoute(builder: (context) => FolderPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('フォルダ管理'),
      ),
      body: Center(
        child: Text(
          'フォルダ管理画面',
          style: TextStyle(fontSize: 24),
        ),
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
                _navigateToCalendar();
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
    );
  }
}


class Task {
  final DateTime date;
  final String name;

  Task({required this.date, required this.name});
}

class TaskInputPage extends StatefulWidget {
  final DateTime selectedDate;

  TaskInputPage({required this.selectedDate});

  @override
  _TaskInputPageState createState() => _TaskInputPageState();
}

class _TaskInputPageState extends State<TaskInputPage> {
  String taskName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タスクの入力'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.selectedDate.year}年 ${widget.selectedDate.month}月 ${widget.selectedDate.day}日',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    if (taskName.isNotEmpty) {
                      final task = Task(
                        date: widget.selectedDate,
                        name: taskName,
                      );
                      Navigator.pop(context, task);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'タイトル',
              style: TextStyle(color: Colors.grey),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  taskName = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'タスク名を入力してください',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final DateTime selectedDate;
  final List<Task> tasks;

  const TaskList({
    Key? key,
    required this.selectedDate,
    required this.tasks,
  }) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> filteredTasks = [];

  List<Task> filterTasks() {
    return widget.tasks.where((task) {
      return task.date.year == widget.selectedDate.year &&
          task.date.month == widget.selectedDate.month &&
          task.date.day == widget.selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    filteredTasks = filterTasks();

    if (filteredTasks.isEmpty) {
      return Center(
        child: Text(
          'タスクがありません',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Dismissible(
          key: Key(task.name),
          onDismissed: (_) {
            setState(() {
              widget.tasks.remove(task);
            });
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            title: Text(task.name),
          ),
        );
      },
    );
  }
}

