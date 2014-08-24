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
		
		var _hitbox:FlxSprite = new FlxSprite(0, 0, Resource.SWORD_HITBOX);
		public function SwordPlayerProjectile() {
			super();
			this.loadGraphic(Resource.SWORD);
		}
		
		var _follow:Player;
		public function init(follow:Player, g:BottomGame):SwordPlayerProjectile {
			this.reset(follow._x, follow._y);
			this._follow = follow;
			g._hitboxes.add(_hitbox);
			_last_mouse_x = FlxG.mouse.x;
			_last_mouse_y = FlxG.mouse.y;
			this.set_scale(GameStats._sword_scale);
			this._hitbox.set_scale(GameStats._sword_scale * GameStats._sword_scale);
			return this;
		}
		
		public var _sword_invuln:Boolean = false;
		var _last_mouse_x:Number, _last_mouse_y:Number, _hold_sword_ct:Number = 0;
		public override function _update(g:BottomGame):void {
			var sword_speed:Number = Util.point_dist(_last_mouse_x, _last_mouse_y, FlxG.mouse.x, FlxG.mouse.y);
			
			_hitbox.x = this.x;
			_hitbox.y = this.y;
			_hitbox.angle = this.angle;
			
			var v:Vector3D = Util.normalized(FlxG.mouse.x - g._player.get_center().x, FlxG.mouse.y - g._player.get_center().y);
			v.scaleBy(this.frameHeight / 2);
			
			var offset_right:Vector3D = Util.Z_VEC.crossProduct(v);
			offset_right.normalize();
			offset_right.scaleBy(7);
			
			this.x = this._follow._x - this.frameWidth/2 + g._player._body.frameWidth/2 + v.x + offset_right.x;
			this.y = this._follow._y - this.frameHeight / 2 + g._player._body.frameHeight / 2 + v.y + offset_right.y;
			
			if (sword_speed > 40 && !FlxG.mouse.pressed() && GameStats._energy/GameStats._max_energy > 0.2) {
				GameStats._energy -= 10;
				GameStats._just_used_energy_ct = GameStats._sword_just_used_energy_ct;
				this.alpha = 1;
				this._hold_sword_ct = 5;
				_sword_invuln = true;
			} else {
				if (this._hold_sword_ct > 0) {
					if (GameStats._energy > 0) {
						GameStats._energy -= 5;
						this._hold_sword_ct--;
					} else {
						this._hold_sword_ct = 0;
					}
					_sword_invuln = true;
					
				} else if (this.alpha > 0) {
					if (GameStats._energy > 0) GameStats._energy -= 3;
					this.alpha -= 0.05;
					_sword_invuln = false;
				} else {
					_sword_invuln = false;
				}
			}
			
			this.angle = _follow._angle;
			
			for each (var enem:BaseEnemy in g._enemies.members) {
				if (enem.alive && enem._invuln_ct <= 0 && this.alpha > 0.1 && sword_speed > 25 && FlxCollision.pixelPerfectCheck(this._hitbox,enem._hitbox)) {
					enem._knockback(enem.x - g._player.get_center().x, enem.y - g._player.get_center().y, 50, GameStats._sword_knockback, GameStats._sword_stun);
					enem._hit(g);
					enem._health -= GameStats._sword_damage;
					FlxG.shake(0.005, 0.075);
					BottomGame._freeze_frame = 6;
				}
			}
			
			_last_mouse_x = FlxG.mouse.x;
			_last_mouse_y = FlxG.mouse.y;
		}
		
		public override function _should_remove():Boolean {
			return false;
		}
		
		public override function _do_remove():void {
			this.kill();
		}
		
	}

}