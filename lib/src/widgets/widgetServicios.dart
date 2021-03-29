import 'package:bufi_empresas/src/models/subsidiaryService.dart';
import 'package:bufi_empresas/src/utils/constants.dart';
import 'package:bufi_empresas/src/utils/responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget serviceWidget(BuildContext context, SubsidiaryServiceModel serviceData,
    Responsive responsive) {
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.symmetric(
          horizontal: responsive.wp(1), vertical: responsive.hp(.5)),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 2), // changes position of shadow
        ),
      ], borderRadius: BorderRadius.circular(8), color: Colors.white),
      width: responsive.wp(42.5),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: responsive.hp(18),
            child: Stack(
              children: <Widget>[
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Image(
                          image: AssetImage('assets/jar-loading.gif'),
                          fit: BoxFit.cover),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageUrl:
                          '$apiBaseURL/${serviceData.subsidiaryServiceImage}',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            serviceData.subsidiaryServiceName,
            style: TextStyle(
                fontSize: responsive.ip(1.5), color: Color(0XFFb1bdef)),
          ),
          Text(
              '${serviceData.subsidiaryServiceCurrency} ${serviceData.subsidiaryServicePrice}',
              style: TextStyle(
                  fontSize: responsive.ip(1.9),
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          Text(
            serviceData.subsidiaryServiceDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(1.5),
                color: Colors.red),
          ),
        ],
      ),
    ),
    onTap: () {},
  );
}