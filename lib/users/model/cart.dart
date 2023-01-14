class Cart{
  //from cart table
  int? cart_id;
  int? user_id;
  int? item_id;
  int? quantity;
  String? color;
  String? size;

  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String? image;

  Cart({
    this.cart_id,
    this.user_id,
    this.item_id,
    this.quantity,
    this.color,
    this.size,
    this.name,
    this.rating,
    this.tags,
    this.price,
    this.sizes,
    this.colors,
    this.description,
    this.image,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    cart_id: int.parse(json['cart_id']),
    item_id: int.parse(json['item_id']),
    user_id: int.parse(json['user_id']),
    quantity: int.parse(json['quantity']),
    color: json['color'],
    size: json['size'],
    name: json['name'],
    rating: double.parse(json['rating']),
    tags: json['tags'].toString().split(', '),
    price: double.parse(json['price']),
    sizes: json['sizes'].toString().split(', '),
    colors: json['colors'].toString().split(', '),
    description: json['description'],
    image: json['image'],

  );
}

