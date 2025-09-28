# CAMT Terminator - System Architecture Diagram

**Description:**

> This diagram illustrates how **UI screen navigation (UIScreenCubit)**, **UI widgets**, **gameplay state management (GameCubit / CardCubit)**, **combat logic (CombatResolver)**, **player and boss states**, and **visual/audio effects (Rive animations & just_audio sounds)** interact in CAMT Terminator.

It emphasizes the role of each layer, separates screen navigation from gameplay logic, and reads more naturally.

```mermaid

flowchart LR
    %% UI Screen State
    subgraph Screen[UI Screen State]
        direction TB
        ScreenCubit[UIScreenCubit]
        MainMenu[Main Menu Screen]
        MenuScreen[Menu Screen]
        CombatScreen[Combat Screen]
        GameOverScreen[Game Over Screen]
    end

    %% UI Layer - Widgets
    subgraph UI[UI Layer - Widgets]
        direction TB
        ButtonWidget[ButtonWidget]
        CardWidget[CardWidget]
        HPBar[HP Bar]
        ConsumableWidget[Consumable Widget]
    end

    %% State Management
    subgraph Cubit[GameCubit / CardCubit]
        direction TB
        GC[GameCubit]
        CC[CardCubit]
    end

    %% Domain / Logic
    subgraph Logic[Combat / Player / Boss]
        direction TB
        Combat[CombatResolver]
        Player[Player State]
        Boss[Boss State]
    end

    %% Effects
    subgraph Effects[Animations & Sound]
        direction TB
        Rive[Rive Animation]
        Audio[just_audio Sound]
    end

    %% Connections
    ScreenCubit --> MainMenu
    ScreenCubit --> MenuScreen
    ScreenCubit --> CombatScreen
    ScreenCubit --> GameOverScreen

    MainMenu --> ButtonWidget
    MenuScreen --> UI
    CombatScreen --> UI
    GameOverScreen --> UI

    CardWidget --> GC
    HPBar --> GC
    ConsumableWidget --> GC

    CC --> Combat
    GC --> Combat
    Combat --> Player
    Combat --> Boss
    Player --> GC
    Boss --> GC

    CC --> Effects
    GC --> Effects
    
```
