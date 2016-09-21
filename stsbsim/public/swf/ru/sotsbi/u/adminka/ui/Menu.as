package ru.sotsbi.u.adminka.ui {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ru.sotsbi.u.adminka.data.Relations;
	import ru.sotsbi.u.adminka.debug.DbgEvent;
	import ru.sotsbi.u.adminka.data.UObject;
	
    public class Menu extends MovieClip
    {
		private var _submenu:Submenu;
		private var _ids:Array; //of  id->menuItem
		private var _answerMode:Boolean;
		private var _disabled:Boolean;
		public function Menu()
        {
			_ids = new Array();
			_answerMode = false;
			_disabled = false;
			addEventListener(MenuEvent.ADD_ITEM, addItemHnd);
        }
		public function init(xml:XMLList){
			_ids = new Array();
			var item:MItem;
			var sub:Submenu;
			if (_submenu) {
				removeChild(_submenu);
			}
			_submenu = new Submenu();
			_submenu.rootSubmenu = true;
			addChild(_submenu);
			generateSubmenu(xml, _submenu);
			trace('sub ' + _submenu.x + _submenu.y + _submenu.visible );
			if (_submenu.items.length == 0) {
				xml = new XMLList('<B txt="Block" w="100"/>');
				generateSubmenu(xml, _submenu);
			}
			addEventListener(MenuEvent.ITEM_CLICK, itemClickHnd);
		}
		private function generateSubmenu(xml:XMLList, target:Submenu){
			var a:Object;
			var node:XML;
			var name:String;
			var sub:Submenu;
			var item:MItem;
			var attList:XMLList;
			for each(node in xml){
//				trace([node,node.name(),node.name()=='MENU']);
				name = node.name();
				a = {};
				attList = node.attributes();
				for (var i:int = 0; i < attList.length(); i++){
					if(attList[i].nodeKind() == 'attribute'){
						a[String(attList[i].name())] = String(attList[i]);
					}
				}
				switch(name){
//TODO: в БД именование аттрибутов меню другое. В редакторе label это текст кнопки, а text это текст блока. В БД txt это текст кнопки, а label это текст блока. Хорошо бы привести к единообразию(версия в редакторе более логичная кмк).
					case 'B':
						a['type'] = MItem.TYPE_BLOCK;
						target.addItem(a);
					break;
					case 'A':
						a['type'] = MItem.TYPE_ARROW;
						target.addItem(a);
					break;
					case 'M':
						a['type'] = MItem.TYPE_NODE;
						item = target.addItem(a);
						generateSubmenu(node.children(), item.submenu);
					break;
				}
			}
		}
		public function toXML(submenu:Submenu = null){
			if(submenu == null){
				submenu = _submenu;
			}
			var xmlList:XMLList = new XMLList;
			var tmpXmlList:XMLList = new XMLList;
			var att:Array;
			var tempXml:XML;
//			trace(submenu);
			for each(var item:MItem in submenu.items){
				att = item.attributes;
				tempXml = new XML('<node/>');
				tempXml.@txt = att['txt'];
				tempXml.@w = att['w'];
//				dispatchEvent(new DbgEvent(DbgEvent.TRACE, [item, item.type],true));
				switch(item.type){
					case MItem.TYPE_NODE:
						tempXml.setName('M');
						tmpXmlList = toXML(item.submenu);
						if (tmpXmlList.length() == 0) continue;
						tempXml.appendChild(toXML(item.submenu));
					break;
					case MItem.TYPE_ARROW:
						tempXml.setName('A');
						tempXml.@id = att['id'];
						tempXml.@lbl = att['lbl'];
						tempXml.@txt = att['txt'];
						tempXml.@mc = att['mc'];
					break;
					case MItem.TYPE_BLOCK:
						tempXml.setName('B');
						tempXml.@lbl = att['lbl'];
						tempXml.@txt = att['txt'];
						tempXml.@id = att['id'];
					break;
					default:
						continue;
					break;
				}
				if (att['icon']) {
					tempXml.@icon = att['icon'];
				}
				xmlList+= tempXml;
			}
			return xmlList;
		}
		private function itemClickHnd(e:MenuEvent){
			trace('CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK CLICK ');
		}
		private function addItemHnd(e:MenuEvent){
			var target:Object = e.target;
			var i:int = 0;
			var obj:Object;
			var id:String;
			if(target.attributes['id'] == undefined){
				for(i =0; _ids[i]!=undefined; i++){
				};
				target.attributes['id'] = i;
				_ids[i] = target;
			}else{
				id = target.attributes['id'];
				if(_ids.indexOf(id)!== -1){ 
					/*по идее такое может быть только при создании меню из xml
						<M />   		-> id=0
							<A /> 		-> id=1
							<A /> 		-> id=2
							<A id="1"/> -> надо элементу с id=1 сделать id=3
					*/
					obj = _ids[id];
					for(i =0; _ids[i]!=undefined; i++){
					};
					_ids[i] = obj;
					_ids[id] = target;
				}else{
					_ids[id] = target;
				}
			}
		}
		public function getItemsRelations(submenu:Submenu = null) { //relations дублируют функционал массива _ids надо чтото одно убрать
			if(submenu == null){
				submenu = _submenu;
			}
			var r:Relations = new Relations();
			var t:Relations;
			var att:Object;
			for each(var item:MItem in submenu.items) {
				att = item.attributes;
//				trace('getItemsRelations '+item.type+' ' + att['id'] + ' '+att['text'] + ' '+att['label']+' ' + att['mc']+' '+submenu.items.length);
				switch(att['type']){
					case MItem.TYPE_NODE:
						t = getItemsRelations(item.submenu);
						r.merge(t);
					break;
					case MItem.TYPE_ARROW:
					case MItem.TYPE_BLOCK:
						r.addRelation(att);
					break;
				}
			}
			return r;
		}
		public function set answerMode(b:Boolean){
			if(_answerMode == b) return;
			_answerMode = b;
			_submenu.answerMode = b;
		}
		public function get answerMode(){
			return _answerMode;
		}
		public function set disabled(b:Boolean){
			_disabled = b;
		}
		public function get disabled(){
			return _disabled;
		}
	}
}