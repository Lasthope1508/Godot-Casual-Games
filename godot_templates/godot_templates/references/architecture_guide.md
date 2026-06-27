# Hướng dẫn Kiến trúc Dự án Godot 4 2D (Project Architecture & Gameplay Loop)

Tài liệu này đóng vai trò là kim chỉ nam (SSOT) giúp AI Coding Assistant định hình cấu trúc và cơ chế khi xây dựng hoặc mở rộng bất kỳ dự án game Godot 4 nào.

---

## 1. Phân loại Học hỏi & Tận dụng

### 🌟 Nhóm 1: Gameplay Loop (Vòng lặp Chơi game)
*   **Mẫu tham chiếu**: Godot 4 2D Template Collection (7-in-1 / 10-in-1) từ Godot Example Hub (Asset ID: 4975).
*   **Mục tiêu áp dụng**:
    *   Học hỏi các cơ chế tương tác trực tiếp (Core Gameplay) như: Di chuyển, va chạm vật lý, tính toán điểm số, tạo quái vật tự động, logic xếp hình, kéo thả chuột.
    *   Tận dụng các hàm nhỏ gọn, xử lý nhanh trong phạm vi một màn chơi (Scene lẻ).

### 🌟 Nhóm 2: Project Architecture (Kiến trúc Dự án Lớn)
*   **Mẫu tham chiếu**: Maaack’s Game Template / Minimal Game Template & TakinGodotTemplate (Dành cho Godot 4.4+).
*   **Mục tiêu áp dụng**:
    *   **Hệ thống UI/UX Khung**: Main Menu, Options/Settings (Điều chỉnh đồ họa, âm lượng), Pause Menu, Credits Screen.
    *   **Scene Loader**: Chuyển màn mượt mà kèm màn hình chờ (Loading Screen) sử dụng luồng phụ (Background Loading).
    *   **Hệ thống Core Core (Autoload/Singletons)**:
        *   `SaveManager`: Quản lý lưu trữ trạng thái game và mã hóa dữ liệu.
        *   `AudioManager`: Quản lý nhạc nền (BGM) và hiệu ứng âm thanh (SFX) qua các audio bus chuyên biệt.
        *   `LocalizationManager`: Hỗ trợ đa ngôn ngữ (chuyển đổi ngôn ngữ động).
        *   `Logger`: Ghi log debug có tổ chức ra file hoặc màn hình console.
    *   **Mở rộng tính năng**: Phát triển thêm các hệ thống phụ như Leaderboard (Bảng xếp hạng), Achievements (Thành tựu), Ads/Purchases dựa trên kiến trúc modular này.

---

## 2. Quy tắc Thiết kế Dự án cho AI

Khi được yêu cầu xây dựng một hệ thống mới, AI phải tuân thủ kiến trúc phân tách rõ ràng:
1.  **Gameplay Node độc lập**: Tuyệt đối không viết cứng (hardcode) các logic lưu dữ liệu hay bật tắt âm thanh trực tiếp trong script của Player hay Enemy. Phải giao tiếp thông qua các Singleton Manager (ví dụ: `AudioManager.play_sfx("click")`).
2.  **Modular & Extensible**: Khi phát triển các tính năng như Leaderboard hay Achievements, hãy thiết kế chúng thành các component riêng biệt, đăng ký dưới dạng Autoload hoặc các Node dịch vụ độc lập, giúp dự án dễ dàng bảo trì và không gây ảnh hưởng đến phần gameplay loop cốt lõi.
