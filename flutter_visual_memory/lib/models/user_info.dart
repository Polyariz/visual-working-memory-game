/// Класс для хранения информации о пользователе
/// Портировано из sign_up_page.py
class UserInfo {
  String name;
  String lastName;
  String mobile;
  String subjectNumber;
  String age;
  String gender;
  String eyeNumber;
  String astigmatism;

  UserInfo({
    this.name = '',
    this.lastName = '',
    this.mobile = '',
    this.subjectNumber = '',
    this.age = '',
    this.gender = '',
    this.eyeNumber = '',
    this.astigmatism = '',
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'last_name': lastName,
      'mobile': mobile,
      'sbjct_nmbr': subjectNumber,
      'age': age,
      'gender': gender,
      'eye_numbr': eyeNumber,
      'astigmatism': astigmatism,
    };
  }

  @override
  String toString() {
    return 'UserInfo(name: $name, lastName: $lastName, mobile: $mobile, '
        'subjectNumber: $subjectNumber, age: $age, gender: $gender, '
        'eyeNumber: $eyeNumber, astigmatism: $astigmatism)';
  }
}
