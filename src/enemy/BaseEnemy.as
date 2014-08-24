package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	public class BaseEnemy extends FlxSprite{
		
		public function _update(g:BottomGame):void {
			this.track_healthbar();
		}
		public function _should_kill():Boolean { return false; }
		public function _do_kill(g:BottomGame):void { }
		
		public var _hitbox:FlxSprite = new FlxSprite();
		public var _healthbar:FlxBar;
		
		public var _max_health:Number = 1;
		public var _health:Number = 1;
		public function _hit(g:BottomGame):void {
			if (this._health > 0 && _healthbar == null) {
				_healthbar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 30, 4, this, "_health", 0, this._max_health);
				g._healthbars.add(_healthbar);
			}
		}
		
		public function _kill(g:BottomGame):void {
			g._healthbars.remove(_healthbar);
			_healthbar = null;
			FlxG.shake(0.01, 0.1);
			BottomGame._freeze_frame = 6;
		}
		
		public function track_healthbar():void {
			if (_healthbar)_healthbar.trackParent(0, 0);
		}
		
		public var _get_center:FlxPoint = new FlxPoint();
		public function get_center():FlxPoint {
			_get_center.x = this.x;
			_get_center.y = this.y;
			return _get_center;
		}
		
		public var _vx:Number = 0, _vy:Number = 0;
		public var _invuln_ct:Number = 0;
		public var _stun_ct:Number = 0;
		public function invuln_update():void {
			this.x += _vx;
			this.y += _vy;
			if (this.hit_wall()) {
				_health -= GameStats._knockback_damage;;
				_vx = 0;
				_vy = 0;
				_invuln_ct = 0;
				this.alpha = 1;
				FlxG.shake(0.01, 0.15);
				BottomGame._freeze_frame = 6;
				
			} else {
				_vx *= 0.96;
				_vy *= 0.96;
				_invuln_ct--;
				this.alpha = Math.floor(_invuln_ct / 5) % 2 == 0?1:0.5;
			}
		}
		
		public function stun_update():void {
			_stun_ct--;
		}
		
		
		private function hit_wall():Boolean {
			var rtv:Boolean = false;
			this.get_center();
			if (this._get_center.x < 0) {
				this.x = 0;
				rtv = true;
			}
			if (this._get_center.x > Util.WID) {
				this.x = Util.WID;
				rtv = true;
			}
			if (this._get_center.y < 0) {
				this.y = 0;
				rtv = true;
			}
			if (this._get_center.y > Util.HEI-50) {
				this.y = Util.HEI-50;
				rtv = true;
			}
			return rtv;
		}
		
		public function _knockback(dx:Number, dy:Number, invuln_ct:Number, knockback:Number = 14, stun_ct:Number = 0) {
			var dv:Vector3D = Util.normalized(dx, dy);
			dv.scaleBy(knockback);
			_vx = dv.x;
			_vy = dv.y;
			_invuln_ct = invuln_ct;
			_stun_ct = stun_ct;
		}
	}

}