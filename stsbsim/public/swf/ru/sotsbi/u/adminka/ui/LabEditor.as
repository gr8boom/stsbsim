package ru.sotsbi.u.adminka.ui {
	import fl.accessibility.UIComponentAccImpl;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.StageDisplayState
	import flash.external.ExternalInterface;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import ru.sotsbi.u.adminka.ui.answer.AWorkspace;
	import ru.sotsbi.u.adminka.data.Relations;
	import ru.sotsbi.u.adminka.debug.Dbg;
	import ru.sotsbi.u.adminka.debug.DbgEvent;
	import ru.sotsbi.u.adminka.i18.I18MovieClip;
	import ru.sotsbi.u.adminka.i18.I18;
	
    public class LabEditor extends I18MovieClip
    {
		private var menu:Menu;
		private var editPanel:EditPanel;
		private var editorWorkspace:EWorkspace;
		private var answerWorkspace:AWorkspace;
		private var bgdId:uint;
		private var bgd:Background;
		private var baseMenu:String;
		private var baseAnswer:String;
		private var baseQuest:String;
		private var baseCorner:String;
		private var baseFileId:uint;
		private var answer:String;
		private var answerMode:Boolean;
		private var offlineMode:Boolean;
		private var fullscreen:Boolean;
		private var changed:Boolean;
		private var _i18instance:I18;
		
		public function LabEditor() {
			_i18instance = I18.instance; //we need do it for init default values for i18 class
			trace(menuBlocksTF.text);
			getDictFromAdminka();
			changed = false;
			fullscreen = false;
			offlineMode = false;
			answersTF.mouseEnabled=false;
			menuBlocksTF.mouseEnabled=false;
			try{
				ExternalInterface.call('as_getType');
			}catch (err:Error) {
				offlineMode = true;
			}
			trace('OFFLINE MODE ' + offlineMode);
			answerMode = false;
			baseMenu = <![CDATA[
<M txt="Усилия" w="120">
  <B txt="10%" w="60" label="10%ten" id="200"/>
  <B txt="20%" w="60" label="20%twenty" id="300"/>
  <B txt="30%" w="60" label="30%thirty" id="400" chars="4" len="0"/>
  <B txt="40%" w="60" label="40%fourty" id="500" chars="5" len="0"/>
</M>
<M txt="Результат" w="120">
  <B txt="70%" w="60" label="70%seventy%" id="700" chars="7" len="0"/>
  <B txt="80%" w="60" label="80%eighty%" id="80" chars="8" len="0"/>
  <B txt="90%" w="60" label="90%ninety%" id="90" chars="9" len="0"/>
  <B txt="100%" w="60" label="100%hundred%" id="100" chars="10" len="0"/>
</M>
<M txt="arrows" w="80">
  <A txt="proc 21" w="80" id="102" label="p21" mc="p21"/>
  <A txt="proc13" w="80" id="103" label="p13" mc="p13"/>
  <A txt="arr31" w="80" id="104" label="a31" mc="a31"/>
  <A txt="Стрелко" w="80" id="105" label="стрелко 13" mc="a13"/>
</M>
<BLOCKS>
  <BLOCK txt="№" x="98" y="197" w="52" h="52" c="13421568" brdr="0" chars="abc" len="0"/>
  <BLOCK txt=";;;" x="443" y="157" w="74" h="103" c="6737151" chars="10" len="1"/>
  <BLOCK txt=";;;" x="443" y="257" w="74" h="103" c="6737151" chars="0123456789" len="5"/>
</BLOCKS>
<LINES y="100.2" x1="149.8" x2="275.5" x3="399.6"/>
]]>;
			baseAnswer = '[(100|700|102|103)|(200|300|105)]';
//*			
			baseMenu = '';
			baseAnswer = '';//*/
			baseQuest = 'WTF?';
			baseCorner = '6.9';
			baseFileId = 3784;
			init();
        } 
		public function init(){
			menu = new Menu();
			editorWorkspace = new EWorkspace();
			editorWorkspace.x = 153;
			answerWorkspace = new AWorkspace();
			answerWorkspace.x = 153;
			answerWorkspace.visible = false;
			bgd = new Background();
			bgd.x = 153
			addChild(editorWorkspace);
			addChild(answerWorkspace);
			addChild(menu);
			addChild(bgd);
			swapChildren(tmpBgd, bgd);
			swapChildren(editorWorkspace, zoom);
			swapChildren(editorWorkspace, zoomBgd);
			swapChildren(answerWorkspace, questTF);
			tmpBgd.visible = false;
			if (offlineMode) {
				getBaseData();
			}else{
				getDataFromAdminka();
				ExternalInterface.addCallback("getDataFromAdminka", getDataFromAdminka);
				ExternalInterface.addCallback("sendDataToAdminka", sendDataToAdminka);
			}
			
//			traceDisplayList(this);
			addEventListener(MenuEvent.ITEM_DOUBLE_CLICK, itemDblClickHnd);
			addEventListener(MenuEvent.ANSWER_CLICK, answerClickHnd);
			addEventListener(MenuEvent.SAVE_PANEL, savePanelHnd);
			addEventListener(MenuEvent.CLOSE_PANEL, closePanelHnd);
			addEventListener(DbgEvent.TRACE, dbgTraceHnd);
			addEventListener(Event.ENTER_FRAME, enterFrameHnd);
			answerWorkspace.addEventListener(Event.CHANGE, changeHnd);
			editorWorkspace.addEventListener(Event.CHANGE, changeHnd);
			questTF.addEventListener(Event.CHANGE, changeHnd);
			cornerTF.addEventListener(Event.CHANGE, changeHnd);
			answersBtn.addEventListener(MouseEvent.CLICK, answersBtn_clickHnd);
			menuBtn.addEventListener(MouseEvent.CLICK, menuBtn_clickHnd);
			zoom.button.addEventListener(MouseEvent.CLICK, zoomBtn_clickHnd);
		}
		private function traceDisplayList(container:DisplayObjectContainer, indentString:String = ""):void 
		{ 
			var child:DisplayObject; 
			for (var i:uint=0; i < container.numChildren; i++) 
			{ 
				child = container.getChildAt(i);
				trace(indentString, child, child.name);  
				if (container.getChildAt(i) is DisplayObjectContainer) 
				{ 
					traceDisplayList(DisplayObjectContainer(child), indentString + "    ") 
				} 
			} 
		}
		private function openPanel(elem:Object){
//			trace(editorWorkspace.toXML().toXMLString());
			var type:String;
/*			questTF.text = 'Double clicked to ['+e.target+'] type='+e.target.type;
			trace('Double clicked to ['+e.target+'] type='+e.target.type);*/
			switch(elem.type){
				case MItem.TYPE_BLOCK:
					type = EditPanel.TYPE_BLOCK;
				break;
				case MItem.TYPE_ARROW:
					type = EditPanel.TYPE_ARROW;
				break;
				case MItem.TYPE_NODE:
					type = EditPanel.TYPE_NODE;
				break;
				case MItem.TYPE_NO:
					type = EditPanel.TYPE_NO;
				break;
				case EWorkspace.TYPE_FIELD:
					type = EditPanel.TYPE_FIELD;
				break;
			}
			if(editPanel){
				removeChild(editPanel);
			}
			trace(elem.attributes['chars']);
			trace(elem.attributes['len']);
			editPanel = new EditPanel(elem, type, elem.attributes);
//			trace([stage.width,editPanel.width,stage.height,editPanel.height]);
			editPanel.x = (stage.stageWidth - editPanel.width)/2;
			editPanel.y = (stage.stageHeight - editPanel.height)/2;
			addChild(editPanel);
		}
		private function getBaseData() {
			var xml = new XMLList(baseMenu);
			menu.init(xml);
			trace(menu.toXML());
			editorWorkspace.init(xml);
			questTF.text = baseQuest;
			cornerTF.text = baseCorner;
			answer = baseAnswer;
			if(!offlineMode){
				bgd.loadFile('http://192.168.14.189:8081/getFile.php?anyway=1&f_id=' + baseFileId);
				bgd.contentLoaderInfo.addEventListener(Event.COMPLETE, bgdImgLoaded);
			}
		}
		private function bgdImgLoaded(e:Event) {
//			questTF.text+= ' img loaded '+e.target.contentType;
			if (e.target.contentType.substr(0, 5) == 'image') {
//				questTF.text+= ' IMAGE';
				e.target.loader.width = 650;
				e.target.loader.height = 500;
			}
		}
			
		private function getDictFromAdminka(){
			try{
				var dict:Array = ExternalInterface.call('as_getDict') as Array;
				if(dict == null) return;
				I18.dict = dict;
				I18.tObj(this);
			}catch(err:Error){
//				questTF.text = ' ExtItrf err:'+err.message;
			}
		}
		
		private function getDataFromAdminka(){
			try{
				var s:String = String(ExternalInterface.call('as_getMenu'));
				if(s == 'null'){
					s = baseMenu;
				}
				var xml = new XMLList(s);
				menu.init(xml);
				editorWorkspace.init(xml);
				questTF.text = String(ExternalInterface.call('as_getQuest'));
				cornerTF.text = String(ExternalInterface.call('as_getCorner'));
				answer = String(ExternalInterface.call('as_getAnswer'));
				if (answer == 'null') {
					answer = baseAnswer;
				}
				bgdId = uint(ExternalInterface.call('as_getBgdId'));
				if(bgdId>0){
					bgd.loadFile('/../getFile.php?anyway=1&f_id=' + bgdId);
					bgd.contentLoaderInfo.addEventListener(Event.COMPLETE, bgdImgLoaded);
				}
				var blocksAttr:Array = editorWorkspace.attributes;
				answerWorkspace.relations = menu.getItemsRelations();
				answerWorkspace.init(blocksAttr, answer);
			}catch(err:Error){
//				questTF.text = ' ExtItrf err:'+err.message;
			}
		}
		private function sendDataToAdminka(){
			if(offlineMode) return;
			ExternalInterface.call('as_setQuest',questTF.text);
			ExternalInterface.call('as_setCorner',cornerTF.text);
			ExternalInterface.call('as_setMenu',menu.toXML().toXMLString()+'\n'+editorWorkspace.toXML().toXMLString());
			ExternalInterface.call('as_setAnswer',answerWorkspace.getAnswerSting());
		}
		private function savePanelHnd(e:MenuEvent){
			trace('saved !');
			var att:Array = editPanel.attributes;
			var target:Object = editPanel.target;
			var panelType:String = editPanel.type;
			if(att['type']){
				target.type = att['type'];
				trace([target,att['type']]);
				trace([target,target.type]);
			}
			trace([target,att['length']]);
			target.attributes = att;
			removeChild(editPanel);
			editPanel = null;
			changed = true;
			if(panelType == EditPanel.TYPE_NO){
				trace(panelType);
				openPanel(target);
			}
		}
		private function answerClickHnd(e:MenuEvent){
			switch(e.target.type) {
				case MItem.TYPE_ARROW:
					answerWorkspace.setArrow(e.target.value);
					changed = true;
				break;
				case MItem.TYPE_BLOCK:
					answerWorkspace.setBlock(e.target.value);
					changed = true;
				break;
			}
		}
		private function answersBtn_clickHnd(e:MouseEvent) {
			answersBtn.selected = true;
			menuBtn.selected = false;
			flash.x = answersBtn.x;
			answerMode = true;
			menu.answerMode = answerMode;
			answerWorkspace.visible = true;
			editorWorkspace.visible = false;
			answerWorkspace.relations = menu.getItemsRelations();
			answerWorkspace.init(editorWorkspace.attributes, answer);
			removeEventListener(MenuEvent.ITEM_DOUBLE_CLICK, itemDblClickHnd);
//			var d:Dbg = new Dbg();
//			d.trc(menu.getItemsRelations().asArray);
			
//			ExternalInterface.addCallback('select_js', select);
//			var answer:* = ExternalInterface.call('show_message', 'Привет из AS3');
//			var answer:* = menu.toXML();
//			trace(answer);
//			questTF.text = String(answer)+answerMode;
		}
		private function menuBtn_clickHnd(e:MouseEvent){
			answersBtn.selected = false;
			menuBtn.selected = true;
			flash.x = menuBtn.x;
			answerMode = false;
			menu.answerMode = answerMode;
			editorWorkspace.visible = true;
			answerWorkspace.visible = false;
			answerWorkspace.relations = menu.getItemsRelations();
			addEventListener(MenuEvent.ITEM_DOUBLE_CLICK, itemDblClickHnd);
//			var d:Dbg = new Dbg();
//			d.trc(menu.getItemsRelations().asArray);
			
//			ExternalInterface.addCallback('select_js', select);
//			var answer:* = ExternalInterface.call('show_message', 'Привет из AS3');
//			var answer:* = menu.toXML();
//			trace(answer);
//			questTF.text = String(answer)+answerMode;
		}
		private function zoomBtn_clickHnd(e:MouseEvent) {
			fullscreen = !fullscreen;
			ExternalInterface.call('fullscreen', fullscreen);
			zoom.arrows.gotoAndStop(fullscreen?2:1);
		}
		private function changeHnd(e:Event) {
//			questTF.text = e.currentTarget + ' ' + e.target;
			changed = true;
		}
		private function closePanelHnd(e:MenuEvent){
			removeChild(editPanel);
			editPanel = null;
		}
		private function itemDblClickHnd(e:MenuEvent){
			openPanel(e.target);
		}
		private function dbgTraceHnd(e:DbgEvent){
//			questTF.appendText('\n'+String(e.params));
		}
		
		private function enterFrameHnd(e:Event) {
			if (changed) {
				trace('Enter frame && changed');
				changed = false;
				sendDataToAdminka();
			}
		}
		
		private function setQuestion(s:String){
			questTF.text = s;
		}
		private function getQuestion(){
			return questTF.text;
		}
		private function setCorner(s:String){
			cornerTF.text = s;
		}
		private function getCorner(){
			return cornerTF.text;
		}
    }
}