import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

class _Apis {
  static const String catImage = '/cat?json=true';
  static const String catFact = '/fact';
}

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {required String baseUrl}) = _ApiClient;

  @GET(_Apis.catImage)
  Future<CatModel> getCatImage();

  @GET(_Apis.catFact)
  Future<CatModel> getCatFacts();
}

@JsonSerializable()
class CatModel {
  @JsonKey(name: 'url')
  final String? image;
  @JsonKey(name: 'fact')
  final String? fact;
  @JsonKey(name: 'date')
  final String? date;

  const CatModel({this.image, this.fact, this.date});

  factory CatModel.fromJson(Map<String, dynamic> json) =>
      _$CatModelFromJson(json);

  Map<String, dynamic> toJson() => _$CatModelToJson(this);

  CatModel add({String? image, String? fact, String? date}) {
    return CatModel(
        image: image ?? this.image,
        fact: fact ?? this.fact,
        date: date ?? this.date,
    );
  }
}
