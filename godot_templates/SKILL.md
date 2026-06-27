---
name: godot-templates
description: "Thư viện code mẫu SSOT cho các cơ chế game Godot 4 2D (Movement, States, Spawning, PathFollow, Grid)"
---

# Thư viện Code Mẫu Godot 4 2D (Single Source of Truth)

Khi phát triển game Godot 4 2D, hãy mở thư mục `examples/` để tham khảo và tận dụng trực tiếp các đoạn code mẫu chuẩn sau:

1.  **examples/movement_8way.gd**: Di chuyển nhân vật 8 hướng mượt mà cho game Top-down, hỗ trợ AnimationPlayer và AnimationTree.
2.  **examples/state_machine.gd**: Cấu trúc Finite State Machine (FSM) phân cấp chuẩn để quản lý các trạng thái phức tạp (Idle, Move, Jump, Attack...).
3.  **examples/spawner.gd**: Bộ sinh quái vật/vật phẩm tự động theo thời gian, hỗ trợ Spawner Marker và giới hạn số lượng.
4.  **examples/path2d_follow.gd**: Quản lý di chuyển của vật thể bám theo đường cong vẽ sẵn (Path2D) ứng dụng cho Tower Defense hoặc đạn bay quỹ đạo.
5.  **examples/grid_manager.gd**: Quản lý ma trận tọa độ màn chơi Puzzle/Match-3, hỗ trợ chuyển đổi tọa độ màn hình và kiểm tra ô trống.
6.  **examples/isometric_helper.gd**: Hỗ trợ toán học chuyển đổi hệ tọa độ Isometric 2.5D (Map sang World và ngược lại) cùng thiết lập tìm đường `AStar2D` lưới chéo.
7.  **examples/editor_asset_placer.gd**: Template mẫu `@tool` mở rộng trình biên tập (Editor Plugin) giúp thực hiện Raycasting từ chuột trong Viewport 3D và tự động đặt vật thể dọc theo bề mặt (Normal alignment).

### ✨ Hiệu ứng hình ảnh & Cảm giác chơi (VFX & Game Feel / Juice)
Tham khảo mã nguồn tại thư mục `examples/vfx/`:
- **[screen_shake.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/screen_shake.gd)**: Rung màn hình Camera2D bằng tiếng ồn Simplex Noise giúp các chấn động, vụ nổ mượt mà và thực tế.
- **[hit_flash.gdshader](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/hit_flash.gdshader)**: Shader nhấp nháy màu trắng/đỏ khi Sprite nhận sát thương (Visual feedback).
- **[vfx_spawner.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/vfx_spawner.gd)**: Trình tạo hiệu ứng hạt (Particles) và âm thanh (SFX) tự động giải phóng bộ nhớ khi hoàn thành để chống tràn RAM.
- **[squash_stretch.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/squash_stretch.gd)**: Hiệu ứng co giãn đàn hồi vật lý hoạt họa cho nhân vật bằng Tween khi nhảy và tiếp đất.
- **[dissolve.gdshader](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/dissolve.gdshader)**: Shader tan biến theo cấu trúc ảnh nhiễu (Noise texture) kèm hiệu ứng viền cháy rực lửa.
- **[dash_ghost.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/dash_ghost.gd)**: Tạo ảnh bóng mờ sau lưng nhân vật khi lướt đi (Dash Ghost / Afterimage).
- **[trail_2d.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/trail_2d.gd)**: Hiệu ứng đường kéo vệt (Trail) cho đạn hoặc kiếm khí bằng Line2D.
- **[shield_3d.gdshader](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/shield_3d.gdshader)**: Shader lá chắn năng lượng 3D phát sáng ở cạnh bằng toán học Fresnel.
- **[decal_spawner_3d.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/decal_spawner_3d.gd)**: Hệ thống phun decal (vết đạn, vết máu) ghim lên bề mặt 3D theo hướng Vector pháp tuyến địa hình.
- **[billboard_helper.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/vfx/billboard_helper.gd)**: Trình xoay đối tượng 2D luôn hướng về phía Camera 3D (Cylindrical & Spherical Billboard) cho game phong cách 2.5D (Doom/Octopath Traveler).
- **[particle_vfx_guide.md](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/references/particle_vfx_guide.md)**: Hướng dẫn chi tiết cách cấu hình hạt (GPUParticles) để áp dụng các gói Premium VFX bên ngoài (Spritesheets/Flipbook, Gradient Ramps, Scale Curves, Damping).
- **[object_vfx_classification.md](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/references/object_vfx_classification.md)**: Hướng dẫn phân loại vật thể (Người, Gạch, Tia sáng, Vật phẩm) và các đặc tính vật lý & cấu hình hạt tương ứng.

## Khung Dự án Từ các Template Chuẩn (Maaack & Takin):
Tham khảo mã nguồn thực tế đã lưu vào kho skill:

### 🎮 Maaack's Game Template (Kiến trúc Khung & UI)
- **[main_menu.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/maaack/main_menu.gd)**: Quản lý giao diện Menu chính, xử lý nút nhấn chuyển màn, nút options và credits.
- **[loading_screen.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/maaack/loading_screen.gd)**: Quản lý màn hình load tài nguyên bất đồng bộ (Thread-safe background loading).
- **[level_and_state_manager.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/maaack/level_and_state_manager.gd)**: Quản lý trạng thái và thứ tự chuyển tiếp giữa các màn chơi.

### ⚙️ TakinGodotTemplate (Hệ thống Core & Autoload - Godot 4.4+)
- **[audio_manager.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/takin/audio_manager.gd)**: Trình quản lý âm thanh (BGM & SFX) qua Audio Bus.
- **[logger.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/takin/logger.gd)**: Hệ thống ghi log gỡ lỗi có định dạng và xuất file.
- **[scene_manager.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/takin/scene_manager.gd)**: Trình chuyển màn chuyên sâu kèm hiệu ứng fade-in / fade-out.
- **[save_data_base.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/takin/save_data_base.gd)** và **[game_save_data.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/takin/game_save_data.gd)**: Cơ chế Save/Load game, mã hóa dữ liệu.
- **[signal_bus.gd](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/examples/takin/signal_bus.gd)**: Event Bus lưu trữ các tín hiệu toàn cục, giảm sự phụ thuộc chéo (coupling) giữa các class.

## Hướng dẫn Kiến trúc Dự án (Architecture Guide):
- Đọc chi tiết tại **[architecture_guide.md](file:///C:/Users/Admin/.gemini/config/skills/godot_templates/references/architecture_guide.md)** để nắm rõ cách phân bổ thiết kế:
  - **Gameplay Loop**: Tham khảo từ bộ sưu tập 7-in-1 / 10-in-1.
  - **Project Architecture**: Kế thừa cấu trúc từ Maaack's / Takin Godot Template.

## Cách sử dụng nhanh:
- Đọc nội dung file cụ thể: Sử dụng công cụ `view_file` trên đường dẫn đầy đủ (ví dụ: `C:/Users/Admin/.gemini/config/skills/godot_templates/examples/movement_8way.gd`).
- Áp dụng vào dự án: Copy code mẫu cấu trúc và chỉnh sửa biến/tên node cho khớp với cấu trúc Node cụ thể của game.
