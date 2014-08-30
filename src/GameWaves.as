package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import player_projectiles.*;
	import enemy.*;
	import particles.*;
	import pickups.*;
	
	public class GameWaves {
		
		public static var _world:Number = 0;
		public static var _ct:Number = 0;
		public static var _wave:Number = 0;
		public static function reset(world:Number):void {
			_world = world;
			_ct = 0;
			_wave = 0;
		}
		
		static var _random_spot:FlxPoint = new FlxPoint();
		public static function random_spot_not_near_player(g:BottomGame):FlxPoint {
			_random_spot.x = Util.float_random(0+50, Util.WID-50);
			_random_spot.y = Util.float_random(0 + 50, Util.HEI - 50);
			while (Util.pt_dist(_random_spot.x, _random_spot.y, g._player.get_center().x, g._player.get_center().y) < 100) {
				_random_spot.x = Util.float_random(0+50, Util.WID-50);
				_random_spot.y = Util.float_random(0 + 50, Util.HEI - 50);
			}
			return _random_spot;
		}
		
		public static function _update(g:BottomGame):void {
			_ct--;
			var skip_when_empty:Boolean = true;
			if (_ct <= 0) {
				if (_world == 0) {
					world_0(g);
				} else if (_world == 1) { 
					world_1(g);
				} else if (_world == 2) {
					world_2(g);
				}
			}
			
			var ct_alive:Number = 0;
			for each (var enem:BaseEnemy in g._enemies.members) {
				if (enem.alive /*&& Util.pt_in_world(enem.x,enem.y,20) */&& !(enem is BulletEnemy)) ct_alive++;
			}
			if (ct_alive == 0) {
				_ct = Math.min(30, _ct);
			}
		}
		
		public static function world_2(g:BottomGame):void {
			if (_wave == 0) {
				_ct = 50;
				_wave++;
				
			} else if (_wave == 1) {
				for (var i:int = 0; i < 10; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 5; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					JellyEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
										
				_ct = 5000;
				_wave++;
			} else if (_wave == 2) {
				for (var i:int = 0; i < 7; i++) {
					random_spot_not_near_player(g);
					JellyEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 1; i++) {
					random_spot_not_near_player(g);
					BoarEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
										
				_ct = 5000;
				_wave++;
			} else if (_wave == 3) {
				for (var i:int = 0; i < 10; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 20; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 4) {
				for (var i:int = 0; i < 10; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 5; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 5; i++) {
					random_spot_not_near_player(g);
					JellyEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					BoarEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 5) {
				for (var i:int = 0; i < 5; i++) {
					random_spot_not_near_player(g);
					BoarEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 10; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 5; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 6) {
				for (var i:int = 0; i < 1; i++) {
					random_spot_not_near_player(g);
					FireBossEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 500000;
				_wave++;

			}
		}
		
		public static function world_1(g:BottomGame):void {
			if (_wave == 0) {						
				_ct = 50;
				_wave++;					
			} else if (_wave == 1) {
				for (var i:int = 0; i < 10; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 2) {
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 4; i++) {
					random_spot_not_near_player(g);
					JellyEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 3) {
				for (var i:int = 0; i < 1; i++) {
					random_spot_not_near_player(g);
					BoarEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 4) {
				for (var i:int = 0; i < 1; i++) {
					random_spot_not_near_player(g);
					BoarEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 5; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 5) {
				for (var i:int = 3; i < 5; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 3; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					JellyEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					BoarEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 500000;
				_wave++;
			} else if (_wave == 6) {
				for (var i:int = 0; i < 1; i++) {
					random_spot_not_near_player(g);
					SpiderBossEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			}
		}
			
		public static function world_0(g:BottomGame):void {
			if (_wave == 0) {						
				_ct = 50;
				_wave++;					
			} else if (_wave == 1) {
				for (var i:int = 0; i < 1; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				g._bottom_game_ui.tutorial_text_for("WASD to move, and swing your mouse to swing your sword.");
				//SpiderBossEnemy.cons(g._enemies).init(200, 200, g);
				//BoarEnemy.cons(g._enemies).init(0, 0, g);
				_ct = 5000;
				_wave++;
			} else if (_wave == 2) {
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				g._bottom_game_ui.tutorial_text_for("Click and release to fire your crossbow.");
				_ct = 5000;
				_wave++;
			} else if (_wave == 3) {
				for (var i:int = 0; i < 3; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				g._bottom_game_ui.tutorial_text_for("Pick up gold and spend on upgrades.");
				_ct = 5000;
				_wave ++;
			} else if (_wave == 4) {
				for (var i:int = 0; i < 5; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				g._bottom_game_ui.tutorial_text_for("Watch your health and energy (top left).");
				_ct = 5000;
				_wave++;
			} else if (_wave == 5) {
				for (var i:int = 0; i < 5; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 6) {
				for (var i:int = 0; i < 3; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 1; i++) {
					random_spot_not_near_player(g);
					JellyEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 7) {
				for (var i:int = 0; i < 3; i++) {
					random_spot_not_near_player(g);
					TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				for (var i:int = 0; i < 2; i++) {
					random_spot_not_near_player(g);
					JellyEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 5000;
				_wave++;
			} else if (_wave == 8) {
				for (var i:int = 0; i < 1; i++) {
					random_spot_not_near_player(g);
					SnakeBossEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
				}
				
				_ct = 500000;
				_wave++;
			}
		}
		
	}

}