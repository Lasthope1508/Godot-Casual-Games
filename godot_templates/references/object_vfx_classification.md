# Phân loại Vật thể & Đặc tính VFX trong Lập trình Game Godot 4

Tài liệu này đóng vai trò là cẩm nang thiết kế (SSOT) giúp phân loại các nhóm vật thể phổ biến trong game và chỉ dẫn chi tiết cách thiết lập các thông số VFX tương ứng để đạt hiệu ứng thị giác tối đa.

---

## 1. Nhân vật Sinh động (Living Characters / Entities)
*Nhóm vật thể di chuyển chủ động, có tương tác vật lý liên tục như Người chơi (Player) và Kẻ địch (Enemy/NPC).*

### 🛠️ Các đặc tính VFX đi kèm:
*   **Bụi chân (Footstep Dust)**: Sinh ra khói nhỏ ở chân khi chạy nhảy.
*   **Ảnh bóng mờ (Dash Ghost / Afterimage)**: Để lại vệt ảnh mờ phía sau khi lướt tốc độ cao.
*   **Phản hồi trúng đòn (Hit Flash)**: Sprite nháy sáng trắng hoặc đỏ trong 0.1s báo hiệu mất máu.
*   **Tia máu / Năng lượng văng (Damage Splatter)**: Bắn hạt ra phía sau khi bị tấn công.

### ⚙️ Quy tắc cấu hình trong Godot 4:
1.  **Tắt Tọa độ cục bộ (`local_coords = false`)**: Đây là quy tắc tối quan trọng cho hạt bụi di chuyển. Hạt khói/tia lửa sau khi rời khỏi nhân vật phải ở lại vị trí cũ trong thế giới game (`World Space`), không được dịch chuyển theo nhân vật.
2.  **Căn chỉnh Pivot Sprite**: Đảm bảo điểm gốc tọa độ (Pivot) của nhân vật nằm ở đáy chân (bụng chân) thay vì ở tâm (Center). Việc này giúp hạt bụi chân sinh ra đúng vị trí tiếp đất và hệ thống `Y-Sort` tính toán chiều sâu chính xác.

---

## 2. Vật thể Phá hủy & Khối cứng (Destructible Props / Bricks)
*Các vật thể đứng yên trên bản đồ nhưng có thể bị đập vỡ, va chạm mạnh như Hộp gỗ, Thùng thuốc súng, Khối gạch (Brick Breaker).*

### 🛠️ Các đặc tính VFX đi kèm:
*   **Mảnh vỡ văng (Debris / Shards)**: Văng ra các mảnh nhỏ có hình dáng giống vật liệu gốc (gỗ, đá, kính).
*   **Sóng chấn động (Shockwave)**: Vòng tròn năng lượng tỏa ra xung quanh vụ nổ.
*   **Vết nứt (Crack overlay)**: Xuất hiện các texture nứt vỡ trước khi nổ hẳn.

### ⚙️ Quy tắc cấu hình trong Godot 4:
1.  **Bật chế độ Phát một lần (`one_shot = true`)**: Hạt mảnh vỡ chỉ nổ ra một lần ngay khi vật thể vỡ, tuyệt đối không lặp lại (`explosiveness = 1.0`).
2.  **Lực cản không khí (`Damping`)**: Đặt ma sát cao để mảnh vỡ bắn ra nhanh rồi khựng lại tự nhiên, không bay vô tận.
3.  **Vật lý Trọng lực (`Gravity`)**: Đặt trọng lực hướng xuống (Ví dụ: `Vector3(0, 980, 0)` trong 2D) để các mảnh vỡ gỗ/đá rơi rụng xuống đất sau khi bắn lên cao.

---

## 3. Tia Sáng & Chùm Năng lượng (Beams / Lasers / Projectiles)
*Các nguồn sáng định hướng, đường đạn bay tốc độ cao hoặc luồng năng lượng liên tục.*

### 🛠️ Các đặc tính VFX đi kèm:
*   **Hào quang nòng súng (Muzzle Flash)**: Lóe sáng tại điểm xuất phát của luồng sáng.
*   **Đường truyền năng lượng (Beam / Trail)**: Thân tia sáng có họa tiết cuộn trôi tạo cảm giác luồng điện đang phóng đi.
*   **Plasma va chạm (Impact Splash)**: Tia lửa xẹt ra mạnh tại điểm chạm mục tiêu hoặc tường.

### ⚙️ Quy tắc cấu hình trong Godot 4:
1.  **Bật Tọa độ cục bộ (`local_coords = true`) cho đầu bắn**: Các hạt phát sáng tụ năng lượng ở đầu súng phải quay theo nòng súng khi nhân vật đổi hướng bắn.
2.  **Sử dụng Line2D + Texture Seamless**: Không dùng hạt để dựng thân tia laser. Hãy dùng `Line2D` kết hợp với một texture không mối nối (Seamless) và dùng Shader để cuộn tọa độ UV (`UV.x -= TIME * speed`) tạo hiệu ứng dòng điện chạy dọc thân tia.
3.  **Phản xạ va chạm (Normal Orientation)**: Hạt nổ ở điểm va chạm phải được định hướng góc bắn dựa trên Vector pháp tuyến của bề mặt va chạm (đạn đập vào tường nghiêng phải bắn tia lửa ngược ra ngoài tương ứng).

---

## 4. Vật phẩm nhặt được & Phần thưởng (Collectibles / Loot)
*Vật phẩm trôi nổi chờ người chơi nhặt như Tiền vàng, Bình máu, Thẻ bổ trợ (Power-ups).*

### 🛠️ Các đặc tính VFX đi kèm:
*   **Hào quang phát sáng (Halo / Glow)**: Đốm sáng nhẹ tỏa ra xung quanh vật phẩm.
*   **Chuyển động lơ lửng (Floating Bobbing)**: Chuyển động lên xuống hình Sin chậm rãi.
*   **Đường bay thu hoạch (Absorption Trail)**: Khi người chơi lại gần, vật phẩm bay nhanh và uốn lượn hút vào túi người chơi.

### ⚙️ Quy tắc cấu hình trong Godot 4:
1.  **Sử dụng Tween cho hoạt ảnh tĩnh**: Không dùng hệ thống vật lý để làm chuyển động bay lên xuống. Hãy dùng `create_tween()` với chế độ `TRANS_SINE` và `EASE_IN_OUT` để làm Sprite bồng bềnh mượt mà.
2.  **Hạt lơ lửng tốc độ thấp**: Đặt `Gravity = 0.0` và `Initial Velocity` rất thấp (5-10 px/s) hướng ngẫu nhiên để tạo các hạt bụi lấp lánh xung quanh vật phẩm.
