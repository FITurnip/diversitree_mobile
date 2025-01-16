import 'package:diversitree_mobile/core/styles.dart';
import 'package:flutter/material.dart';

class StepperButton extends StatefulWidget {
  final int urutanSaatIni;
  final Function(int) onStepChanged;

  const StepperButton({
    Key? key,
    required this.urutanSaatIni,
    required this.onStepChanged,
  }) : super(key: key);

  @override
  _StepperButtonState createState() => _StepperButtonState();
}

class _StepperButtonState extends State<StepperButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Stepper Progress Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * (widget.urutanSaatIni / 4),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * ((4 - widget.urutanSaatIni) / 4),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
          ],
        ),

        // Navigation Buttons
        Container(
          decoration: BoxDecoration(
            color: Colors.white
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // "Sebelumnya" button
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: ElevatedButton(
                  onPressed: widget.urutanSaatIni > 1
                      ? () => widget.onStepChanged(widget.urutanSaatIni - 1)
                      : null, // Disable if step is at 1
                  child: Text("Sebelumnya"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(width: MediaQuery.of(context).size.width * 0.05),

              // "Selanjutnya" button
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: ElevatedButton(
                  onPressed: widget.urutanSaatIni < 4
                      ? () => widget.onStepChanged(widget.urutanSaatIni + 1)
                      : null, // Disable if step is at 4
                  child: Text("Selanjutnya"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    side: BorderSide(color: AppColors.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
