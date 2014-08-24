package particles {
	import org.flixel.FlxGroup;
	import flash.geom.Vector3D;
	import misc.FlxGroupSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.FlxG;
	import enemy.BaseEnemy;
	
	public class SweatParticle extends BaseParticle {
		
		public static function cons(g:FlxGroup):SweatParticle {
			var rtv:SweatParticle = new SweatParticle();
			g.add(rtv);
			return rtv;
		}
		
		public function SweatParticle() {
			super();
			this.loadGraphic(Resource.SWEAT_SS, true, false, 28, 38);
			this.addAnimation("test", [0, 1, 2, 3],10);
			this.play("test");
		}
		
		public override function _update(g:BottomGame):void {
			this.x = g._player._x - 25;
			this.y = g._player._y + 5;
			if (GameStats._energy / GameStats._max_energy < 0.2) {
				this.alpha = 1;
			} else {
				this.alpha = 0;
			}
		}
		
	}

}