import 'package:snest/api/api.dart';
import 'package:snest/models/response/posts_response.dart';
import 'package:snest/models/request/pagination_request.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final ApiRepository apiRepository;
  DashboardController({required this.apiRepository});
  var loading = false.obs;
  var posts = Rxn<List<Post>>();
  var postCount = 0.obs;
  var isOver = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> getPosts({bool isRefresh = false}) async {
    if (isRefresh == false && isOver.value == true) return;
    try {
      loading.value = true;
      int offset = 0;
      if (isRefresh) {
        offset = 0;
        posts.value!.clear();
        postCount.value = 0;
      } else {
        offset = posts.value!.length;
      }
      final res = await apiRepository.getPosts(
        PaginationRequest(
          offset: offset,
          limit: 5,
        ),
      );
      print(res);
    } catch (err) {
    } finally {
      loading.value = false;
    }
    // var _users = await apiRepository.getUsers();
    // if (_users!.data!.length > 0) {
    //   users.value = _users;
    //   users.refresh();
    //   _saveUserInfo(_users);
    // }
  }
}
