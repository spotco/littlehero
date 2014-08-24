package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	public class BulletEnemy extends BaseEnemy {
		
		public static function cons(g:FlxGroup):BulletEnemy {
			var rtv:BulletEnemy = g.getFirstAvailable(BulletEnemy) as BulletEnemy;
			if (rtv == null) {
				rtv = new BulletEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function BulletEnemy() {
			super();
			this.loadGraphic(Resource.BULLET);
			_hitbox.loadGraphic(Resource.BULLET);
		}
		
		var _ct:Number = 0;
		public function init(x:Number,y:Number,vx:Number, vy:Number, ct:Number, g:BottomGame):BulletEnemy {
			this.reset(x, y);
			_vx = vx;
			_vy = vy;
			_ct = ct;
			g._hitboxes.add(_hitbox);
			this._max_health = 1;
			this._health = 1;
			return this;
		}
		
		public override function _update(g:BottomGame):void {
			super._update(g);
			this.x += _vx;
			this.y += _vy;
			_ct--;
			_hitbox.x = this.x;
			_hitbox.y = this.y;
			if (this.hit_player(g)) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(15);
				g._player.hit(v.x, v.y, 1);
				FlxG.shake(0.01, 0.15);
				this._health = 0;
			}
		}
		
		public override function _hit(g:BottomGame):void {}
		public override function _kill(g:BottomGame):void {}
		
		public override function _should_kill():Boolean { 
			return _health <= 0 || _ct < 0;
		}
		public override function _do_kill(g:BottomGame):void {			
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random( -20, 20), this.y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			this.kill();
			this._kill(g);
			
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x;
			_get_center.y = this.y;
			return _get_center;
		}
		
		public override function _knockback(dx:Number, dy:Number, invuln_ct:Number, knockback:Number = 14, stun_ct:Number = 0):void {
			
		}
		
	}

}