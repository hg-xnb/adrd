// import 'package:math_expressions/math_expressions.dart';

// class Calculator {
//   static const String _expressionReset = 'Add something to calc like 3x10+19-27+33*100-109*3204 ;3';
//   static const String _resultReset = 'Nothin\'';

//   String _expression = _expressionReset; // Biểu thức tính toán
//   String _result = _resultReset; // Kết quả hiện tại
//   String _recentResult = _resultReset; // Kết quả gần đây

//   // Getters
//   String get expression => _expression;
//   String get result => _result;
//   String get recentResult => _recentResult;

//   // Thêm số hoặc dấu thập phân
//   void addDigit(String digit) {
//     if (digit == '.' && _expression.contains('.')) {
//       // Ngăn thêm dấu chấm nếu đã có
//       return;
//     }
//     if (_expression == '0' && digit != '.') {
//       // Thay số 0 ban đầu bằng số mới
//       _expression = digit;
//     } else {
//       _expression += digit;
//     }
//   }

//   // Thêm toán tử (+, -, *, /)
//   void addOperator(String operator, String value) {
//     if (_expression.isEmpty && operator != '-') {
//       // Chỉ cho phép dấu trừ ở đầu
//       return;
//     }
//     if (_expression.endsWith('+') ||
//         _expression.endsWith('-') ||
//         _expression.endsWith('*') ||
//         _expression.endsWith('/')) {
//       // Thay toán tử cuối nếu đã có toán tử
//       _expression = _expression.substring(0, _expression.length - 1) + operator;
//     } else {
//       _expression += operator;
//     }
//   }

//   // Xóa ký tự cuối cùng trong biểu thức
//   void removeDigit() {
//     if (_expression.isNotEmpty) {
//       _expression = _expression.substring(0, _expression.length - 1);
//     }
//     if (_expression.isEmpty) {
//       _expression = '0';
//     }
//   }

//   // Xóa toán tử cuối cùng
//   void removeLastOperator() {
//     if (_expression.isNotEmpty) {
//       final lastChar = _expression[_expression.length - 1];
//       if (lastChar == '+' || lastChar == '-' || lastChar == '*' || lastChar == '/') {
//         _expression = _expression.substring(0, _expression.length - 1);
//       }
//     }
//     if (_expression.isEmpty) {
//       _expression = '0';
//     }
//   }

//   // Xóa toàn bộ biểu thức và kết quả
//   void clearAll() {
//     _expression = _expressionReset;
//     _result = _resultReset;
//     _recentResult = _resultReset;
//   }

//   // Tính toán kết quả từ biểu thức
//   void calc() {
//     try {
//       // Lưu kết quả hiện tại vào recentResult
//       _recentResult = _result;

//       // Thay thế các ký hiệu toán học phù hợp
//       String evalExpression = _expression.replaceAll('x', '*').replaceAll('÷', '/');

//       // Sử dụng ShuntingYardParser thay vì Parser
//       ShuntingYardParser parser = ShuntingYardParser();
//       Expression exp = parser.parse(evalExpression);
//       ContextModel cm = ContextModel();
//       double evalResult = exp.evaluate(EvaluationType.REAL, cm);

//       // Cập nhật kết quả
//       _result = evalResult.toString();
//       if (_result.endsWith('.0')) {
//         _result = _result.substring(0, _result.length - 2);
//       }
//     } catch (e) {
//       _result = 'Error';
//     }
//   }
// }

import 'package:math_expressions/math_expressions.dart';

class Calculator {
  static const String _expressionReset =
      'Add something to calc like 3x10+19-27+33*100-109*3204 ;3';
  static const String _resultReset = 'Nothin\'';

  String _expression = _expressionReset; // Biểu thức tính toán
  String _result = _resultReset; // Kết quả hiện tại
  String _recentResult = _resultReset; // Kết quả gần đây

  // Getters
  String get expression => _expression;
  String get result => _result;
  String get recentResult => _recentResult;

  // Thêm số hoặc dấu thập phân
  void addDigit(String digit) {
    if (digit == '.' && _expression.contains('.')) {
      // Ngăn thêm dấu chấm nếu đã có
      return;
    }
    if (_expression == '0' && digit != '.') {
      // Thay số 0 ban đầu bằng số mới
      _expression = digit;
    } else {
      _expression += digit;
    }
  }

  // Thêm toán tử (+, -, *, /)
  void addOperator(String operator, String value) {
    if (_expression.isEmpty && operator != '-') {
      // Chỉ cho phép dấu trừ ở đầu
      return;
    }
    if (_expression.endsWith('+') ||
        _expression.endsWith('-') ||
        _expression.endsWith('*') ||
        _expression.endsWith('/')) {
      // Thay toán tử cuối nếu đã có toán tử
      _expression = _expression.substring(0, _expression.length - 1) + operator;
    } else {
      _expression += operator;
    }
  }

  // Xóa ký tự cuối cùng trong biểu thức
  void removeDigit() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
    }
    if (_expression.isEmpty) {
      _expression = '0';
    }
  }

  // Xóa toán tử cuối cùng
  void removeLastOperator() {
    if (_expression.isNotEmpty) {
      final lastChar = _expression[_expression.length - 1];
      if (lastChar == '+' ||
          lastChar == '-' ||
          lastChar == '*' ||
          lastChar == '/') {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    }
    if (_expression.isEmpty) {
      _expression = '0';
    }
  }

  // Xóa toàn bộ biểu thức và kết quả
  void clearAll() {
    _expression = '';
    _result = '';
    _recentResult = '';
  }

  // Tính toán kết quả từ biểu thức
  void calc() {
    try {
      // Lưu kết quả hiện tại vào recentResult
      _recentResult = _result;

      // Thay thế các ký hiệu toán học phù hợp
      String evalExpression = _expression
          .replaceAll('x', '*')
          .replaceAll('÷', '/');

      // Sử dụng ShuntingYardParser thay vì Parser
      ShuntingYardParser parser = ShuntingYardParser();
      Expression exp = parser.parse(evalExpression);
      ContextModel cm = ContextModel();
      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      // Cập nhật kết quả
      _result = evalResult.toString();
      if (_result.endsWith('.0')) {
        _result = _result.substring(0, _result.length - 2);
      }
    } catch (e) {
      _result = 'Error';
    }
  }

  // Add the recent result to the current expression
  void addANS() {
    bool isNumeric = _recentResult.runes.every((r) {
      var ch = String.fromCharCode(r);
      return ch == '.' ||
          (ch.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
              ch.codeUnitAt(0) <= '9'.codeUnitAt(0));
    });

    if (isNumeric) {
      _expression += '${_recentResult}!';
    } else {
      _expression += '0';
    }
  }

  // Add parentheses (open or close)
  void addBracket() {
    int openBrackets = _expression.split('(').length - 1;
    int closeBrackets = _expression.split(')').length - 1;

    if (openBrackets > closeBrackets) {
      // If there are more open brackets, add a closing one
      _expression += ')';
    } else {
      // Otherwise, add an opening bracket
      _expression += '(';
    }
  }
}
