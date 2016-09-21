package ru.sotsbi.u.adminka.ui.answer{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	
	public class Arrow extends MovieClip {
		private var _selected:Boolean;
		private var _wrong:Boolean;
		private var _label:String;		
//		private const dw:Number = 5; //head owerlays body
		private var head:MovieClip;
		private var tail:MovieClip;
		private var body:MovieClip;
		public function Arrow(w, type, dir) {
			var halfw:Number = w/2;
			var headRect, tailRect:Rectangle;
			switch(type) {
				case 'a':
					body = new ArrowBody();
					head = new ArrowHead();
					tail = new ArrowTail();
					break;
				case 'b':
					body = new BoldBody();
					head = new BoldHead();
					tail = new BoldTail();
					break;
				case 's':
					body = new StateBody();
					head = new StateHead();
					tail = new StateHead();
					tail.scaleX*= -1;
					break;
				case 'p':
					body = new ProcessBody();
					head = new ProcessHead();
					tail = new ProcessTail();
					break;
				case 'n':
					body = new NeedBody();
					head = new NeedHead();
					tail = new NeedTail();
					break;
			}
			addChild(body);
			addChild(head);
			addChild(tail);
			body.gotoAndStop(1);
			head.gotoAndStop(1);
			tail.gotoAndStop(1);
			addChild(body);
			labelTF.width = w;
			labelTF.x = 0;
			switch(dir) {
				case 'left':
					head.x = 0;
					head.scaleX*= -1;
					tail.x = w;
					tail.scaleX*= -1;
					headRect = head.getRect(this);
					tailRect = tail.getRect(this);
					body.width = tailRect.left - headRect.right;
					body.x = headRect.right;
				break;
				case 'right': 
					head.x = w;
					tail.x = 0;
					headRect = head.getRect(this);
					tailRect = tail.getRect(this);
					body.width = headRect.left - tailRect.right;
					body.x = tailRect.right;
				break;
			}
			trace('new Arrow' + [body.x, body.y, body.width, head.x, tail.x, w, this]);
			swapChildren(body,labelTF);
			_selected = false;
			_wrong = false;
		}
		private function updateState() {
			var t:uint;
			if (_selected) {
				t = 2;
			}else if (_wrong) {
				t =	3;
			}else {
				t = 1;
			}
			body.gotoAndStop(t);
			head.gotoAndStop(t);
			tail.gotoAndStop(t);
		}
		public function get label() {
			return labelTF.text;
		}
		public function set label(s:String) {
			labelTF.text = s;//(s != null)?s:'-Err-';
		}
		public function get wrong() {
			return _wrong;
		}
		public function set wrong(b:Boolean) {
			_wrong = b;
			updateState();
		}
		public function get selected() {
			return _selected;
		}
		public function set selected(b:Boolean) {
			_selected = b;
			updateState();
		}
	}
}