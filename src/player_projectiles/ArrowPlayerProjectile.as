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
		var _vx:Number = 0, _vy:Number = 0, _ct:Number = 0, _mult:Number = 0;
		public function init(x:Number, y:Number, vx:Number, vy:Number, ct:Number, g:BottomGame, mult:Number = 1):ArrowPlayerProjectile {
			this.reset(x, y);
			_vx = vx;
			_vy = vy;
			_mult = mult;
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
					enem._knockback(enem.x - g._player.get_center().x, enem.y - g._player.get_center().y, Math.floor(5 * enem._arrow_stun_mult()), GameStats._bow_knockback * enem._arrow_stun_mult(), GameStats._bow_stun * enem._arrow_stun_mult());
					this._ct = 0;
					enem._hit(g);
					enem._health -= GameStats._bow_damage * _mult;
					RotateFadeParticle.cons(g._particles).init(enem.get_center().x, enem.get_center().y).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1, 1.3));
					FlxG.shake(0.005, 0.035);
					BottomGame._freeze_frame = 3;
				}
			}
			this._ct--;
		}
		
		public override function _should_remove():Boolean { return _ct <= 0; }
		public override function _do_remove():void { this.kill(); }
		
	}

}