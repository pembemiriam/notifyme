
import 'package:notifytest/helpers/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test email valid returns true', () {
    /* 
      input: pembe@gmail.com
      expected: true
    */
    var email = 'pembe@gmail.com';
    var actual = Utils.isValidEmail(email);
    var expected = true;
    expect(actual, expected);
  });

}