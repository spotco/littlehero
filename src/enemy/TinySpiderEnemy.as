package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	
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
			this.loadGraphic(Resource.BLOB_SS, true, false, 100, 100);
			this.addAnimation("walk", [0, 1, 2,3,4,5,6], 10);
			
			_hitbox.loadGraphic(Resource.BLOB_HITBOX);
			
		}
		
		var _state:int = 0;
		var _ct:Number = 0;
		var _tar_pos:FlxPoint = new FlxPoint(0, 0);
		public function init(x:Number,y:Number, g:BottomGame):TinySpiderEnemy {
			this.reset(x, y);
			this.play("walk");
			this.set_scale(Util.float_random(0.85,1.05));
			_state = 0;
			_ct = 20;
			g._hitboxes.add(_hitbox);
			this._max_health = 30;
			this._health = 30;
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
				_state = 0;
				_ct = 30;
				return;
			} else if (this._stun_ct > 0) {
				this.stun_update();
				return;
			}
			
			if (_state == 0) {
				_ct--;
				if (_ct <= 0) _state = 1;
			
			} else if (_state == 1) {
				var dp:Vector3D = Util.normalized(g._player._x - this.x, g._player._y - this.y);
				dp.scaleBy(30);
				
				_tar_pos.x = this.x + Util.float_random( -50, 50) + dp.x;
				_tar_pos.y = this.y + Util.float_random( -50, 50) + dp.y;
				_state = 2;
				
			} else if (_state == 2) {
				var spd:Number = 5;
				if (Util.pt_dist(this.x, this.y, _tar_pos.x, _tar_pos.y) < spd + 0.1) {
					_state = 0;
					_ct = 20;
				} else {
					var dv:Vector3D = Util.normalized(_tar_pos.x - this.x, _tar_pos.y - this.y);
					dv.scaleBy(spd);
					this.x += dv.x;
					this.y += dv.y;
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
			
			this.kill();
			this._kill(g);
			
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x + 35;
			_get_center.y = this.y + 35;
			return _get_center;
		}
		
	}

}