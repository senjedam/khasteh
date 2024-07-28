import 'package:flutter/material.dart';
import 'package:snake_and_ladders/theme/app_colors.dart';

class CustomOverlayWidget extends StatelessWidget {
  final int score;
  const CustomOverlayWidget(this.score, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          color:AppColors.accentColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                    width: 200,
                    child: Image.asset('assets/cat/catLaugh.gif',)),
                Text('ما بردیم!'+" "+score.toString()+" امتیاز",textDirection: TextDirection.rtl,textAlign: TextAlign.right,),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('بستن'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}