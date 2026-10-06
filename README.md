# MrPinPin — Advanced Roblox Systems Engineer & OOP Architect

[![Luau](https://img.shields.io/badge/Language-Luau%20%7C%20Type--Strict-00A2FF?style=flat-square&logo=roblox&logoColor=white)](https://luau-lang.org/)
[![Architecture](https://img.shields.io/badge/Architecture-Modular%20OOP%20%2F%20Network%20Buffers-10B981?style=flat-square)](https://roblox.com)
[![Portfolio](https://img.shields.io/badge/Live%20Portfolio-pinpinfolio.vercel.app-6366F1?style=flat-square)](https://pinpinfolio.vercel.app/)

> Portfolio technique conçu pour **Hidden Devs** et les studios Roblox exigeants. Spécialisé dans l'ingénierie système haute performance, l'architecture orientée objet (OOP), la sérialisation binaire par buffers (`buffer`), et la structure modulaire de projets à grande échelle.

---

## 1. Vue d'Ensemble & Compétences Clés

- **Programmation Orientée Objet (OOP)** : Conception métatable robuste, encapsulation stricte (`--!strict`), factories et machines à états.
- **Mise en Réseau Haute Densité & Optimisation Mémoire** : Remplacement des RemoteEvents verbeux par des paquets binaires custom via l'API native `buffer` de Luau (réduction drastique du ping et de la bande passante).
- **Organisation & Rangement de Projet** : Hiérarchie unifiée `ReplicatedStorage.Shared` découplée en modules spécialisés (`Classes`, `Data`, `Modules`, `Network`, `Utils`).
- **Game Feel & Polish** : Systèmes d'armes, combat dynamique, caméras custom, réactivité client et autorité serveur stricte.

---

## 2. Structure & Rangement de Projet

Une architecture claire, prédictible et scalable, inspirée des standards industriels Roblox :

```text
ReplicatedStorage/
└── Shared/
    ├── Assets/            # Modèles, VFX, configurations de maillage
    ├── Classes/           # Définitions de classes OOP (Entity, Weapon, Inventory...)
    ├── Data/              # Tables de données statiques, configurations d'armes & items
    ├── Modules/           # Librairies utilitaires & singletons partagés
    ├── Network/           # Système de réplication binaire propriétaire
    │   ├── Remotes/       # RemoteFunctions & RemoteEvents déclarés
    │   ├── BufferReader   # Désérialisation binaire avec curseur de lecture
    │   ├── BufferWriter   # Sérialisation et packing dynamique
    │   ├── PacketRegistry # Table des identifiants et signatures d'opcodes
    │   └── Packets        # Structures de données sérialisées
    └── Utils/             # Mathématiques, wrappers et helpers génériques
```

---

## 3. Démonstration de Code — Moteur Réseau Binaire OOP (`buffer`)

### `BufferReader.luau` (Extrait)
```lua
--!strict
export type BufferReader = typeof(setmetatable(
	{} :: {
		_buffer: buffer,
		_cursor: number,
	},
	{} :: { __index: any }
))

local BufferReader = {}
BufferReader.__index = BufferReader

function BufferReader.new(source: buffer): BufferReader
	local self = setmetatable({}, BufferReader)
	self._buffer = source
	self._cursor = 0
	return self
end

function BufferReader:ReadUint8(): number
	local value = buffer.readu8(self._buffer, self._cursor)
	self._cursor += 1
	return value
end

function BufferReader:ReadUint16(): number
	local value = buffer.readu16(self._buffer, self._cursor)
	self._cursor += 2
	return value
end

function BufferReader:ReadVector3(): Vector3
	local x = self:ReadFloat32()
	local y = self:ReadFloat32()
	local z = self:ReadFloat32()
	return Vector3.new(x, y, z)
end

function BufferReader:HasMore(): boolean
	return self._cursor < buffer.len(self._buffer)
end

return BufferReader
```

---

## 4. Aperçu Gameplay en Production

Retrouvez des extraits et clips de gameplay de mon dernier projet en cours :
- Architecture de combat réactive et réplication d'états
- Gestion fine des hitboxes et rollback réseau
- Interface utilisateur dynamique sans latence perçue

---

## 5. Contact & Références

- **Portfolio en Ligne** : [pinpinfolio.vercel.app](https://pinpinfolio.vercel.app/)
- **Hidden Devs** : Actif pour missions freelance & contrats de développement système.
