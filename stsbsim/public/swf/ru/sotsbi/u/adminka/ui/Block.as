package ru.sotsbi.u.adminka.ui{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.ColorTransform;
	public class Block extends MovieClip {
		private var dragCornerFlg:Boolean;
		private var step:uint;
		private var _stepOn:Boolean;
		private var _type:String;
		private var _selected:Boolean;
		private var _attributes:Array;
		private var prepareDrag:Boolean;
		private var dragMoverFlg:Boolean;
		private var colorTrans = new ColorTransform();
		public function Block(a:Array = null) {
			prepareDrag=false;
			dragMoverFlg=false;
			_type=EWorkspace.TYPE_FIELD;
			if (a==null) {
				a = new Array();
				a['c']=uint('0xAAAAAA');
				a['txt']='Новое поле';
				a['x']=20;
				a['y']=20;
				a['width']=120;
				a['height']=50;
				a['brdr'] = 1;
				a['manual'] = false;
				a['chars'] = '0-9a-z';
				a['len'] = 0;
			}
			attributes=a;
			mover.height=bgd.height=textTF.height=frame.height=a['height'];
			mover.width=bgd.width=textTF.width=frame.width=a['width'];
			step=5;
			_stepOn=false;
			dragCornerFlg=false;
			selected=false;
			mover.doubleClickEnabled=true;
			mover.addEventListener(MouseEvent.MOUSE_UP, mover_mouseupHnd);
			mover.addEventListener(MouseEvent.MOUSE_DOWN, mover_mousedownHnd);
			mover.addEventListener(MouseEvent.ROLL_OVER, mover_rolloverHnd);
			mover.addEventListener(MouseEvent.ROLL_OUT, mover_rolloutHnd);
			mover.addEventListener(MouseEvent.DOUBLE_CLICK, mover_dblClickHnd);
			corner.addEventListener(MouseEvent.ROLL_OVER, corner_rolloverHnd);
			corner.addEventListener(MouseEvent.ROLL_OUT, corner_rolloutHnd);
			corner.addEventListener(MouseEvent.MOUSE_UP, corner_mouseupHnd);
			corner.addEventListener(MouseEvent.MOUSE_DOWN, corner_mousedownHnd);
			addEventListener(MouseEvent.MOUSE_MOVE, mousemoveHnd);
		}
		private function mover_dblClickHnd(e:MouseEvent) {
			trace('dbl click');
			dispatchEvent(new MenuEvent(MenuEvent.ITEM_DOUBLE_CLICK, true));
		}
		private function mover_rolloverHnd(e:MouseEvent) {
			mover.gotoAndStop(3);
		}
		private function mover_rolloutHnd(e:MouseEvent) {
			mover.gotoAndStop(1);
		}
		private function mover_mousedownHnd(e:MouseEvent) {
			if (! selected) {
				selected=true;
				dispatchEvent(new Event(Event.SELECT, true));
			}
			prepareDrag=true;

			startDrag();
		}
		private function mover_mouseupHnd(e:MouseEvent) {
			stopDrag();
			dragMoverFlg=false;
			prepareDrag=false;
			if (_stepOn) {
				x=Math.round(x/step)*step;
				y=Math.round(y/step)*step;
				frame.x=0;
				frame.y=0;
			}
			_attributes['x']=x;
			_attributes['y']=y;

			dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function mover_mousemoveHnd(e:MouseEvent) {
		}
		private function corner_rolloverHnd(e:MouseEvent) {
			if (dragCornerFlg==false) {
				corner.gotoAndStop(2);
			}
		}
		private function corner_rolloutHnd(e:MouseEvent) {
			if (dragCornerFlg==false) {
				corner.gotoAndStop(1);
			}
		}
		private function corner_mouseupHnd(e:MouseEvent) {
			dragCornerFlg=false;
			corner.stopDrag();
			_attributes['height']=mover.height=bgd.height=textTF.height=frame.height;
			_attributes['width']=mover.width=bgd.width=textTF.width=frame.width;
			corner.x=frame.width;
			corner.y = frame.height;
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function corner_mousedownHnd(e:MouseEvent) {
			dragCornerFlg=true;
			corner.startDrag();
		}
		private function mousemoveHnd(e:MouseEvent) {
			if (dragCornerFlg) {
				if (mouseX<15||mouseY<15) {
					return;
				}
				if (_stepOn) {
					corner.x=Math.round(mouseX/step)*step;
					corner.y=Math.round(mouseY/step)*step;
				} else {
					corner.x=mouseX;
					corner.y=mouseY;
				}
				frame.width=corner.x;
				frame.height=corner.y;
			}
			if (prepareDrag) {
				dragMoverFlg=true;
				startDrag();
			}
			if (dragMoverFlg) {
				if (_stepOn) {
					frame.x=Math.round(x/step)*step-x;
					frame.y=Math.round(y/step)*step-y;
				}
			}
		}
		public function toXML() {
			var xml=new XML('<BLOCK/>');
			xml.@txt=_attributes['txt'];
			xml.@x=_attributes['x'];
			xml.@y=_attributes['y'];
			xml.@w=_attributes['width'];
			xml.@h=_attributes['height'];
			xml.@c=_attributes['c'];
			if (_attributes['brdr'] === 0) {
				xml.@brdr = 0;
			}
			if (attributes['len']>0) {
				xml.@len=_attributes['len'];
				xml.@chars=_attributes['chars'];
			}
			return xml;
		}
		public function get attributes() {
//			trace('get block attributes' + _attributes['brdr']);
			return _attributes;
		}
		public function set attributes(a:Array) {
			trace('blocks aaaaalensa '+a['len']);
			if (a['c']) {
				colorTrans.color=a['c'];
				bgd.transform.colorTransform=colorTrans;
			}
			if (a['txt']) {
				textTF.text=a['txt'];
			}
			if (a['x']) {
				var tx:int=int(a['x']);
				if (tx<0) {
					tx=0;
				}
				if (tx>640) {
					tx=640;
				}
				x=tx;
			}
			if (a['y']) {
				var ty:int=int(a['y']);
				if (ty<0) {
					ty=0;
				}
				if (ty>500) {
					ty=500;
				}
				y=ty;
			}
			if (a['height']) {
				var th:uint=uint(a['height']);
				if (th<20) {
					ty=20;
				}
				if (th>500) {
					th=500;
				}
				textTF.height = th;
				bgd.height = th;
				frame.height=corner.y=th;
			}
			if (a['width']) {
				var tw:uint=uint(a['width']);
				if (tw<15) {
					tw=15;
				}
				if (tw>640) {
					tw=640;
				}
				bgd.width=tw;
				textTF.width=tw;
				frame.width=corner.x=tw;
			}
			if (a['brdr']!=undefined && a['brdr'] == 0) {
				textTF.border = false;
			}else {
				textTF.border = true;
			}
			mover.x=0;//corner.x/2;
			mover.y=0;//corner.y/2;
			_attributes = a;
			trace('set block attributes' + a['brdr']);
		}
		public function get stepOn() {
			return _stepOn;
		}
		public function set stepOn(b:Boolean) {
			_stepOn=b;
		}
		public function get selected() {
			return _selected;
		}
		public function set selected(b:Boolean) {
			if (b) {
				_selected=true;
				colorTrans.color=0xFFFFFF;
				bgd.transform.colorTransform=colorTrans;
				corner.visible=true;
				frame.visible=true;
			} else {
				_selected=false;
				colorTrans.color=uint(_attributes['c']);
				bgd.transform.colorTransform=colorTrans;
				corner.visible=false;
				frame.visible=false;
			}
		}
		public function get type() {
			return _type;
		}
	}
}