class User{
  
  late String id;
  late String username;
  late String firstname;
  late String lastname;
  late String email;




  User();

  User.fromJson(Map<String, dynamic> json){
    id = json['id'].toString();
    username = json['username'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
  }


}//end of model class