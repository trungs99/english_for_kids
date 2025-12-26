================================================================================
TÊN DỰ ÁN: APP HỌC TIẾNG ANH TRẺ EM (INTERACTIVE STORIES & VOCABULARY)
NGÀY BẮT ĐẦU: [Điền ngày bắt đầu]
MỤC TIÊU: Xây dựng ứng dụng giáo dục cho trẻ em với 2 tính năng chính: Truyện tranh tương tác & Game từ vựng.
================================================================================

PHẦN 1: PHÂN TÍCH YÊU CẦU & CHUẨN BỊ (TUẦN 1)
--------------------------------------------------------------------------------
1. Phân tích tính năng (Dựa trên ý tưởng gốc):
   a. Module Truyện tranh tương tác:
      - Hiển thị truyện dạng trang (Page view).
      - Audio tự động đọc hoặc bấm để đọc.
      - Tương tác: Chạm vào từ vựng -> Phát âm + Hiện nghĩa (Popup/Tooltip).
      - Logic: Đọc hết trang -> Trigger mini-game kiểm tra bài -> Qua trang mới.
   b. Module Game từ vựng:
      - Chủ đề (Themes): Động vật, Trường học, Màu sắc, Số đếm.
      - Gameplay: Kéo thả (Drag & Drop) từ vào hình ảnh tương ứng.
      - Hệ thống phần thưởng: Tích lũy Sticker vào bộ sưu tập.

2. Công nghệ đề xuất (Tech Stack):
   - Ngôn ngữ: Flutter (khuyên dùng vì làm UI/Animation tốt, chạy cả Android/iOS) hoặc Unity (nếu muốn làm game nặng về hiệu ứng).
   - Dữ liệu (Backend/Local): Sử dụng JSON/SQLite lưu trữ nội dung truyện và từ vựng (Offline-first).
   - Âm thanh: Text-to-Speech (TTS) hoặc File ghi âm MP3 (Ghi âm sẽ tự nhiên hơn cho trẻ em).

================================================================================
PHẦN 2: THIẾT KẾ UI/UX & TÀI NGUYÊN (TUẦN 2-3)
--------------------------------------------------------------------------------
1. Thiết kế UI (Giao diện):
   - Phong cách: Màu sắc tươi sáng, nút bấm to, font chữ tròn dễ đọc.
   - Màn hình chính (Home): Menu chọn "Đọc truyện" hoặc "Chơi game".
   - Màn hình Đọc truyện: Layout hiển thị ảnh full màn hình, text overlay, nút điều hướng.
   - Màn hình Game: Khu vực hiển thị từ, khu vực hiển thị ảnh, hiệu ứng pháo hoa khi thắng.
   - Màn hình Sticker: "Tủ đồ" chứa các sticker bé đã nhận được.

2. Chuẩn bị Tài nguyên (Assets):
   - Content: Viết kịch bản cho 3-5 câu chuyện mẫu.
   - Images: Vẽ hoặc mua stock ảnh vector (Động vật, trường học...).
   - Audio:
     + Giọng đọc truyện (Narrator).
     + Phát âm từng từ vựng.
     + Âm thanh hiệu ứng (Vỗ tay, Ting ting, Fail, Success).

================================================================================
PHẦN 3: LẬP TRÌNH - GIAI ĐOẠN 1: CẤU TRÚC & MODULE TRUYỆN (TUẦN 4-6)
--------------------------------------------------------------------------------
1. Thiết lập dự án:
   - Cài đặt điều hướng (Navigation/Routing).
   - Cấu hình State Management (Provider/Bloc/GetX).
   - Xây dựng Model dữ liệu: StoryModel, PageModel, WordModel.

2. Phát triển Module Đọc truyện:
   - Coding giao diện lật trang.
   - Xử lý đồng bộ Audio và Text (Highlight chữ khi đọc).
   - Xử lý sự kiện Touch:
     + Chạm vào từ -> Dừng audio kể chuyện -> Phát âm từ đó -> Hiện nghĩa.
   - Xây dựng Mini-game cuối trang: Câu hỏi trắc nghiệm đơn giản (Chọn hình đúng với nội dung vừa nghe).

================================================================================
PHẦN 4: LẬP TRÌNH - GIAI ĐOẠN 2: MODULE GAME & REWARD (TUẦN 7-8)
--------------------------------------------------------------------------------
1. Phát triển Module Game Từ Vựng:
   - Coding màn hình chọn chủ đề (List view).
   - Logic Game "Ghép từ - Hình ảnh":
     + Random dữ liệu câu hỏi.
     + Xử lý sự kiện Drag & Drop (Kéo thả).
     + Check kết quả (Đúng/Sai).
     + Hiệu ứng âm thanh vui nhộn khi ghép đúng.

2. Hệ thống Phần thưởng (Reward System):
   - Logic tính điểm/sao sau mỗi màn chơi.
   - Logic mở khóa Sticker: Ví dụ hoàn thành 1 chủ đề -> Nhận 1 sticker.
   - Lưu trữ tiến độ người chơi (SharedPreferences/Local DB) để khi thoát app không bị mất sticker.

================================================================================
PHẦN 5: KIỂM THỬ & HOÀN THIỆN (TUẦN 9)
--------------------------------------------------------------------------------
1. Testing (QA):
   - Kiểm tra trên các thiết bị màn hình khác nhau (Tablet, Phone).
   - Kiểm tra lỗi logic (Ví dụ: Bấm liên tục vào màn hình, kéo thả sai vị trí).
   - Kiểm tra âm thanh (Có bị chồng chéo âm thanh không?).

2. Tối ưu (Polish):
   - Thêm hiệu ứng chuyển cảnh (Transition) mượt mà.
   - Tối ưu dung lượng ảnh/âm thanh để app không quá nặng.

================================================================================
PHẦN 6: PHÁT HÀNH (TUẦN 10)
--------------------------------------------------------------------------------
1. Chuẩn bị Store Listing:
   - Chụp ảnh màn hình (Screenshots) đẹp mắt.
   - Viết mô tả hấp dẫn, nhấn mạnh từ khóa "Tiếng Anh cho bé", "Học qua truyện".
   - Thiết kế Icon App nổi bật.

2. Upload:
   - Đẩy lên Google Play Console / Apple App Store Connect.
   - Chờ duyệt và theo dõi phản hồi.

================================================================================
GHI CHÚ QUAN TRỌNG:
- Đối với app trẻ em, UX (trải nghiệm người dùng) quan trọng hơn tính năng phức tạp. Bé chạm vào đâu cũng nên có phản hồi âm thanh hoặc chuyển động.
- Tuân thủ chính sách "Designed for Families" của Google/Apple (Không thu thập dữ liệu cá nhân trái phép, quảng cáo phù hợp lứa tuổi).