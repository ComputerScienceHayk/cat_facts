import 'package:cat_facts/constants/app_values.dart';
import 'package:cat_facts/utils/show_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_facts/cats/cats_history/history_item.dart';
import 'package:cat_facts/main.dart';
import 'package:cat_facts/res/colors.dart';
import 'package:cat_facts/common_widgets/custom_circular_progress.dart';
import 'package:cat_facts/common_widgets/cutom_button.dart';
import 'package:cat_facts/cats/bloc/cats_bloc.dart';

class CatsHistory extends StatefulWidget {
  const CatsHistory({super.key});

  @override
  State<CatsHistory> createState() => _CatsHistoryState();
}

class _CatsHistoryState extends State<CatsHistory> {
  final CatsBloc _catsBloc = CatsBloc();

  @override
  void initState() {
    super.initState();
    _catsBloc.add(GetCatsHistory());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: white,
      appBar: _appBar(),
      body: _buildBody(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: white,
      leading: CustomButton(
        onTap: () => Navigator.pop(context),
        height: size.width * .15,
        width: size.width * .15,
        borderRadius: size.width * .5,
        alignment: MainAxisAlignment.center,
        tooltip:  AppValues.back,
        leading: const Icon(Icons.arrow_back_ios_new, color: black, size: 26),
      ),
      elevation: 0,
      centerTitle: true,
      title: Text(
        AppValues.factHistory,
        style: StyleText.blackText(
          22,
          FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (_) => _catsBloc,
      child: BlocListener(
        bloc: _catsBloc,
        listener: (context, CatsState state) {
          if (state is CatsError) {
            showError(state.message);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder(
          bloc: _catsBloc,
          builder: (context, CatsState state) {
            return state is HistoryInitial
                ? const CustomCircularProgress()
                : state is CatsHistoryLoaded &&
                        (state.cats?.isNotEmpty ?? false)
                    ? Scrollbar(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * .04,
                          ).copyWith(
                            bottom: size.height * .03,
                          ),
                          itemCount: state.cats?.length ?? 0,
                          itemBuilder: (context, i) => HistoryItem(
                            cat: state.cats![i],
                          ),
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(color: grey, height: 1.5),
                        ),
                      )
                    : Center(
                        child: Text(
                          AppValues.nothingThere,
                          style: StyleText.blackText(
                            16,
                            FontWeight.w300,
                          ),
                        ),
                      );
          },
        ),
      ),
    );
  }
}
