package particles {
	import flash.geom.Vector3D;
	import misc.FlxGroupSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.FlxG;
	import enemy.BaseEnemy;
	
	public class ArrowReticuleUIParticle extends BaseParticle {
		
		public static function cons(g:FlxGroup):ArrowReticuleUIParticle {
			var rtv:ArrowReticuleUIParticle = g.getFirstAvailable(ArrowReticuleUIParticle) as ArrowReticuleUIParticle;
			if (rtv == null) {
				rtv = new ArrowReticuleUIParticle();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function ArrowReticuleUIParticle() {
			super();
			this.loadGraphic(Resource.ARROW_RETICULE);
		}
		
		var _follow:Player;
		var _plus:Boolean;
		var _ang:Number = 45;
		public function init(follow:Player, plus:Boolean):ArrowReticuleUIParticle {
			_follow = follow;
			_plus = plus;
			_ang = 45;
			return this;
		}
		
		public override function _update(g:BottomGame):void {
			var offset_forward:Vector3D = Util.normalized(FlxG.mouse.x - g._player.get_center().x, FlxG.mouse.y - g._player.get_center().y);
			offset_forward.scaleBy(30);
			
			var offset_left:Vector3D = Util.Z_VEC.crossProduct(offset_forward);
			offset_left.normalize();
			offset_left.scaleBy( -15);
			
			this.x = _follow._x - this.frameWidth/2 + g._player._body.frameWidth/2 + offset_left.x + offset_forward.x;
			this.y = _follow._y  - this.frameHeight / 2 + g._player._body.frameHeight / 2 + offset_left.y + offset_forward.y;
			
			if (FlxG.mouse.pressed()) {
				this.alpha = 1;
				this._ang *= 0.95;
			} else {
				if (this.alpha > 0) this.alpha -= 0.1;
				if (this.alpha == 0) {
					this._ang = 45;
				}
			}
			
			this.angle = _follow._angle + _ang * (_plus?1:-1);
		}
		
	}

}