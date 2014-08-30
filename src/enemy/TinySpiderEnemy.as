package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	
	public class TinySpiderEnemy extends BaseEnemy{
		
		public static function cons(g:FlxGroup):TinySpiderEnemy {
			var rtv:TinySpiderEnemy = g.getFirstAvailable(TinySpiderEnemy) as TinySpiderEnemy;
			if (rtv == null) {
				rtv = new TinySpiderEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function TinySpiderEnemy() {
			super();
			this.loadGraphic(Resource.EYEDER_SS, true, false, 71, 70);
			this.addAnimation("walk", [0, 1], 20);
			this.addAnimation("stand", [0], 0);
			_hitbox.loadGraphic(Resource.EYEDER_HITBOX);
			
		}
		
		var _state:int = 0;
		var _ct:Number = 0;
		var _tar_pos:FlxPoint = new FlxPoint(0, 0);
		public function init(x:Number,y:Number, g:BottomGame):TinySpiderEnemy {
			this.reset(x, y);
			this.play("walk");
			this.set_scale(0.5);
			_hitbox.set_scale(0.5);
			
			_state = 0;
			_ct = 20;
			g._hitboxes.add(_hitbox);
			this._max_health = 14;
			this._health = 14;
			
			RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random( -20, 20), this.get_center().y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random( -20, 20), this.get_center().y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,2));
			RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random(-20,20), this.get_center().y + Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,4));
			
			return this;
		}
		
		public override function track_healthbar():void {
			if (_healthbar)_healthbar.trackParent(30, 0);
		}
		
		public override function _update(g:BottomGame):void {
			super._update(g);
			
			_hitbox.x = this.x + 15;
			_hitbox.y = this.y + 15;
			if (this._invuln_ct > 0) {
				this.invuln_update();
				_state = 0;
				_ct = 30;
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
			
			if (_state == 0) {
				_ct--;
				this.play("stand");
				if (_ct <= 0) _state = 1;
			
			} else if (_state == 1) {
				var dp:Vector3D = Util.normalized(g._player._x - this.x, g._player._y - this.y);
				dp.scaleBy(20);
				this.play("walk");
				_tar_pos.x = this.x + Util.float_random( -80, 80) + dp.x;
				_tar_pos.y = this.y + Util.float_random( -80, 80) + dp.y;
				
				var v:Vector3D = Util.normalized(_tar_pos.x - this.x, _tar_pos.y - this.y);
				this.angle = Util.pt_to_flxrotation(v.x, v.y) + 90;
				
				_state = 2;
				
			} else if (_state == 2) {
				this.play("walk");
				var spd:Number = 5;
				if (Util.pt_dist(this.x, this.y, _tar_pos.x, _tar_pos.y) < spd + 0.1) {
					_state = 0;
					_ct = 20;
				} else {
					var dv:Vector3D = Util.normalized(_tar_pos.x - this.x, _tar_pos.y - this.y);
					dv.scaleBy(spd);
					this.x += dv.x;
					this.y += dv.y;
					if (this.hit_wall()) {
						_state = 0;
						_ct = 20;
					}
				}
			}
		}
		public override function _should_kill():Boolean { 
			return _health <= 0
		}
		public override function _do_kill(g:BottomGame):void {
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random( -20, 20), this.y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random( -20, 20), this.y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(5,10));
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random(-20,20), this.y+ Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(5,10));
			
			for (var i:int = 0; i < 3; i++) {
				if (Util.float_random(0, SmallFollowPickup._HEALTH_SPAWN) < 1) {
					SmallFollowPickup.cons(g._pickups).init(this.get_center().x,this.get_center().y,1,1);
				} else {
					SmallFollowPickup.cons(g._pickups).init(this.get_center().x,this.get_center().y,1,0);
				}
			}
			FlxG.play(Resource.SFX_EXPLOSION);
			
			this.kill();
			this._kill(g);
			
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x + 35;
			_get_center.y = this.y + 35;
			return _get_center;
		}
		
		public override function get_knockback_mult():Number {
			return 3;
		}
		
	}

}