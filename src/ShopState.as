package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import player_projectiles.*;
	import enemy.*;
	import particles.*;
	import pickups.*;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class ShopState extends FlxState {
		
		static var items = {
			"root": {
				"price":0,
				"name":"",
				"desc":"",
				"func":function() { },
				"linkto":["bow_damage_1","hp_1","sword_damage_1"],
				"owned":true
			},
			
			//row 1
			"bow_damage_1": {
				"price":25,
				"icon":Resource.SHOP_ICON_BOW_DAMAGE,
				"name":"Bow Damage+",
				"desc":"Increase Bow Damage.",
				"func":function() {
					GameStats._bow_damage += 3;
					GameStats._bow_knockback += 2;
					GameStats._bow_stun += 5;
				},
				"linkto":["bow_accuracy_1"]
			},
			"hp_1": {
				"price":25,
				"icon":Resource.SHOP_ICON_HEALTH,
				"name":"HP+",
				"desc":"Increase HP.",
				"func":function() {
					GameStats._max_health += 7;
				},
				"linkto":["energy_1"]
			},
			"sword_damage_1": {
				"price":25,
				"icon":Resource.SHOP_ICON_SWORD_DAMAGE,
				"name":"Sword Damage+",
				"desc":"Increase Sword Damage.",
				"func":function() {
					GameStats._sword_damage += 4;
					GameStats._sword_knockback += 5;
				},
				"linkto":["sword_size_1"]
			},
			
			//row 2
			"bow_accuracy_1": {
				"price":50,
				"icon":Resource.SHOP_ICON_BOW_ACCURACY,
				"name":"Bow Accuracy+",
				"desc":"Increase Bow Accuracy.",
				"func":function() {
					GameStats._bow_focus_factor -= 0.01;
					GameStats._just_used_energy_ct -= 3;
					GameStats._bow_spread_factor -= 0.25;
				},
				"linkto":["bow_damage_2","energy_2"]
			},
			"energy_1": {
				"price":50,
				"icon":Resource.SHOP_ICON_ENERGY,
				"name":"Energy+",
				"desc":"Increase Energy.",
				"func":function() {
					GameStats._max_energy += 200;
				},
				"linkto":["energy_2","health_2"]
			},
			"sword_size_1": {
				"price":50,
				"icon":Resource.SHOP_ICON_SWORD_SIZE,
				"name":"Sword Size+",
				"desc":"Increase sword size and power.",
				"func":function() {
					GameStats._sword_scale = Math.max(GameStats._sword_scale, 1.5);
				},
				"linkto":["health_2","sword_recharge_1"]
			},
			
			//row 3
			"bow_damage_2": {
				"price":50,
				"icon":Resource.SHOP_ICON_BOW_DAMAGE,
				"name":"Bow Damage++",
				"desc":"Increase Bow Damage.",
				"func":function() {
					GameStats._bow_damage += 6;
					GameStats._bow_knockback += 4;
					GameStats._bow_stun += 5;
				},
				"linkto":["more_arrows_1","bow_accuracy_2"]
			},
			"energy_2": {
				"price":50,
				"icon":Resource.SHOP_ICON_ENERGY,
				"name":"Energy++",
				"desc":"Increase Energy.",
				"func":function() {
					GameStats._energy += 400;
				},
				"linkto":["bow_accuracy_2","health_3"]
			},
			"health_2": {
				"price":50,
				"icon":Resource.SHOP_ICON_HEALTH,
				"name":"Health++",
				"desc":"Increase Health.",
				"func":function() {
					GameStats._max_health += 14;	
				},
				"linkto":["health_3","sword_recharge_2"]
			},
			"sword_recharge_1": {
				"price":50,
				"icon":Resource.SHOP_ICON_SWORD_RECHARGE,
				"name":"Sword Recharge+",
				"desc":"Increase Sword Recharge.",
				"func":function() {
					GameStats._sword_just_used_energy_ct -= 15;
				},
				"linkto":["sword_recharge_2","sword_damage_2"]
			},
			
			//row_4
			"more_arrows_1": {
				"price":100,
				"icon":Resource.SHOP_ICON_2ARROW,
				"name":"Arrows+",
				"desc":"More Arrows.",
				"func":function() {
					GameStats._bow_num_arrows += 1;
				},
				"linkto":["more_arrows_2"]
			},
			"bow_accuracy_2": {
				"price":50,
				"icon":Resource.SHOP_ICON_BOW_ACCURACY,
				"name":"Bow Accuracy+",
				"desc":"Increase Bow Accuracy.",
				"func":function() {
					GameStats._bow_focus_factor -= 0.02;
					GameStats._just_used_energy_ct -= 3;
					GameStats._bow_spread_factor -= 0.5;	
				},
				"linkto":["more_arrows_2","hp_regen"]
			},
			"health_3": {
				"price":50,
				"icon":Resource.SHOP_ICON_HEALTH,
				"name":"Health+++",
				"desc":"More Health.",
				"func":function() {
					GameStats._health += 20;
				},
				"linkto":["hp_regen","armor"]
			},
			"sword_recharge_2": {
				"price":50,
				"icon":Resource.SHOP_ICON_SWORD_RECHARGE,
				"name":"Sword Recharge++",
				"desc":"Increase Sword Recharge.",
				"func":function() {
					GameStats._sword_just_used_energy_ct -= 15;	
				},
				"linkto":["armor","sword_size_2"]
			},
			"sword_damage_2": {
				"price":50,
				"icon":Resource.SHOP_ICON_SWORD_DAMAGE,
				"name":"Sword Damage++",
				"desc":"Increase Sword Damage.",
				"func":function() {
					GameStats._sword_damage += 8;
					GameStats._sword_knockback += 8;	
				},
				"linkto":["sword_size_2"]
			},
			
			//row 5
			"more_arrows_2": {
				"price":200,
				"icon":Resource.SHOP_ICON_3ARROW,
				"name":"Arrows++",
				"desc":"More Arrows.",
				"func":function() {
					GameStats._bow_num_arrows += 1;
				}
			},
			"hp_regen": {
				"price":100,
				"icon":Resource.SHOP_ICON_HEALTH_REGEN,
				"name":"HP Regen",
				"desc":"Regenerate Health.",
				"func":function() {
					GameStats._health_regen = 0.25;
				}
			},
			"armor": {
				"price":100,
				"icon":Resource.SHOP_ICON_ARMOR,
				"name":"Armor",
				"desc":"Take Less Damage.",
				"func":function() {
					GameStats._armor_mult = 0.75;
				}
			},
			"sword_size_2": {
				"price":100,
				"icon":Resource.SHOP_ICON_SWORD_SIZE,
				"name":"Sword Size++",
				"desc":"Increase sword size and power.",
				"func":function() {
					GameStats._sword_scale = Math.max(GameStats._sword_scale, 2);	
				}
			}
		};
		
		public function owned_items():Array {
			var rtv:Array = [];
			for (var i in items) if (items[i].owned) rtv.push(i);
			return rtv;
		}
		
		public function own_item(info):Boolean {
			return owned_items().indexOf(info.id) != -1;
		}
		
		public function item_available(info):Boolean {
			var rtv:Boolean = false;
			var owned:Array = owned_items();
			for each (var id in owned) {
				for each (var linkto_id in items[id].linkto) {
					if (info.id == linkto_id) return true;
				}
			}
			return false;
		}
		
		var _buttons:Array = [];
		var _continue:FlxSprite = new FlxSprite(880, 336, Resource.SHOP_CONTINUE);
		
		public var _text_title:FlxText;
		public var _text_desc:FlxText;
		public var _price_disp:FlxText;
		public var _gold_disp:FlxText;
		var _particles:FlxGroup = new FlxGroup();
		
		public override function create():void {
			
			for (var i in items) {
				items[i].id = i;
			}
			Util.play_bgm(Resource.BGM_MAIN);
			
			this.add(new FlxSprite(0, 0, Resource.SHOP_BG));
			
			var text_back:FlxSprite = new FlxSprite(0, 0, Resource.SHOP_TEXT_BACK);
			text_back.alpha = 0.4;
			text_back.set_position(25,250);
			this.add(text_back);
			
			_text_title = Util.cons_text(25+5, 250+5, "Upgrades", 0xFFFFFF, 26);
			this.add(_text_title);
			
			_text_desc = Util.cons_text(25 + 5, 290, "Click a Skill to upgrade!", 0xFFFFFF, 16, 320-10);
			this.add(_text_desc);
			
			_price_disp = Util.cons_text(25 + 5, 360, "Price: 0", 0xFFFFFF, 16, 320 - 10);
			this.add(_price_disp);
			
			_gold_disp = Util.cons_text(25 + 5, 360+24, "Gold: 0", 0xFFFFFF, 25, 320 - 10);
			this.add(_gold_disp);
			
			_buttons.push(new ShopButton(430, 283, items["bow_damage_1"],items));//bow damage
			_buttons.push(new ShopButton(485, 283, items["hp_1"],items));//hp
			_buttons.push(new ShopButton(545, 283, items["sword_damage_1"],items));//sword damage
			
			_buttons.push(new ShopButton(410, 214, items["bow_accuracy_1"],items));//bow acc
			_buttons.push(new ShopButton(490, 214, items["energy_1"],items));//energy
			_buttons.push(new ShopButton(580, 214, items["sword_size_1"],items));//sword size
			
			_buttons.push(new ShopButton(358, 161, items["bow_damage_2"],items));//bow damage
			_buttons.push(new ShopButton(445, 161, items["energy_2"],items));//energy
			_buttons.push(new ShopButton(525, 161, items["health_2"],items));//health
			_buttons.push(new ShopButton(621, 161, items["sword_recharge_1"],items));//sword recharge
			
			_buttons.push(new ShopButton(288, 120, items["more_arrows_1"],items));//2 arrows
			_buttons.push(new ShopButton(396, 107, items["bow_accuracy_2"],items));//bow accuracy
			_buttons.push(new ShopButton(481, 107, items["health_3"],items));//health
			_buttons.push(new ShopButton(569, 107, items["sword_recharge_2"],items));//sword recharge
			_buttons.push(new ShopButton(691, 120, items["sword_damage_2"],items));//sword damage
			
			_buttons.push(new ShopButton(320, 58, items["more_arrows_2"],items));//3 arrows
			_buttons.push(new ShopButton(430, 58, items["hp_regen"],items));//hp regen
			_buttons.push(new ShopButton(520, 58, items["armor"],items));//armor
			_buttons.push(new ShopButton(640, 58, items["sword_size_2"],items));//sword size
			
			for each(var b:ShopButton in _buttons) this.add(b);
			this.add(_continue);
			
			this.add(Util.cons_text(25, 10, "Equip Thyself!", 0xFFFFFF, 30));
			this.add(new FlxSprite(Util.WID*0.65,Util.HEI*0.4,Resource.TOP_KNIGHT));
			
			this.add(_particles);
			
			_fade_cover.makeGraphic(1000, 500, 0xFF000000);
			this.add(_fade_cover);
		}
		
		var _fade_cover:FlxSprite = new FlxSprite();
		var _fadeout:Boolean = false;
		var _fadein:Boolean = true;
		public override function update():void {
			if (_fadein) {
				_fade_cover.alpha -= 0.05;
				if (_fade_cover.alpha <= 0) {
					_fade_cover.alpha = 0;
					_fadein = false;
				}
				
			} else if (_fadeout) {
				_fade_cover.alpha += 0.05;
				if (_fade_cover.alpha >= 1) {
					_fade_cover.alpha = 1;
					_fadeout = false;
					FlxG.switchState(new BottomGame());
					Mouse.cursor = MouseCursor.AUTO;
				}
				return;
			}
			
			for each (var part:BaseParticle in _particles.members) {
				if (part.alive) {
					part._update(null);
					if (part._should_remove()) {
						part._do_remove();
					}
				}
			}
			
			var cursor:Boolean = false;
			for each(var b:ShopButton in _buttons) cursor ||=  b._update(this);
			_gold_disp.text = "Gold: " + GameStats._gold;
			
			if (Util.pt_dist(FlxG.mouse.x,FlxG.mouse.y,_continue.x+40,_continue.y+80) < 60) {
				_continue.set_scale(1.3);
				cursor = true;
				if (FlxG.mouse.justPressed()) {
					_fadeout = true;
					_fade_cover.alpha = 0;
					FlxG.play(Resource.SFX_POWERUP);
				}
			} else {
				_continue.set_scale(1);
			}
			
			if (cursor) {
				Mouse.cursor = MouseCursor.BUTTON;
			} else {
				Mouse.cursor = MouseCursor.AUTO;
			}
		}
		
		public function hover_info(info):void {
			_text_title.text = info.name;
			_text_desc.text = info.desc;
			if (own_item(info)) {
				_price_disp.text = "Owned";
				_gold_disp.color = 0xFFCC00;
				
			} else if (item_available(info)) {
				_price_disp.text = "Price: " + info.price;
				if (info.price > GameStats._gold) {
					_gold_disp.color = 0xFF0000;
				} else {
					_gold_disp.color = 0x00FF00;
				}
				
			} else {
				_price_disp.text = "Locked";
				_gold_disp.color = 0x999999;
			}
		}
		
		public function click_info(info,bx:Number = 0,by:Number = 0):void {
			if (!info.owned && GameStats._gold >= info.price) {
				FlxG.play(Resource.SFX_POWERUP);
				GameStats._gold -= info.price;
				info.owned = true;
				info.func();
				for (var i:int = 0; i < 8; i++)  RotateFadeParticle.cons(_particles).init(bx + Util.float_random( -30, 30), by + Util.float_random( -30, 30)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1, 2)).p_set_delay(Util.float_random(0, 6));
				for each(var b:ShopButton in _buttons) b._update(this);
			}
		}
		
	}

}