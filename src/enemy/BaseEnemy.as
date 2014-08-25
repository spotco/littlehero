package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.plugin.photonstorm.FlxCollision;
	public class BaseEnemy extends FlxSprite{
		
		public function get_knockback_mult():Number {
			return 1;
		}
		
		public function hit_player(g:BottomGame):Boolean {
			return g._player._invuln_ct <= 0 && !g._player._sword._sword_invuln && FlxCollision.pixelPerfectCheck(this._hitbox, g._player._body);
		}
		
		public function _update(g:BottomGame):void {
			this.track_healthbar();
		}
		public function _should_kill():Boolean { return false; }
		public function _do_kill(g:BottomGame):void { }
		
		public var _hitbox:FlxSprite = new FlxSprite();
		public var _healthbar:FlxBar;
		
		public var _max_health:Number = 1;
		public var _health:Number = 1;
		public function _hit(g:BottomGame, bow:Boolean = false):void {
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
		
		public function set_center(x:Number, y:Number):void {
			this.get_center();
			var off_x:Number = _get_center.x - this.x, off_y:Number = _get_center.y - this.y;
			this.set_position(x - off_x, y - off_y);
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
		
		
		protected var _hit_wall_top:Boolean = false, _hit_wall_bottom:Boolean = false, _hit_wall_left:Boolean = false, _hit_wall_right:Boolean = false;
		public function hit_wall():Boolean {
			var rtv:Boolean = false;
			_hit_wall_bottom = false;
			_hit_wall_left = false;
			_hit_wall_right = false;
			_hit_wall_top = false;
			if (this.get_center().x < 0) {
				this.set_center(0, this.get_center().y);
				_hit_wall_left = true;
				rtv = true;
			}
			if (this.get_center().x > Util.WID) {
				this.set_center(Util.WID, this.get_center().y);
				_hit_wall_right = true;
				rtv = true;
			}
			if (this.get_center().y < 0) {
				this.set_center(this.get_center().x, 0);
				_hit_wall_top = true;;
				rtv = true;
			}
			if (this.get_center().y > Util.HEI) {
				this.set_center(this.get_center().x, Util.HEI);
				_hit_wall_bottom = true;
				rtv = true;
			}
			return rtv;
		}
		
		public function _knockback(dx:Number, dy:Number, invuln_ct:Number, knockback:Number = 14, stun_ct:Number = 0):void {
			var dv:Vector3D = Util.normalized(dx, dy);
			dv.scaleBy(knockback * this.get_knockback_mult());
			_vx = dv.x;
			_vy = dv.y;
			_invuln_ct = invuln_ct;
			_stun_ct = stun_ct;
		}
		
		public function _arrow_stun_mult():Number { return 1; }
		public function _arrow_damage_mult():Number { return 1; }
		public function _sword_damage_mult():Number { return 1; }
	}

}