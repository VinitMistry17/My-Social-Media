class AppUser{
  final String uid;
  final String email;
  final String name;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
  });

  //convert app user -> json
  //Firebase / APIs / local storage JSON format use karte hain data save karne ke liye.
  //To agar tum AppUser ko database me save karna chahte ho → pehle usse JSON banana padega.
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'name': name,
  };

  //convert json -> app user
  //Jab Firebase ya API se data fetch karte ho → vo JSON deta hai.
  // Par tumhare app me JSON ke saath kaam karna mushkil hai (kyunki json['uid'] likhna padta baar-baar).
  //Isiliye fromJson bana ke JSON ko wapas AppUser me convert karte hain.
  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
        uid: jsonUser['uid'],
        email: jsonUser['email'],
        name: jsonUser['name'],
    );
  }
}
