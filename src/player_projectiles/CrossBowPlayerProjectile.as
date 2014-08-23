package player_projectiles {
	import flash.geom.Vector3D;
	import misc.FlxGroupSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.FlxG;
	import enemy.BaseEnemy;
	
	public class CrossBowPlayerProjectile extends BasePlayerProjectile{
		
		public static function cons(g:FlxGroup):CrossBowPlayerProjectile {
			var rtv:CrossBowPlayerProjectile = g.getFirstAvailable(CrossBowPlayerProjectile) as CrossBowPlayerProjectile;
			if (rtv == null) {
				rtv = new CrossBowPlayerProjectile();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function CrossBowPlayerProjectile() {
			super();
			this.loadGraphic(Resource.CROSSBOW);
		}
		
		var _follow:Player;
		public function init(follow:Player):CrossBowPlayerProjectile {
			_follow = follow;
			this.reset(_follow._x, _follow._y);
			return this;
		}
		
		public override function _update(g:BottomGame):void {
			var v:Vector3D = Util.normalized(FlxG.mouse.x - g._player.get_center().x, FlxG.mouse.y - g._player.get_center().y);
			v.scaleBy(this.frameHeight / 2);
			
			var offset_left:Vector3D = Util.Z_VEC.crossProduct(v);
			offset_left.normalize();
			offset_left.scaleBy( -15);
			
			this.x = this._follow._x - this.frameWidth/2 + g._player._body.frameWidth/2 + v.x + offset_left.x;
			this.y = this._follow._y - this.frameHeight / 2 + g._player._body.frameHeight / 2 + v.y + offset_left.y;
			this.angle = _follow._angle;
			
			if (FlxG.mouse.pressed()) {
				this.alpha = 1;
			} else {
				if (this.alpha > 0) {
					this.alpha -= 0.05;
				}
			}
			
			if (FlxG.mouse.justReleased()) {
				var dv:Vector3D = new Vector3D(FlxG.mouse.x - g._player.get_center().x, FlxG.mouse.y - g._player.get_center().y);
				dv.normalize();
				dv.scaleBy(10);
				ArrowPlayerProjectile.cons(g._player_projectiles).init(this.x, this.y, dv.x, dv.y);
			}
		}
		
	}

}