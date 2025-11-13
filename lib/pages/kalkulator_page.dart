import 'dart:math';
import 'package:flutter/material.dart';

class KalkulatorPage extends StatefulWidget {
  const KalkulatorPage({super.key});

  @override
  State<KalkulatorPage> createState() => _KalkulatorPageState();
}

class _KalkulatorPageState extends State<KalkulatorPage> {
  String input = '';
  String result = '';

  void _onButtonClick(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == '=') {
        _calculate();
      } else if (value == '√') {
        if (input.isNotEmpty) {
          final num = double.tryParse(input);
          if (num != null) {
            final val = sqrt(num);
            result = _formatResult(val);
            input = result;
          }
        }
      } else if (value == '%') {
        if (input.isNotEmpty) {
          final num = double.tryParse(input);
          if (num != null) {
            final val = num / 100;
            result = _formatResult(val);
            input = result;
          }
        }
      } else if (value == '+/-') {
        if (input.isNotEmpty) {
          if (input.startsWith('-')) {
            input = input.substring(1);
          } else {
            input = '-$input';
          }
        }
      } else if (value == ',') {
        // ubah koma ke titik biar bisa dihitung
        if (!input.contains('.')) {
          input += '.';
        }
      } else {
        input += value;
      }
    });
  }

  void _calculate() {
    try {
      String finalInput = input.replaceAll('x', '*').replaceAll('÷', '/');
      double value = _evaluateExpression(finalInput);
      result = _formatResult(value);
      input = result;
    } catch (e) {
      result = 'Error';
    }
  }

  String _formatResult(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString(); // tanpa koma
    } else {
      return value.toString(); // tetap desimal
    }
  }

  double _evaluateExpression(String expression) {
    List<String> tokens = expression.split(RegExp(r'([+\-*/])'));
    List<String> operators =
    expression.replaceAll(RegExp(r'[0-9.]'), '').split('');

    double value = double.tryParse(tokens[0]) ?? 0.0;
    int opIndex = 0;

    for (int i = 1; i < tokens.length; i++) {
      double next = double.tryParse(tokens[i]) ?? 0.0;
      if (opIndex < operators.length) {
        String op = operators[opIndex];
        switch (op) {
          case '+':
            value += next;
            break;
          case '-':
            value -= next;
            break;
          case '*':
            value *= next;
            break;
          case '/':
            value /= next;
            break;
        }
        opIndex++;
      }
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buttons = [
      'C', '(', ')', '÷',
      '7', '8', '9', 'x',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '+/-', '0', ',', '=',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // === DISPLAY ===
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                color: const Color(0xFFF8F8F8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      input,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      result,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BUTTON
            Expanded(
              flex: 5,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final text = buttons[index];
                    final isOperator =
                    ['÷', 'x', '-', '+', '=', '%'].contains(text);
                    final isClear = text == 'C';
                    final isEqual = text == '=';

                    Color bgColor;
                    Color textColor;

                    if (isClear) {
                      bgColor = Colors.grey.shade200;
                      textColor = Colors.red;
                    } else if (isOperator) {
                      bgColor =
                      isEqual ? Colors.green : Colors.grey.shade200;
                      textColor =
                      isEqual ? Colors.white : Colors.green.shade700;
                    } else {
                      bgColor = Colors.white;
                      textColor = Colors.black87;
                    }

                    return GestureDetector(
                      onTap: () => _onButtonClick(text),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(1, 1),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
