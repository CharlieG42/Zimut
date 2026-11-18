class_name CardDeck
extends RefCounted
## CardDeck.gd — Pioche / main / défausse du mode « Cartes tactiques ».
## Règles (décisions Q1-Q3, doc prototype/zimut/MODE_CARTES_TACTIQUE.md) :
## deck de 20 cartes, main de départ 5, pioche 1 carte par tour, main max 7
## (au-delà, la carte piochée part directement en défausse).
## Q1 : une carte jouée coûte les PA/PM du héros — géré par GameManager.cast_spell.

const DECK_SIZE := 20
const HAND_START := 5
const HAND_MAX := 7

var deck: Array = []      # pioche (on pioche à la fin du tableau)
var hand: Array = []      # main
var discard: Array = []   # défausse
var _uid_seq: int = 0


## Construit un deck à partir d'une liste de noms de cartes (data/cartes.txt).
## Chaque instance de carte reçoit un "card_uid" unique pour la suivre main -> défausse.
## (load() de soi-même : en mode -s les class_name ne sont pas dans le ClassDB)
static func from_names(card_names: Array, cards_data: Array, rng: RandomNumberGenerator):
	var cd = (load("res://scripts/CardDeck.gd") as GDScript).new()
	for nm in card_names:
		for row in cards_data:
			if String(row.get("Nom", "")) == String(nm):
				var c: Dictionary = (row as Dictionary).duplicate(true)
				cd._uid_seq += 1
				c["card_uid"] = cd._uid_seq
				cd.deck.append(c)
				break
	# Mélange de Fisher-Yates avec le rng fourni (reproductible en test).
	for i in range(cd.deck.size() - 1, 0, -1):
		var j: int = int(rng.randi_range(0, i))
		var tmp: Variant = cd.deck[i]
		cd.deck[i] = cd.deck[j]
		cd.deck[j] = tmp
	for i in range(HAND_START):
		cd.draw()
	return cd


## Pioche 1 carte. Si la main est pleine (HAND_MAX), la carte part en défausse.
## Retourne la carte piochée, ou {} si la pioche est vide.
func draw() -> Dictionary:
	if deck.is_empty():
		return {}
	var card: Dictionary = deck.pop_back()
	if hand.size() >= HAND_MAX:
		discard.append(card)
	else:
		hand.append(card)
	return card


## Joue la carte de la main correspondant à card_uid : elle part en défausse.
## Retourne la carte jouée, ou {} si elle n'est plus en main.
func play_uid(card_uid: int) -> Dictionary:
	for i in range(hand.size()):
		if int(hand[i].get("card_uid", -1)) == card_uid:
			var card: Dictionary = hand[i]
			hand.remove_at(i)
			discard.append(card)
			return card
	return {}


func hand_size() -> int:
	return hand.size()


## Invariant : aucune carte n'est perdue (deck + main + défausse = total initial).
func total_cards() -> int:
	return deck.size() + hand.size() + discard.size()
