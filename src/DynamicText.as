package {
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.flixel.FlxG;
	import org.flixel.FlxText;

	public class DynamicText extends FlxText {
		
		private var dieTimer:Timer;
		private var onDone:Function;
		
		public function DynamicText(x:Number, y:Number, width:uint, s:uint, text:String, t:int, handler:Function = null) {
			super(x, y, width, text);
			size = s;
			alignment = "center";
			onDone = handler;
			time = t;
			//add text to the current state
			this.scrollFactor.x = 0;
			this.scrollFactor.y = 0;
			FlxG.state.add(this);
			fadeAndDie();			
		}
		
		private var repeats:int = 7;
		private var time:int = 1000;
		
		public function fadeAndDie():void {
			// fade the text
			dieTimer = new Timer((time / repeats), time / (time / repeats));
			dieTimer.addEventListener(TimerEvent.TIMER, fadeText);
			dieTimer.addEventListener(TimerEvent.TIMER_COMPLETE, dieText);
			dieTimer.start();
		}
		
		private function dieText(e:TimerEvent):void {
			dieTimer.removeEventListener(TimerEvent.TIMER, fadeText);
			dieTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, dieText);	
			FlxG.state.remove(this);
			if (onDone != null) {
				onDone();
			}
		}
		
		private function fadeText(e:Event):void {			
			this.alpha = this.alpha - (1.0 / repeats);
		}
	}
}