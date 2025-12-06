import 'package:flutter/material.dart';
import 'package:movie_app/api/api_manger.dart';
import 'package:movie_app/api/api_model/movies_response.dart';
import 'package:movie_app/ui/home_tab/movies_item/movies_item.dart';
import 'package:movie_app/utils/app_assets.dart';
import 'package:movie_app/utils/app_color.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();
  List<Movies> results = [];
  bool isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() => results = []);
      return;
    }

    setState(() => isLoading = true);

    final data = await ApiManager.searchMovies(query);

    setState(() {
      results = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.blackColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TextField(
                  controller: _controller,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    prefixIcon: Image.asset(
                      AppAssets.searchTop,
                    ),
                    hintText: "Search",
                    hintStyle: const TextStyle(color: AppColor.whiteColor),
                    filled: true,
                    fillColor: AppColor.grayColor,
                  ),
                ),
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: AppColor.yellow,
                ),
              ),
            Expanded(
              child: _controller.text.isEmpty
                  ? Center(
                      child: Image.asset(
                        AppAssets.popcorn,
                        width: 200,
                      ),
                    )
                  : results.isEmpty
                      ? const Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            return MoviesItem(movie: results[index]);
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}
