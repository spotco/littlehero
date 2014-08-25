package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import player_projectiles.*;
	import enemy.*;
	import particles.*;
	import pickups.*;
	public class ShopState extends FlxState {
		
		var items = {
			//row 1
			"bow_damage_1": {
				"price":100,
				"name":"Bow Damage+",
				"desc":"Increase Bow Damage.",
				"func":function() {}
			},
			"hp_1": {
				"price":100,
				"name":"HP+",
				"desc":"Increase HP.",
				"func":function() {}
			},
			"sword_damage_1": {
				"price":100,
				"name":"Sword Damage+",
				"desc":"Increase Sword Damage",
				"func":function() {}
			},
			
			//row 2
			"bow_accuracy_1": {
				"price":100,
				"name":"Bow Accuracy+",
				"desc":"Increase Bow Accuracy.",
				"func":function() {}
			},
			"energy_1": {
				"price":100,
				"name":"Energy+",
				"desc":"Increase Energy",
				"func":function() {}
			},
			"sword_size_1": {
				"price":100,
				"name":"Sword+",
				"desc":"Increase Sword Power.",
				"func":function() {}
			},
			
			//row 3
			"bow_damage_2": {
				"price":100,
				"name":"Bow Damage++",
				"desc":"Increase Bow Damage",
				"func":function() {}
			},
			"energy_2": {
				"price":100,
				"name":"Energy++",
				"desc":"Increase Energy.",
				"func":function() {}
			},
			"health_2": {
				"price":100,
				"name":"Health++",
				"desc":"Increase Health",
				"func":function() {}
			},
			"sword_recharge_1": {
				"price":100,
				"name":"Sword Recharge+",
				"desc":"Increase Sword Recharge.",
				"func":function() {}
			},
			
			//row_4
			"more_arrows_1": {
				"price":100,
				"name":"ArrowS+",
				"desc":"More Arrows.",
				"func":function() {}
			},
			"bow_accuracy_2": {
				"price":100,
				"name":"Arrows+",
				"desc":"More Arrows.",
				"func":function() {}
			},
			"health_3": {
				"price":100,
				"name":"Health+++",
				"desc":"More Health.",
				"func":function() {}
			},
			"sword_recharge_2": {
				"price":100,
				"name":"Sword Recharge++",
				"desc":"Increase Sword Recharge.",
				"func":function() {}
			},
			"sword_damage_2": {
				"price":100,
				"name":"Sword Damage++",
				"desc":"Increase Sword Damage.",
				"func":function() {}
			},
			
			//row 5
			"more_arrows_2": {
				"price":100,
				"name":"Arrows++",
				"desc":"More Arrows.",
				"func":function() {}
			},
			"hp_regen": {
				"price":100,
				"name":"HP Regen",
				"desc":"Regenerate Health.",
				"func":function() {}
			},
			"armor": {
				"price":100,
				"name":"Armor",
				"desc":"Take Less Damage",
				"func":function() {}
			},
			"sword_size_2": {
				"price":100,
				"name":"Sword Size++",
				"desc":"Bigger Sword",
				"func":function() {}
			}
		};
		
		var _buttons:Array = [];
		
		public override function create():void {
			this.add(new FlxSprite(0, 0, Resource.SHOP_BG));
			
			_buttons.push(new ShopButton(430, 283, items["bow_damage_1"]));//bow damage
			_buttons.push(new ShopButton(485, 283, items["hp_1"]));//hp
			_buttons.push(new ShopButton(545, 283, items["sword_damage_1"]));//sword damage
			
			_buttons.push(new ShopButton(410, 214, items["bow_accuracy_1"]));//bow acc
			_buttons.push(new ShopButton(490, 214, items["energy_1"]));//energy
			_buttons.push(new ShopButton(580, 214, items["sword_size_1"]));//sword size
			
			_buttons.push(new ShopButton(358, 161, items["bow_damage_2"]));//bow damage
			_buttons.push(new ShopButton(445, 161, items["energy_2"]));//energy
			_buttons.push(new ShopButton(525, 161, items["health_2"]));//health
			_buttons.push(new ShopButton(621, 161, items["sword_recharge_1"]));//sword recharge
			
			_buttons.push(new ShopButton(288, 120, items["more_arrows_1"]));//2 arrows
			_buttons.push(new ShopButton(396, 107, items["bow_accuracy_2"]));//bow accuracy
			_buttons.push(new ShopButton(481, 107, items["health_3"]));//health
			_buttons.push(new ShopButton(569, 107, items["sword_recharge_2"]));//sword recharge
			_buttons.push(new ShopButton(691, 120, items["sword_damage_2"]));//sword damage
			
			_buttons.push(new ShopButton(320, 58, items["more_arrows_2"]));//3 arrows
			_buttons.push(new ShopButton(430, 58, items["hp_regen"]));//hp regen
			_buttons.push(new ShopButton(520, 58, items["armor"]));//armor
			_buttons.push(new ShopButton(640, 58, items["sword_size_2"]));//sword size
			
			for each(var b:ShopButton in _buttons) this.add(b);
		}
		
		public override function update():void {
			for each(var b:ShopButton in _buttons) b._update();
		}
		
	}

}