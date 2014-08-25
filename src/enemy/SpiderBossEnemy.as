package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	
	public class SpiderBossEnemy extends BaseEnemy{
		
		public static function cons(g:FlxGroup):SpiderBossEnemy {
			var rtv:SpiderBossEnemy = g.getFirstAvailable(SpiderBossEnemy) as SpiderBossEnemy;
			if (rtv == null) {
				rtv = new SpiderBossEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		var _butt_hitbox:FlxSprite = new FlxSprite();
		var _body_hitbox:FlxSprite = new FlxSprite();
		
		public function SpiderBossEnemy() {
			super();
			this.loadGraphic(Resource.SPIDER_BOSS_SS, true, false, 369, 313);
			this.addAnimation("walk", [1,2], 10);
			this.addAnimation("stand", [0], 10);
			_butt_hitbox.loadGraphic(Resource.SPIDER_BOSS_HITBOX);
			_body_hitbox.loadGraphic(Resource.SPIDER_BOSS_BODY_HITBOX);
			
			_hitbox = _body_hitbox;
		}
		
		public function init(x:Number,y:Number, g:BottomGame):SpiderBossEnemy {
			this.reset(x, y);
			g._hitboxes.add(_butt_hitbox);
			this.play("stand");
			this._max_health = 60;
			//this._health = 5;
			this._health = this._max_health;
			g._bottom_game_ui.track_boss(this);
			_side = Util.float_random(0, 2) < 1?1:0;
			this.pick_side();
			return this;
		}
		
		var _spawned_count:Number = 0;
		var _ct:Number = 0;
		var _mode:Number = 0;
		var _side:Number = 0;//0-right,1-left
		var _tar_x:Number = 0;
		var _tar_angle:Number = 0;
		private function pick_side():void {
			FlxG.shake(0.01, 0.15);
			_spawned_count = 0;
			if (_side == 0) { //right
				_side = 1;
				_tar_x = Util.WID-100;
				this.set_center(Util.WID + 200, Util.float_random(150, 350));
				this.angle = 90;
				this._tar_angle = -90;
				_mode = 0;
				
			} else { //left
				_side = 0;
				this.set_center( -200, Util.float_random(150, 350));
				_tar_x = 0;
				this.angle = -90;
				this._tar_angle = 90;
				_mode = 0;
			}
		}
		
		var _red_ct:Number = 0;
		public override function _update(g:BottomGame):void {
			super._update(g);
			_butt_hitbox.x = this.x + 125 + Math.cos((this.angle-90)*Util.DEG_TO_RAD)*130;
			_butt_hitbox.y = this.y + 90 + Math.sin((this.angle-90)* Util.DEG_TO_RAD) * 160;
			_body_hitbox.x = this.x + 40;
			_body_hitbox.y = this.y + 40;
			
			if (this._invuln_ct > 0) {
				this.alpha = Math.floor(_invuln_ct / 5) % 2 == 0?1:0.5;
				this._invuln_ct--;
				this.color = 0xCC99FF;
				return;
			} else if (this._stun_ct > 0) {
				_stun_ct--;
				this.color = 0xCC99FF;
				return;
			} else {
				_red_ct--;
				if (_red_ct <= 0) this.color = 0xFFFFFF;
			}
			
			
			if (this.hit_player(g)) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(15);
				g._player.hit(v.x, v.y, 1);
				FlxG.shake(0.01, 0.15);
			}
			
			if (_mode == 0) { //in
				var cy:Number = this.get_center().y;
				this.set_center(Util.drp(this.get_center().x, _tar_x, 20), cy);
				if (Util.pt_dist(this.get_center().x, this.get_center().y, _tar_x, this.get_center().y) < 5) {
					_mode = 1;
					_ct = 100;
				}
				this.play("walk");
				this._hitbox = _body_hitbox;
				
			} else if (_mode == 1) { //spit spider
				this.play("walk");
				_ct--;
				var mod:Number = 50;
				var pct:Number = 4;
				if (this._health / this._max_health < 0.25) {
					mod = 33;
					pct = 5;
				} else if (this._health / this._max_health < 0.5) {
					mod = 40;
					pct = 6;
				} else if (this._health / this._max_health < 0.75) {
					mod = 50;
					pct = 7;
				} else {
					mod = 50;
					pct = 8;
				}
				
				if (_ct%mod==0&&Util.alive_ct(g)<8) {
					var random_spot:FlxPoint = GameWaves.random_spot_not_near_player(g);
					if (Util.float_random(0, pct) < 1) {
						BigSpiderEnemy.cons(g._enemies).init(random_spot.x, random_spot.y, g);
					} else {
						TinySpiderEnemy.cons(g._enemies).init(random_spot.x, random_spot.y, g);
					}
					
				}
				if (_ct <= 0) {
					_mode = 2;
					_ct = 70;
					FlxG.shake(0.01, 0.15);
				}
				this._hitbox = _body_hitbox;
				
			} else if (_mode == 2) { //turn
				this.angle += Util.lerp_deg(this.angle, this._tar_angle, 0.1);
				_ct--;
				if (_ct == 15) {
					this.color = 0xFF0000;
					_red_ct = 10;
				}
				if (_ct <= 0) {
					_mode = 3;
					_ct = 200;
				}
				this._hitbox = _butt_hitbox;
				
			} else if (_mode == 3) { //spit bullet
				this.angle = _tar_angle;
				this._hitbox = _butt_hitbox;
				_ct--;
				if (_ct == 50) {
					this.color = 0xFF0000;
					_red_ct = 10;
				}
				if (_ct == 195 || _ct == 180  || _ct == 20 || _ct == 5) {
					var i:Number = 0;
					while (i < 3.14 * 2) {
						var pos:FlxPoint = Util.flxpt(_butt_hitbox.x+45, _butt_hitbox.y+60);
						var dv:Vector3D = Util.normalized(Math.cos(i), Math.sin(i));
						dv.scaleBy(2);
						BulletEnemy.cons(g._enemies).init(pos.x,pos.y, dv.x, dv.y,600,g);
						i += Util.float_random(0.3,0.7);
					}
					this.color = 0xFF0000;
					_red_ct = 10;
				}
				if (_ct <= 0) {
					_mode = 4;
					FlxG.shake(0.01, 0.15);
					if (_side == 0) {
						_tar_x = _tar_x - 300;
					} else {
						_tar_x = _tar_x + 300;
					}
				}
			} else if (_mode = 4) {
				this._hitbox = _butt_hitbox;
				var cy:Number = this.get_center().y;
				this.set_center(Util.drp(this.get_center().x, _tar_x, 20), cy);
				if (Util.pt_dist(this.get_center().x, this.get_center().y, _tar_x, this.get_center().y) < 5) {
					pick_side();
				}
			}
			
		}
		public override function _hit(g:BottomGame, bow:Boolean = false):void {
			if (!bow) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(7);
				g._player.knockback(v.x, v.y, 25);
				if (_mode == 3) {
					_ct = 0;
				} else if (_mode == 2) {
					_mode = 3;
					_ct = 6;
				}
			}
		}
		
		public override function _knockback(dx:Number, dy:Number, invuln_ct:Number, knockback:Number = 14, stun_ct:Number = 0):void {
			if (_mode == 2 || _mode == 3 || _mode == 4) {
				_invuln_ct = Math.min(5,invuln_ct);
			}
		}
		
		public override function get_knockback_mult():Number {
			return 0;
		}
		
		public override function _arrow_damage_mult():Number { return (_mode == 2 || _mode == 3 || _mode == 4)?0.15:0; }
		public override function _sword_damage_mult():Number { return (_mode == 2 || _mode == 3 || _mode == 4)?1.4:0; }
		
		
		
		public override function _should_kill():Boolean { 
			return _health <= 0;
		}
		public override function _do_kill(g:BottomGame):void {
			for (var ii:Number = 0; ii < this.frameWidth; ii+=Util.float_random(5,20)) {
				RotateFadeParticle.cons(g._particles).init(
					this.x + Util.float_random( -20, 20) + ii, 
					this.y + Util.float_random( 0, 156)
				).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1, 4)).p_set_delay(Util.float_random(0,40));
			}
			
			for (var j:int = 0; j < 150; j++) {
				SmallFollowPickup.cons(g._pickups).init(
					this.get_center().x + Util.float_random(-150,150),
					this.get_center().y + Util.float_random( -150,150),
					3
				);
			}
			for each (var enem:BaseEnemy in g._enemies.members) {
				if (enem.alive) enem._health = 0;
			}
			FlxG.shake(0.1, 3);
			BottomGame._freeze_frame = 10;
			this.kill();
			this._kill(g);
			
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x + 125;
			_get_center.y = this.y + 90;
			return _get_center;
		}
		
	}

}