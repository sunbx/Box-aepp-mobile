import 'dart:convert';

import 'package:box/dao/urls.dart';
import 'package:box/model/account_info_model.dart';
import 'package:box/model/block_top_model.dart';
import 'package:box/model/contract_balance_model.dart';
import 'package:box/model/contract_info_model.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class ContractInfoDao {
  static Future<ContractInfoModel> fetch() async {
    Map<String, String> params = new Map();
    var address = await BoxApp.getAddress();
    params["address"] = address;
    Response response = await Dio().post(CONTRACT_INFO,queryParameters: params);
    if (response.statusCode == 200) {
      print(response.toString());
      var data = jsonDecode(response.toString());
      ContractInfoModel model = ContractInfoModel.fromJson(data);
      return model;
    } else {
      throw Exception('Failed to load ContractInfoModel.json');
    }
  }
}
