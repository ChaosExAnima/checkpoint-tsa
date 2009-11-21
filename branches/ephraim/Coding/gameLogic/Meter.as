package gameLogic {
	
	import flash.display.DisplayObject;
    import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
    import flash.utils.Timer;
	import flash.ui.Mouse;
	import gameLogic.ProhibitedObject;
	import gameLogic.PassengerStub;
	
    public class Meter extends Sprite
    {
		var m_meterMC:MovieClip;
		var NUM_STEPS = 47;
		var MAX_DETECT_DISTANCE = 150;
		var USES_PER_LEVEL = 3;
		var LENGTH_OF_USE = 20; // seconds
		var stopFlag:Boolean = false;
		
		var m_remainingUses:int = USES_PER_LEVEL;
		var m_timer:Timer;
		
		var m_cursorMC:MovieClip;
		var m_stage:Stage;
		
		public function Meter(aStage:Stage, aMC:MovieClip, cursor:MovieClip)
		{
			m_meterMC = aMC;
			m_cursorMC = cursor;
			m_stage = aStage;
						
						
			addChild(m_meterMC);
			//m_meterMC.x = 0;
			//m_meterMC.y = 600;
			
			aStage.addChild(m_cursorMC);		
			
			m_meterMC.knife_mc.addEventListener(Event.ENTER_FRAME, MeterNoise);
			m_meterMC.knife_mc.lastNoise = 0;
			m_meterMC.gun_mc.addEventListener(Event.ENTER_FRAME, MeterNoise);
			m_meterMC.gun_mc.lastNoise = 0;
			m_meterMC.drug_mc.addEventListener(Event.ENTER_FRAME, MeterNoise);
			m_meterMC.drug_mc.lastNoise = 0;
			m_meterMC.bomb_mc.addEventListener(Event.ENTER_FRAME, MeterNoise);
			m_meterMC.bomb_mc.lastNoise = 0;
		
			m_meterMC.btn_stop.addEventListener(MouseEvent.CLICK, onButtonStop);
		
			m_meterMC.visible = false;
			m_cursorMC.visible = false;
		}

		
		public function StartHotColdGame()
		{
			
			if(m_remainingUses > 0)
			{
				m_meterMC.visible = true;
				m_cursorMC.visible = true;
				Mouse.hide();
				
				ResetMeters();
	
				m_remainingUses--;
				
				m_timer = new Timer(1000, LENGTH_OF_USE);
				
           		m_timer.addEventListener(TimerEvent.TIMER, onTick);
          		m_timer.addEventListener(TimerEvent.TIMER_COMPLETE, StopColdGame);
				
				m_timer.start();
				stopFlag = false;
			}
		}
		
		
		public function onButtonStop(e:MouseEvent) 
		{
			StopColdGame(null);
		}
		
		public function StopColdGame(event:TimerEvent)
		{
			//m_meterMC.visible = false;		
			m_cursorMC.visible = false;
			Mouse.show();
			
			m_timer.stop();
			m_meterMC.meter_countdown.text = LENGTH_OF_USE;
			stopFlag = true;
		}
		
		public function flagStop():Boolean
		{
			return stopFlag
		}
		
		public function onTick(event:TimerEvent)
		{
			m_meterMC.meter_countdown.text = LENGTH_OF_USE-event.target.currentCount;
		}
		
		public function OnNewLevel()
		{
			m_remainingUses = USES_PER_LEVEL;
			ResetMeters();
		}
		
		public function ResetMeters()
		{
			if(!m_meterMC.visible)
				return;
			
			var maxCurrViolation = Math.max(m_meterMC.knife_mc.currentFrame,m_meterMC.gun_mc.currentFrame,
									m_meterMC.drug_mc.currentFrame,m_meterMC.bomb_mc.currentFrame);
			
			if(maxCurrViolation > 43)
			{
				if( m_cursorMC.currentFrame != 3)
					m_cursorMC.gotoAndStop(3);
			}
			else if(maxCurrViolation > 36)
			{
				if(m_cursorMC.currentFrame != 2)
					m_cursorMC.gotoAndStop(2);
			}
			else if(m_cursorMC.currentFrame != 1)
				m_cursorMC.gotoAndStop(1);
			
			
			m_meterMC.knife_mc.gotoAndStop(0);
			m_meterMC.gun_mc.gotoAndStop(0);
			m_meterMC.drug_mc.gotoAndStop(0);
			m_meterMC.bomb_mc.gotoAndStop(0);
			
			m_cursorMC.x = m_stage.mouseX;
			m_cursorMC.y = m_stage.mouseY;
			
		}
		
		// checks individual and adds violation to culmative effect
		public function CheckPassengerViolation(aPass:PassengerStub, xmouse:int, ymouse:int)
		{
			var prohibObj = aPass.carriesWhat();
			if(prohibObj)
			{
				var newFrame;
				var percent = PassengerConcealPercent(aPass, xmouse, ymouse);
				var frameChange:int = 1+ NUM_STEPS * percent / 100;
				
				
				switch(prohibObj.getKindOfObj())
				{
					case "bomb":
						newFrame = Math.min(NUM_STEPS, m_meterMC.bomb_mc.currentFrame + frameChange);
						m_meterMC.bomb_mc.gotoAndStop(newFrame);
						break;
					case "drugs":
						newFrame = Math.min(NUM_STEPS, m_meterMC.drug_mc.currentFrame + frameChange);
						m_meterMC.drug_mc.gotoAndStop(newFrame);
						break;
					case "gun":
						newFrame = Math.min(NUM_STEPS, m_meterMC.gun_mc.currentFrame + frameChange);
						m_meterMC.gun_mc.gotoAndStop(newFrame);
						break;
					case "knife":
						newFrame = Math.min(NUM_STEPS, m_meterMC.knife_mc.currentFrame + frameChange);
						m_meterMC.knife_mc.gotoAndStop(newFrame);
						break;
						
					
				}
			}
		}
		
		

		private function MeterNoise(event:Event)
		{
			var thisMC:MovieClip = MovieClip(event.target);
				  
			//thisMC = event.target;
		
			var noise = Math.round(Math.random()*(2))-1; // get a number from -1 to 1
			if(noise == thisMC.lastNoise || noise == 0)
				return;
			
			if(noise == 1 && thisMC.currentFrame != thisMC.totalFrames)
				thisMC.nextFrame();
			else if (noise == -1 && thisMC.currentFrame > 0)
				thisMC.prevFrame();
				
			thisMC.lastNoise = noise;	
		}
		
	

		
		private function PassengerConcealPercent(myPass:PassengerStub, x:int, y:int)
		{
			var passDistance = myPass.GetDistance(x,y);
			if(passDistance > MAX_DETECT_DISTANCE)
				return 0;
			
			var passConceal = myPass.GetConceal();
			// the greater the concealment the farther away from the passenger
			// the meter maxes out.
		
			var radiusForMaxMeter = MAX_DETECT_DISTANCE * passConceal / 100;
	
			if(passDistance <= radiusForMaxMeter)
				return 100;
	
			return 100-((passDistance-radiusForMaxMeter)/MAX_DETECT_DISTANCE*100);
		
		}
    }
	
/*	public function setPos(xLoc:Number, yLoc:Number):void
	{
			m_meterMC.x = xLoc;
			m_meterMC.y = yLoc;
	}*/
}
