enum UserType {
  freelancer,
  recruiter;
}

extension UserTypeExtension on UserType{
  String get name{
    switch(this){
      case UserType.freelancer:
        return 'Freelancer';
      case UserType.recruiter:
        return 'Recruiter';
    }
  }
}