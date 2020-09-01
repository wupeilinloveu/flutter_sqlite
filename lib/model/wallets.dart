class Wallets {
  String id;
  String name;
  String walletAddress;

  Wallets({this.id, this.name, this.walletAddress});

  Wallets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    walletAddress = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.walletAddress;
    return data;
  }

}
