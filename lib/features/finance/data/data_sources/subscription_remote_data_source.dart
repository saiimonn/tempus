import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tempus/features/finance/data/models/subscription_model.dart';

class SubscriptionRemoteDataSource {
  final SupabaseClient _client;

  SubscriptionRemoteDataSource(this._client);

  String get _userId => _client.auth.currentUser!.id;

  Future<int> _getFinancesId() async {
    final row = await _client
        .from('finances')
        .select('id')
        .eq('user_id', _userId)
        .single();

    return row['id'] as int;
  }

  Future<List<SubscriptionModel>> getSubscriptions() async {
    final financesId = await _getFinancesId();

    final data = await _client
        .from('subscriptions')
        .select('id, title, monthly_price')
        .eq('finances_id', financesId)
        .eq('is_deleted', false)
        .order('created_at', ascending: true);

    return (data as List<dynamic>).map((row) {
      return SubscriptionModel.fromMap({
        'id': row['id'],
        'title': row['title'],
        'monthly_price': (row['monthly_price'] as num).toDouble(),
      });
    }).toList();
  }

  Future<SubscriptionModel> addSubscription({
    required String title,
    required double monthlyPrice,
  }) async {
    final financesId = await _getFinancesId();

    final data = await _client
        .from('subscriptions')
        .insert({
          'finances_id': financesId,
          'title': title,
          'monthly_price': monthlyPrice,
        })
        .select('id, title, monthly_price')
        .single();

    return SubscriptionModel.fromMap({
      'id': data['id'],
      'title': data['title'],
      'monthly_price': (data['monthly_price'] as num).toDouble(),
    });
  }

  Future<SubscriptionModel> updateSubscription({
    required int id,
    required String title,
    required double monthlyPrice,
  }) async {
    final data = await _client
        .from('subscriptions')
        .update({'title': title, 'monthly_price': monthlyPrice})
        .eq('id', id)
        .select('id, title, monthly_price')
        .single();

    return SubscriptionModel.fromMap({
      'id': data['id'],
      'title': data['title'],
      'monthly_price': (data['monthly_price'] as num).toDouble(),
    });
  }

  Future<void> deleteSubscription(int id) async {
    await _client
        .from('subscriptions')
        .update({'is_deleted': true})
        .eq('id', id);
  }
}
