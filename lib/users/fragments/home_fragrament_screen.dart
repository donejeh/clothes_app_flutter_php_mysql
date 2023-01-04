import 'package:flutter/material.dart';

class HomeFragmentScreen extends StatelessWidget {

  final TextEditingController searchController = TextEditingController();

  HomeFragmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          //search bar widget
          showSearchBarWidget(),
          const SizedBox(height: 16,),
          //tending-popular items
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Trending",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),

          const SizedBox(height: 16,),
          //all new Colloection Items
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "New Collcections",
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          )
        ],
      ),
    );
  }


  showSearchBarWidget(){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){

            },
            icon: const Icon(
              Icons.search,
              color: Colors.purpleAccent,
            ),
          ),
          hintText: "Search best clothes here....",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: (){

            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.purpleAccent,
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.purpleAccent,
            )
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.purpleAccent,
              )
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Colors.green,
              )
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10
          ),
          //filled: true,
          //fillColor: Colors.grey
        ),
      ),
    );
  }
}
