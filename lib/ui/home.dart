import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:space_news/ui/app/app_drawer.dart';

import '../models/nasa/nasa_image.dart';
import 'general/call_error.dart';
import 'general/list_cell.dart';
import 'general/photo_card.dart';
import 'general/separator.dart';


class HomeScreen extends StatelessWidget {
  static final Map<String, String> _menu = {
    'home.menu.about': '/about',
    'home.menu.settings': '/settings'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          FlutterI18n.translate(context, 'app.title'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (_) => _menu.keys
                .map((string) => PopupMenuItem(
                      value: string,
                      child: Text(
                        FlutterI18n.translate(context, string),
                      ),
                    ))
                .toList(),
            onSelected: (string) => Navigator.pushNamed(context, _menu[string]),
          ),
        ],
        centerTitle: true,
      ),
      body: ContentPage(),
      drawer: AppDrawer(),
    );
  }

  openPage(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }
}

class ContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ScopedModel<NasaImagesModel>(
              model: NasaImagesModel()..loadData(),
              child: _buildNasaImage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNasaImage() {
    return ScopedModelDescendant<NasaImagesModel>(
      builder: (context, child, model) => model.isLoading
          ? NativeLoadingIndicator(center: true)
          : model.items == null || model.items.isEmpty
              ? CallError(() => model.loadData())
              : Swiper(
                  itemBuilder: (_, index) => PhotoCard(model.getItem(index)),
                  scrollDirection: Axis.vertical,
                  itemCount: model?.getItemCount ?? 0,
                  autoplay: true,
                  autoplayDelay: 6000,
                  duration: 750,
                  itemWidth: MediaQuery.of(context).size.width,
                  itemHeight: MediaQuery.of(context).size.height * 0.7,
                  layout: SwiperLayout.STACK,
                ),
    );
  }
}
