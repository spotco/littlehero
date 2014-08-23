package player_projectiles {
	import org.flixel.*;
	import enemy.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	public class ArrowPlayerProjectile extends BasePlayerProjectile {
		
		public static function cons(g:FlxGroup):ArrowPlayerProjectile {
			var rtv:ArrowPlayerProjectile = g.getFirstAvailable(ArrowPlayerProjectile) as ArrowPlayerProjectile;
			if (rtv == null) {
				rtv = new ArrowPlayerProjectile();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function ArrowPlayerProjectile() {
			super();
			this.makeGraphic(5, 5, 0xFF0000FF);
		}
		
		var _vx:Number = 0, _vy:Number = 0, _ct:Number = 0;
		public function init(x:Number, y:Number, vx:Number, vy:Number):ArrowPlayerProjectile {
			this.reset(x, y);
			_vx = vx;
			_vy = vy;
			_ct = 300;
			return this;
		}
		
		public override function _update(g:BottomGame):void {
			this.x += _vx;
			this.y += _vy;
			
			for each (var enem:BaseEnemy in g._enemies.members) {
				if (enem.alive && enem._invuln_ct <= 0 && FlxCollision.pixelPerfectCheck(this,enem)) {
					enem.hit(enem.x - g._player.get_center().x, enem.y - g._player.get_center().y, 10);
					this._ct = 0;
				}
			}
			this._ct--;
		}
		
		public override function _should_remove():Boolean { return _ct <= 0; }
		public override function _do_remove():void { this.kill(); }
		
	}

}