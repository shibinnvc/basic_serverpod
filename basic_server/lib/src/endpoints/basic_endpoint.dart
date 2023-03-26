import 'package:basic_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class BasicEndPoints extends Endpoint {
  //Fetch article from DB
  Future<List<Article>> getArticles(Session session, {String? keyword}) async {
    return await Article.find(
      session,
      where: (t) =>
          keyword != null ? t.title.like('%$keyword%') : Constant(true),
    );
  }

  //Add article in DB
  Future<bool> addArticle(Session session, Article article) async {
    await Article.insert(session, article);
    return true;
  }

//Edit article in DB
  Future<bool> editArticle(Session session, Article article) async {
    await Article.update(
      session,
      article,
    );
    return true;
  }

//Delete article in DB
  Future<bool> deleteArticle(Session session, int id) async {
    var result = await Article.delete(
      session,
      where: (t) => t.id.equals(id),
    );
    return result == 1;
  }

//Fetch whether info
  Future<WhetherInfo> getWhetherInfo(Session session, int cityId) async {
    var weatherKey = 'whether-$cityId';
    var whetherInfo =
        await session.caches.local.get(weatherKey) as WhetherInfo?;
    if (whetherInfo == null) {
      //!Log analytical data
      session.log('city-$cityId', level: LogLevel.info);
      //API call to fetch data
      await Future.delayed(Duration(seconds: 1));
      //Parsing response to model
      whetherInfo = WhetherInfo(temperature: 24);
      //Saving the data in cache
      session.caches.local
          .put(weatherKey, whetherInfo, lifetime: Duration(minutes: 10));
    }
    return whetherInfo;
  }
}
