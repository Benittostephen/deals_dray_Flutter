class ApiResponse {
  final int status;
  final HomeData data;

  ApiResponse({required this.status, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      data: HomeData.fromJson(json['data']),
    );
  }
}

class HomeData {
  final List<Banner> bannerOne;
  final List<Category> categories;
  final List<Product> products;
  final List<Banner> bannerTwo;
  final List<Product> newArrivals;
  final List<Banner> bannerThree;
  final List<Product> categoriesListing;
  final List<Brand> topBrands;
  final List<Product> brandListing;
  final List<TopSellingProduct> topSellingProducts;
  final List<FeaturedLaptop> featuredLaptops;
  final List<UpcomingLaptop> upcomingLaptops;
  final List<Product> unboxedDeals;
  final List<Product> browsingHistory;

  HomeData({
    required this.bannerOne,
    required this.categories,
    required this.products,
    required this.bannerTwo,
    required this.newArrivals,
    required this.bannerThree,
    required this.categoriesListing,
    required this.topBrands,
    required this.brandListing,
    required this.topSellingProducts,
    required this.featuredLaptops,
    required this.upcomingLaptops,
    required this.unboxedDeals,
    required this.browsingHistory,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      bannerOne: (json['banner_one'] as List)
          .map((item) => Banner.fromJson(item))
          .toList(),
      categories: (json['category'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      bannerTwo: (json['banner_two'] as List)
          .map((item) => Banner.fromJson(item))
          .toList(),
      newArrivals: (json['new_arrivals'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      bannerThree: (json['banner_three'] as List)
          .map((item) => Banner.fromJson(item))
          .toList(),
      categoriesListing: (json['categories_listing'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      topBrands: (json['top_brands'] as List)
          .map((item) => Brand.fromJson(item))
          .toList(),
      brandListing: (json['brand_listing'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      topSellingProducts: (json['top_selling_products'] as List)
          .map((item) => TopSellingProduct.fromJson(item))
          .toList(),
      featuredLaptops: (json['featured_laptop'] as List)
          .map((item) => FeaturedLaptop.fromJson(item))
          .toList(),
      upcomingLaptops: (json['upcoming_laptops'] as List)
          .map((item) => UpcomingLaptop.fromJson(item))
          .toList(),
      unboxedDeals: (json['unboxed_deals'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      browsingHistory: (json['my_browsing_history'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

class Banner {
  final String banner;

  Banner({required this.banner});

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      banner: json['banner'],
    );
  }
}

class Category {
  final String label;
  final String icon;

  Category({required this.label, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      label: json['label'],
      icon: json['icon'],
    );
  }
}

class Product {
  final String icon;
  final String offer;
  final String label;
  final String? subLabel; // Nullable in case it doesn't exist

  Product(
      {required this.icon,
      required this.offer,
      required this.label,
      this.subLabel});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      icon: json['icon'],
      offer: json['offer'] ?? '', // Provide a default value
      label: json['label'],
      subLabel: json[
          'Sublabel'], // Check for the correct key (Sublabel is case-sensitive)
    );
  }
}

class Brand {
  final String icon;

  Brand({required this.icon});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      icon: json['icon'],
    );
  }
}

class TopSellingProduct {
  final String icon;
  final String label;

  TopSellingProduct({required this.icon, required this.label});

  factory TopSellingProduct.fromJson(Map<String, dynamic> json) {
    return TopSellingProduct(
      icon: json['icon'],
      label: json['label'],
    );
  }
}

class FeaturedLaptop {
  final String icon;
  final String brandIcon;
  final String label;
  final String price;

  FeaturedLaptop(
      {required this.icon,
      required this.brandIcon,
      required this.label,
      required this.price});

  factory FeaturedLaptop.fromJson(Map<String, dynamic> json) {
    return FeaturedLaptop(
      icon: json['icon'],
      brandIcon: json['brandIcon'],
      label: json['label'],
      price: json['price'],
    );
  }
}

class UpcomingLaptop {
  final String icon;

  UpcomingLaptop({required this.icon});

  factory UpcomingLaptop.fromJson(Map<String, dynamic> json) {
    return UpcomingLaptop(
      icon: json['icon'],
    );
  }
}
