# IJAC — It's Just a Cube

> A game that starts as nothing and becomes whatever its community creates.

**IJAC** is an experiment in community-driven game development. Every season starts with the same thing: one gray cube in an empty 3D scene. No genre, no roadmap. Changes are proposed, tested, voted on and merged — and when a season ends, the game is archived and a new season starts again with just a cube.

**Status: Season 0 — a local technical prototype.** It proves the process (cube → versions → history → switch between builds), not a finished game. There is no public contribution pipeline or voting yet.

---

## What's in Season 0

- The starting scene: a textured cube on an endless grid floor, with an orbit camera.
- An in-game **history panel**: **ACTUAL** (the current approved version) and **TIMELINE** (open any earlier version).
- Three versions to switch between:

| Version | Title | Notes |
|---|---|---|
| `s0-v000` | Just a Cube | The starting point |
| `s0-v001` | Movement | **Demo** — simulated PR, WASD moves the cube |
| `s0-v002` | Jump | **Demo** — simulated PR, Space to jump |

Versions marked *demo* are written by the project author to test the process. They are not real community contributions, and the game says so.

## Controls

| Input | Action |
|---|---|
| LMB / RMB + mouse, arrow keys | Orbit the camera around the cube |
| Mouse wheel | Zoom |
| H | Show / hide the history panel |
| F11 | Fullscreen / windowed |
| W A S D, Space | Move / jump (only in versions that have them) |
| Esc | Quit |

## Download

- Windows build: [GitHub Releases](https://github.com/ruffbuff/IJAC-season-0/releases)
- Windows may show a SmartScreen warning because the build is not code-signed: **More info → Run anyway**.

## Run from source

1. Install [Godot](https://godotengine.org/) 4.2 or newer.
2. Godot → Import → select `game/project.godot`.
3. Press F5.

## Build for Windows

1. Godot → Editor → Manage Export Templates → Download and Install.
2. Project → Export → *Windows Desktop* (preset included) → Export Project.
3. Output: `builds/ijac-dev/ijac.exe` (the `builds/` folder is git-ignored).

## Project layout

```text
game/
  scenes/Main.tscn          shell: history panel + container for versions
  scenes/versions/vNNN.tscn one scene per version (snapshots, not edited later)
  scripts/versions/vNNN/    scripts that belong to a specific version
  data/versions.json        version list and the "current" pointer
  textures/                 cube logo atlas, floor grid
```

To add a version: copy the latest scene to `vNNN.tscn`, make changes, add an entry to `versions.json`, update `current`.

## Roadmap

1. **Season 0** — local prototype *(this repository)*.
2. Contribution rules, license terms for contributors, PR template.
3. Small closed test with real contributors and votes.
4. Public Season 1 with a transparent, clearly labeled starter set of changes.

## License

Source code and assets in this repository are available under the **[PolyForm Noncommercial License 1.0.0](LICENSE)**: you may read, build, modify and share the project for noncommercial purposes. Selling it or using it commercially requires separate permission from the author. This is *source-available*, not OSI "open source". The name "IJAC" and its logo are not licensed for use as your own branding.

---

# IJAC — It's Just a Cube (RU)

> Игра, которая начинается с ничего и становится тем, что создаст её сообщество.

**IJAC** — эксперимент по совместной разработке игры. Каждый сезон начинается одинаково: один серый куб в пустой 3D-сцене. Без жанра и дорожной карты. Изменения предлагаются, тестируются, голосуются и принимаются, а когда сезон заканчивается, игра архивируется и новый сезон снова начинается с куба.

**Статус: Season 0 — локальный технический прототип.** Он проверяет процесс (куб → версии → история → переключение сборок), а не является готовой игрой. Публичного приёма вкладов и голосования пока нет.

## Что есть в Season 0

- Стартовая сцена: куб с текстурой на бесконечной сетке, камера вокруг куба.
- **Панель истории** в игре: **ACTUAL** (текущая утверждённая версия) и **TIMELINE** (любая прошлая версия).
- Три версии для переключения: `s0-v000` (чистый куб), `s0-v001` (движение, WASD) и `s0-v002` (прыжок, Пробел).

Версии с пометкой *demo* написаны автором проекта для проверки процесса. Это не настоящие вклады сообщества, и игра об этом прямо говорит.

## Управление

ЛКМ/ПКМ + мышь или стрелки — вращение камеры, колесо — зум, **H** — панель истории, **F11** — полный экран, **WASD / Пробел** — движение и прыжок (только в версиях, где они есть), **Esc** — выход.

## Скачать и запустить

- Сборка для Windows: [GitHub Releases](https://github.com/ruffbuff/IJAC-season-0/releases). Windows может показать предупреждение SmartScreen, так как сборка не подписана: **Подробнее → Выполнить в любом случае**.
- Из исходников: установите Godot 4.2+, импортируйте `game/project.godot`, нажмите F5.
- Сборка exe: Editor → Manage Export Templates → установить шаблоны, затем Project → Export → *Windows Desktop* → Export Project. Результат: `builds/ijac-dev/ijac.exe`.

## Лицензия

Код и ресурсы репозитория доступны по лицензии **[PolyForm Noncommercial 1.0.0](LICENSE)**: можно читать, собирать, изменять и распространять проект в некоммерческих целях. Продажа и коммерческое использование требуют отдельного разрешения автора. Это *source-available*, а не «открытый исходный код» в смысле OSI. Название «IJAC» и логотип не лицензируются для использования в качестве вашего бренда.
