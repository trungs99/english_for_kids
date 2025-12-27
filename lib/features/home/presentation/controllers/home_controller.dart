import 'package:english_for_kids/features/learning/domain/entities/topic_entity.dart';
import 'package:english_for_kids/features/learning/domain/usecases/get_topics_usecase.dart';
import 'package:exo_shared/exo_shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends BaseController {
  final GetTopicsUseCase _getTopicsUseCase;

  HomeController({GetTopicsUseCase? getTopicsUseCase})
    : _getTopicsUseCase = getTopicsUseCase ?? Get.find<GetTopicsUseCase>();

  final RxList<TopicEntity> topics = <TopicEntity>[].obs;
  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;

  @override
  Future<void> initData() async {
    await loadTopics();
    _setupPageListener();
  }

  void _setupPageListener() {
    pageController.addListener(() {
      if (pageController.hasClients) {
        final page = pageController.page?.round() ?? 0;
        if (currentPageIndex.value != page) {
          currentPageIndex.value = page;
        }
      }
    });
  }

  Future<void> loadTopics() async {
    // Use mock data for now
    topics.assignAll(_getMockTopics());

    // Uncomment below to use real data from database
    // try {
    //   final fetchedTopics = await _getTopicsUseCase.call();
    //   if (fetchedTopics.isEmpty) {
    //     topics.assignAll(_getMockTopics());
    //   } else {
    //     topics.assignAll(fetchedTopics);
    //   }
    // } catch (e) {
    //   LoggerUtil.error('Failed to load topics', e);
    //   topics.assignAll(_getMockTopics());
    // }
  }

  List<TopicEntity> _getMockTopics() {
    return [
      TopicEntity(
        id: 'mock_1',
        name: 'Bảng Chữ Cái',
        description: 'Học bảng chữ cái ABC với các hoạt động và trò chơi vui nhộn',
        thumbnailPath: 'assets/images/topic/topic_1.png',
        orderIndex: 0,
        isLocked: false,
        isCompleted: false,
      ),
      TopicEntity(
        id: 'mock_2',
        name: 'Số Đếm',
        description: 'Đếm từ 1 đến 100 và học toán cơ bản',
        thumbnailPath: 'assets/images/topic/topic_2.png',
        orderIndex: 1,
        isLocked: false,
        isCompleted: false,
      ),
      TopicEntity(
        id: 'mock_3',
        name: 'Màu Sắc',
        description: 'Khám phá tất cả những màu sắc đẹp xung quanh chúng ta',
        thumbnailPath: 'assets/images/topic/topic_3.png',
        orderIndex: 2,
        isLocked: false,
        isCompleted: false,
      ),
      TopicEntity(
        id: 'mock_4',
        name: 'Động Vật',
        description: 'Gặp gỡ những động vật tuyệt vời và học tên của chúng',
        thumbnailPath: 'assets/images/topic/topic_4.png',
        orderIndex: 3,
        isLocked: true,
        isCompleted: false,
      ),
      TopicEntity(
        id: 'mock_5',
        name: 'Thức Ăn',
        description: 'Khám phá những món ăn ngon và thói quen ăn uống lành mạnh',
        thumbnailPath: 'assets/images/topic/topic_5.png',
        orderIndex: 4,
        isLocked: true,
        isCompleted: false,
      ),
    ];
  }

  void navigateToLearning() {
    // Will be implemented in learning feature
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
