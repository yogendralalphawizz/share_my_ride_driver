class SettingModel {
  String? id;
  String? title;
  String? slug;
  String? html;
  String? createdAt;
  String? updatedAt;
  String? heading;
  String? img1;
  String? img2;
  String? img3;
  String? img4;
  String? url;

  SettingModel(
      {this.id,
        this.title,
        this.slug,
        this.html,
        this.createdAt,
        this.updatedAt,
        this.heading,
        this.img1,
        this.img2,
        this.img3,
        this.img4,
        this.url});

  SettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    html = json['html'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    heading = json['heading'];
    img1 = json['img_1'];
    img2 = json['img_2'];
    img3 = json['img_3'];
    img4 = json['img_4'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['html'] = this.html;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['heading'] = this.heading;
    data['img_1'] = this.img1;
    data['img_2'] = this.img2;
    data['img_3'] = this.img3;
    data['img_4'] = this.img4;
    data['url'] = this.url;
    return data;
  }
}
class FAQModel {
  String? id;
  String? title;
  String? description;

  FAQModel({this.id, this.title, this.description});

  FAQModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
