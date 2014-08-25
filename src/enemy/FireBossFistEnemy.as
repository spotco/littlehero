package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	
	public class FireBossFistEnemy extends BaseEnemy{
		
		public static function cons(g:FlxGroup):FireBossFistEnemy {
			var rtv:FireBossFistEnemy = g.getFirstAvailable(FireBossFistEnemy) as FireBossFistEnemy;
			if (rtv == null) {
				rtv = new FireBossFistEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function FireBossFistEnemy() {
			super();
			this.loadGraphic(Resource.FIREBOSS_FIST, true, false, 76, 238);
			this.addAnimation("stand", [0], 20);
			_hitbox.loadGraphic(Resource.FIREBOSS_FIST_HITBOX);
			
		}
		
		var _follow:FireBossEnemy;
		var _offset:Number;
		
		public function init(x:Number,y:Number, g:BottomGame, follow:FireBossEnemy, offset:Number):FireBossFistEnemy {
			this.reset(x, y);
			this.play("stand");
			g._hitboxes.add(_hitbox);
			this._max_health = 35;
			this._health = 35;
			
			_follow = follow;
			_offset = offset;
			
			
			_initial = 3;
			return this;
		}
		
		public override function track_healthbar():void {
			if (_healthbar)_healthbar.trackParent(30, 60);
		}
		
		var _initial:Number = 0;
		public override function _update(g:BottomGame):void {
			super._update(g);
			_hitbox.x = this.x + this.frameWidth/2 - _hitbox.frameWidth/2;
			_hitbox.y = this.y + this.frameHeight / 2 - _hitbox.frameHeight / 2;
			
			this.set_center(_follow.get_center().x + Math.cos(_follow._theta+_offset) * 150, _follow.get_center().y + Math.sin(_follow._theta+_offset) * 150);
			this.angle = Util.pt_to_flxrotation(-Math.sin(_follow._theta+_offset - 3.14/2),Math.cos(_follow._theta+_offset - 3.14/2));
			
			if (_initial > 0) {
				_initial--;
				if (_initial == 0) {
					RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random( -20, 20), this.get_center().y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
					RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random( -20, 20), this.get_center().y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,2));
					RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random(-20,20), this.get_center().y + Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,4));
					RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random(-20,20), this.get_center().y + Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,4));
				}
			}
			
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
			
			_follow.fist_notify_death(this);
			_follow = null;
			
			this.kill();
			this._kill(g);
			
		}
		
		public override function _knockback(dx:Number, dy:Number, invuln_ct:Number, knockback:Number = 14, stun_ct:Number = 0):void {
			var dv:Vector3D = Util.normalized(dx, dy);
			dv.scaleBy(knockback * this.get_knockback_mult());
			_vx = dv.x;
			_vy = dv.y;
			_invuln_ct = Math.min(5,invuln_ct);
			_stun_ct = Math.min(5,stun_ct);
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = _hitbox.x + 32;
			_get_center.y = _hitbox.y + 29;
			return _get_center;
		}
		
		public override function get_knockback_mult():Number {
			return 1;
		}
		
		public override function _sword_damage_mult():Number { return 3; }
		
	}

}