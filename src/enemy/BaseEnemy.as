package enemy {
	import flash.geom.Vector3D;
	import org.flixel.FlxSprite;
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
		}
		
		public function track_healthbar():void {
			if (_healthbar)_healthbar.trackParent(0, 0);
		}
		
		public var _vx:Number = 0, _vy:Number = 0;
		public var _invuln_ct:Number = 0;
		public function invuln_update():void {
			this.x += _vx;
			
			this.y += _vy;
			_vx *= 0.98;
			_vy *= 0.98;
			_invuln_ct--;
			this.alpha = Math.floor(_invuln_ct / 5) % 2 == 0?1:0.5;
		}
		
		public function _knockback(dx:Number, dy:Number, ct:Number) {
			var dv:Vector3D = Util.normalized(dx, dy);
			dv.scaleBy(14);
			_vx = dv.x;
			_vy = dv.y;
			_invuln_ct = ct;
		}
	}

}