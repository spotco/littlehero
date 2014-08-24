package player_projectiles {
	import org.flixel.*;
	import enemy.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import particles.*;
	
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
			this.loadGraphic(Resource.ARROW);
		}
		
		var _hitbox:FlxSprite = new FlxSprite(0, 0, Resource.ARROW_HITBOX);
		var _vx:Number = 0, _vy:Number = 0, _ct:Number = 0;
		public function init(x:Number, y:Number, vx:Number, vy:Number, ct:Number, g:BottomGame):ArrowPlayerProjectile {
			this.reset(x, y);
			_vx = vx;
			_vy = vy;
			this.angle = Util.pt_to_flxrotation(_vx, _vy) - 90;
			this.setOriginToCorner();
			_ct = ct;
			
			g._hitboxes.add(_hitbox);
			_hitbox.setOriginToCorner();
			
			return this;
		}
		
		public override function _update(g:BottomGame):void {
			this.x += _vx;
			this.y += _vy;
			
			_hitbox.x = this.x;
			_hitbox.y = this.y;
			_hitbox.angle = this.angle;
			
			for each (var enem:BaseEnemy in g._enemies.members) {
				if (enem.alive && enem._invuln_ct <= 0 && FlxCollision.pixelPerfectCheck(this,enem._hitbox)) {
					enem._knockback(enem.x - g._player.get_center().x, enem.y - g._player.get_center().y, 10);
					this._ct = 0;
					enem._hit(g);
					enem._health -= 1;
					RotateFadeParticle.cons(g._particles).init(enem.x, enem.y).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1,1.3));
				}
			}
			this._ct--;
		}
		
		public override function _should_remove():Boolean { return _ct <= 0; }
		public override function _do_remove():void { this.kill(); }
		
	}

}