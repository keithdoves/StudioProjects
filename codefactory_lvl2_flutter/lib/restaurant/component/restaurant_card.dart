import 'package:codefactory_lvl2_flutter/common/const/colors.dart';
import 'package:flutter/material.dart';

import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  final Widget image;

  //레스토랑 이름
  final String name;

  //레스토랑 태그
  final List<String> tags;

  //평점 갯수
  final int ratingsCount;

  //배송걸리는 시간
  final int deliveryTime;

  //배송 비용
  final int deliveryFee;

  //평균 평점
  final double ratings;

  //상세 가트 여부
  final bool isDetail;

  //상세내용
  final String? detail;
  final String? heroKey;

  RestaurantCard(
      {required this.image,
      required this.name,
      required this.tags,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.ratings,
      this.isDetail = false,
      this.detail,
      this.heroKey,
      Key? key})
      : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model, //factory는 자식도 들어올 수 있음 DetailModel 가능
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(model.thumbUrl, fit: BoxFit.cover),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      heroKey: model.id,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          if (heroKey != null)
            Hero(
              tag: ObjectKey(heroKey),
              child: ClipRRect(
                //자식 위젯의 테두리를 깎아줌
                borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
                child: image,
              ),
            ),
        if(heroKey == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
            child: image,
          ),
        const SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16.0 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$name',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                tags.join(' · '),
                style: TextStyle(
                  color: BODY_TEXT_COLOR,
                  fontSize: 14.0,
                ), //리스트 텍스트 합치기
              ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '$deliveryTime분',
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label: deliveryFee == 0 ? '무료' : deliveryFee.toString(),
                  ),
                ],
              ),
              if (detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(detail!),
                ),
            ],
          ),
        ),
      ],
    );
  }

  renderDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: Text(
        '·',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconText({
    required this.icon,
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
