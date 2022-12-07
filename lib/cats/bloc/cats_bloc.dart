import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cat_facts/constants/app_urls.dart';
import 'package:cat_facts/constants/app_values.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cat_facts/api_service/api_service.dart';

part 'cats_event.dart';

part 'cats_state.dart';

class CatsBloc extends Bloc<CatsEvent, CatsState> {
  CatsBloc() : super(CatsInitial()) {
    on<GetLastCat>(
      (event, emit) async {
        try {
          emit(CatsInitial());
          final box = await _openHiveBox();
          List<CatModel> cats = _getCatsFromBox(box);
          emit(CatsLoaded(cat: cats.isNotEmpty ? cats.last : null));
        } catch (e) {
          emit(CatsError(message: e.toString()));
        }
      },
    );

    on<GetRandomCat>(
      (event, emit) async {
        try {
          emit(CatsLoading());
          final box = await _openHiveBox();
          final imageRequest = await ApiClient(
            Dio(
              BaseOptions(contentType: 'application/json'),
            ),
            baseUrl: AppUrls.catImagesUrl,
          ).getCatImage();
          final factRequest = await ApiClient(
            Dio(
              BaseOptions(
                headers: {
                  'Accept': 'application/json',
                  'X-CSRF-TOKEN': AppValues.token,
                },
                contentType: 'application/json',
              ),
            ),
            baseUrl: AppUrls.catFactsUrl,
          ).getCatFacts();
          String date = await _getCatDate();
          CatModel cat =
              imageRequest.add(fact: factRequest.fact).add(date: date);
          List<CatModel> cats = _getCatsFromBox(box);
          cats.add(cat);
          await box.put(
            'cats',
            jsonEncode(
              cats.map((cat) => cat.toJson()).toList(),
            ),
          );
          emit(CatsLoaded(cat: cat));
        } catch (e) {
          emit(
            CatsError(
              message: e.toString(),
            ),
          );
        }
      },
    );

    on<GetCatsHistory>(
      (event, emit) async {
        try {
          emit(
            HistoryInitial(),
          );
          final box = await _openHiveBox();
          List<CatModel> cats = _getCatsFromBox(box);
          emit(
            CatsHistoryLoaded(cats: cats),
          );
        } catch (e) {
          emit(
            CatsError(
              message: e.toString(),
            ),
          );
        }
      },
    );
  }

  Future<Box> _openHiveBox() async {
    if (!kIsWeb && !Hive.isBoxOpen('animals')) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }
    return await Hive.openBox('animals');
  }

  List<CatModel> _getCatsFromBox(Box box) {
    return List.of(jsonDecode(box.get('cats') ?? '[]') ?? [])
        .map(
          (e) => CatModel.fromJson(e),
        )
        .toList();
  }

  Future<String> _getCatDate() async {
    String systemLocale = await findSystemLocale();
    return DateFormat.yMMMMd(systemLocale).format(
      DateTime.now(),
    );
  }
}
