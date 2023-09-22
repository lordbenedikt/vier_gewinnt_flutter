import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _cols;
  late int _rows;
  late List<List<int>> _squares;
  int _currentPlayer = 1;
  int _hoverCol = -1;
  int _hoverRow = -1;
  bool _anticipatingMove = false;

  @override
  void initState() {
    initSquares(7, 6);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Vier gewinnt')),
      body: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _anticipatingMove = true;
          });
        },
        onTapCancel: () {
          setState(() {
            _anticipatingMove = false;
          });
        },
        onPanStart: (_) {
          setState(() {
            _anticipatingMove = true;
          });
        },
        onPanEnd: (_) {
          setState(() {
            _anticipatingMove = false;
          });
          play(_hoverCol);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildColumns(),
        ),
      ),
    );
  }

  void initSquares(int cols, int rows) {
    this._cols = cols;
    this._rows = rows;
    _squares = List.generate(
        cols, (i) => List<int>.generate(rows, (index) => 0),
        growable: false);
  }

  ({double x, double y}) squareSize() {
    return (x: 60.0, y: 60.0);
  }

  Widget squareIcon(int col, int row) {
    int squareState = _squares[col][row];
    switch (squareState) {
      case -1:
        return Icon(Icons.circle, color: Colors.yellow, size: squareSize().y);
      case 1:
        return Icon(Icons.circle, color: Colors.red, size: squareSize().y);
      default:
        return Container();
    }
  }

  Widget squareWidget(int col, int row) {
    double getAlpha() {
      return col == _hoverCol ? (_anticipatingMove ? 0.3 : 0.2) : 0.1;
    }

    return Container(
      padding: EdgeInsets.all(0.0),
      width: squareSize().x,
      height: squareSize().y,
      child: Stack(children: [
        Container(
          margin: EdgeInsets.all(1.0),
          color: Color.fromRGBO(0, 0, 0, getAlpha()),
        ),
        squareIcon(col, row),
      ]),
    );
  }

  bool play(int col) {
    for (int i = 1; i <= _rows; i++) {
      if (_squares[col][_rows - i] == 0) {
        setState(() {
          _squares[col][_rows - i] = _currentPlayer;
          _currentPlayer *= -1;
        });
        return true;
      }
    }
    return false;
  }

  List<Widget> buildColumns() {
    List<Widget> rowWidgets = [];
    for (int i = 0; i < _cols; i++) {
      List<Widget> children = [];
      for (int j = 0; j < _rows; j++) {
        children.add(squareWidget(i, j));
      }
      rowWidgets.add(MouseRegion(
        onEnter: (_) {
          setState(() {
            _hoverCol = i;
          });
        },
        onExit: (_) {
          setState(() {
            _hoverCol = -1;
          });
        },
        child: InkWell(
          onTap: () {
            play(i);
          },
          child: Container(
            height: squareSize().y * _rows,
            child: Column(
              children: children,
            ),
          ),
        ),
      ));
    }
    return rowWidgets;
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text('Firebase Meetup'),
//     ),
//     body: ListView(
//       children: <Widget>[
//         Image.asset('assets/codelab.png'),
//         const SizedBox(height: 8),
//         const IconAndDetail(Icons.calendar_today, 'October 30'),
//         const IconAndDetail(Icons.location_city, 'San Francisco'),
//         // Add from here
//         Consumer<ApplicationState>(
//           builder: (context, appState, _) => AuthFunc(
//               loggedIn: appState.loggedIn,
//               signOut: () {
//                 FirebaseAuth.instance.signOut();
//               }),
//         ),
//         // to here
//         const Divider(
//           height: 8,
//           thickness: 1,
//           indent: 8,
//           endIndent: 8,
//           color: Colors.grey,
//         ),
//         const Header("What we'll be doing"),
//         const Paragraph(
//           'Join us for a day full of Firebase Workshops and Pizza!',
//         ),
//         Consumer<ApplicationState>(
//           builder: (context, appState, _) => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Add from here...
//               switch (appState.attendees) {
//                 1 => const Paragraph('1 person going'),
//                 >= 2 => Paragraph('${appState.attendees} people going'),
//                 _ => const Paragraph('No one going'),
//               },
//               // ...to here.
//               if (appState.loggedIn) ...[
//                 // Add from here...
//                 YesNoSelection(
//                   state: appState.attending,
//                   onSelection: (attending) => appState.attending = attending,
//                 ),
//                 // ...to here.
//                 const Header('Discussion'),
//                 GuestBook(
//                   addMessage: (message) =>
//                       appState.addMessageToGuestBook(message),
//                   messages: appState.guestBookMessages,
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
