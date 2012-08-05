package
{
	import org.flixel.*;
	import DynamicText;
	
	public class LoseState extends FlxState {			
		private var switched:Boolean;
		
		override public function create():void {				
			switched = false;
			var text1:DynamicText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15, 400, 30, "You Lost!", 10000, switchToMenu);
			var text2:DynamicText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15 + 50, 400, 20, "As The Hero Reaches Your Inner Sanctum You See Him Taking Your Precious Princess", 4000, secondText);
		}
		
		public function secondText():void {
			if (!switched) {
				var text3:DynamicText = new DynamicText((FlxG.width / 2) - 200, (FlxG.height / 4) - 15 + 50, 400, 20, "Forever Alone Level: Loser", 4000, allDone);
			}
		}
		
		public function allDone():void {
			if (!switched) {
				switchToMenu();
			}
		}
		
		override public function update():void {
			super.update();
			if ( FlxG.keys.justPressed("SPACE") ) {
				switchToMenu();
			}		
		}		
		
		public function switchToMenu():void {
			switched = true;
			FlxG.switchState(new MenuState);
		}
	}
}