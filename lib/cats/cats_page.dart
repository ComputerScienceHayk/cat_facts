import 'package:cat_facts/constants/app_values.dart';
import 'package:cat_facts/routes/route_name.dart';
import 'package:cat_facts/utils/show_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_facts/res/colors.dart';
import 'package:cat_facts/common_widgets/custom_circular_progress.dart';
import 'package:cat_facts/common_widgets/cutom_button.dart';
import 'package:cat_facts/main.dart';
import 'package:cat_facts/cats/bloc/cats_bloc.dart';

class CatsPage extends StatefulWidget {
  const CatsPage({super.key});

  @override
  State<CatsPage> createState() => _CatsPageState();
}

class _CatsPageState extends State<CatsPage> {
  final CatsBloc _catsBloc = CatsBloc();
  final Duration _defaultDuration = const Duration(seconds: 1);
  final Duration _halfDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _catsBloc.add(GetLastCat());
  }

  void _findCat() {
    _catsBloc.add(GetRandomCat());
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
      elevation: 0,
      centerTitle: true,
      title: Text(
        AppValues.catFacts,
        style: StyleText.blackText(22, FontWeight.w700),
      ),
      actions: [
        CustomButton(
          onTap: () => Navigator.of(context).pushNamed(RouteName.history),
          height: size.width * .15,
          width: size.width * .15,
          borderRadius: size.width * .5,
          alignment: MainAxisAlignment.center,
          tooltip: AppValues.factHistory,
          leading: const Icon(
            Icons.history,
            color: black,
            size: 26,
          ),
        ),
      ],
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
          }
        },
        child: BlocBuilder(
          bloc: _catsBloc,
          builder: (context, CatsState state) {
            return state is CatsInitial
                ? const CustomCircularProgress()
                : Stack(
                    children: [
                      Positioned.fill(
                        bottom: size.height * .15,
                        child: AnimatedOpacity(
                          opacity: state is CatsLoaded ? 1 : 0,
                          duration: _halfDuration,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (state is CatsLoaded &&
                                  state.cat?.image != null)
                                _catImage(state, state.cat!.image!),
                              if (state is CatsLoaded &&
                                  state.cat?.fact != null)
                                _catFact(state),
                            ],
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        top: state is CatsLoaded &&
                                    state.cat?.fact != null &&
                                    state.cat?.image != null ||
                                state is CatsLoading
                            ? size.height * .73
                            : size.height * .4,
                        left: size.width * .3,
                        duration: _defaultDuration,
                        curve: Curves.fastOutSlowIn,
                        child: CustomButton(
                          onTap: _findCat,
                          height: size.height * .07,
                          width: size.width * .4,
                          tooltip: AppValues.noCats,
                          text: state is CatsLoaded &&
                                  state.cat?.fact != null &&
                                  state.cat?.image != null
                              ? AppValues.noCats
                              : AppValues.findCat,
                          isLoading: state is CatsLoading,
                          borderColor: black,
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _catImage(CatsState state, String url) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
              minWidth: 0,
              maxWidth: size.width * .7,
              minHeight: 0,
              maxHeight: size.width * .7,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * .05),
            boxShadow: CustomShadow.defaultShadow(),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size.width * .05),
            child: Image.network(
              'https://cataas.com$url',
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : CustomCircularProgress(
                          strokeWidth: 3,
                          color: black,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _catFact(CatsLoaded state) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * .1,
      ).copyWith(
        top: size.height * .03,
      ),
      child: Column(
        children: [
          Text(
            AppValues.randomFact,
            style: StyleText.blackText(
              16,
              FontWeight.w400,
              underline: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: size.height * .02,
            ),
            child: Text(
              state.cat!.fact!,
              style: StyleText.blackText(
                16,
                FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            state.cat!.date!,
            style: StyleText.blackText(
              14,
              FontWeight.w200,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
