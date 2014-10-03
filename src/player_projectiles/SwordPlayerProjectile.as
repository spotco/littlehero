package player_projectiles {
	import flash.geom.Vector3D;
	import misc.FlxGroupSprite;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import org.flixel.FlxG;
	import enemy.BaseEnemy;
	import particles.RotateFadeParticle;
	
	public class SwordPlayerProjectile extends BasePlayerProjectile {
		
		public static function cons(g:FlxGroup):SwordPlayerProjectile {
			var rtv:SwordPlayerProjectile = g.getFirstAvailable(SwordPlayerProjectile) as SwordPlayerProjectile;
			if (rtv == null) {
				rtv = new SwordPlayerProjectile();
				g.add(rtv);
			}
			return rtv;
		}
		
		var _hitbox:FlxSprite;
		public function SwordPlayerProjectile() {
			super();
			if (GameStats._sword_scale <= 1.3) {
				_hitbox = new FlxSprite(0, 0, Resource.SWORD_HITBOX_1); //1
			} else if (GameStats._sword_scale <= 1.8) {
				_hitbox = new FlxSprite(0, 0, Resource.SWORD_HITBOX_2);//1.5
			} else if (GameStats._sword_scale <= 2.6) {
				_hitbox = new FlxSprite(0, 0, Resource.SWORD_HITBOX_3);//2
			} else {
				_hitbox = new FlxSprite(0, 0, Resource.SWORD_HITBOX_4);//2
			}
			this.loadGraphic(Resource.SWORD);
		}
		
		var _follow:Player;
		public function init(follow:Player, g:BottomGame):SwordPlayerProjectile {
			this.reset(follow._x, follow._y);
			this._follow = follow;
			g._hitboxes.add(_hitbox);
			this.set_scale(GameStats._sword_scale);
			this.alpha = 1;
			return this;
		}
		
		public var _sword_invuln:Boolean = false;
		var _swinging:Boolean = false;
		var _swing_angle:Number = 45;
		var _swing_prev_angle:Number = 45;
		var _swing_tar_angle:Number = 45;
		var _swing_t:Number = 0;
		
		var _mouse_hold_count:Number = 0;
		var _can_spin:Boolean = false;
		var _slash_cost_mult:Number = 1;
		
		public function get_slash_cost():Number {
			return 25 * _slash_cost_mult;
		}
		
		public override function _update(g:BottomGame):void {
			var v:Vector3D = Util.normalized(
				Math.cos((_follow._angle + _swing_angle) * Util.DEG_TO_RAD),
				Math.sin((_follow._angle + _swing_angle) * Util.DEG_TO_RAD)
			);
			
			this.angle = _follow._angle + _swing_angle;
			_hitbox.angle = this.angle;
			
			if (FlxG.mouse.pressed()) {
				_mouse_hold_count++;
			} else {
				_mouse_hold_count = 0;
			}
			
			var SPIN_COST:Number = 7;
			var SLASH_COST:Number = get_slash_cost();
			var SPIN_TIME:Number = 25;
			
			if (_mouse_hold_count > SPIN_TIME && GameStats._energy <= SPIN_COST + SLASH_COST) {
				_can_spin = false;
			} else if (!FlxG.mouse.pressed()) {
				_can_spin = true;
			}
			_slash_cost_mult =  Math.max(1,_slash_cost_mult * 0.99);
			
			if (_mouse_hold_count > SPIN_TIME && GameStats._energy > SLASH_COST && _can_spin && GameStats._sword_can_spin && !FlxG.keys.SPACE) {
				_swing_angle -= 18;
				this.alpha = 1;
				//_sword_invuln = true;
				GameStats._energy -= SPIN_COST;
				GameStats._just_used_energy_ct = GameStats._sword_just_used_energy_ct;
				if (_mouse_hold_count%10==0) FlxG.play(Resource.SFX_SPIN);
				
			} else {
				_sword_invuln = false;
				if (!_swinging && FlxG.mouse.justPressed() && !FlxG.keys.SPACE && GameStats._energy > SLASH_COST) {
					GameStats._energy -= SLASH_COST;
					GameStats._just_used_energy_ct = GameStats._sword_just_used_energy_ct;
					
					FlxG.play(Resource.SFX_SPIN);
					_swinging = true;
					_swing_t = 0;
					_swing_angle = 45;
					_swing_tar_angle = -75;
					_swing_prev_angle = _swing_angle;
					_slash_cost_mult += 1;
				}
				
				if (_swinging) {
					_swing_t += 0.09;
					_swing_angle = Util.sin_lerp(_swing_prev_angle, _swing_tar_angle, _swing_t);
					if (_swing_t >= 1) {
						_swinging = false;
					}
					this.alpha = 1;
				} else {
					this.alpha *= 0.9;
				}
			}
			
			var out_offset:Number = Math.sin(_swing_t * Math.PI);
			
			v.normalize();
			v.scaleBy(this.frameWidth * 0.8 + out_offset * 5);
			
			var offset_up:Vector3D = Util.Z_VEC.crossProduct(v);
			offset_up.normalize();
			offset_up.scaleBy(this.frameHeight * 0.5 + out_offset * 15);
			
			this.x = this._follow._x - this.frameWidth/2 + g._player._body.frameWidth/2 + offset_up.x + v.x;
			this.y = this._follow._y - this.frameHeight / 2 + g._player._body.frameHeight / 2 + offset_up.y + v.y;
			
			_hitbox.x = this._follow._x - _hitbox.frameWidth / 2 + g._player._body.frameWidth / 2 + offset_up.x + v.x;
			_hitbox.y = this._follow._y - _hitbox.frameHeight / 2 + g._player._body.frameHeight / 2 + offset_up.y + v.y;
			
			for each (var enem:BaseEnemy in g._enemies.members) {
				if (enem.alive && enem._invuln_ct <= 0 && this.alpha > 0.1 && FlxCollision.pixelPerfectCheck(this._hitbox,enem._hitbox)) {
					enem._knockback(enem.x - g._player.get_center().x, enem.y - g._player.get_center().y, 50, GameStats._sword_knockback, GameStats._sword_stun);
					enem._hit(g);
					enem._health -= GameStats._sword_damage * enem._sword_damage_mult();
					if (enem._sword_damage_mult() > 0) {
						FlxG.shake(0.01, 0.075);
						BottomGame._freeze_frame = Math.max(6, BottomGame._freeze_frame);
						FlxG.play(Resource.SFX_HIT);
					} else {
						FlxG.shake(0.01, 0.075);
						BottomGame._freeze_frame = Math.max(1, BottomGame._freeze_frame);
					}
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