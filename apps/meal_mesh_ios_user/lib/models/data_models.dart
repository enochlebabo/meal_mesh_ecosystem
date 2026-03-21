class RestaurantModel {
  final String id;
  final String name;
  final String address;
  final String image;
  final double rating;
  final String deliveryTime;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    this.rating = 0.0,
    this.deliveryTime = 'Calculating...',
  });
}

class FoodModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;

  FoodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}
