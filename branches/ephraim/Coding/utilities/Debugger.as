package utilities {
	import flash.display.Sprite;
	import flash.events.*;
	import fl.controls.TextInput;
	import fl.controls.Button;
	
	public class Debugger extends Sprite {
		public var _container:Sprite = new Sprite();
		private var _shown:Boolean = true;
		private var _curX:Number = 920;
		private var _curY:Number = 10;
		private var _width:Number = 70;
		private var _height:Number = 30;
		
		public function Debugger():void {
			var debugButton:Button = new Button();
			with (debugButton) {
				x = _curX;
				y = _curY;
				width = _width;
				height = _height;
				label = "Debug";
				addEventListener(MouseEvent.CLICK, activate);
				toggle = true;
			}
			setStyles(debugButton);
			this.addChild(debugButton);
			this.addChild(_container);
			this.name = "Debugger";
		}
		
		private function setStyles(button:Button):void {
			var down:Default_downSkin = new Default_downSkin();
			var up:Default_upSkin = new Default_upSkin();
			var over:Default_overSkin = new Default_overSkin();
			with(button) {
				setStyle("downSkin", down);
				setStyle("overSkin", over);
				setStyle("upSkin", up);
			}
		}
		
		private function activate(e:MouseEvent):void {
			if (_shown) {
				_container.visible = false;
				_shown = false;
			} else {
				_container.visible = true;
				_shown = true;
			}
		}
		
		private function getY():Number {
			_curY = _curY+(_height+10);
			if (_curY >= 600) {
				_curY = 10;
				_curX = _curX-(_width+10);
			}
			return(_curY);
		}
		
		public function addButton(action:Function, title:String):void {
			var newButton:Button = new Button();
			with (newButton) {
				x= _curX;
				y= getY();
				width = _width;
				height = _height;
				label = title;
				addEventListener(MouseEvent.CLICK, action);
			}
			setStyles(newButton);
			_container.addChild(newButton);
		}
		
		public function addTextBox(title:String):void {
			var newText:TextInput = new TextInput();
			with (newText) {
				x= _curX;
				y= getY();
				width = _width;
				height = _height;
				name = title;
				editable = true;
			}
			_container.addChild(newText);
		}
		
		public function closeUp():void {
			activate(new MouseEvent(MouseEvent.CLICK));
		}
	}
}