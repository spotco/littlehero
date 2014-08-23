package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
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
			this.makeGraphic(40, 40, 0xFF0000FF);
			//this.loadGraphic(Resource.SPIDER);
		}
		
		var _state:int = 0;
		var _ct:Number = 0;
		var _tar_pos:FlxPoint = new FlxPoint(0, 0);
		public function init(x:Number,y:Number):TinySpiderEnemy {
			this.reset(x, y);
			_state = 0;
			_ct = 20;
			return this;
		}
		
		public override function _update(g:BottomGame):void {
			if (this._invuln_ct > 0) {
				this.invuln_update();
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
		public override function _should_remove():Boolean { 
			return false; 
		}
		public override function _do_remove():void {
			this.kill();
		}
		
	}

}