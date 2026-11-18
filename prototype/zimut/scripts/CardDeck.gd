class_name CardDeck
extends RefCounted
## CardDeck.gd — Pioche / main / défausse du mode « Cartes tactiques ».
## Règles (décisions Q1-Q3, doc prototype/zimut/MODE_CARTES_TACTIQUE.md) :
## deck de 20 cartes, main de départ 5, pioche 1 carte par tour, main max 7
## (au-delà, la carte piochée part directement en défausse).
## Q1 : une carte jouée coûte les PA/PM du héros — géré par GameManager.cast_spell.
## V401 (refonte Krosmaga) : le deck et la main sont PARTAGÉS par tout un camp (les héros jouent
## les cartes d'une même main) et le mana est commun : il repart de MANA_START à la manche 1,
## gagne +1 par manche jusqu'à MANA_MAX, et se dépense carte après carte quel que soit le héros.

const DECK_SIZE := 20
const HAND_START := 5
const HAND_MAX := 7
const MANA_START := 3
const MANA_MAX := 10

var deck: Array = []      # pioche (on pioche à la fin du tableau)
var hand: Array = []      # main
var discard: Array = []   # défausse
var mana: int = 0         # mana restant du camp pour la manche en cours
var mana_round: int = 0   # manche pour laquelle le mana et la pioche ont été renouvelés
var _uid_seq: int = 0


## Mana disponible au début d'une manche : 3 à la manche 1, +1 par manche, plafonné à 10.
static func mana_for_round(round_no: int) -> int:
	return clampi(MANA_START + maxi(round_no, 1) - 1, MANA_START, MANA_MAX)


## Début d'une manche pour ce camp : renouvelle le mana et pioche 1 carte (sauf manche 1).
## Sans effet si la manche est déjà lancée. Retourne la carte piochée ({} si aucune).
func start_round(round_no: int) -> Dictionary:
	if round_no == mana_round:
		return {}
	mana_round = round_no
	mana = mana_for_round(round_no)
	return draw() if round_no > 1 else {}


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
