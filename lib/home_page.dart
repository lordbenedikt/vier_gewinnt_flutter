import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/authentication.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int hoverCol = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => Scaffold(
            appBar: AppBar(
                backgroundColor: appState.gameState.winner == -1
                    ? Colors.yellow
                    : (appState.gameState.winner == 1
                        ? Colors.red
                        : Colors.blue),
                centerTitle: true,
                title: Text(appState.gameState.winner == 0
                    ? 'Vier gewinnt'
                    : 'Player ${appState.gameState.winner == -1 ? "yellow" : "red"} wins!')),
            body: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        appState.gameState.anticipatingMove = true;
                      });
                    },
                    onTapCancel: () {
                      setState(() {
                        appState.gameState.anticipatingMove = false;
                      });
                    },
                    onPanStart: (_) {
                      setState(() {
                        appState.gameState.anticipatingMove = true;
                      });
                    },
                    onPanEnd: (_) {
                      setState(() {
                        appState.gameState.anticipatingMove = false;
                        appState.gameState.play(hoverCol);
                        print('onPanEnd');
                        print('before set doc');
                        appState.setVierGewinntState(appState.gameState);
                        print('after set doc');
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildColumns(appState),
                    ),
                  ),
                ),
                Consumer<ApplicationState>(
                  builder: (context, appState, _) => AuthFunc(
                      loggedIn: appState.loggedIn,
                      signOut: () {
                        FirebaseAuth.instance.signOut();
                      }),
                ),
              ],
            )));
  }

  ({double x, double y}) squareSize() {
    return (x: 60.0, y: 60.0);
  }

  Widget squareIcon(int col, int row, ApplicationState appState) {
    int squareState = appState.gameState.squares[col][row];
    switch (squareState) {
      case -1:
        return Icon(Icons.circle, color: Colors.yellow, size: squareSize().y);
      case 1:
        return Icon(Icons.circle, color: Colors.red, size: squareSize().y);
      default:
        bool showPreview =
            col == hoverCol && row == appState.gameState.nextRow[hoverCol];
        Color previewColor = appState.gameState.currentPlayer == -1
            ? Colors.yellow.withOpacity(0.3)
            : Colors.red.withOpacity(0.3);
        return showPreview
            ? Icon(Icons.circle, color: previewColor, size: squareSize().y)
            : Container();
    }
  }

  Widget squareWidget(int col, int row, ApplicationState appState) {
    double getAlpha() {
      return col == hoverCol
          ? (appState.gameState.anticipatingMove ? 0.3 : 0.2)
          : 0.1;
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
        squareIcon(col, row, appState),
      ]),
    );
  }

  List<Widget> buildColumns(ApplicationState appState) {
    List<Widget> rowWidgets = [];
    for (int i = 0; i < appState.gameState.cols; i++) {
      List<Widget> children = [];
      for (int j = 0; j < appState.gameState.rows; j++) {
        children.add(squareWidget(i, j, appState));
      }
      rowWidgets.add(MouseRegion(
          onEnter: (_) {
            setState(() {
              hoverCol = i;
            });
          },
          onExit: (_) {
            setState(() {
              hoverCol = -1;
            });
          },
          child: Consumer<ApplicationState>(
            builder: (context, appState, _) => InkWell(
              onTap: () {
                setState(() {
                  appState.gameState.play(i);
                  appState.setVierGewinntState(appState.gameState);
                });
              },
              child: Container(
                height: squareSize().y * appState.gameState.rows,
                child: Column(
                  children: children,
                ),
              ),
            ),
          )));
    }
    return rowWidgets;
  }
//
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
