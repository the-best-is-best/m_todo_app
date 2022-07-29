import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_todo_app/app/cubit/app_cubit.dart';
import 'package:m_todo_app/app/extension/context_extension.dart';
import 'package:m_todo_app/app/resources/font_manager.dart';
import 'package:m_todo_app/app/resources/styles_manger.dart';
import 'package:m_todo_app/presentation/schedule/view/schedule_view.dart';
import 'package:m_todo_app/presentation/search/view/search_view.dart';

import '../../../../main.dart';
import '../../../../services/admob_services.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TabController controller;
  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.strings().homeTitle),
      actions: [
        SizedBox(
            width: .1.sw,
            child: IconButton(
                onPressed: () {
                  context.push(const SearchView());
                },
                icon: Icon(
                  Icons.search,
                  size: FontSize.s24,
                ))),
        SizedBox(
            width: .1.sw,
            child: IconButton(
                onPressed: () {
                  context.push(const ScheduleView());
                },
                icon: Icon(
                  Icons.calendar_today,
                  size: FontSize.s24,
                ))),
        SizedBox(
            width: .1.sw,
            child: IconButton(
                onPressed: () async {
                  final box = GetStorage();

                  String currentLang = box.read('lang');
                  if (currentLang == "en") {
                    await box.write('lang', 'ar');
                    language = "ar";
                  } else {
                    await box.write('lang', 'en');
                    language = "en";
                  }
                  AppCubit appCubit = AppCubit.get(context);
                  appCubit.hideAd();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Phoenix.rebirth(context);
                  });
                },
                icon: const Icon(Icons.language))),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Column(
          children: [
            const Divider(),
            TabBar(
              controller: widget.controller,
              isScrollable: true,
              labelColor: Colors.black,
              labelStyle: getRegularStyle(color: Colors.black),
              unselectedLabelStyle: getLightStyle(),
              indicatorColor: Colors.black,
              tabs: [
                Tab(child: Text(context.strings().all)),
                Tab(child: Text(context.strings().completed)),
                Tab(child: Text(context.strings().unCompleted)),
                Tab(child: Text(context.strings().favorite)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
