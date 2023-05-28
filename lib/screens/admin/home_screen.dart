import 'package:ecommerce_app/screens/admin/add_category/add_category.dart';
import 'package:ecommerce_app/screens/admin/add_product/add_new_product.dart';
import 'package:ecommerce_app/screens/admin/admin_home_screen/admin_home_screen.dart';
import 'package:ecommerce_app/screens/admin/home_dashboard/widgets/home_dashboard.dart';
import 'package:ecommerce_app/screens/admin/orders_screen/orders_page.dart';
import 'package:ecommerce_app/style/assets_manager.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  final _pageOptions = [
    const DashboardScreen(),
    const ProductsAdmin(),
    const AddProductWidget(),
    const AddCategoryWidget(),
    const OrdersPage(),
  ];
  final drawerWidth = 300.0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 820) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 232, 236, 237),
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Center(
                  child: Text(
                    "Style My Space",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                )),
            key: _scaffoldKey,
            body: Row(
              children: [
                SizedBox(
                  width: 220,
                  child: _buildDrawer(context),
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 300),
                    child: _pageOptions[_selectedIndex],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Center(
                  child: Text(
                    "Style My Space",
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                )),
            body: Row(
              children: [
                Expanded(child: _pageOptions[_selectedIndex]),
              ],
            ),
            key: _scaffoldKey,
            drawer: constraints.maxWidth < 820 ? _buildDrawer(context) : null,
            floatingActionButton: constraints.maxWidth < 820
                ? FloatingActionButton(
                    onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                    child: const Icon(Icons.menu),
                  )
                : null,
          );
        }
      },
    );
  }
// TODO: Dont use methods to build widgets, use classes instead 
  Widget _buildDrawer(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  ImageAssets.welcome,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () {
                _updatePage(0);
              },
              isSelected: _selectedIndex == 0),
          _createDrawerItem(
              icon: Icons.dashboard,
              text: 'Products',
              onTap: () {
                _updatePage(1);
              },
              isSelected: _selectedIndex == 1),
          _createDrawerItem(
              icon: Icons.add,
              text: 'Add Product',
              onTap: () {
                _updatePage(2);
              },
              isSelected: _selectedIndex == 2),
          _createDrawerItem(
              icon: Icons.category,
              text: 'Add Category',
              onTap: () {
                _updatePage(3);
              },
              isSelected: _selectedIndex == 3),
          _createDrawerItem(
              icon: Icons.shopping_cart,
              text: 'Orders',
              onTap: () {
                _updatePage(4);
              },
              isSelected: _selectedIndex == 4),
          MediaQuery.of(context).size.width < 820
              ? _createDrawerItem(
                  icon: Icons.arrow_back_ios,
                  text: 'back',
                  onTap: () {
                    Navigator.pop(context);
                  },
                  isSelected: _selectedIndex == 4)
              : Container(),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap,
      required bool isSelected}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text,
                style:
                    TextStyle(color: isSelected ? Colors.blue : Colors.grey)),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void _updatePage(int index) {
    if (MediaQuery.of(context).size.width <= 600) {
      Navigator.of(context).pop();
    }
    setState(() {
      _selectedIndex = index;
    });
  }
}
