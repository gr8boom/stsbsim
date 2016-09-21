package ru.sotsbi.u.adminka.ui {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
    public class Submenu extends MovieClip
    {
		public var items:Array; //of MItem
		private var _rootSubmenu:Boolean;
		private var _answerMode:Boolean;
		private var count:uint;
		private var itemSpace:Number;
		private var leftSpace:Number;
		
		public function Submenu()
        {
			_rootSubmenu = false;
			itemSpace = 3;
			leftSpace = 3;
			items = new Array();
			count = 0;
			addEventListener(MenuEvent.REDRAW, redrawHnd);
			addEventListener(MenuEvent.SUBMENU_OPEN, submenuOpenHnd);
//			addEventListener(MenuEvent.CONVERT_TO_NODE, manualConvertToNodeHnd);
			addEventListener(MenuEvent.CUSTOM_ROLL_OVER, rollOverHnd);
			addEventListener(MenuEvent.REMOVE_CLICK, removeClickHnd);
			addEventListener(MenuEvent.ADD_BEFORE_CLICK, addBeforeClickHnd);
			addEventListener(MenuEvent.ADD_AFTER_CLICK, addAfterClickHnd);
        }
		public function addItem(attr:Object = null, k:int = -1){
			for(var s:String in attr){
				trace('sub addi attr['+s+']='+attr[s]);
			}			
			var item:MItem = new MItem(attr);
			var prevItem:MItem;
			if(items.length > 0){
				prevItem = items[items.length-1];
				item.y = prevItem.y + prevItem.innerHeight + itemSpace;
			}else{
				item.y = 0;
			}
			item.x = leftSpace;
			if(k < 0){
				items.push(item);
			}else{
				items.splice(k,0,item);
			}
			addChild(item);
			item.answerMode = _answerMode;
			item.dispatchEvent(new MenuEvent(MenuEvent.ADD_ITEM, true));
			return item;
		}
		public function redrawItems(){
			var prevItem:MItem;
			var first:Boolean = true;
			for each(var item in items){
				item.x = leftSpace;
				if(first){
					item.y = 0;
					first = false;
				}else{
					item.y = prevItem.y + prevItem.innerHeight + itemSpace;
				}
				prevItem = item;
			}
		}
		public function hideSubmenus(){
			for each(var item in items){
				trace(item);
				item.showSubmenu = false;
			}
		}
		private function redrawHnd(e:MenuEvent){
			redrawItems();
		}
		private function manualConvertToNodeHnd(e:MenuEvent){
			e.target.submenu.addItem();			
		}
		private function addBeforeClickHnd(e:MenuEvent){
			e.stopPropagation();			
			trace('add^');
			var k:Number = items.indexOf(e.target);
			if(k >= 0){
				var a:Array = new Array();
				a['type'] = MItem.TYPE_NO;
				addItem(a, k);
			}
			redrawItems();
		}
		private function addAfterClickHnd(e:MenuEvent){
			e.stopPropagation();			
			var k:Number = items.indexOf(e.target);
			trace('addV '+' '+k);
			if(k >= 0){
				var a:Array = new Array();
				a['type'] = MItem.TYPE_NO;
				addItem(a, k+1);
			}
			redrawItems();
		}

		private function removeClickHnd(e:MenuEvent){
			e.stopPropagation();
			if(_rootSubmenu && items.length == 1){
				return;
			}
			for(var k:String in items){
				if(items[k] == e.target){
					removeChild(items[k]);
					items.splice(k,1);
				}
			}
			if(items.length == 0){
				dispatchEvent(new MenuEvent(MenuEvent.EMPTY_SUBMENU));
			}
			redrawItems();
		}
		private function submenuOpenHnd(e:MenuEvent){
			e.stopPropagation();
			for each(var item in items){
				if(item != e.target){
					item.showSubmenu = false;
				}
			}
		}
		private function rollOverHnd(e:MenuEvent){
			e.stopPropagation();
			var topChild = getChildAt(numChildren-1);
			swapChildren(e.target as DisplayObject, topChild);
//			trace([e.target,topChild]);
		}
		public function set rootSubmenu(b:Boolean){
			_rootSubmenu = b;
		}
		public function set answerMode(b:Boolean){
			if(_answerMode == b) return;
			_answerMode = b;
			for each(var item:MItem in items){
				item.answerMode = b;
			}
		}
		public function get answerMode(){
			return _answerMode;
		}
    }
}