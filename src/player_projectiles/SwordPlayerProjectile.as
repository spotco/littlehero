package player_projectiles {
	import flash.geom.Vector3D;
	import misc.FlxGroupSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	public class SwordPlayerProjectile extends BasePlayerProjectile {
		
		public static function cons(g:FlxGroup):SwordPlayerProjectile {
			var rtv:SwordPlayerProjectile = g.getFirstAvailable(SwordPlayerProjectile) as SwordPlayerProjectile;
			if (rtv == null) {
				rtv = new SwordPlayerProjectile();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function SwordPlayerProjectile() {
			super();
			this.loadGraphic(Resource.SWORD);
		}
		
		var _follow:Player;
		var _ct:Number = 0;
		public function init(follow:Player):SwordPlayerProjectile {
			this.reset(follow._x, follow._y);
			this._follow = follow;
			this._ct = 10;
			return this;
		}
		
		public override function _update():void {
			var rtv:FlxPoint = Util.flxrotation_to_pt(_follow._angle);
			var offset:Vector3D = Util.normalized(rtv.x, rtv.y);
			offset.scaleBy(-10);
			
			
			this.x = this._follow._x + offset.x - 20;
			this.y = this._follow._y + offset.y - 20;
			this.angle = _follow._angle;
			this._ct--;
		}
		
		public override function _should_remove():Boolean {
			return this._ct <= 0;
		}
		
		public override function _do_remove():void {
			this.kill();
		}
		
	}

}