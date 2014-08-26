package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	
	public class FireBossEnemy extends BaseEnemy{
		
		public static function cons(g:FlxGroup):FireBossEnemy {
			var rtv:FireBossEnemy = g.getFirstAvailable(FireBossEnemy) as FireBossEnemy;
			if (rtv == null) {
				rtv = new FireBossEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function FireBossEnemy() {
			super();
			this.loadGraphic(Resource.FIREBOSS_SS, true, false, 363, 334);
			this.addAnimation("fire", [1,2,3], 10);
			this.addAnimation("nofire", [0], 10);
			_hitbox.loadGraphic(Resource.FIREBOSS_HITBOX);
			_hitbox.alpha = 0.5;
			
		}
		
		var _mode:Number = 0, _ct:Number = 0;
		var _fist1:FireBossFistEnemy, _fist2:FireBossFistEnemy, _fist3:FireBossFistEnemy;
		var _fist1_ct:Number = 0, _fist2_ct:Number = 0, _fist3_ct:Number = 0;
		var _fire_ct:Number = 0;
		
		public function init(x:Number,y:Number, g:BottomGame):FireBossEnemy {
			this.reset(x, y);
			g._bottom_game_ui.track_boss(this);
			g._hitboxes.add(_hitbox);
			this._max_health = 3;
			if (Main.BOSS_1_HEALTH) {
				this._health = 1;
			} else {
				this._health = this._max_health;
			}
			FlxG.play(Resource.SFX_BOSS_ENTER);
			RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random( -20, 20), this.get_center().y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random( -20, 20), this.get_center().y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,2));
			RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random(-20,20), this.get_center().y + Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,4));
			RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random(-20,20), this.get_center().y + Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,4));
			
			this.set_center(0, Util.float_random(100, 400));
			_vx = 2;
			_vy = 2 * (Util.float_random(0, 2) < 1?1: -1);
			
			_fist1 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 0);
			_fist2 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 3.14*2/3);
			_fist3 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 3.14*2/3*2);
			
			_mode = 0;
			return this;
		}
		
		public function fist_notify_death(fist:FireBossFistEnemy):void {
			if (fist == _fist1) {
				_fist1 = null;
				_fist1_ct = 1000;
			} else if (fist == _fist2) {
				_fist2 = null;
				_fist2_ct = 1000;
			} else if (fist == _fist3) {
				_fist3 = null;
				_fist3_ct = 1000;
			}
		}
		
		private function alive_ct():Number {
			var rtv:Number = 0;
			if (_fist1 && _fist1.alive) rtv++;
			if (_fist2 && _fist2.alive) rtv++;
			if (_fist3 && _fist3.alive) rtv++;
			return rtv;
		}
		
		public var _theta:Number = 0;
		public override function _update(g:BottomGame):void {
			super._update(g);
			_hitbox.x = this.x + 120;
			_hitbox.y = this.y + 100;
			_theta += alive_ct()==3?0.015:(alive_ct()==2?0.03:0.05);
			
			if (this._invuln_ct > 0) {
				this.color = 0xCC99FF;
				this.alpha = Math.floor(_invuln_ct / 5) % 2 == 0?1:0.5;
				_invuln_ct--;
				return;
			} else {
				this.color = 0xFFFFFF;
			}
			
			if (_mode != 1 && this.hit_player(g)) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(35);
				g._player.hit(v.x, v.y, 1);
				FlxG.shake(0.01, 0.15);
			}
			_fire_ct++;
			if (_mode == 0) {
				var mod:Number = 0;
				if (_health == 1) {
					mod = 50;
				} else if (_health == 2) {
					mod = 100;
				} else {
					mod = 150;
				}
				if (_fire_ct % mod == 0) {
					var i:Number = 0;
					while (i < 3.14 * 2) {
						var pos:FlxPoint = this.get_center();
						var dv:Vector3D = Util.normalized(Math.cos(i), Math.sin(i));
						dv.scaleBy(2);
						BulletEnemy.cons(g._enemies).init(pos.x,pos.y, dv.x, dv.y,600,g);
						i += Util.float_random(0.3,0.7);
					}
					FlxG.play(Resource.SFX_BULLET4);
				}
				this.angle = 0;
				this.play("fire");
				if (_fist1_ct > 0) {
					_fist1_ct--;
					if (_fist1_ct==0)_fist1 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 0);
				}
				if (_fist2_ct > 0) {
					_fist2_ct--;
					if (_fist2_ct==0)_fist2 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 3.14*2/3);
				
				}
				if (_fist3_ct > 0) {
					_fist3_ct--;
					if (_fist3_ct==0)_fist3 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 3.14*2/3*2);
				}
				var pt:FlxPoint = Util.flxpt(this.get_center().x, this.get_center().y);
				this.set_center(pt.x + _vx, pt.y + _vy);
				if (this.hit_wall(100)) {
					if (this._hit_wall_top || this._hit_wall_bottom) {
						_vy *= -1;
					}
					if (this._hit_wall_left || this._hit_wall_right) {
						_vx *= -1;
					}
					FlxG.shake(0.01, 0.15);
				}
				if (this.alive_ct() == 0) {
					_mode = 1;
					_ct = 500;
					FlxG.play(Resource.SFX_BOSS_ENTER);
					FlxG.play(Resource.SFX_BOSS_ENTER);
					FlxG.play(Resource.SFX_BOSS_ENTER);
				}
			} else if (_mode==1) {
				_ct--;
				var pt:FlxPoint = Util.flxpt(this.get_center().x, this.get_center().y);
				this.set_center(pt.x + _vx, pt.y + _vy);
				if (this.hit_wall(100)) {
					if (this._hit_wall_top || this._hit_wall_bottom) {
						_vy *= -1;
					}
					if (this._hit_wall_left || this._hit_wall_right) {
						_vx *= -1;
					}
					FlxG.play(Resource.SFX_ROCKBREAK);
					FlxG.shake(0.01, 0.15);
				}
				_vx *= 0.995;
				_vy *= 0.995;
				this.play("nofire");
				this.angle += 15;
				
			} else if (_mode == 2) {
				var pt:FlxPoint = Util.flxpt(this.get_center().x, this.get_center().y);
				this.set_center(pt.x + _vx, pt.y + _vy);
				if (this.hit_wall(100)) {
					this._invuln_ct = 50;
					FlxG.shake(0.03, 0.35);
					BottomGame._freeze_frame = 15;
					_mode = 3;
					this._health--;
					FlxG.play(Resource.SFX_ROCKBREAK);
					FlxG.play(Resource.SFX_ROCKBREAK);
					FlxG.play(Resource.SFX_ROCKBREAK);
					FlxG.play(Resource.SFX_BOSS_ENTER);
					FlxG.play(Resource.SFX_BOSS_ENTER);
					FlxG.play(Resource.SFX_BOSS_ENTER);
				}
				
			} else if (_mode == 3) {
				_mode = 0;
				RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random( -20, 20), this.get_center().y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
				RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random( -20, 20), this.get_center().y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,2));
				RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random(-20,20), this.get_center().y + Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,4));
				RotateFadeParticle.cons(g._particles).init(this.get_center().x + Util.float_random(-20,20), this.get_center().y + Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(1,4));
				_fist1 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 0);
				_fist2 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 3.14*2/3);
				_fist3 = FireBossFistEnemy.cons(g._enemies).init(0, 0, g, this, 3.14 * 2 / 3 * 2);
				_vx = 2 * (Util.float_random(0, 2) < 1?1: -1);
				_vy = 2 * (Util.float_random(0, 2) < 1?1: -1);
				if (_health == 2) {
					var _random_spot:FlxPoint = Util.flxpt(0, 0);
					for (i=0; i < 3; i++) {
						_random_spot= GameWaves.random_spot_not_near_player(g);
						TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
					}
					for (i=0; i < 2; i++) {
						_random_spot= GameWaves.random_spot_not_near_player(g);
						BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
					}
					_random_spot= GameWaves.random_spot_not_near_player(g);
					BoarEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y,g);
					
				} else if (_health == 1) {
					for (i=0; i < 4; i++) {
						_random_spot= GameWaves.random_spot_not_near_player(g);
						TinySpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
					}
					for (i=0; i < 1; i++) {
						_random_spot= GameWaves.random_spot_not_near_player(g);
						BigSpiderEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
					}
					for (i=0; i < 1; i++) {
						_random_spot= GameWaves.random_spot_not_near_player(g);
						JellyEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
					}
					_random_spot= GameWaves.random_spot_not_near_player(g);
					BoarEnemy.cons(g._enemies).init(_random_spot.x, _random_spot.y, g);
					
				}
			}
		}
		
		public override function _hit(g:BottomGame, bow:Boolean = false):void {
			if (!bow && _mode == 1) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(13);
				g._player.knockback(v.x, v.y, 25);
				
				v.scaleBy( -1);
				var dv:Vector3D = Util.normalized(v.x, v.y);
				dv.scaleBy(15 * this.get_knockback_mult());
				_vx = dv.x;
				_vy = dv.y;
				_mode = 2;
			} else if (!bow) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(13);
				g._player.knockback(v.x, v.y, 25);
			}
		}
		public override function _knockback(dx:Number, dy:Number, invuln_ct:Number, knockback:Number = 14, stun_ct:Number = 0):void {
		}
		
		public override function _should_kill():Boolean { 
			return _health <= 0;
		}
		public override function _do_kill(g:BottomGame):void {
			this._health = 0;
			FlxG.play(Resource.SFX_EXPLOSION);
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
			g.boss_defeated();
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x + 170;
			_get_center.y = this.y + 160;
			return _get_center;
		}
		
		public override function get_knockback_mult():Number {
			return (_mode==1)?2:0;
		}
		
		public override function _arrow_damage_mult():Number { return 0; }
		public override function _sword_damage_mult():Number { return 0; }
		
	}

}