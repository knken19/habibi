import 'package:flutter/material.dart';
import 'dart:math';

class HeartScreen extends StatefulWidget {
  const HeartScreen({super.key});

  @override
  _HeartScreenState createState() => _HeartScreenState();
}

class _HeartScreenState extends State<HeartScreen> {
  final List<Widget> _hearts = [];

  void _addHeart() {
    final key = UniqueKey();
    final double startPosition =
        Random().nextDouble() * MediaQuery.of(context).size.width;

    setState(() {
      _hearts.add(HeartAnimation(
        key: key,
        startPosition: startPosition,
        onAnimationEnd: () {
          setState(() {
            _hearts.removeWhere((element) => element.key == key);
          });
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Love',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFBE5985),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.all(16.0),
                width: 350,
                height: 665,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(235, 203, 214, 1),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text('''Hi, Love!
Happy Valentines Day!
                  
        Bilang pagalala kung gaano kita kamahal, ginawa ko 'tong gift na 'to para sa'yo. Sobrang proud ako sa lahat ng naachieve natin nang magkasama. Sobrang proud ako sa'yo at sa lahat ng effort mo to be the best you can be at masaya akong nakikita na masaya ka sa path na nilalakaran mo ngayon.
        Hindi ako magsasawang ulit-ulitin na nandito lang ako palagi para suportahan, tulungan, i-motivate, at mahalin ka sa bawat araw. Masaya akong maging parte ng buhay na binubuo mo para sa sarili mo, at gagawin ko lahat para tulungan ka hanggang sa makakaya ko. Alam kong alam mo naman na basta ikaw, kakayanin ko ang lahat.
        Nagkakaroon man tayo ng hindi pagkakaintindihan at 'di pagkakasundo sa mga bagay-bagay, ikaw pa rin ang pipiliin ko PALAGI. Sobrang pasasalamat ko na natagpuan ulit natin ang isa't isa. Sobrang swerte ko sa'yo bilang partner ko, kaibigan ko, kaharutan, kaaway, at soon—kapag umayon na sa atin ang panahon—magiging asawa ko.
        Salamat sa pagintindi, pag-gabay, pag-saway, at pagmamahal sa akin. Mahal na mahal kita.
        
        
        "Ngayon, ako ay luluhod
         bilang tapat mong tagapagmahal.
         Ang tumanda kasama ka,
         ito ang aking dasal"
         
         
    -Ken
         
         ''',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.left),
                ),
              ),
            ),
            ..._hearts,
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70.0),
        ),
        child: FloatingActionButton(
          onPressed: _addHeart,
          backgroundColor: Colors.red,
          child: const Icon(Icons.favorite, color: Colors.white, size: 50),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class HeartAnimation extends StatefulWidget {
  final double startPosition;
  final VoidCallback onAnimationEnd;

  const HeartAnimation(
      {super.key, required this.startPosition, required this.onAnimationEnd});

  @override
  _HeartAnimationState createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _positionAnimation =
        Tween<double>(begin: 50, end: 1000).animate(_controller);
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _controller.forward().whenComplete(widget.onAnimationEnd);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: _positionAnimation.value,
          left: widget.startPosition,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 60,
            ),
          ),
        );
      },
    );
  }
}
