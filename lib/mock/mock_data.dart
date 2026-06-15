import 'package:flutter/material.dart';
import '../models/product.dart';
import '../features/orders/models/order_return_replace_request.dart';
import '../models/category.dart';
import '../models/user.dart';
import '../models/address.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../core/constants/app_colors.dart';

class MockData {
  static List<String> topCategories = [
    'Women', 'Men', 'Kids', 'Home', 'All Brands', 'More',
  ];

  static List<Category> categories = [
    const Category(
      id: 'cat_ww',
      name: 'Westernwear',
      icon: Icons.checkroom,
      color: AppColors.categoryWomen,
      productCount: 120,
      gender: 'women',
    ),
    const Category(
      id: 'cat_iw',
      name: 'Indianwear',
      icon: Icons.diamond,
      color: AppColors.categoryWomen,
      productCount: 85,
      gender: 'women',
    ),
    const Category(
      id: 'cat_mw',
      name: 'Men',
      icon: Icons.man,
      color: AppColors.categoryMen,
      productCount: 95,
      gender: 'men',
    ),
    const Category(
      id: 'cat_kd',
      name: 'Kids',
      icon: Icons.child_care,
      color: AppColors.categoryKids,
      productCount: 60,
      gender: 'kids',
    ),
    const Category(
      id: 'cat_fw',
      name: 'Footwear',
      icon: Icons.directions_run,
      color: AppColors.categoryFootwear,
      productCount: 110,
      gender: 'unisex',
    ),
    const Category(
      id: 'cat_ln',
      name: 'Lingerie',
      icon: Icons.weekend,
      color: AppColors.categoryWomen,
      productCount: 45,
      gender: 'women',
    ),
    const Category(
      id: 'cat_bg',
      name: 'Bags',
      icon: Icons.shopping_bag,
      color: AppColors.categoryAccessories,
      productCount: 70,
      gender: 'women',
    ),
    const Category(
      id: 'cat_aw',
      name: 'Activewear',
      icon: Icons.fitness_center,
      color: AppColors.categoryFootwear,
      productCount: 55,
      gender: 'unisex',
    ),
    const Category(
      id: 'cat_jw',
      name: 'Jewellery',
      icon: Icons.star,
      color: AppColors.categoryWomen,
      productCount: 65,
      gender: 'women',
    ),
    const Category(
      id: 'cat_sn',
      name: 'Sneakers',
      icon: Icons.directions_walk,
      color: AppColors.categoryFootwear,
      productCount: 80,
      gender: 'unisex',
    ),
    const Category(
      id: 'cat_hm',
      name: 'Home',
      icon: Icons.home,
      color: AppColors.categoryHome,
      productCount: 40,
      gender: 'unisex',
    ),
    const Category(
      id: 'cat_sg',
      name: 'Sunglasses',
      icon: Icons.wb_sunny,
      color: AppColors.categoryAccessories,
      productCount: 35,
      gender: 'unisex',
    ),
    const Category(
      id: 'cat_wt',
      name: 'Watches',
      icon: Icons.watch,
      color: AppColors.categoryAccessories,
      productCount: 50,
      gender: 'unisex',
    ),
  ];

