import 'package:deals_dray/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:deals_dray/const/const.dart';
import 'data/fetch_data.dart';
import 'model/api.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        elevation: 2.0,
        shadowColor: Colors.black,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/menu.png',
            width: width * 0.08,
          ),
          onPressed: () {},
        ),
        automaticallyImplyLeading: false,
        title: Container(
          height: height * 0.05,
          child: TextFormField(
            // controller: controller,
            decoration: InputDecoration(
                filled: true,
                fillColor: primaryColor.withOpacity(0.2),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Container(
                    margin: EdgeInsets.all(5),
                    width: width * 0.09,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        //  fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  size: width * 0.08,
                  color: Colors.grey.shade600,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  //borderSide: BorderSide.none,
                ),
                hintText: 'Search here',
                hintStyle:
                    TextStyle(fontSize: width * 0.045, color: primaryColor),
                labelStyle: TextStyle(
                  color: Colors.grey.shade700,
                )),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, size: width * 0.07),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<ApiResponse>(
        future: fetchHomeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CustomPaint(
                size: Size(50, 50), // Size of the circular loader
                painter: CircleLoaderPainter(controller: _controller),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.data.products.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final homeData = snapshot.data!.data;

            return ListView(
              children: [
                // Display Banners horizontally
                SizedBox(
                  height: height * 0.23, // Adjust height as needed
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: homeData.bannerOne.map((banner) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 15),
                        child: Image.network(
                          banner.banner,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFF8388f0), Color(0xFFF5156cb)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue[100],
                    ),
                    padding: EdgeInsets.all(width * 0.03),
                    child: Column(
                      children: [
                        Text(
                          'KYC Pending',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'You need to provide the required \ndocuments for your account activation.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.037),
                        ),
                        SizedBox(height: 8),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Click Here',
                            style: TextStyle(
                                fontSize: width * 0.05,
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decorationColor: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.14,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: homeData.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              category.icon,
                              width: width * 0.2,
                              height: height * 0.08,
                            ),
                            Text(category.label),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Display Products horizontally

                Container(
                  height: height * 0.28, // Adjust height as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/back.jpg'),
                      // Background image
                      fit: BoxFit.cover,
                    ),
                  ), // Adjust height as needed
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('EXCLUSIVE FOR YOU',
                                style: TextStyle(
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Image.asset(
                              'assets/icons/next.png',
                              color: Colors.white,
                              height: height * 0.03,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: homeData.products.map((product) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            product.icon,
                                            width: width * 0.35,
                                            height: height * 0.1,
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            child: Text(
                                              '${product.offer} Off',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 20),
                                      child: Text(
                                        product.label,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
      /*SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.network(
                'https://via.placeholder.com/300x100.png?text=Redmi+Note+7S'),
            Container(
              color: Colors.blue[100],
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'KYC Pending',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You need to provide the required documents for your account activation.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: Text('Click Here'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategoryIcon(icon: Icons.phone_android, label: 'Mobile'),
                  CategoryIcon(icon: Icons.laptop, label: 'Laptop'),
                  CategoryIcon(icon: Icons.camera_alt, label: 'Camera'),
                  CategoryIcon(icon: Icons.tv, label: 'LED'),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('EXCLUSIVE FOR YOU',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ExclusiveItem(
                        imageUrl:
                            'https://via.placeholder.com/100x200.png?text=Phone+1',
                        discount: '32% Off',
                      ),
                      ExclusiveItem(
                        imageUrl:
                            'https://via.placeholder.com/100x200.png?text=Phone+2',
                        discount: '14% Off',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),*/
      bottomNavigationBar: BottomAppBar(
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem('assets/icons/home.png', 'Home', 0),
            _buildNavItem('assets/icons/category.png', 'Categories', 1),
            _buildNavItem('assets/icons/logo.png', 'Deals', 2),
            _buildNavItem('assets/icons/shopping-cart.png', 'Cart', 3),
            _buildNavItem('assets/icons/user.png', 'Profile', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            color: isSelected ? secondaryColor : Colors.grey,
            scale: (label == 'Deals') ? 10 : 16,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? secondaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  CategoryIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Icon(icon, size: 30),
        ),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

class ExclusiveItem extends StatelessWidget {
  final String imageUrl;
  final String discount;

  ExclusiveItem({required this.imageUrl, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image.network(imageUrl, width: 100, height: 200, fit: BoxFit.cover),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                color: Colors.green,
                padding: EdgeInsets.all(4),
                child: Text(
                  discount,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
