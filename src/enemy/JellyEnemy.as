package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	public class JellyEnemy extends BaseEnemy {
		
		public static function cons(g:FlxGroup):JellyEnemy {
			var rtv:JellyEnemy = g.getFirstAvailable(JellyEnemy) as JellyEnemy;
			if (rtv == null) {
				rtv = new JellyEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function JellyEnemy() {
			super();
			this.loadGraphic(Resource.BLOB_SS, true, false, 100, 100);
			this.addAnimation("walk", [0, 1, 2, 3, 4, 5, 6], 10);
			this.addAnimation("stand", [0], 0);
			_hitbox.loadGraphic(Resource.BLOB_HITBOX);
			
		}
		
		public function init(x:Number,y:Number, g:BottomGame):JellyEnemy {
			this.reset(x, y);
			this.play("walk");
			
			g._hitboxes.add(_hitbox);
			this._max_health = 36;
			this._health = 36;
			return this;
		}
		
		public override function track_healthbar():void {
			if (_healthbar)_healthbar.trackParent(30, 0);
		}
		
		public override function _update(g:BottomGame):void {
			super._update(g);
			_hitbox.x = this.x + 25;
			_hitbox.y = this.y + 25;
			if (this._invuln_ct > 0) {
				this.invuln_update();
				this.color = 0xCC99FF;
				return;
			} else if (this._stun_ct > 0) {
				this.stun_update();
				this.color = 0xCC99FF;
				return;
			}
			this.color = 0xFFFFFF;
			if (this.hit_player(g)) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(15);
				g._player.hit(v.x, v.y, 1);
				FlxG.shake(0.01, 0.15);
			}
		}
		
		public override function _should_kill():Boolean { 
			return _health <= 0
		}
		public override function _do_kill(g:BottomGame):void {
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random( -20, 20), this.y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random( -20, 20), this.y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(5,10));
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random(-20,20), this.y+ Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(5,10));
			
			SmallFollowPickup.cons(g._pickups).init(this.x,this.y);
			SmallFollowPickup.cons(g._pickups).init(this.x,this.y);
			SmallFollowPickup.cons(g._pickups).init(this.x,this.y);
			
			this.kill();
			this._kill(g);
			
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x + 35;
			_get_center.y = this.y + 35;
			return _get_center;
		}
		
		public override function get_knockback_mult():Number {
			return 1;
		}
		
	}

}