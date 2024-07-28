import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomDiceWidget extends StatelessWidget {
  final int? diceNumber;
  const CustomDiceWidget(this.diceNumber, {super.key});

  Widget _diceDot(){
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50))
      ),
    );
  }

  Widget _diceMaker(){
    if(diceNumber!%2==0){
      List<Widget> dotRows=List<Widget>.generate((diceNumber!/2) as int, (index) => (
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _diceDot(),
              _diceDot(),
            ],
          )
      ));
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: dotRows
      );
    }else{
      if(diceNumber==1){
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _diceDot(),
          ],
        );
      }else if(diceNumber==3){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(alignment: Alignment.centerRight,child: _diceDot()),
            Align(alignment: Alignment.center,child: _diceDot()),
            Align(alignment: Alignment.centerLeft,child: _diceDot()),
          ],
        );
      }else{
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _diceDot(),
                _diceDot(),
              ],
            ),
            Align(alignment: Alignment.center,child: _diceDot()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _diceDot(),
                _diceDot(),
              ],
            )
          ],
        );
      }

      // List<Widget> dotRows=List<Widget>.generate((diceNumber!/2) as int, (index) => (
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         _diceDot(),
      //         _diceDot(),
      //       ],
      //     )
      // ));
      // return Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: dotRows
      // );
    }

    // return Center(
    //   child: GridView.builder(
    //       shrinkWrap: true,
    //       itemCount: 6,
    //       physics: NeverScrollableScrollPhysics(),
    //       ,
    //       padding: const EdgeInsets.all(10),//20),
    //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2,
    //           crossAxisSpacing: 10,
    //           mainAxisSpacing: diceNumber!>4?2:10
    //       ),
    //     itemBuilder: (context, index) => _diceDot(),
    //   ),
    // );
    // return
    //  Column(
    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         _diceDot(),
    //         _diceDot(),
    //       ],
    //     ),
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         _diceDot(),
    //         _diceDot(),
    //       ],
    //     ),
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
          color: Color(0xffa87b6e),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
              color: AppColors.buttonColor,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child:diceNumber==null || diceNumber==0?const Icon(Icons.question_mark_rounded,color: Colors.white,)
              :Padding(
                padding: const EdgeInsets.all(3.0),
                child: _diceMaker(),
              )
        ),
      ),
    );
  }
}