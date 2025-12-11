import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_bloc.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_event.dart';
import 'package:movie_app/bloc/locale/profile_bloc/profile_state.dart';
import 'package:movie_app/utils/app_assets.dart';
import 'package:movie_app/utils/app_color.dart';
import 'package:movie_app/utils/app_route.dart';
import 'package:movie_app/utils/app_style.dart';

import '../../../api/auth_api.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> wishlistMovies = [];
  List<Map<String, dynamic>> historyMovies = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor.blackColor,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.yellow),
            );
          }

          if (state is ProfileLoaded ||
              state is ProfileUpdating ||
              state is ProfileUpdateSuccess) {
            final user = state is ProfileLoaded
                ? state.user
                : state is ProfileUpdating
                    ? state.currentUser
                    : (state as ProfileUpdateSuccess).user;

            final avatarPath = state is ProfileLoaded
                ? state.avatarPath
                : state is ProfileUpdating
                    ? state.currentAvatarPath
                    : (state as ProfileUpdateSuccess).avatarPath;

            return SafeArea(
              child: Column(
                children: [
                  _buildProfileHeader(height, width, user, avatarPath),
                  _buildTabBar(),
                  Expanded(child: _buildMoviesGrid()),
                ],
              ),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 100,
                      color: AppColor.yellow.withOpacity(0.5),
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      state.message,
                      style: AppStyle.bold20White,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.04),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.yellow,
                          foregroundColor: Colors.black,
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<ProfileBloc>().add(LoadProfileEvent());
                        },
                        icon: const Icon(Icons.refresh),
                        label:
                            const Text("Retry", style: AppStyle.reglur16black),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    if (state.message.contains('login') ||
                        state.message.contains('Login'))
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColor.yellow,
                            side: const BorderSide(color: AppColor.yellow),
                            padding:
                                EdgeInsets.symmetric(vertical: height * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              AppRoute.loginScreen,
                            );
                          },
                          icon: const Icon(Icons.login),
                          label: const Text("login",
                              style: AppStyle.reglur16yellow),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: AppColor.yellow),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
      double height, double width, dynamic user, String avatarPath) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.02,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: width * 0.3,
                    height: height * 0.14,
                    child: ClipOval(
                      child: Image.asset(
                        avatarPath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColor.grayColor,
                            child: const Icon(Icons.person,
                                size: 40, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  Text(
                    user?.name ?? 'User Name',
                    style: AppStyle.bold20White,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(
                      count: wishlistMovies.length.toString(),
                      label: "Wish_List",
                    ),
                    _buildStat(
                      count: historyMovies.length.toString(),
                      label: "History",
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, AppRoute.updateProfile);
                    if (mounted) {
                      context.read<ProfileBloc>().add(LoadProfileEvent());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.yellow,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.018,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child:
                      const Text('Edit Profile', style: AppStyle.reglur16black),
                ),
              ),
              SizedBox(width: width * 0.04),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await AuthMangerApi.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoute.loginScreen,
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                      vertical: height * 0.014,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Exit', style: AppStyle.reglur20white),
                      SizedBox(width: 4),
                      Icon(Icons.logout, size: 20, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({required String count, required String label}) {
    return Column(
      children: [
        Text(count, style: AppStyle.bold26White),
        const SizedBox(height: 4),
        Text(label, style: AppStyle.bold24White),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColor.yellow,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        labelStyle: AppStyle.reglur20white,
        dividerColor: AppColor.transparent,
        tabs: const [
          Tab(
            icon: Icon(Icons.list, size: 39, color: AppColor.yellow),
            text: "Watch List",
          ),
          Tab(
            icon: Icon(Icons.folder, size: 35, color: AppColor.yellow),
            text: "History",
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesGrid() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildMoviesList(wishlistMovies),
        _buildMoviesList(historyMovies),
      ],
    );
  }

  Widget _buildMoviesList(List<Map<String, dynamic>> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.popcorn),
            const SizedBox(height: 16),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return _buildMovieCard(movies[index]);
      },
    );
  }

  Widget _buildMovieCard(Map<String, dynamic> movie) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoute.movieDetailsScreen,
          arguments: movie['id'],
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.grayColor,
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.yellow.withOpacity(0.3),
                    AppColor.grayColor,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.movie_outlined,
                  size: 40,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie['rating'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.star, color: AppColor.yellow, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
