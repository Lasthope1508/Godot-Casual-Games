# GLYPHFLOW ARRAYS - INTRODUCTION & ARCHITECTURE

Welcome to **Glyphflow Arrays**, a commercial-grade, premium 2D grid connection puzzle game built with **Godot Engine 4.3**.

---

## 🌌 1. Game Lore & Concept

In **Glyphflow Arrays**, you play as a cyber-network calibration engineer in a high-tech quantum computing grid. Your mission is to align data transmission streams (Data Conduits) to establish a continuous path from the **Source Power Core** to the target **Glyph Array nodes**. Once all target nodes receive the correct data stream, the network sector calibrates, and you progress to the next array sector.

---

## 🎮 2. Core Gameplay Mechanics

- **The Grid Puzzle**: Players interact with a grid of cells (ranging from 3x3 up to 9x9).
- **Click-to-Rotate**: Clicking any tile rotates it $90^\circ$ clockwise, updating its routing ports.
- **Connection Port Rules**: 
  - `pipe_cap` (1-port end cap)
  - `pipe_i` (2-port straight conduit)
  - `pipe_l` (2-port corner curve)
  - `pipe_t` (3-port junction)
  - `pipe_x` (4-port cross intersection)
- **Path Resolution**: The solver runs a recursive flood-fill algorithm starting from the **Source node** (`source.png`). If the flow reaches all **Target nodes** (`target.png`) with matching connection ports, the level resolves successfully.

---

## 🎨 3. Design System & Theme-Aware Architecture

Glyphflow Arrays implements a strict **Single Source of Truth (SSOT)** style design system. Every visual skin is an independent `.tres` file inheriting from [ThemeConfig.gd](file:///C:/Users/Admin/Desktop/Godot%20Casual%20Games/WaternetGodot/Resources/Classes/ThemeConfig.gd).

### Available Visual Themes:
1.  **Glyphflow Matrix (`hacknet_theme`)** [DEFAULT]:
    *   *Aesthetic*: Cyberpunk terminal, neon laser lines.
    *   *Colors*: Cyan (`#00ffff`) text & flows, hot magenta (`#ff007f`) borders, black (`#05050f`) backgrounds.
    *   *Typography*: Monospace digital system font.
2.  **Grow a Garden (`garden_theme`)**:
    *   *Aesthetic*: Cozy greenhouse, friendly organic textures.
    *   *Colors*: Forest Green text (`#2e7d32`), soft leaf green accents, cream off-white background (`#fbfaf5`).
    *   *Typography*: `Poppins-Bold.ttf` (Soft geometric sans-serif).
3.  **Luxury Wood & Gold (`wood_theme`)**:
    *   *Aesthetic*: Classical skeuomorphic wooden board game.
    *   *Colors*: Amber gold text (`#f59e0b`), walnut brown button backgrounds, dark mahogany panel backing.
    *   *Typography*: `Alegreya-ExtraBold.ttf` (Elegant serif).

---

## ⚙️ 4. Software Architecture Specifications

- **Decoupled Asset Loading**: UI components read textures, colors, and layout bounds (margins, widths) dynamically from the active `ThemeConfig` resource, completely eliminating hardcoded script values.
- **Proportional UI Scaling**: Utility buttons (Reset, Mute) scale their heights dynamically based on the active theme's `utility_button_height`.
- **Dynamic Icon Modulation**: Icon-only buttons (like `MuteBtn`) dynamically tint their white textures at runtime to contrast perfectly against button backgrounds, resolving contrast accessibility issues.
- **Responsive Viewport Manager**: The camera zoom and grid positioning scale dynamically to support notched mobile displays, widescreen desktop, and iPads seamlessly.
- **Autoload singletons**:
  - `ThemeManager`: Manages `.tres` theme swapping and exports shared styles.
  - `AudioManager`: Manages theme-aware BGM loop streams and normalized SFX pools.
  - `SaveManager`: Encrypts unlocked levels, progress, and volumes.
  - `SceneRouter`: Transition controller with fading overlays.
