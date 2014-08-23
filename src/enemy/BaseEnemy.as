package enemy {
	import flash.geom.Vector3D;
	import org.flixel.FlxSprite;
	public class BaseEnemy extends FlxSprite{
		
		public function _update(g:BottomGame):void { }
		public function _should_remove():Boolean { return true; }
		public function _do_remove():void { }
		
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
		
		public function hit(dx:Number, dy:Number, ct:Number) {
			var dv:Vector3D = Util.normalized(dx, dy);
			dv.scaleBy(14);
			_vx = dv.x;
			_vy = dv.y;
			_invuln_ct = ct;
		}
	}

}