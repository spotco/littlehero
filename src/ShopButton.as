package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import player_projectiles.*;
	import enemy.*;
	import particles.*;
	import pickups.*;
	public class ShopButton extends FlxSprite{
		
		public function ShopButton(x:Number, y:Number, info) {
			this.loadGraphic(Resource.SHOP_ICON);
			this.x = x - this.frameWidth/2;
			this.y = y - this.frameHeight/2;
		}
		
		public var _pressed:Boolean = false;
		public function _update():void {
			if (Util.pt_dist(FlxG.mouse.x,FlxG.mouse.y,this.x+30,this.y+30) < 30) {
				this.set_scale(1.3);
				if (FlxG.mouse.justPressed()) {
					this._pressed = true;
				}
			} else {
				this.set_scale(1);
			}
		}
		
	}

}