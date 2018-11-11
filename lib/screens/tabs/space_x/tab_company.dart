import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../models/rockets/spacex_company.dart';
import '../../../util/colors.dart';
import '../../../widgets/achievement_cell.dart';
import '../../../widgets/row_item.dart';

class SpacexCompanyTab extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<String> _popupItems = [
    'SpaceX website',
    'Twitter account',
    'Flickr page',
  ];

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SpacexCompanyModel>(
      builder: (context, child, model) => Scaffold(
            key: _scaffoldKey,
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  floating: false,
                  pinned: true,
                  actions: <Widget>[
                    PopupMenuButton<String>(
                      itemBuilder: (context) => _popupItems
                          .map((f) => PopupMenuItem(value: f, child: Text(f)))
                          .toList(),
                      onSelected: (option) => FlutterWebBrowser.openWebPage(
                            url: model
                                .company.links[_popupItems.indexOf(option)],
                            androidToolbarColor: primaryColor,
                          ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text('About ${model.company.name}'),
                    background: (model.isLoading)
                        ? NativeLoadingIndicator(center: true)
                        : Swiper(
                            itemCount: model.getPhotosCount,
                            itemBuilder: _buildImage,
                            autoplay: true,
                            autoplayDelay: 6000,
                            duration: 750,
                            onTap: (index) => FlutterWebBrowser.openWebPage(
                                  url: model.getPhoto(index),
                                  androidToolbarColor: primaryColor,
                                ),
                          ),
                  ),
                ),
                // TODO fix this
              ]..addAll(
                  (model.isLoading)
                      ? <Widget>[
                          SliverFillRemaining(
                            child: NativeLoadingIndicator(center: true),
                          )
                        ]
                      : <Widget>[
                          SliverToBoxAdapter(
                            child: _buildBody(),
                          ),
                          SliverList(
                            key: PageStorageKey('spacex'),
                            delegate: SliverChildBuilderDelegate(
                              _buildAchievement,
                              childCount: model.getSize,
                            ),
                          ),
                        ],
                ),
            ),
          ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<SpacexCompanyModel>(
      builder: (context, child, model) => Scrollbar(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        model.company.fullName,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Container(height: 8.0),
                      Text(
                        model.company.getFounderDate,
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: secondaryText),
                      ),
                      Container(height: 12.0),
                      RowItem.textRow('CEO', model.company.ceo),
                      Container(height: 12.0),
                      RowItem.textRow('CTO', model.company.cto),
                      Container(height: 12.0),
                      RowItem.textRow('COO', model.company.coo),
                      Container(height: 12.0),
                      RowItem.textRow('Valuation', model.company.getValuation),
                      Container(height: 12.0),
                      RowItem.textRow('Location', model.company.getLocation),
                      Container(height: 12.0),
                      RowItem.textRow('Employees', model.company.getEmployees),
                      Container(height: 12.0),
                      Text(
                        model.company.details,
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: secondaryText),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0.0),
              ],
            ),
          ),
    );
  }

  Widget _buildAchievement(BuildContext context, int index) {
    return ScopedModelDescendant<SpacexCompanyModel>(
      builder: (context, child, model) {
        final Achievement achievement = model.getItem(index);
        return Column(
          children: <Widget>[
            AchievementCell(
              title: achievement.name,
              subtitle: achievement.details,
              date: achievement.getDate,
              url: achievement.url,
              index: index + 1,
            ),
            const Divider(height: 0.0, indent: 82.0),
          ],
        );
      },
    );
  }

  Widget _buildImage(BuildContext context, int index) {
    return ScopedModelDescendant<SpacexCompanyModel>(
      builder: (context, child, model) => CachedNetworkImage(
            imageUrl: model.getPhoto(index),
            errorWidget: const Icon(Icons.error),
            fadeInDuration: Duration(milliseconds: 100),
            fit: BoxFit.cover,
          ),
    );
  }
}