import 'package:flex/helper/app_colors.dart';
import 'package:flex/widgets/loader.dart';
import 'package:flutter/material.dart';

class LoadingBarrier extends StatelessWidget {

  final Stream<bool> stream;
  final bool initialData;
  LoadingBarrier(this.stream, {this.initialData = false});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: stream,
      initialData: initialData,
      builder: (c,v){
        return Visibility(
          visible: v.data,
          child: Stack(
            children: [
              ModalBarrier(
                color: Colors.black12,
                dismissible: false,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: SHADOW_COLOR,
                                blurRadius: 6.0,
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(15.0),
                          child: Loader(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