  static List<Map<String, dynamic>> brands = [
    {'name': 'Forever New', 'offer': 'Up to 50% off', 'tag': 'Stylish & elegant dresses', 'imageUrl': 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=300'},
    {'name': 'Twenty Dresses', 'offer': 'Up to 70% off', 'tag': 'Chic dresses & tops', 'imageUrl': 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=300'},
    {'name': 'Libas', 'offer': 'Min 30% off', 'tag': 'Stylish ethnicwear', 'imageUrl': 'https://images.unsplash.com/photo-1583391733956-6c78276477e3?w=300'},
    {'name': 'Puma', 'offer': 'Min 40% off', 'tag': 'Bestselling activewear', 'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=300'},
    {'name': 'Cider', 'offer': 'Up to 60% off', 'tag': 'Trendiest global styles', 'imageUrl': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=300'},
    {'name': 'Autumnlane', 'offer': 'Up to 25% off', 'tag': 'Chic printed co-ords', 'imageUrl': 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=300'},
    {'name': 'U.S. Polo Assn.', 'offer': 'Up to 50% off', 'tag': 'Comfort-first styles', 'imageUrl': 'https://images.unsplash.com/photo-1593030761757-71fae45fa0e7?w=300'},
    {'name': 'The Souled Store', 'offer': 'Min 30% off', 'tag': 'Cool casuals', 'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=300'},
    {'name': 'P.S. Peaches', 'offer': 'Min 50% off', 'tag': 'Cute ethnics & casuals', 'imageUrl': 'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=300'},
    {'name': 'Pure Home + Living', 'offer': 'Up to 30% off', 'tag': 'Aesthetic home decor', 'imageUrl': 'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=300'},
  ];

  static List<Map<String, String>> trendingPicks = [
    {'title': 'Floral Dresses', 'imageUrl': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=300'},
    {'title': 'Rectangular Sunglasses', 'imageUrl': 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=300'},
    {'title': 'T-Shirt Bras', 'imageUrl': 'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=300'},
    {'title': 'Baggy Jeans', 'imageUrl': 'https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?w=300'},
    {'title': 'Ethnic Co-ords', 'imageUrl': 'https://images.unsplash.com/photo-1583391733956-6c78276477e3?w=300'},
    {'title': 'Trendiest Shoes', 'imageUrl': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=300'},
    {'title': 'Cotton Kurtas', 'imageUrl': 'https://images.unsplash.com/photo-1617127365659-c47c8643ef44?w=300'},
    {'title': 'Shoulder Bags', 'imageUrl': 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=300'},
    {'title': 'Block Heels', 'imageUrl': 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=300'},
    {'title': 'Jewellery Sets', 'imageUrl': 'https://images.unsplash.com/photo-1635767798638-3e25273a8236?w=300'},
  ];

  static List<Map<String, String>> luxeItems = [
    {'title': 'Luxe Dresses', 'subtitle': 'Premium designer wear', 'imageUrl': 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=300'},
    {'title': 'Designer Bags', 'subtitle': 'Statement accessories', 'imageUrl': 'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?w=300'},
    {'title': 'Luxe Watches', 'subtitle': 'Timeless elegance', 'imageUrl': 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=300'},
    {'title': 'Premium Ethnic', 'subtitle': 'Designer lehengas', 'imageUrl': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=300'},
  ];

  static List<Product> products = [
    const Product(
      id: 'p1',
      title: 'Printed Floral Maxi Dress',
      description: 'Beautiful floral print maxi dress with a flattering fit. Perfect for summer outings and beach vacations.',
      brand: 'Forever New',
      category: 'Women',
      categoryId: 'cat_ww',
      price: 2499,
      originalPrice: 4999,
      discountPercentage: 50,
      rating: 4.5,
      reviewCount: 128,
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['Blue Floral', 'Pink Floral', 'Yellow Floral'],
      isFeatured: true,
      isNew: false,
      badge: 'Best Seller',
      stock: 150,
      imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
    ),
    const Product(
      id: 'p2',
      title: 'Embroidered Kurta Set',
      description: 'Traditional embroidered kurta with churidar and dupatta set. Handcrafted with delicate thread work.',
      brand: 'Libas',
      category: 'Women',
      categoryId: 'cat_iw',
      price: 1899,
      originalPrice: 3499,
      discountPercentage: 46,
      rating: 4.7,
      reviewCount: 215,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Pink', 'Green', 'Blue', 'Yellow'],
      isFeatured: true,
      isNew: false,
      badge: 'Festival Special',
      stock: 80,
      imageUrl: 'https://images.unsplash.com/photo-1583391733956-6c78276477e3?w=400',
    ),
    const Product(
      id: 'p3',
      title: 'Classic Fit Blazer',
      description: 'Modern slim fit blazer crafted from premium wool blend. Perfect for formal occasions.',
      brand: 'U.S. Polo Assn.',
      category: 'Men',
      categoryId: 'cat_mw',
      price: 3999,
      originalPrice: 6999,
      discountPercentage: 43,
      rating: 4.6,
      reviewCount: 89,
      sizes: ['M', 'L', 'XL', 'XXL'],
      colors: ['Charcoal', 'Navy', 'Black'],
      isFeatured: true,
      isNew: true,
      badge: 'New',
      stock: 45,
      imageUrl: 'https://images.unsplash.com/photo-1593030761757-71fae45fa0e7?w=400',
    ),
    const Product(
      id: 'p4',
      title: 'Leather Tote Bag',
      description: 'Premium leather tote bag with gold-toned hardware. Spacious interior with multiple compartments.',
      brand: 'Luxe Carry',
      category: 'Accessories',
      categoryId: 'cat_bg',
      price: 2999,
      originalPrice: 5499,
      discountPercentage: 45,
      rating: 4.8,
      reviewCount: 156,
      sizes: ['One Size'],
      colors: ['Tan', 'Black', 'Burgundy'],
      isFeatured: true,
      isNew: false,
      badge: 'Trending',
      stock: 25,
      imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400',
    ),
    const Product(
      id: 'p5',
      title: 'Denim Jacket',
      description: 'Classic denim jacket with a modern twist. Features distressed details and comfortable fit.',
      brand: 'U.S. Polo Assn.',
      category: 'Men',
      categoryId: 'cat_mw',
      price: 2499,
      originalPrice: 3999,
      discountPercentage: 38,
      rating: 4.4,
      reviewCount: 94,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Light Wash', 'Dark Wash', 'Black'],
      isFeatured: true,
      isNew: true,
      badge: 'New',
      stock: 60,
      imageUrl: 'https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?w=400',
    ),
    const Product(
      id: 'p6',
      title: 'High-Waist Yoga Leggings',
      description: 'High-waist compression leggings with moisture-wicking technology. Perfect for workouts and casual wear.',
      brand: 'Puma',
      category: 'Women',
      categoryId: 'cat_aw',
      price: 1799,
      originalPrice: 2999,
      discountPercentage: 40,
      rating: 4.7,
      reviewCount: 312,
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['Black', 'Navy', 'Burgundy', 'Teal'],
      isFeatured: true,
      isNew: false,
      badge: 'Best Seller',
      stock: 200,
      imageUrl: 'https://images.unsplash.com/photo-1506629082955-511b1aa562c8?w=400',
    ),
    const Product(
      id: 'p7',
      title: 'Printed Dinosaur T-Shirt',
      description: 'Fun dinosaur print t-shirt for kids. Made from soft, hypoallergenic cotton material.',
      brand: 'P.S. Peaches',
      category: 'Kids',
      categoryId: 'cat_kd',
      price: 599,
      originalPrice: 999,
      discountPercentage: 40,
      rating: 4.3,
      reviewCount: 67,
      sizes: ['2-3Y', '3-4Y', '5-6Y', '7-8Y'],
      colors: ['Blue', 'Pink', 'Green'],
      isFeatured: false,
      isNew: true,
      badge: 'New',
      stock: 120,
      imageUrl: 'https://images.unsplash.com/photo-1622290291468-a28f7a7dc6a8?w=400',
    ),
    const Product(
      id: 'p8',
      title: 'White Leather Sneakers',
      description: 'Premium leather sneakers with cushioned sole for all-day comfort. Versatile style for any outfit.',
      brand: 'Puma',
      category: 'Footwear',
      categoryId: 'cat_fw',
      price: 3999,
      originalPrice: 6999,
      discountPercentage: 43,
      rating: 4.6,
      reviewCount: 178,
      sizes: ['7', '8', '9', '10', '11', '12'],
      colors: ['White', 'Black', 'Tan'],
      isFeatured: true,
      isNew: false,
      badge: 'Trending',
      stock: 90,
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
    ),
    const Product(
      id: 'p9',
      title: 'Silk Evening Gown',
      description: 'Elegant floor-length evening gown in pure silk with delicate embroidery. Perfect for special occasions.',
      brand: 'Twenty Dresses',
      category: 'Women',
      categoryId: 'cat_ww',
      price: 7999,
      originalPrice: 12999,
      discountPercentage: 38,
      rating: 4.9,
      reviewCount: 42,
      sizes: ['XS', 'S', 'M', 'L'],
      colors: ['Midnight Blue', 'Burgundy', 'Emerald'],
      isFeatured: true,
      isNew: false,
      badge: 'Premium',
      stock: 15,
      imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=400',
    ),
    const Product(
      id: 'p10',
      title: 'Cotton Hoodie',
      description: 'Comfortable cotton hoodie with kangaroo pocket. Perfect for casual everyday wear.',
      brand: 'The Souled Store',
      category: 'Men',
      categoryId: 'cat_mw',
      price: 1499,
      originalPrice: 2499,
      discountPercentage: 40,
      rating: 4.5,
      reviewCount: 73,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Gray', 'Navy', 'Burgundy', 'Forest Green'],
      isFeatured: false,
      isNew: false,
      badge: 'Comfort Pick',
      stock: 35,
      imageUrl: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=400',
    ),
    const Product(
      id: 'p11',
      title: 'Raincoat Set with Boots',
      description: 'Waterproof raincoat with matching boots. Features fun animal print design kids love.',
      brand: 'P.S. Peaches',
      category: 'Kids',
      categoryId: 'cat_kd',
      price: 1299,
      originalPrice: 1999,
      discountPercentage: 35,
      rating: 4.4,
      reviewCount: 55,
      sizes: ['2-3Y', '3-4Y', '5-6Y'],
      colors: ['Yellow', 'Red', 'Blue'],
      isFeatured: false,
      isNew: false,
      badge: 'Sale',
      stock: 40,
      imageUrl: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=400',
    ),
    const Product(
      id: 'p12',
      title: 'Gold Plated Hoop Earrings',
      description: 'Stunning 18K gold-plated hoop earrings with a polished finish. Lightweight and elegant.',
      brand: 'Accessorize London',
      category: 'Accessories',
      categoryId: 'cat_jw',
      price: 899,
      originalPrice: 1499,
      discountPercentage: 40,
      rating: 4.7,
      reviewCount: 203,
      sizes: ['Small', 'Medium', 'Large'],
      colors: ['Gold', 'Silver', 'Rose Gold'],
      isFeatured: true,
      isNew: false,
      badge: 'Best Seller',
      stock: 150,
      imageUrl: 'https://images.unsplash.com/photo-1635767798638-3e25273a8236?w=400',
    ),
    const Product(
      id: 'p13',
      title: 'Running Shoes',
      description: 'Lightweight running shoes with responsive cushioning and breathable mesh upper.',
      brand: 'Puma',
      category: 'Footwear',
      categoryId: 'cat_fw',
      price: 4999,
      originalPrice: 7999,
      discountPercentage: 38,
      rating: 4.6,
      reviewCount: 245,
      sizes: ['7', '8', '9', '10', '11', '12', '13'],
      colors: ['Black/White', 'Blue/Neon', 'Red/Black'],
      isFeatured: true,
      isNew: true,
      badge: 'Performance',
      stock: 75,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    ),
    const Product(
      id: 'p14',
      title: 'Printed Co-Ord Set',
      description: 'Trendy printed co-ord set with top and matching bottom. Perfect for parties and events.',
      brand: 'Autumnlane',
      category: 'Women',
      categoryId: 'cat_ww',
      price: 2199,
      originalPrice: 3499,
      discountPercentage: 37,
      rating: 4.8,
      reviewCount: 167,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Pink', 'Green', 'Blue', 'Yellow'],
      isFeatured: true,
      isNew: true,
      badge: 'Trending',
      stock: 55,
      imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=400',
    ),
    const Product(
      id: 'p15',
      title: 'Designer Scarf',
      description: 'Handwoven designer scarf with traditional patterns. Made from premium quality fabric.',
      brand: 'Accessorize London',
      category: 'Accessories',
      categoryId: 'cat_sg',
      price: 999,
      originalPrice: 1799,
      discountPercentage: 44,
      rating: 4.3,
      reviewCount: 88,
      sizes: ['One Size'],
      colors: ['Red', 'Gray', 'Navy', 'Mustard'],
      isFeatured: false,
      isNew: false,
      badge: 'Winter Wear',
      stock: 100,
      imageUrl: 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=400',
    ),
    const Product(
      id: 'p16',
      title: 'Cargo Joggers',
      description: 'Comfortable cargo joggers with multiple pockets. Made from stretch cotton blend fabric.',
      brand: 'The Souled Store',
      category: 'Men',
      categoryId: 'cat_mw',
      price: 1499,
      originalPrice: 2499,
      discountPercentage: 40,
      rating: 4.4,
      reviewCount: 134,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      colors: ['Black', 'Olive', 'Gray', 'Navy'],
      isFeatured: false,
      isNew: true,
      badge: 'Trending',
      stock: 110,
      imageUrl: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=400',
    ),
    const Product(
      id: 'p17',
      title: 'Cotton Saree',
      description: 'Handloom cotton saree with traditional border design. Comfortable and elegant for daily wear.',
      brand: 'Libas',
      category: 'Women',
      categoryId: 'cat_iw',
      price: 1599,
      originalPrice: 2999,
      discountPercentage: 47,
      rating: 4.6,
      reviewCount: 198,
      sizes: ['Free Size'],
      colors: ['Red', 'Green', 'Blue', 'Yellow'],
      isFeatured: true,
      isNew: false,
      badge: 'Popular',
      stock: 65,
      imageUrl: 'https://images.unsplash.com/photo-1617127365659-c47c8643ef44?w=400',
    ),
    const Product(
      id: 'p18',
      title: 'Sports Bra',
      description: 'High-support sports bra with moisture-wicking fabric. Perfect for workouts and running.',
      brand: 'Puma',
      category: 'Women',
      categoryId: 'cat_aw',
      price: 1299,
      originalPrice: 1999,
      discountPercentage: 35,
      rating: 4.5,
      reviewCount: 276,
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['Black', 'White', 'Gray'],
      isFeatured: false,
      isNew: false,
      badge: 'Active',
      stock: 180,
      imageUrl: 'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=400',
    ),
    const Product(
      id: 'p19',
      title: 'A-line Skirt',
      description: 'Floral print A-line skirt with elastic waistband. Comfortable and stylish for everyday wear.',
      brand: 'Forever New',
      category: 'Women',
      categoryId: 'cat_ww',
      price: 1799,
      originalPrice: 2999,
      discountPercentage: 40,
      rating: 4.4,
      reviewCount: 92,
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['Blue', 'Pink', 'White'],
      isFeatured: false,
      isNew: true,
      badge: 'New',
      stock: 85,
      imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=400',
    ),
    const Product(
      id: 'p20',
      title: 'Leather Belt',
      description: 'Premium genuine leather belt with brushed metal buckle. Classic design for any wardrobe.',
      brand: 'U.S. Polo Assn.',
      category: 'Accessories',
      categoryId: 'cat_sg',
      price: 999,
      originalPrice: 1799,
      discountPercentage: 44,
      rating: 4.3,
      reviewCount: 145,
      sizes: ['28', '30', '32', '34', '36', '38'],
      colors: ['Black', 'Brown'],
      isFeatured: false,
      isNew: false,
      badge: 'Essential',
      stock: 200,
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
    ),
  ];

  static List<Product> get featuredProducts =>
      products.where((p) => p.isFeatured).toList();

  static List<Product> get newProducts =>
      products.where((p) => p.isNew).toList();

  static List<Product> getProductsByCategory(String categoryId) =>
      products.where((p) => p.categoryId == categoryId).toList();

  static List<Product> getProductsByBrand(String brandName) =>
      products.where((p) => p.brand == brandName).toList();

  static List<Product> searchProducts(String query) {
    final q = query.toLowerCase();
    return products
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();
  }

  static const User currentUser = User(
    id: 'u1',
    fullName: 'Priya Sharma',
    email: 'priya.sharma@email.com',
    phone: '+91 98765 43210',
    walletBalance: 250.00,
    referralCode: 'PRIYA250',
    isVerified: true,
    role: 'customer',
  );

  static User? currentLoggedInUser;

  static final Map<String, String> _otpStore = {};

  static void sendOtp(String email) {
    _otpStore[email.toLowerCase()] = '123456';
  }

  static bool verifyOtp(String email, String otp) {
    final key = email.toLowerCase();
    final stored = _otpStore[key];
    if (stored == null) return false;
    final isValid = stored == otp;
    if (isValid) _otpStore.remove(key);
    return isValid;
  }

  static List<Address> addresses = [
    const Address(
      id: 'addr1',
      fullName: 'Priya Sharma',
      phone: '+91 98765 43210',
      street: '42, MG Road, Indiranagar',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560038',
      isDefault: true,
      type: 'Home',
    ),
    const Address(
      id: 'addr2',
      fullName: 'Priya Sharma',
      phone: '+91 98765 43210',
      street: 'Suite 501, Tech Park, Whitefield',
      city: 'Bengaluru',
      state: 'Karnataka',
      pincode: '560066',
      isDefault: false,
      type: 'Work',
    ),
  ];

  static List<CartItem> cartItems = [
    CartItem(
      id: 'ci1',
      product: products[0],
      quantity: 2,
      selectedSize: 'M',
      selectedColor: 'Blue Floral',
    ),
    CartItem(
      id: 'ci2',
      product: products[5],
      quantity: 1,
      selectedSize: 'S',
      selectedColor: 'Black',
    ),
    CartItem(
      id: 'ci3',
      product: products[11],
      quantity: 1,
      selectedSize: 'Medium',
      selectedColor: 'Gold',
    ),
  ];

  static int _cartIdCounter = 4;

  static void addToCart(Product product,
      {required int quantity,
      required String selectedSize,
      required String selectedColor}) {
    final existingIndex = cartItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == selectedSize &&
          item.selectedColor == selectedColor,
    );
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity += quantity;
    } else {
      cartItems.add(CartItem(
        id: 'ci${_cartIdCounter++}',
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ));
    }
  }

  static List<Order> orders = [
    Order(
      id: 'ord1',
      orderNumber: 'ORD-2026-001',
      items: [
        OrderItem(
          id: 'oi1',
          product: products[0],
          quantity: 2,
          price: 2499,
          size: 'M',
          color: 'Blue Floral',
        ),
        OrderItem(
          id: 'oi2',
          product: products[5],
          quantity: 1,
          price: 1799,
          size: 'S',
          color: 'Black',
        ),
      ],
      subtotal: 6797,
      shipping: 0,
      discount: 1000,
      gst: 869.64,
      total: 6666.64,
      status: OrderStatus.outForDelivery,
      address: addresses[0],
      paymentMethod: 'UPI (Google Pay)',
      createdAt: DateTime(2026, 5, 24),
      estimatedDelivery: DateTime(2026, 5, 28),
      trackingId: 'TRK12847003',
    ),
    Order(
      id: 'ord2',
      orderNumber: 'ORD-2026-002',
      items: [
        OrderItem(
          id: 'oi3',
          product: products[3],
          quantity: 1,
          price: 2999,
          size: 'One Size',
          color: 'Tan',
        ),
      ],
      subtotal: 2999,
      shipping: 0,
      discount: 0,
      gst: 389.87,
      total: 3388.87,
      status: OrderStatus.processing,
      address: addresses[1],
      paymentMethod: 'Credit Card',
      createdAt: DateTime(2026, 5, 25),
      estimatedDelivery: DateTime(2026, 5, 30),
    ),
    Order(
      id: 'ord3',
      orderNumber: 'ORD-2026-003',
      items: [
        OrderItem(
          id: 'oi4',
          product: products[8],
          quantity: 1,
          price: 7999,
          size: 'M',
          color: 'Midnight Blue',
        ),
        OrderItem(
          id: 'oi5',
          product: products[11],
          quantity: 1,
          price: 899,
          size: 'Medium',
          color: 'Gold',
        ),
      ],
      subtotal: 8898,
      shipping: 0,
      discount: 500,
      gst: 1091.74,
      total: 9489.74,
      status: OrderStatus.delivered,
      address: addresses[0],
      paymentMethod: 'Cash on Delivery',
      createdAt: DateTime(2026, 5, 20),
      estimatedDelivery: DateTime(2026, 5, 25),
      returnReplaceRequests: [
        OrderReturnReplaceRequest(
          id: 'rr1',
          type: ReturnReplaceType.returnRequest,
          status: ReturnReplaceStatus.submitted,
          items: [
            const OrderReturnReplaceRequestItem(
              orderItemId: 'oi4',
              quantity: 1,
            ),
          ],
          reason: 'Item arrived damaged',
          createdAt: DateTime(2026, 5, 26),
        ),
      ],
    ),
    Order(
      id: 'ord4',
      orderNumber: 'ORD-2026-004',
      items: [
        OrderItem(
          id: 'oi6',
          product: products[13],
          quantity: 2,
          price: 2199,
          size: 'M',
          color: 'Pink',
        ),
      ],
      subtotal: 4398,
      shipping: 0,
      discount: 500,
      gst: 506.74,
      total: 4404.74,
      status: OrderStatus.placed,
      address: addresses[0],
      paymentMethod: 'UPI (PhonePe)',
      createdAt: DateTime(2026, 5, 26),
      estimatedDelivery: DateTime(2026, 5, 31),
      trackingId: 'TRK12847089',
    ),
  ];

  static List<String> bannerImages = [
    'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
    'https://images.unsplash.com/photo-1445205170230-053b83016050',
    'https://images.unsplash.com/photo-1469334031218-e382a71b716b',
  ];

  static List<Map<String, String>> banners = [
    {
      'title': 'Summer Collection',
      'subtitle': 'Up to 50% Off on Summer Styles',
      'tag': 'Trending Now',
      'bgImage': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=600',
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Spring 2026 Fresh Styles',
      'tag': 'Fresh Drops',
      'bgImage': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=600',
    },
    {
      'title': 'Festival Edit',
      'subtitle': 'Ethnic Wear Collection',
      'tag': 'Limited Time Offer',
      'bgImage': 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=600',
    },
  ];

  static List<String> availableSizes = [
    'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL'
  ];

  static List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Google Pay',
      'icon': Icons.g_mobiledata,
      'isPopular': true,
    },
    {
      'name': 'PhonePe',
      'icon': Icons.phone_android,
      'isPopular': true,
    },
    {
      'name': 'Paytm',
      'icon': Icons.account_balance_wallet,
      'isPopular': true,
    },
    {
      'name': 'Credit Card',
      'icon': Icons.credit_card,
      'isPopular': false,
    },
    {
      'name': 'Debit Card',
      'icon': Icons.credit_card_outlined,
      'isPopular': false,
    },
    {
      'name': 'Net Banking',
      'icon': Icons.account_balance,
      'isPopular': false,
    },
    {
      'name': 'Cash on Delivery',
      'icon': Icons.money,
      'isPopular': false,
    },
  ];

  static List<Map<String, dynamic>> profileOptions = [
    {'title': 'My Orders', 'icon': Icons.receipt_long, 'count': ''},
    {'title': 'Wishlist', 'icon': Icons.favorite_outline, 'count': ''},
    {'title': 'Rewards', 'icon': Icons.card_giftcard, 'count': ''},
    {'title': 'Payments', 'icon': Icons.payment_outlined, 'count': ''},
    {'title': 'Manage Account', 'icon': Icons.person_outline, 'count': ''},
    {'title': 'Help', 'icon': Icons.headset_mic, 'count': ''},
    {'title': 'Legal & Policies', 'icon': Icons.description_outlined, 'count': ''},
  ];

  static final Set<String> wishlistedIds = {'p1', 'p3', 'p8', 'p12'};

  static void toggleWishlist(String productId) {
    if (wishlistedIds.contains(productId)) {
      wishlistedIds.remove(productId);
    } else {
      wishlistedIds.add(productId);
    }
  }

  static int get wishlistCount => wishlistedIds.length;

  static List<Map<String, String>> blogPosts = [
    {
      'title': 'How to Style Your Summer Wardrobe for Maximum Comfort',
      'author': 'Garment',
      'category': 'Lifestyle',
      'imageUrl': 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=600',
    },
    {
      'title': '10 Essential Accessories Every Fashionista Needs This Season',
      'author': 'Garment',
      'category': 'Fashion Tips',
      'imageUrl': 'https://images.unsplash.com/photo-1490114538077-0a7f8cb49891?w=600',
    },
    {
      'title': 'Sustainable Fashion: How to Build an Eco-Friendly Closet',
      'author': 'Garment',
      'category': 'Sustainability',
      'imageUrl': 'https://images.unsplash.com/photo-1479064312651-24524fb55c0e?w=600',
    },
  ];
}
