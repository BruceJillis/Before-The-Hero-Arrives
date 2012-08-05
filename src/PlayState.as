
package {
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PlayState extends FlxState {
		// sprite sheets
		[Embed(source = "data/kastel_tiles.png")] static public var TileSet:Class;
		[Embed(source = "data/hero_21x27.png")] private static var HeroSheet:Class;
		[Embed(source = "data/wizard_23x27.png")] private static var WizardSheet:Class;
		[Embed(source = "data/skeleton2_12x24.png")] private static var SkeletonSheet:Class;
		[Embed(source = "data/candle3_63x62.png")] private static var Wall1Tile:Class;
		[Embed(source = "data/door1.png")] private static var Door1Tile:Class;
		[Embed(source = "data/door2.png")] private static var Door2Tile:Class;		
		[Embed(source = "data/hearts.png")] public static var HeartsSheet:Class;
		[Embed(source = "data/princess.png")] public static var PrincessSheet:Class;
		
		// world 1
		[Embed(source = "data/worlds/world_1_0.txt", mimeType = "application/octet-stream")] private var World_1_0:Class;
		[Embed(source = "data/worlds/world_1_1.txt", mimeType = "application/octet-stream")] private var World_1_1:Class;
		// world 2
		[Embed(source = "data/worlds/world_2_0.txt", mimeType = "application/octet-stream")] private var World_2_0:Class;
		[Embed(source = "data/worlds/world_2_1.txt", mimeType = "application/octet-stream")] private var World_2_1:Class;
		// world 3
		[Embed(source = "data/worlds/world_3_0.txt", mimeType = "application/octet-stream")] private var World_3_0:Class;
		[Embed(source = "data/worlds/world_3_1.txt", mimeType = "application/octet-stream")] private var World_3_1:Class;
		// world 4
		[Embed(source = "data/worlds/world_4_0.txt", mimeType = "application/octet-stream")] private var World_4_0:Class;
		[Embed(source = "data/worlds/world_4_1.txt", mimeType = "application/octet-stream")] private var World_4_1:Class;
		
		
		
		private var TileMap:FlxTilemap;
		private var player:FlxSprite;
		private var start:Array;
		private var jumps:Array;
		private var exits:Array;
		
		private var world:int = 4;
		
		private var Layer0Tiles:Class;
		private var Layer1Tiles:Class;
		
		private var mode:int = 0;
		
		private var ArrivesText:DynamicText;
		private var HeroText:DynamicText;
		private var WorldText:DynamicText;
		
		private var weapon:FlxWeapon;
		
		private var enemies:FlxGroup;
		private var doodads:FlxGroup;
		private var lights:FlxGroup;		
		
		private var slashing:Boolean = false;
		
		private var mana:FlxBar;
		private var manatext:FlxText;

		private var life:FlxBar;
		private var lifetext:FlxText;
		
		private var scoretext:FlxText;
		
		private var out_of_bounds:Boolean;
		
		public var counter:int = 100;
		
		private var initial_mute:Boolean = false;

		[Embed(source = "data/Constancy Part Two.mp3")] public static var Chase:Class;
		[Embed(source = "data/mude.png")] public static var MuteSheet:Class;
		private var mood:FlxSound;
		private var btnMute:FlxButton;
		
		private function loadWorldZone(world:int):void {
			out_of_bounds = false;
			// load world and meta data
			if (world == 1) {
				Layer0Tiles = World_1_0;
				Layer1Tiles = World_1_1;
			} else if (world == 2) {
				Layer0Tiles = World_2_0;
				Layer1Tiles = World_2_1;
			} else if (world == 3) {
				Layer0Tiles = World_3_0;
				Layer1Tiles = World_3_1;
			} else if (world == 4) {
				Layer0Tiles = World_4_0;
				Layer1Tiles = World_4_1;				
			} else {
				end(false);
			}
			// load meta data
			var columns:Array;
			var metadata:String = new Layer1Tiles;
			var rows:Array = metadata.split("\n");			
			var widthInTiles:int = 0;
			var heightInTiles:int = rows.length;
			var row:uint = 0;
			var column:uint;
			jumps = new Array;
			exits = new Array;			
			while(row < heightInTiles) {				
				columns = rows[row++].split(",");
				if (columns.length <= 1) {
					heightInTiles = heightInTiles - 1;
					continue;
				}
				if (widthInTiles == 0) {
					widthInTiles = columns.length;
				}
				column = 0;
				while(column < widthInTiles) {					
					var cell:int = uint(columns[column++]);
					switch(cell) {
						case 1:							
							start = [row - 2, column - 1];
							break;
						case 2:							
							jumps.push([row - 2, column - 2, false, 0]);
							break;
						case 3:					
							jumps.push([row - 2, column - 2, false, 1]);
							break;
						case 4:				
							var o:FlxSprite = new FlxSprite((column - 1) * 16, (row - 2) * 16);
							o.loadGraphic(Wall1Tile, true, false, 63, 62);
							var r:int = Math.floor(Math.random() * 4);
							switch(r) {
								case 0:
									o.addAnimation('flickr', [0, 1, 2, 3], 6, true);
									break;
								case 1:
									o.addAnimation('flickr', [1, 2, 3, 0], 6, true);
									break;
								default:
									o.addAnimation('flickr', [2, 3, 0, 1], 6, true);
									break;									
							}							
							lights.add(o);
							break;				
						case 15:
							if (world < 4) {
								var p:FlxSprite = new FlxSprite((column - 1) * 16, (row - 3) * 16);
								p.loadGraphic(Door1Tile, false, false, 28, 64);
								doodads.add(p);
								p = new FlxSprite((column) * 16, (row - 3) * 16);
								p.loadGraphic(Door2Tile, false, false, 10, 64);							
								doodads.add(p);						
							} else {
								var p2:FlxSprite = new FlxSprite((column - 1) * 16, (row - 6) * 16);
								p2.loadGraphic(PrincessSheet, false, false, 27, 78);
								doodads.add(p2);
							}
							exits.push([row - 2, column - 1, false]);
							break;
					}
				}
			}
			TileMap.loadMap(new Layer0Tiles, TileSet, 16, 16, FlxTilemap.AUTO);
			// subtract 100 from the left to make falling off to the left possible, don't forget to add it to the right
			// or we wont be able to reach the door!
			FlxG.worldBounds.make(-100, 0, TileMap.width + 100, TileMap.height);
		}
		
		override public function create():void {			
			// hide the mouse and (re)set score to 0
			FlxG.mouse.hide();
			FlxG.score = 0;
			// create groups and add to stage 
			doodads = new FlxGroup();
			add(doodads);
			lights = new FlxGroup();
			add(lights);
			TileMap = new FlxTilemap();
			add(TileMap);
			enemies = new FlxGroup();
			add(enemies);
			loadWorld();
			// misc setup stuff			
			createBars();
			// mute
			if (FlxG.mute) {
				initial_mute = true;
			}
			btnMute = new FlxButton(FlxG.width - 36, FlxG.height - 36);
			btnMute.loadGraphic(MuteSheet, false, false, 32, 32);
			btnMute.onDown = toggleMute;
			btnMute.scrollFactor.x = 0;
			btnMute.scrollFactor.y = 0;
			add(btnMute);
			// music
			mood = new FlxSound();
			mood.loadEmbedded(Chase, true);
			mood.fadeIn(10);			
		}
		
		private function loadWorld():void {
			loadWorldZone(world);
			if (mode == 0) {				
				setupWizard(start[0] * 16, start[1] * 16);
			} else {				
				setupHero(start[0] * 16, start[1] * 16);
			}		
		}
		
		// CREATE 

		private function setupWizard(y:int, x:int):void {
			player = new FlxSprite(x, y);
			player.loadGraphic(WizardSheet, true, true, 23, 27);
			// setup the weapon
			weapon = new FlxWeapon("weapon", player, "x", "y");
			weapon.setBulletRandomFactor(0, 0, null, 0);
			weapon.setBulletElasticity(0);
			weapon.makePixelBullet(2, 4, 4, 0xff785680, 12, 7);			
			weapon.setBulletSpeed(90);
			weapon.setBulletGravity(0, 110);
			weapon.setFireRate(500);
			weapon.setBulletBounds(TileMap.getBounds());			
			add(weapon.group);
			// bounding box tweaks
			player.width = 12;
			player.height = 27;
			player.offset.x = 5;
			player.offset.y = 0;
			// basic player physics
			player.drag.x = 640;
			player.acceleration.y = 420;
			player.maxVelocity.x = 80;
			player.maxVelocity.y = 200;
			// animations
			player.addAnimation("idle", [0]);
			player.addAnimation("run",  [1, 2, 3, 4, 5, 6, 7, 8, 9, 0], 12);
			player.addAnimation("jump", [10]);
			// let the camera follow the wizard
			FlxG.camera.follow(player);
			// add the wizard to the stage
			add(player);
		}
		
		private function setupHero(y:int, x:int):void {
			player = new FlxSprite(x, y);
			player.loadGraphic(HeroSheet, true, true, 21, 26);
			// bounding box tweaks
			player.width = 12;
			player.height = 26;
			player.offset.x = 5;
			player.offset.y = 0;
			// basic player physics
			player.drag.x = 640;
			player.acceleration.y = 420;
			player.maxVelocity.x = 80;
			player.maxVelocity.y = 200;
			// animations
			player.addAnimation("idle", [0]);
			player.addAnimation("run",  [1, 2, 3, 4, 5, 6, 7, 8, 9], 12);
			player.addAnimation("slash", [11, 12, 13, 14], 12, false);			
			player.addAnimation("jump", [10]);
			// let the camera follow the player
			FlxG.camera.follow(player);
			// add to stage
			add(player);
		}
		
		private function setupSkeleton(y:int, x:int, dir:Boolean):void {
			var e:FlxSprite = new FlxSprite(x, y);			
			e.loadGraphic(SkeletonSheet, true, true, 12, 24);
			// bounding box tweaks
			e.width = 12;
			e.height = 24;
			e.offset.x = 1;
			e.offset.y = 1;
			// face enemy left or right depending 
			if (dir) {
				e.facing = FlxObject.RIGHT;
			} else {
				e.facing = FlxObject.LEFT;
			}
			// basic player physics
			e.drag.x = 15;
			e.acceleration.y = 420;
			e.maxVelocity.x = 40;
			e.maxVelocity.y = 200;
			// animations
			e.addAnimation("idle", [0]);
			e.addAnimation("run",  [1, 2, 3, 4, 5, 6, 0], 6);			
			e.addAnimation("die",  [7, 8, 9, 10, 11, 12], 6, false);			
			// add to enemies group which has already been added to the group
			enemies.add(e);			
		}

		// UPDATES
		
		private function doWizard():void {	
			player.acceleration.x = 0;
			var ty:int = Math.floor(player.y / 16);
			var tx:int = Math.floor(player.x / 16);
			if ( FlxG.keys.LEFT ) {
				player.facing = FlxObject.LEFT;
				player.acceleration.x -= player.drag.x;
			} else if ( FlxG.keys.RIGHT ) {
				player.facing = FlxObject.RIGHT;
				player.acceleration.x += player.drag.x;
			}			
			if( FlxG.keys.justPressed("UP") && player.velocity.y == 0 ) {
				player.y -= 1;
				player.velocity.y = -200;
			}
			if ( FlxG.keys.justPressed("SPACE") ) {
				if (mana.currentValue >= 10) {					
					if (player.facing == FlxObject.LEFT) {
						weapon.setBulletDirection(185, 120);					
					} else {
						weapon.setBulletDirection(-5, 120);					
					}
					weapon.fire();					
				}
			}
			FlxG.collide(weapon.group, TileMap, bulletHitMap);			
			if( FlxG.keys.justPressed("BACKSPACE") ) {
				player.kill();
				ArrivesText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15, 400, 30, "The Hero Arrives...", 1000, switchMode);
			}
			for (var j:String in exits) {
				if ((exits[j][0] == ty) && (exits[j][1] == tx) && (!exits[j][2])) {					
					exits[j][2] = true;
					player.kill();					
					ArrivesText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15, 400, 30, "The Hero Arrives...", 1000, switchMode);
				}
			}
			// ANIMATION
			if(player.velocity.y != 0) {
				player.play("jump");
			} else if(player.velocity.x == 0) {
				player.play("idle");
			} else {
				player.play("run");
			}			
		}		
		
		private function doHero():void {
			player.acceleration.x = 0;
			player.acceleration.x += player.drag.x;
			var ty:int = Math.floor(player.y / 16);
			var tx:int = Math.floor(player.x / 16);
			for (var i:String in jumps) {				
				if ((jumps[i][0] == ty) && (jumps[i][1] == tx) && (!jumps[i][2]) && ((player.touching & FlxObject.FLOOR) > FlxObject.NONE)) {
					jumps[i][2] = true;
					if (jumps[i][3] == 0) {
						// random jump
						var r:int = Math.floor(Math.random() * 10);
						if (r >= 5) {
							player.y -= 1;
							player.velocity.y = -250;
						}
					} else if (jumps[i][3] == 1) {
						jumps[i][2] = false;
						// must jump
						player.y -= 1;
						player.velocity.y = -250;						
					}
				}
			}
			for (var j:String in exits) {
				if ((exits[j][0] == ty) && (exits[j][1] == tx) && (!exits[j][2])) {	
					exits[j][2] = true;
					player.kill();
					HeroText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15, 400, 30, "Drats! The Hero Lives", 1000, switchLevel);
				}
			}	
			
			FlxG.overlap(player, enemies, playerHitsEnemies);
			
			// auto attack
			if (!slashing && (counter > 20)) {
				var k:uint = 0;
				while (k < enemies.length) {				
					var e:FlxSprite = enemies.members[k++];
					if (!e.exists || !e.alive) {	
						continue;
					}
					var dx:int = Math.abs(player.x - e.x);
					var dy:int = Math.abs(player.y - e.y);
					if ( (dx > 5) && (dx < 25) && (dy < 30)) {
						counter = 0;
						var r2:int = Math.floor(Math.random() * 50);
						FlxG.log(r2);
						if (r2 >= 10) {
							slashing = true;
						}
						break;
					}
				}
			}
			counter += 1
			
			// ANIMATION
			// is the slashing animation finished?
			if (player.frame == 14) {
				slashing = false;
			}
			
			// do the normal stuff or play slash once
			if (!slashing) {
				if (player.velocity.y != 0) {
					player.play("jump");
				} else if (player.velocity.x == 0) {
					player.play("idle");
				} else {
					player.play("run");
				}
			} else {
				player.play("slash");				
			}
		}		
		
		private function doEnemy(e:FlxSprite):void {
			e.acceleration.x = 0;
			var ty:int = Math.floor(e.y / 16);
			var tx:int = Math.floor(e.x / 16);
			if (e.alive) { 
				// do movement
				if ( e.facing == FlxObject.RIGHT ) {
					if ( (TileMap.getTile(tx + 1, ty + 2) == 0) || e.justTouched(FlxObject.RIGHT) ) {
						e.acceleration.x = 0;
						e.velocity.x = 0;
						e.facing = FlxObject.LEFT
					}
				} else if ( e.facing == FlxObject.LEFT ) {
					if ( (TileMap.getTile(tx, ty + 2) == 0) || e.justTouched(FlxObject.LEFT) ) {
						e.acceleration.x = 0;
						e.velocity.x = 0;
						e.facing = FlxObject.RIGHT
					}				
				}				
				if (e.facing == FlxObject.LEFT) {
					e.acceleration.x -= e.drag.x;
				} else {
					e.acceleration.x += e.drag.x;
				}
			} else {
				// drop down immediatly if dead
				e.velocity.x = 0;
				e.acceleration.x = 0;
			}
			// ANIMATION
			if (e.alive) {
				if (e.velocity.x == 0) {
					e.play("idle");
				} else {
					e.play("run");
				}
			} else {
				e.play('die');
				if (e.frame == 12) {
					e.kill();					
				}
			}
		}
		
		private function updatePlayer():void {			
			if (mode == 0) {
				// we are in input mode
				doWizard();
			} else {
				// auto mode
				doHero();
			}
		}
		
		override public function update():void {
			checkBounds();
			// make sure we don't fall through the map
			FlxG.collide(player, TileMap);
			FlxG.collide(enemies, TileMap);
			// do the player stuff
			updatePlayer();
			// update all the enemies
			var i:uint = 0;
			while (i < enemies.length) {
				doEnemy(enemies.members[i++]);
			}
			// make the lights flickr
			i = 0;
			while (i < lights.length) {
				lights.members[i++].play('flickr');
			}			
			// update the score
			scoretext.text = FlxG.score.toString();
			// for flixel
			super.update();
		}
		
		// COLLISION RESPONSE
		
		public function bulletHitMap(bullet:FlxObject, obj:FlxObject):void {				
			mana.currentValue -= 10;
			setupSkeleton(bullet.y - 24, bullet.x, bullet.x > player.x);
			bullet.kill();
		}
		
		public function playerHitsEnemies(p:FlxObject, e:FlxObject):void {
			if (!e.alive)
				return;
			if (slashing) {
				e.alive = false;
				mana.currentValue += 5;
				mana.currentValue = (mana.currentValue > 100) ? 100 : mana.currentValue;
			} else {
				player.kill();
				life.currentValue -= 1;
				if (life.currentValue == 0) {					
					FlxG.score += 100;
					end(true);
				} else {
					HeroText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15, 400, 30, "The Hero Dies...", 1000, switchMode);
					mana.currentValue += 20;
					mana.currentValue = (mana.currentValue > 100) ? 100 : mana.currentValue;
					FlxG.score += 100;
				}
				
			}
		}
		
		// is the player out of the level?
		private function checkBounds():void {
			if ( !FlxG.worldBounds.overlaps(new FlxRect(player.x, player.y, player.width, player.height)) && !out_of_bounds) {
				out_of_bounds = true;
				if (mode == 0) {
					HeroText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15, 400, 30, "You Fall Into The Abyss", 1000, switchLose);					
					player.kill();
				} else {
					player.kill();
					life.currentValue -= 1;
					if (life.currentValue == 0) {					
						FlxG.score += 100;
						end(true);
					} else {
						HeroText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15, 400, 30, "The Hero Dies...", 1000, switchMode);
						mana.currentValue += 20;
						FlxG.score += 100;
					}
				}				
			}
		}
		
		public function switchLose():void {
			end(false);
		}
		
		private function end(win:Boolean):void {
			mood.stop();
			if (win) {
				FlxG.switchState(new WinState);
			} else {
				FlxG.switchState(new LoseState);
			}
		}
		
		// LEVEL AND MODE SWITCH 
		
		public function switchMode():void {
			// clean up
			manatext.alpha = 0.5;
			mana.alpha = 0.5;
			lifetext.alpha = 1.0;
			life.alpha = 1.0;
			// switch mode
			mode = 1;
			loadWorld(); // restart level			
		}

		public function switchLevel():void {
			// clean up
			var l:uint = 0;
			while (l < enemies.length) {
				enemies.members[l++].kill();
			}
			l = 0;
			while (l < doodads.length) {							
				doodads.members[l++].kill();						
			}
			l = 0;
			while (l < lights.length) {							
				lights.members[l++].kill();						
			}
			// reset mana bar to full alpha
			manatext.alpha = 1.0;
			mana.alpha = 1.0;
			lifetext.alpha = 0.5;
			life.alpha = 0.5;
			// add some mana
			mana.currentValue += 10;
			mana.currentValue = (mana.currentValue > 100) ? 100 : mana.currentValue;
			// do switch
			mode = 0;
			world++;
			loadWorld(); // restart level			
		}
		
		// MISC 
		
		private function createSaveGame():void {
			FlxG.save = 0
			FlxG.saves = new Array();
			FlxG.saves[FlxG.save] = new FlxSave();
			FlxG.saves[FlxG.save].bind('save');
			FlxG.saves[FlxG.save].data.highscores = new Array();			
			// start the score at 0
			FlxG.score = 0
		}
		
		private function createBars():void {
			// mana bar
			manatext = new FlxText(FlxG.width - 108, 5, 100, "MANA");
			manatext.alignment = "right";
			manatext.scrollFactor.x = 0;
			manatext.scrollFactor.y = 0;
			add(manatext);
			mana = new FlxBar(FlxG.width - 110, 20, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10);
			mana.setRange(0, 100);
			mana.currentValue = 100;
			mana.scrollFactor.x = 0;
			mana.scrollFactor.y = 0;
			add(mana);
			// score
			scoretext = new FlxText(FlxG.width - 220, 6, 100, "0000");
			scoretext.size = 23;
			scoretext.alignment = "right";
			scoretext.scrollFactor.x = 0;
			scoretext.scrollFactor.y = 0;			
			add(scoretext);			
			// life bar
			lifetext = new FlxText(9, 5, 100, "LIVES");
			lifetext.alignment = "left";
			lifetext.scrollFactor.x = 0;
			lifetext.scrollFactor.y = 0;
			lifetext.alpha = 0.5;
			add(lifetext);
			life = new FlxBar(10, 20, FlxBar.FILL_LEFT_TO_RIGHT, 158, 14);
			life.createImageBar(null, HeartsSheet, 0x0);
			life.setRange(0, 10);
			life.currentValue = 5;
			life.scrollFactor.x = 0;
			life.scrollFactor.y = 0;
			life.alpha = 0.5;
			add(life);	
		}

		public function toggleMute():void {
			FlxG.mute = !FlxG.mute;			
			if (initial_mute) {
				mood.loadEmbedded(Chase, true);
				mood.fadeIn(10);	
				initial_mute = false;
			}
			if (FlxG.mute == true) {
				mood.pause();
			} else {				
				mood.resume();
			}
		}
	}
}