package player_projectiles {
	import flash.geom.Vector3D;
	import misc.FlxGroupSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.FlxG;
	import enemy.BaseEnemy;
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
			
			_last_mouse_x = FlxG.mouse.x;
			_last_mouse_y = FlxG.mouse.y;
			
			return this;
		}
		
		var _last_mouse_x:Number, _last_mouse_y:Number, _hold_sword_ct:Number = 0;
		
		public override function _update(g:BottomGame):void {
			var v:Vector3D = Util.normalized(FlxG.mouse.x - g._player.get_center().x, FlxG.mouse.y - g._player.get_center().y);
			v.scaleBy(this.frameHeight / 2);
			
			this.x = this._follow._x + offset.x - this.frameWidth/2 + g._player._body.frameWidth/2 + v.x;
			this.y = this._follow._y + offset.y - this.frameHeight/2 + g._player._body.frameHeight / 2 + v.y;
			
			if (Util.point_dist(_last_mouse_x, _last_mouse_y, FlxG.mouse.x, FlxG.mouse.y) > 40) {
				this.alpha = 1;
				this._hold_sword_ct = 1;
			} else {
				if (this._hold_sword_ct > 0) {
					this._hold_sword_ct--;
				} else if (this.alpha > 0) {
					this.alpha -= 0.05;
				}
			}
			
			this.angle = _follow._angle;
			this._ct--;
			for each (var enem:BaseEnemy in g._enemies.members) {
				if (enem.alive && enem._invuln_ct <= 0 && FlxCollision.pixelPerfectCheck(this,enem)) {
					enem.hit(enem.x - g._player.get_center().x, enem.y - g._player.get_center().y, 50);
				}
			}
			
			_last_mouse_x = FlxG.mouse.x;
			_last_mouse_y = FlxG.mouse.y;
		}
		
		public override function _should_remove():Boolean {
			return false;
		}
		
		public override function _do_remove():void {
			this.kill();
		}
		
	}

}