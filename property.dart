import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import './../models/property_model.dart';
import 'package:box_by_box/config.dart' as config;

class PropertyProvider with ChangeNotifier {
  PropertyProvider(this.token);
  List<PropertyModel> saleProperties = [];
  List<PropertyModel> rentProperties = [];
  List<PropertyModel> myListingsSale = [];
  List<PropertyModel> myListingsRent = [];
  List<PropertyModel> allproperties = [];

  String token;
  // PropertyModel propertyToUpload;

  Future<void> uploadProperty(PropertyModel property) async {
    var data;

    data = jsonEncode({
      "address": {
        "city": property.city,
        "country": property.country,
        "houseNoAddress": property.houseNoAddress,
        "lga": property.lga,
        "postCode": property.postCode,
        "state": property.state,
        "longitude": property.longitude,
        "latitude": property.latitude
      },
      "bathrooms": property.bathrooms,
      "bedrooms": property.bedrooms,
      "canBidFor": true,
      "condition": property.condition,
      "description": property.description,
      "documentsAvailable": "CFO",
      "feature": property.feature,
      "images": [
        {"imageUrl": "hjhjhjhjhjhjhjhjhjhjhj"}
      ],
      "parkingLot": true,
      "price": property.price,
      "size": property.size,
      "title": property.title,
      "toilet": property.toilet,
      "type": property.type,
      "units": property.units
    });

    try {
      final response = await http.post(
        "${config.baseUrl}/auth/properties",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data,
      );
      var resData = jsonDecode(response.body);

      print(resData);
      if (resData["status"] != "ACTIVE") {
        throw HttpException(resData["message"]);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchSaleProperty() async {
    try {
      saleProperties = [];
      final response = await http.get(
        "${config.baseUrl}/properties?limit=20&page=0&saleOrRent=SALE&status=ACTIVE",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      var resData = jsonDecode(response.body);
      if (resData["total"] > 0) {
        List<dynamic> entities = resData["entities"];
        entities.forEach((entity) {
          PropertyModel property = PropertyModel();

          property.propertyId = entity["id"];
          property.title = entity["title"];
          property.description = entity["description"];
          property.type = entity["type"];
          property.feature = entity["feature"];
          property.price = entity["price"];
          property.documentsAvailable = entity["documentsAvailable"];
          property.units = entity["units"];
          property.bedrooms = entity["bedrooms"];
          property.bathrooms = entity["bathrooms"];
          property.toilet = entity["toilet"];
          property.parkingLot = entity["parkingLot"];
          property.size = entity["size"];
          property.condition = entity["condition"];
          property.houseNoAddress = entity["address"]["houseNoAddress"];
          property.postCode = entity["address"]["postCode"];
          property.city = entity["address"]["city"];
          property.state = entity["address"]["state"];
          property.lga = entity["address"]["lga"];
          property.longitude = entity["address"]["longitude"];
          property.latitude = entity["address"]["latitude"];
          property.country = entity["address"]["country"];
          property.agentId = entity["createdBy"]["id"];
          property.agentEmail = entity["createdBy"]["email"];
          property.agentPhone = entity["createdBy"]["phone"];

          saleProperties.add(property);
        });
      }

      // print(resData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchRentProperty() async {
    try {
      rentProperties = [];
      final response = await http.get(
        "${config.baseUrl}/properties?limit=20&page=0&saleOrRent=RENT&status=ACTIVE",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      var resData = jsonDecode(response.body);
      if (resData["total"] > 0) {
        List<dynamic> entities = resData["entities"];
        entities.forEach((entity) {
          PropertyModel property = PropertyModel();

          property.propertyId = entity["id"];
          property.title = entity["title"];
          property.description = entity["description"];
          property.type = entity["type"];
          property.feature = entity["feature"];
          property.price = entity["price"];
          property.documentsAvailable = entity["documentsAvailable"];
          property.units = entity["units"];
          property.bedrooms = entity["bedrooms"];
          property.bathrooms = entity["bathrooms"];
          property.toilet = entity["toilet"];
          property.parkingLot = entity["parkingLot"];
          property.size = entity["size"];
          property.condition = entity["condition"];
          property.houseNoAddress = entity["address"]["houseNoAddress"];
          property.postCode = entity["address"]["postCode"];
          property.city = entity["address"]["city"];
          property.state = entity["address"]["state"];
          property.lga = entity["address"]["lga"];
          property.country = entity["address"]["country"];
          property.longitude = entity["address"]["longitude"];
          property.latitude = entity["address"]["latitude"];
          property.agentId = entity["createdBy"]["id"];
          property.agentEmail = entity["createdBy"]["email"];
          property.agentPhone = entity["createdBy"]["phone"];
          rentProperties.add(property);
        });
      }

      //print(resData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchMyListingsSale() async {
    try {
      myListingsSale = [];
      final response = await http.get(
        "${config.baseUrl}/auth/users/properties?authenticated=true&credentials=%7B%7D&details=%7B%7D&limit=10&page=0&principal=%7B%7D&saleOrRent=SALE&status=ACTIVE",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      var resData = jsonDecode(response.body);
      if (resData["total"] > 0) {
        List<dynamic> entities = resData["entities"];
        entities.forEach((entity) {
          PropertyModel property = PropertyModel();

          property.propertyId = entity["id"];
          property.title = entity["title"];
          property.description = entity["description"];
          property.type = entity["type"];
          property.feature = entity["feature"];
          property.price = entity["price"];
          property.documentsAvailable = entity["documentsAvailable"];
          property.units = entity["units"];
          property.bedrooms = entity["bedrooms"];
          property.bathrooms = entity["bathrooms"];
          property.toilet = entity["toilet"];
          property.parkingLot = entity["parkingLot"];
          property.size = entity["size"];
          property.condition = entity["condition"];
          property.houseNoAddress = entity["address"]["houseNoAddress"];
          property.postCode = entity["address"]["postCode"];
          property.city = entity["address"]["city"];
          property.state = entity["address"]["state"];
          property.lga = entity["address"]["lga"];
          property.country = entity["address"]["country"];
          property.longitude = entity["address"]["longitude"];
          property.latitude = entity["address"]["latitude"];
          property.agentId = entity["createdBy"]["id"];
          property.agentEmail = entity["createdBy"]["email"];
          property.agentPhone = entity["createdBy"]["phone"];
          myListingsSale.add(property);
        });
      }

      print(resData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchMyListingsRent() async {
    try {
      myListingsRent = [];
      final response = await http.get(
        "${config.baseUrl}/auth/users/properties?authenticated=true&credentials=%7B%7D&details=%7B%7D&limit=10&page=0&principal=%7B%7D&saleOrRent=RENT&status=ACTIVE",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      var resData = jsonDecode(response.body);
      if (resData["total"] > 0) {
        List<dynamic> entities = resData["entities"];
        entities.forEach((entity) {
          PropertyModel property = PropertyModel();

          property.propertyId = entity["id"];
          property.title = entity["title"];
          property.description = entity["description"];
          property.type = entity["type"];
          property.feature = entity["feature"];
          property.price = entity["price"];
          property.documentsAvailable = entity["documentsAvailable"];
          property.units = entity["units"];
          property.bedrooms = entity["bedrooms"];
          property.bathrooms = entity["bathrooms"];
          property.toilet = entity["toilet"];
          property.parkingLot = entity["parkingLot"];
          property.size = entity["size"];
          property.condition = entity["condition"];
          property.houseNoAddress = entity["address"]["houseNoAddress"];
          property.postCode = entity["address"]["postCode"];
          property.city = entity["address"]["city"];
          property.state = entity["address"]["state"];
          property.lga = entity["address"]["lga"];
          property.country = entity["address"]["country"];
          property.longitude = entity["address"]["longitude"];
          property.latitude = entity["address"]["latitude"];
          property.agentId = entity["createdBy"]["id"];
          property.agentEmail = entity["createdBy"]["email"];
          property.agentPhone = entity["createdBy"]["phone"];

          myListingsRent.add(property);
        });
      }

      print(resData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchallproperty() async {
    try {
      allproperties = [];
      final response = await http.get(
        "${config.baseUrl}/properties?&page=0&limit=20",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      var resData = jsonDecode(response.body);
      if (resData["total"] > 0) {
        List<dynamic> entities = resData["entities"];
        entities.forEach((entity) {
          PropertyModel property = PropertyModel();
          property.propertyId = entity["id"];
          property.title = entity["title"];
          property.description = entity["description"];
          property.type = entity["type"];
          property.feature = entity["feature"];
          property.price = entity["price"];
          property.documentsAvailable = entity["documentsAvailable"];
          property.units = entity["units"];
          property.bedrooms = entity["bedrooms"];
          property.bathrooms = entity["bathrooms"];
          property.toilet = entity["toilet"];
          property.parkingLot = entity["parkingLot"];
          property.size = entity["size"];
          property.condition = entity["condition"];
          property.houseNoAddress = entity["address"]["houseNoAddress"];
          property.postCode = entity["address"]["postCode"];
          property.city = entity["address"]["city"];
          property.state = entity["address"]["state"];
          property.lga = entity["address"]["lga"];
          property.country = entity["address"]["country"];
          property.longitude = entity["address"]["longitude"];
          property.latitude = entity["address"]["latitude"];
          property.agentId = entity["createdBy"]["id"];
          property.agentEmail = entity["createdBy"]["email"];
          property.agentPhone = entity["createdBy"]["phone"];
          allproperties.add(property);
        });
      }

      //print(resData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
