import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:musicplayer_app/pages/panel_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// StreamController<double> _panelPositionController = StreamController<double>();
late AnimationController _ac;

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage>
    with TickerProviderStateMixin {
  double height = 0;
  double width = 0;
  double stasutBarHeight = 0;
  double navBarHeight = 0;
  double blurAmount = 8;
  double minSPHeight = 0;
  double panelPosition = 0;
  final PanelController controller = PanelController();

  @override
  void initState() {
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    stasutBarHeight = MediaQuery.of(context).viewPadding.top;
    navBarHeight = MediaQuery.of(context).padding.bottom;
    minSPHeight = 102 + navBarHeight;
    return Scaffold(
      body: SlidingUpPanel(
        color: Colors.black,
        controller: controller,
        maxHeight: height,
        minHeight: minSPHeight,
        parallaxEnabled: true,
        parallaxOffset: 0.01,
        boxShadow: const <BoxShadow>[
          BoxShadow(blurRadius: 2.0, color: Color.fromRGBO(0, 0, 0, 0.25))
        ],
        onPanelSlide: (position) {
          double num = double.parse(position.toStringAsFixed(4));
          if (num != panelPosition) {
            _ac.value = num;
            panelPosition = num;
          }
        },
        body: const RouterOutlet(),
        panel: PanelPage(
          ac: _ac,
          panelController: controller,
        ),
      ),
    );
  }
}
