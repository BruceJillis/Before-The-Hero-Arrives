package
{
	import org.flixel.*;

	public class MenuState extends FlxState {	
		private var btnStartGame:FlxButton;
		private var btnHighscores:FlxButton;
		private var btnOptions:FlxButton;

		override public function create():void {			
			btnStartGame = new FlxButton((FlxG.width / 2) - 40, (FlxG.height / 2) - 10, "Start Game", startGame);
			add(btnStartGame);
				
			FlxG.mouse.show();
		}
		
		override public function update():void {
			super.update();
			if ( FlxG.keys.any() ) {
				startGame();
			}		
		}
		
		private function startGame():void {
			FlxG.switchState(new PlayState);
		}
	}
}