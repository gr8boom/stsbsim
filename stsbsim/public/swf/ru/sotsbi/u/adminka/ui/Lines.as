package ru.sotsbi.u.adminka.ui{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	public class Lines extends MovieClip {
		private var _attributes:Array;
		public function Lines(attr:Array = null) {
			_attributes = new Array();
			if (attr==null) {
				attr = new Array();
			}
			if (attr['y']==undefined) {
				attr['y']=0;
			}
			if (attr['x1']==undefined) {
				attr['x1']=300;
			}
			if (attr['x2']==undefined) {
				attr['x2']=350;
			}
			if (attr['x3']==undefined) {
				attr['x3']=400;
			}
			attributes = attr;
			line0.addEventListener(MouseEvent.MOUSE_DOWN, line_mouseDownHnd);
			line1.addEventListener(MouseEvent.MOUSE_DOWN, line_mouseDownHnd);
			line2.addEventListener(MouseEvent.MOUSE_DOWN, line_mouseDownHnd);
			line3.addEventListener(MouseEvent.MOUSE_DOWN, line_mouseDownHnd);
			line0.addEventListener(MouseEvent.MOUSE_UP, line_mouseUpHnd);
			line1.addEventListener(MouseEvent.MOUSE_UP, line_mouseUpHnd);
			line2.addEventListener(MouseEvent.MOUSE_UP, line_mouseUpHnd);
			line3.addEventListener(MouseEvent.MOUSE_UP, line_mouseUpHnd);
			line0.addEventListener(MouseEvent.ROLL_OVER, line_rollOverHnd);
			line1.addEventListener(MouseEvent.ROLL_OVER, line_rollOverHnd);
			line2.addEventListener(MouseEvent.ROLL_OVER, line_rollOverHnd);
			line3.addEventListener(MouseEvent.ROLL_OVER, line_rollOverHnd);
			line0.addEventListener(MouseEvent.ROLL_OUT, line_rollOutHnd);
			line1.addEventListener(MouseEvent.ROLL_OUT, line_rollOutHnd);
			line2.addEventListener(MouseEvent.ROLL_OUT, line_rollOutHnd);
			line3.addEventListener(MouseEvent.ROLL_OUT, line_rollOutHnd);
		}
		private function line_mouseDownHnd(e:MouseEvent) {
			var rect:Rectangle;
			var line:Object = e.target;
			var dx:Number = line1.width / 2;
			switch(line) {
				case line0:
					rect = new Rectangle(0, 0, 0, 300);
					break;
				case line1:
					rect = new Rectangle(0, 0, line2.x-dx, 0);
					break;
				case line2:
					rect = new Rectangle(line1.x+dx, 0, line3.x-dx, 0);
					break;
				case line3:
					rect = new Rectangle(line2.x+dx, 0, 650, 0);
					break;
			}
			
			e.currentTarget.startDrag(false,rect);
		}
		private function line_mouseUpHnd(e:MouseEvent) {
			e.currentTarget.stopDrag();
			dispatchEvent(new Event(Event.CHANGE, true));
		}		
		private function line_rollOverHnd(e:MouseEvent) {
			e.currentTarget.gotoAndStop(2);
		}		
		private function line_rollOutHnd(e:MouseEvent) {
			e.currentTarget.gotoAndStop(1);
		}
		public function toXML() {
			var xml = new XML('<LINES/>');
			xml.@y = line0.y;
			xml.@x1 = line1.x;
			xml.@x2 = line2.x;
			xml.@x3 = line3.x;
			return xml;
		}
		public function set attributes(a:Array) {
			_attributes = a;
			line0.y = a['y'];
			line1.x = a['x1'];
			line2.x = a['x2'];
			line3.x = a['x3'];
		}
		public function get attributes() {
			_attributes['y'] = line0.y;
			_attributes['x1'] = line1.x;
			_attributes['x2'] = line2.x;
			_attributes['x3'] = line3.x;
			return _attributes;
		}
	}
}