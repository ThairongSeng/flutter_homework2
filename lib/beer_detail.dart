// To parse this JSON data, do
//
//     final beerDetail = beerDetailFromJson(jsonString);


class BeerDetail {
  int? id;
  String? name;
  String? tagline;
  String? firstBrewed;
  String? description;
  String? imageUrl;
  String? brewersTips;

  BeerDetail({
    required this.id,
    required this.name,
    required this.tagline,
    required this.firstBrewed,
    required this.description,
    required this.imageUrl,
    required this.brewersTips,
  });

  factory BeerDetail.fromJson(Map<String, dynamic> json) => BeerDetail(
    id: json["id"],
    name: json["name"],
    tagline: json["tagline"],
    firstBrewed: json["first_brewed"],
    description: json["description"],
    imageUrl: json["image_url"],
    brewersTips: json["brewers_tips"],
  );

}
