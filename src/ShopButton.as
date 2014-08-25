package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import player_projectiles.*;
	import enemy.*;
	import particles.*;
	import pickups.*;
	public class ShopButton extends FlxSprite{
		
		var _info;
		var _items;
		public function ShopButton(x:Number, y:Number, info, items) {
			this.loadGraphic(Resource.SHOP_ICON);
			this.x = x - this.frameWidth/2;
			this.y = y - this.frameHeight / 2;
			_info = info;
			_items = items;
			this.color = 0x888888;
			this.set_scale(0.4);
			this.alpha = 0.6;
		}
		
		public function mouse_over():Boolean {
			return Util.pt_dist(FlxG.mouse.x, FlxG.mouse.y, this.x + 30, this.y + 30) < 20;
		}
		
		public function _update(shop:ShopState):Boolean {
			
			if (shop.own_item(_info)) {
				this.color = 0xFFFFCC;
				this.set_scale(0.7);
				this.alpha = 0.7;
				if (mouse_over()) {
					shop.hover_info(_info);
					this.alpha = 0.8;
					this.set_scale(0.8);
				}
				
			} else if (shop.item_available(_info)) {
				this.color = 0xFFFFFF;
				this.set_scale(1);
				this.alpha = 1;
				if (mouse_over()) {
					if (FlxG.mouse.justPressed()) {
						shop.click_info(_info);
					} else {
						shop.hover_info(_info);
					}
					this.set_scale(1.3);
				}
				
			} else {
				this.color = 0x888888;
				this.set_scale(0.4);
				this.alpha = 0.6;
				if (mouse_over()) {
					this.set_scale(0.6);
					this.alpha = 0.8;
					shop.hover_info(_info);
				}	
			}
			return this.mouse_over();
		}
		
	}

}