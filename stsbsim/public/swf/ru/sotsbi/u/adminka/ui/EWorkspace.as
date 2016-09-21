package ru.sotsbi.u.adminka.ui{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ru.sotsbi.u.adminka.i18.I18MovieClip;

	public class EWorkspace extends I18MovieClip {
		public static const TYPE_FIELD:String='field';
						
		private var submenu:Submenu;
		private var _showAnswers:Boolean;
		private var grid:Sprite;
		private var _showGrid:Boolean;
		private var blocksContainer:MovieClip;
		private var fields:Array;//of fields
		public function EWorkspace() {
			eToolbar.addTF.mouseEnabled = false;
			eToolbar.delTF.mouseEnabled = false;
			eToolbar.glueTF.mouseEnabled = false;
			blocksContainer = new MovieClip();
			addChild(blocksContainer);
			grid = new Sprite();
			grid.mouseEnabled=false;
			drawGrid();
			addChild(grid);
			eToolbar.addBtn.addEventListener(MouseEvent.CLICK, addBtn_clickHnd);
			eToolbar.removeBtn.addEventListener(MouseEvent.CLICK, removeBtn_clickHnd);
			eToolbar.stepCB.addEventListener(Event.CHANGE, stepCB_changeHnd);
			lines.addEventListener(Event.CHANGE, lines_changeHnd);
			blocksContainer.addEventListener(Event.CHANGE, changeHnd);
			addEventListener(Event.SELECT, selectHnd);
		}
		public function init(xml:XMLList) {
			for each(var field:Block in fields){
				removeChild(field);
			}
			fields = new Array();
			generateFields(xml);
		}
		private function drawGrid(step:uint = 10, x0:uint = 0, y0:uint = 0, c:uint = 6710886) {
			for (var i=step; i<650; i+=step) {
				if (i%(step*5)==0) {
					grid.graphics.lineStyle(0,c,0.6);
				} else {
					grid.graphics.lineStyle(0,c,0.3);
				}
				grid.graphics.moveTo(i,0);
				grid.graphics.lineTo(i,500);
			}
			for (i=step; i<500; i+=step) {
				if (i%(step*5)==0) {
					grid.graphics.lineStyle(0,c,0.6);
				} else {
					grid.graphics.lineStyle(0,c,0.3);
				}
				grid.graphics.moveTo(0, i);
				grid.graphics.lineTo(650, i);
			}
		}
		private function generateFields(xml:XMLList) {
			var subnode:XML;
			var x0,y0:Number;
			var a:Array;
			for each (var node:XML in xml) {
				if (node.name()=='BLOCKS') {
					x0=Number(node.attribute('x'));
					y0=Number(node.attribute('y'));
					for each (subnode in node.children()) {
//						trace(subnode.name());
						if (subnode.name()=='BLOCK') {
							a = new Array();
							a['x']=x0+Number(subnode.attribute('x'));
							a['y']=y0+Number(subnode.attribute('y'));
							a['width']=Number(subnode.attribute('w'));
							a['height']=Number(subnode.attribute('h'));
							a['txt']=String(subnode.attribute('txt'));
							a['c']=Number(subnode.attribute('c'));
							a['manual']=uint(subnode.attribute('len'))>0;
							a['len'] = uint(subnode.attribute('len'));
							if (subnode.attribute('brdr') == undefined) {
								a['brdr'] = 1; //default value
							}else {
								a['brdr'] = uint(subnode.attribute('brdr'));
							}
							if (subnode.attribute('chars')!=undefined) {
								a['chars']=subnode.attribute('chars');
							} else {
								a['chars']='a-zа-я0-9';
							}
						}
						addBlock(a);
					}
				}
				if (node.name() == 'LINES') {
					a = new Array();
					a['y'] = Number(node.attribute('y'));
					a['x1'] = Number(node.attribute('x1'));
					a['x2'] = Number(node.attribute('x2'));
					a['x3'] = Number(node.attribute('x3'));
					lines.attributes = a;
				}
			}
		}
		private function addBlock(a:Array = null) {
			var id:uint;
			var field:Block=new Block(a);
			field.stepOn=eToolbar.stepCB.selected;
			id=fields.push(field);
//			trace([field,id,fields[id-1]]);
			blocksContainer.addChild(fields[id - 1]);
			
			return field;
		}
		private function removeBlock(a:Array = null) {
			for each (var field:Block in fields) {
				if (field.selected == true) {
					blocksContainer.removeChild(field);
					fields.splice(fields.indexOf(field), 1); 
					return;
				}
			}
		}
		private function selectHnd(e:Event) {
			for each (var field:Block in fields) {
				trace([e.target,field]);
				if (e.target!=field) {
					field.selected=false;
				}
			}
			var topChild=blocksContainer.getChildAt(blocksContainer.numChildren-1);
			blocksContainer.swapChildren(e.target as DisplayObject,topChild);
		}
		private function changeHnd(e:Event) {
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function stepCB_changeHnd(e:Event) {
			for each (var field:Block in fields) {
				field.stepOn=eToolbar.stepCB.selected;
			}
		}
		private function addBtn_clickHnd(e:MouseEvent) {
			addBlock();
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function removeBtn_clickHnd(e:MouseEvent) {
			removeBlock();
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		private function lines_changeHnd(e:Event) {
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		public function get showGrid() {
			return _showGrid;
		}
		public function set showGrid(b:Boolean) {
			if (b) {
				_showGrid=true;
				grid.visible=true;
			} else {
				_showGrid=false;
				grid.visible=false;
			}
		}
		public function toXML() {
			var xml:XMLList = new XMLList();
			var att:Array;
			var tempXml:XML = new XML('<BLOCKS />');
			for each (var field:Block in fields) {
				tempXml.appendChild(field.toXML());
			}
			xml+= tempXml;
			xml+= lines.toXML();
			return xml;
		}
		
		public function get attributes(){
			var t:Array = new Array();
			t['blocks'] = new Array();
			for each (var field:Block in fields) {
				t['blocks'].push(field.attributes);
			}
			var a:Array = lines.attributes;
			for(var k in a){ 
				t[k] = a[k];
			}
			return t;
		}

	}
}