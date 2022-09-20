import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistants/requestAssistant.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/Models/directDetails.dart';
import 'package:rider_app/configMaps.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rider_app/main.dart';

class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(Uri.parse(url));

    if(response != 'failed')
    {
      //placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][4]["long_name"];
      st2 = response["results"][0]["address_components"][7]["long_name"];
      st3 = response["results"][0]["address_components"][6]["long_name"];
      st4 = response["results"][0]["address_components"][9]["long_name"];
      placeAddress = "$st1, $st2, $st3, $st4";

      Address userPickUpAddress = Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;
      
      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }


    return placeAddress;
  }
  static Future<DirectionDetails?> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async {
    Uri directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey" as Uri;
    
    var res = await RequestAssistant.getRequest(directionUrl);

    if(res == "failed"){
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails(distanceValue: 0, distanceText: '',durationValue: 0, durationText: '',encodedPoints: '');

    directionDetails.encodedPoints = res['routes'][0]["overview_polyline"]["points"];
    directionDetails.distanceText = res['routes'][0]["legs"][0]["distance"]['text'];
    directionDetails.distanceValue = res['routes'][0]["legs"][0]["distance"]['value'];

    directionDetails.durationText = res['routes'][0]["legs"][0]["duration"]['text'];
    directionDetails.durationValue = res['routes'][0]["legs"][0]["duration"]['value'];

    return directionDetails;




  }






}