
class ProfileInfo{
  String name;
  String email;
  int id;
  String image;
  String nic;

  ProfileInfo({required this.email,required this.name, required this.nic, required this.image, required this.id});

  Map<String,dynamic> toMap()
  {
    return {
      "name":name,
      "price":email,
      "id":id,
      "image":image,
      "nic":nic
    };
  }
}