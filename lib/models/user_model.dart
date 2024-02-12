
class UserModel {
  String? name, email, password, profileImageUri, lastMessage, bio,userId;
  UserModel(
      {this.name,
      this.email,
      this.password,
      this.profileImageUri,
      this.lastMessage,
      this.bio,
      this.userId});

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      profileImageUri: map['profileImageUri'],
      lastMessage: map['lastMessage'],
      bio: map['bio'],
    );
  }
  
}
