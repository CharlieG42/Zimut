extends CanvasLayer
## BountiesUI.gd — Tableau des primes du jour (V28), ouvert depuis « Mes Parties ».

signal closed

const U = preload("res://scripts/UiKit.gd")


func open(save_data: Dictionary) -> void:
	var list: Array = Bounties.ensure(save_data)
	var bg := ColorRect.new()
	bg.color = Color(0.04, 0.05, 0.09, 0.96)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(bg)
	var root := Control.new()
	add_child(root)
	UiFit.apply(root, 1.1, Vector2(1300, 760))
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side in ["left", "right"]:
		margin.add_theme_constant_override("margin_" + side, 120)
	margin.add_theme_constant_override("margin_top", 30)
	margin.add_theme_constant_override("margin_bottom", 30)
	root.add_child(margin)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", U.box(Color(0.16, 0.11, 0.07, 0.98), Color(0.95, 0.65, 0.30), 18, 3, 22))
	margin.add_child(panel)
	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 14)
	panel.add_child(page)
	var top := HBoxContainer.new()
	page.add_child(top)
	var title := U.lbl("📜  PRIMES DU JOUR", 34, Color(1.0, 0.85, 0.50), true)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title)
	var close := U.btn("✕  FERMER", Color(0.95, 0.75, 0.30), 22, Vector2(170, 54))
	close.pressed.connect(func() -> void: closed.emit())
	top.add_child(close)
	var bd: Dictionary = save_data.get("bounties", {})
	var sub := U.lbl("Valables dans tous les modes. Nouvelles primes chaque jour.   Série de jours complets : %d" % int(bd.get("streak", 0)), 18, U.C_DIM)
	sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	page.add_child(sub)
	for b: Dictionary in list:
		var done: bool = bool(b.get("done", false))
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel", U.box(Color(0.10, 0.16, 0.10, 0.95) if done else Color(0.10, 0.10, 0.14, 0.95),
			U.C_GOOD if done else Color(0.65, 0.50, 0.30), 14, 2, 14))
		page.add_child(card)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 14)
		card.add_child(row)
		row.add_child(U.lbl("✔" if done else "◇", 34, U.C_GOOD if done else Color(1.0, 0.80, 0.45), true))
		var col := VBoxContainer.new()
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(col)
		col.add_child(U.lbl(String(b.get("title", "?")), 24, U.C_TXT, true))
		col.add_child(U.lbl("Récompense : " + Bounties.reward_text(b.get("reward", {})), 17, U.C_DIM))
		var bar := ProgressBar.new()
		bar.max_value = float(b.get("target", 1))
		bar.value = float(b.get("progress", 0))
		bar.show_percentage = false
		bar.custom_minimum_size = Vector2(0, 14)
		bar.add_theme_stylebox_override("background", U.box(Color(0.05, 0.05, 0.08), Color(0.25, 0.22, 0.18), 7, 1, 0))
		bar.add_theme_stylebox_override("fill", U.box(U.C_GOOD if done else Color(1.0, 0.72, 0.30), Color(0, 0, 0, 0), 7, 0, 0))
		col.add_child(bar)
		row.add_child(U.lbl("%d / %d" % [int(b.get("progress", 0)), int(b.get("target", 1))], 24, U.C_GOOD if done else U.C_TXT, true))
	var bonus_done: bool = bool(bd.get("bonus", false))
	var chest := U.lbl(("🎁  Coffre des primes obtenu !" if bonus_done else "🎁  Les 3 primes faites : coffre bonus (%s)") % ([] if bonus_done else [Bounties.reward_text(Bounties.bonus_reward(save_data))]),
		20, U.C_GOOD if bonus_done else Color(1.0, 0.85, 0.50), true)
	chest.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	page.add_child(chest)
