# Hướng dẫn Cấu hình Hạt cho Premium Assets (Spritesheets & Textures) trong Godot 4

Khi anh mua hoặc tải các gói **Premium VFX** từ bên ngoài về (dưới dạng Spritesheet/Flipbook hoặc Texture rời), tài liệu này sẽ chỉ dẫn chi tiết cách cấu hình `GPUParticles2D`/`GPUParticles3D` để áp dụng hiệu ứng mượt mà và đẹp mắt nhất.

---

## 1. Cấu hình Spritesheet / Flipbook chạy trên Particle
Premium VFX thường được bán dưới dạng một bức ảnh lớn chứa nhiều khung hình hoạt ảnh (ví dụ vụ nổ gồm 4x4 hoặc 8x8 khung hình).

### 🛠️ Các bước thiết lập trong Godot 4:
1.  **Tạo Node**: Thêm node `GPUParticles2D` (hoặc `GPUParticles3D`).
2.  **Gán Texture**: Kéo bức ảnh Spritesheet gán vào mục `Texture` của Particles.
3.  **Cấu hình CanvasItemMaterial**:
    *   Tại mục `Material` của Particles -> Chọn **New CanvasItemMaterial**.
    *   Click vào material đó, bật thuộc tính **Particles Animation** thành `On`.
    *   Chỉnh **Particles Anim H Frames** (Số cột hình) và **Particles Anim V Frames** (Số dòng hình) khớp với Spritesheet (Ví dụ: 8 cột, 8 dòng).
4.  **Cấu hình Hoạt ảnh trong ParticleProcessMaterial**:
    *   Tạo mới hoặc click vào `Process Material` (kiểu `ParticleProcessMaterial`).
    *   Cuộn xuống mục **Anim Speed** (Tốc độ hoạt ảnh): Chỉnh `Max` thành `1.0` (nghĩa là chạy hết 1 vòng hoạt ảnh từ khung đầu đến khung cuối trong suốt vòng đời particle).
    *   Chỉnh **Anim Offset**: Nếu muốn các hạt xuất hiện ngẫu nhiên ở các khung hình khác nhau, tăng `Max` lên `1.0`.

---

## 2. Kỹ thuật tạo độ "Juicy" (Premium Look) cho hạt
Hạt thô sơ trông rất phẳng và xấu. Premium VFX có chiều sâu nhờ việc biến đổi tỷ lệ (Scale), màu sắc (Color) và lực cản vật lý (Physics) theo thời gian.

### 📈 Tỷ lệ hạt theo thời gian (Scale Curve)
*Tránh việc hạt tự dưng biến mất đột ngột. Hạt nên xuất hiện nhỏ -> phình to -> thu nhỏ và biến mất.*
*   Trong `ParticleProcessMaterial` -> Cuộn đến **Scale** -> Bấm vào mũi tên cạnh `Scale Curve` -> Chọn **New CurveTexture**.
*   Click vào đường cong: Vẽ điểm đầu ở `0.2`, kéo đỉnh giữa lên `1.0`, và điểm cuối kéo xuống `0.0`.

### 🎨 Chuyển đổi màu sắc (Color Ramp / Gradient)
*Hạt lửa nên đi từ Trắng (siêu nóng) -> Vàng -> Đỏ -> Xám (khói) -> Trong suốt.*
*   Trong `ParticleProcessMaterial` -> Cuộn đến **Color** -> Bấm vào `Color Ramp` -> Chọn **New GradientTexture1D**.
*   Click vào `Gradient` -> Thiết lập dải màu từ sáng chói ở bên trái sang tối/trong suốt dần về bên phải.

### 💨 Lực cản không khí & Gia tốc (Damping & Radial Accel)
*Hạt bay ra từ vụ nổ nên bay nhanh lúc đầu và chậm dần lại do ma sát không khí.*
*   **Damping (Lực cản)**: Chỉnh khoảng `10.0` đến `50.0` để hạt hãm phanh tự nhiên.
*   **Radial Accel (Gia tốc tâm)**: Chỉnh số âm nếu muốn hạt bị hút vào tâm (hiệu ứng tụ năng lượng), chỉnh số dương để hạt bị đẩy văng ra ngoài.

---

## 3. Các Preset cấu hình nhanh cho Premium Textures
Khi có Texture đơn lẻ (đốm sáng, khói), hãy chỉnh các thông số này để ra hiệu ứng mong muốn:

| Hiệu ứng | Emission Shape | Gravity | Initial Velocity | Damping | Orbit Velocity |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Tia lửa (Sparks)** | Sphere/Ring | Y: 100 (rơi xuống) | 200 - 300 | 5.0 | 0.0 |
| **Khói bay (Smoke)** | Box/Line | Y: -50 (bay lên) | 20 - 50 | 10.0 | 0.1 (xoáy nhẹ) |
| **Vòng phép (Magic)** | Ring | 0.0 | 0.0 | 0.0 | 0.5 (xoay tròn) |
| **Bụi sáng (Glow Dust)**| Sphere | 0.0 | 5 - 15 | 2.0 | 0.0 |
