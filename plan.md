================================================================================
PROJECT NAME: ENGLISH DISCOVERY FOR KIDS (AI & STORY INTEGRATED)
VERSION: 2.0 (Updated with AI Vision & Quizlet Flow)
DATE: [Điền ngày]
TECH STACK: Flutter, GetX, Google ML Kit, Camera
================================================================================

I. TỔNG QUAN DỰ ÁN (PROJECT OVERVIEW)
--------------------------------------------------------------------------------
Mục tiêu: Xây dựng ứng dụng học tiếng Anh tương tác đa chiều cho trẻ em.
Phương pháp giáo dục (Flow):
   1. LEARN (Học): Thẻ Flashcard (Quizlet Style) - Nghe & Nhìn.
   2. PRACTICE (Thực hành): AI Camera Challenge - Tìm đồ vật thật.
   3. APPLY (Áp dụng): Interactive Story - Đọc truyện có ngữ cảnh.
   4. REVIEW (Ôn tập): Mini Game & Reward.

--------------------------------------------------------------------------------
II. PHÂN TÍCH CÔNG NGHỆ & THƯ VIỆN (DEPENDENCIES)
--------------------------------------------------------------------------------
1. Core & Architecture:
   - get: ^4.6.6 (Quản lý State, Route, Dependency Injection).
   - equatable: ^2.0.5 (So sánh Object, tối ưu render lại UI khi State thay đổi).

2. AI & Hardware (Tính năng Camera nhận diện):
   - google_mlkit_image_labeling: ^0.13.0 (Nhận diện đồ vật offline).
   - camera: ^0.11.0 (Truy cập phần cứng camera).
   - permission_handler: ^11.3.0 (Xin quyền truy cập Camera/Microphone trên Android/iOS).

3. UI & Animations:
   - flip_card: (Hiệu ứng lật thẻ 3D).
   - flutter_tts hoặc audioplayers: (Phát âm thanh/Giọng đọc).

--------------------------------------------------------------------------------
III. LUỒNG NGƯỜI DÙNG CHI TIẾT (USER FLOW)
--------------------------------------------------------------------------------
STEP 1: HOME SCREEN (BẢN ĐỒ BÀI HỌC)
   - Giao diện: Dạng Map (Level 1, Level 2...) hoặc Grid chủ đề.
   - Trạng thái: Bài chưa học bị khóa (Lock UI).

STEP 2: LEARNING PHASE (FLASHCARD QUIZLET)
   - Màn hình hiển thị 1 thẻ bài lớn giữa màn hình.
   - Hành động:
     + Mặt trước: Hình ảnh (Vector/Cartoon) + Từ vựng Tiếng Anh.
     + Tap vào thẻ: Lật xoay 3D -> Mặt sau: Nghĩa Tiếng Việt + Nút loa.
     + Sự kiện Lật: Tự động phát âm thanh từ vựng.
     + Nút Toggle: Chuyển chế độ "Anh trước - Việt sau" hoặc ngược lại.
     + Nút Yêu thích (Heart): Lưu từ khó vào kho riêng.

STEP 3: PRACTICE PHASE (AI CAMERA CHALLENGE - TÍNH NĂNG CỦA LEADER)
   - Logic: Sau khi học xong 5 từ (ví dụ: Banana, Cup, Pen...).
   - App hiển thị: "Bé hãy tìm một quả Chuối (Banana) thật cho mình xem nào!".
   - Action: Mở Camera View.
   - Xử lý kỹ thuật (Back-end logic):
     + Stream hình ảnh từ Camera -> Gửi vào ML Kit Image Labeler.
     + ML Kit trả về danh sách Labels (ví dụ: [Banana: 90%, Food: 80%]).
     + So sánh: Nếu Label chứa "Banana" -> Hiệu ứng pháo hoa -> Phát âm "Excellent! This is a Banana".
   - Fallback: Nếu không tìm thấy đồ vật thật, cho phép bỏ qua (Skip).

STEP 4: APPLICATION PHASE (INTERACTIVE STORY)
   - Màn hình chuyển sang đọc truyện ngắn chứa các từ vừa học.
   - Text Highlight: Các từ (Banana, Cup...) sẽ được tô màu nổi bật trong đoạn văn.
   - Tương tác: Chạm vào từ Highlight -> Hiện Popup nghĩa + Đọc lại mẫu câu.

STEP 5: GAME & REWARD
   - Mini-game nhanh: Kéo thả từ vào bóng (Shadow Matching).
   - Hoàn thành: Tặng Sticker, mở khóa bài tiếp theo.

--------------------------------------------------------------------------------
IV. KẾ HOẠCH TRIỂN KHAI KỸ THUẬT (DEVELOPMENT PLAN)
--------------------------------------------------------------------------------

GIAI ĐOẠN 1: CORE & FLASHCARD (TUẦN 1-2)
- Nhiệm vụ:
  + Setup dự án Flutter, cấu hình GetX Pattern (Model, View, Controller).
  + Xây dựng Data Model (Word, Lesson).
  + Code màn hình Flashcard:
    > Sử dụng thư viện `flip_card`.
    > Viết `StudyController` xử lý logic phát âm thanh khi lật.

GIAI ĐOẠN 2: TÍCH HỢP AI CAMERA (TUẦN 3-4) - QUAN TRỌNG
- Nhiệm vụ:
  + Cấu hình quyền (Permission) trong AndroidManifest.xml và Info.plist.
  + Viết `CameraDetectionController`:
    > Init CameraController.
    > Start ImageStream.
    > InputImage.fromBytes (Convert ảnh camera sang định dạng ML Kit đọc được).
    > ImageLabeler.processImage (Nhận diện).
  + Xử lý Logic Matching: So sánh kết quả AI trả về với Từ vựng bài học.
  + Tối ưu Performance: Chỉ xử lý 1 frame mỗi 0.5s để tránh lag máy nóng máy.

GIAI ĐOẠN 3: MODULE TRUYỆN & GAME (TUẦN 5-6)
- Nhiệm vụ:
  + Xây dựng UI đọc truyện lật trang.
  + Đồng bộ highlight text với audio (nếu có audio đọc cả câu).
  + Xây dựng hệ thống lưu trữ tiến độ (Hive/SharedPreferences) để lưu Sticker và Level đã qua.

GIAI ĐOẠN 4: UI POLISHING & TEST (TUẦN 7)
- Nhiệm vụ:
  + Thêm animation chuyển cảnh mượt mà giữa các Step (Học -> Camera -> Truyện).
  + Test trên thiết bị thật (Real Device) để kiểm tra Camera và độ nóng của máy.

--------------------------------------------------------------------------------
V. GHI CHÚ CHO DEVELOPER (DEV NOTES)
--------------------------------------------------------------------------------
1. Về Google ML Kit:
   - Model mặc định (Base model) nhận diện được khoảng 400+ danh mục đồ vật phổ biến (Mèo, Chó, Bàn, Ghế, Trái cây...).
   - Cần map (ánh xạ) từ vựng tiếng Anh của ML Kit trả về với từ vựng trong bài học (Ví dụ ML Kit trả về "Computer keyboard" thì cũng tính là đúng cho từ "Keyboard").

2. Về Equatable:
   - Sử dụng trong Bloc/GetX Controller để so sánh state của Camera (Ví dụ: Trạng thái đang Loading, Đã tìm thấy, Tìm sai) giúp tránh rebuild UI thừa thãi.

3. Về Camera:
   - Nhớ dispose (giải phóng) CameraController khi rời màn hình để tránh crash app.

================================================================================
END OF PLAN