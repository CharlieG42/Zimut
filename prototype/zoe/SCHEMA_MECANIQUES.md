# ZOE - Schéma des Mécaniques de Jeu

## 📊 Diagramme Mermaid

```mermaid
flowchart TB
    %% === STYLE ===
    classDef title fill:#f8f9fa,stroke:#495057,stroke-width:2px,font-size:20px,font-weight:bold
    classDef biome fill:#e3f2fd,stroke:#1976d2,stroke-width:1px,color:#0d47a1
    classDef system fill:#fff3e0,stroke:#ff8f00,stroke-width:1px,color:#e65100
    classDef action fill:#e8f5e9,stroke:#388e3c,stroke-width:1px,color:#1b5e20
    classDef startEnd fill:#ffebee,stroke:#d32f2f,stroke-width:2px,color:#b71c1c
    
    %% === TITRE ===
    ZOE["Zimut: L'Odyssée des Éléments"]:::title
    
    %% === PAGE D'ACCUEIL ===
    subgraph "Page d'Accueil"
        A["🎮 Zimut
(Mode Combat)"] -->|Choix| B["🗺️ ZOE
(Mode Aventure)"]
    end
    
    %% === CORE LOOP ===
    subgraph "Core Loop (Mode ZOE)"
        direction TB
        C["🏞️ Exploration"]:::action
        D["🎒 Gestion Ressources"]:::system
        E["🧩 Résolution Énigmes"]:::action
        F["📈 Progression"]:::system
        
        C --> D
        D --> E
        E --> F
        F --> C
    end
    
    %% === BIOMES ===
    subgraph "Biomes"
        direction TB
        G1["⛰️ Montagne"]:::biome
        G2["🌊 Océan"]:::biome
        G3["🌿 Plaine Verdoyante"]:::biome
        G4["❄️ Toundra"]:::biome
        G5["🏜️ Désert"]:::biome
        
        G1 -->|Débloque| G2
        G2 -->|Débloque| G3
        G3 -->|Débloque| G4
        G4 -->|Débloque| G5
    end
    
    %% === SYSTÈMES PRINCIPAUX ===
    subgraph "Systèmes"
        direction TB
        H1["🍎 Ressources"]:::system
        H2["⚒️ Craft"]:::system
        H3["📜 Quêtes"]:::system
        H4["🧠 Énigmes"]:::system
        H5["💾 Sauvegarde Auto"]:::system
        H6["🗺️ Carte & Brouillard"]:::system
        
        H1 --> H2
        H2 --> H1
        H3 --> H4
        H4 --> H3
        H5 --> H6
    end
    
    %% === DÉTAIL DES MÉCANIQUES ===
    subgraph "Détail des Mécaniques"
        direction TB
        
        I1["Déplacement Libre"]
        I2["Découverte de Points d'Intérêt"]
        I3["Interaction avec l'Environnement"]
        
        J1["Faim/Soif"]
        J2["Énergie"]
        J3["Outils/Équipement"]
        J4["Inventaire"]
        
        K1["Énigmes Environnementales"]
        K2["Puzzles Logiques"]
        K3["Utilisation d'Objets"]
        
        L1["Déblocage de Zones"]
        L2["Amélioration des Compétences"]
        L3["Récompenses Cosmétiques"]
        
        I1 --> I2
        I2 --> I3
        J1 --> J4
        J2 --> J4
        J3 --> J4
        K1 --> K3
        K2 --> K3
        L1 --> L2
        L2 --> L3
    end
    
    %% === LIENS ENTRE SECTIONS ===
    B --> C
    C --> G1
    C --> H1
    C --> H6
    D --> H1
    D --> H2
    E --> H4
    F --> L1
    
    %% === LÉGENDE ===
    subgraph "Légende"
        M1["🟦 Bleu = Biomes"]
        M2["🟨 Orange = Systèmes"]
        M3["🟩 Vert = Actions"]
        M4["🟥 Rouge = Début/Fin"]
    end
    
    N["⚠️ Mode Solo | Monde Ouvert avec Fil Conducteur | Style Monument Valley"]:::startEnd
```

---

## 📌 Légende
- **🟦 Bleu** : Biomes (environnements du jeu)
- **🟨 Orange** : Systèmes (ressources, craft, quêtes, etc.)
- **🟩 Vert** : Actions (exploration, résolution d'énigmes)
- **🟥 Rouge** : Points de départ/fin

## 🔗 Liens Utiles
- [Game Design Document (GDD)](./GDD.md)
- [Dépôt Zimut](../../../)
