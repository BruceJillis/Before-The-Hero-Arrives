package
{
	import org.flixel.*;

	public class MenuState extends FlxState {	
		private var background:FlxSprite;
		private var clouds:FlxSprite;
		private var btnStartGame:FlxButton;
		private var btnMute:FlxButton;
		[Embed(source = "data/brgounde.png")] public static var CastleSheet:Class;
		[Embed(source = "data/klouwds.png")] public static var CloudsSheet:Class;
		[Embed(source = "data/Oppressive Gloom.mp3")] public static var Gloom:Class;
		[Embed(source = "data/mude.png")] public static var MuteSheet:Class;
		private var mood:FlxSound;
		
		override public function create():void {			
			background = new FlxSprite(0, 0);
			background.loadGraphic(CastleSheet, false, false, 640, 480);			
			add(background);
			//
			clouds = new FlxSprite(0, FlxG.height / 3);
			clouds.loadGraphic(CloudsSheet, false, false, 557, 41);			
			add(clouds);
			// anim
			btnStartGame = new FlxButton((FlxG.width / 2) - 40, (FlxG.height / 6) - 50, "Start Game", startGame);			
			add(btnStartGame);
			// mute
			btnMute = new FlxButton(FlxG.width - 36, FlxG.height - 36);
			btnMute.loadGraphic(MuteSheet, false, false, 32, 32);
			btnMute.onDown = toggleMute;
			btnMute.scrollFactor.x = 0;
			btnMute.scrollFactor.y = 0;			
			add(btnMute);
			// music
			mood = new FlxSound();
			mood.loadEmbedded(Gloom, true);
			mood.fadeIn(10);
			FlxG.mute = false;
			// show the mouse
			FlxG.mouse.show();
		}
		
		public function toggleMute():void {
			FlxG.mute = !FlxG.mute;			
			if (FlxG.mute == true) {
				mood.pause();
			} else {
				mood.resume();
			}
		}
		
		override public function update():void {
			super.update();
			clouds.x += 0.2;
			if (clouds.x >= 557) {
				clouds.x = -557;
			}
			if ( FlxG.keys.justPressed("SPACE") ) {
				startGame();
			}		
		}
		
		private function startGame():void {
			mood.stop();
			FlxG.switchState(new PlayState);
		}
	}
}