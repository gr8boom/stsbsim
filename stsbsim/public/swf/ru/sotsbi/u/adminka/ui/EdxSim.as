package ru.sotsbi.u.adminka.ui {
	import fl.accessibility.UIComponentAccImpl;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.LoaderInfo;
	import flash.display.StageDisplayState
	import flash.external.ExternalInterface;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import ru.sotsbi.u.adminka.ui.answer.SWorkspace;
	import ru.sotsbi.u.adminka.data.Relations;
	import ru.sotsbi.u.adminka.debug.Dbg;
	import ru.sotsbi.u.adminka.debug.DbgEvent;
	import ru.sotsbi.u.adminka.i18.I18MovieClip;
	import ru.sotsbi.u.adminka.i18.I18;
	
    public class EdxSim extends I18MovieClip
    {
		private var menu:Menu;
		private var workspace:SWorkspace;
		private var bgdId:uint;
		private var bgd:Background;
		private var baseData:String;
		private var baseAnswer:String;
		private var baseQuest:String;
		private var answer:String;
		private var answerMode:Boolean;
		private var offlineMode:Boolean;
		private var fullscreen:Boolean;
		private var changed:Boolean;
		private var _i18instance:I18;
		private var _finished:Boolean;
		private var uniqueId:String;
		
		public function EdxSim() {
			_i18instance = I18.instance; //we need do it for init default values for i18 class
			_finished = false;
			getDictFromAdminka();
			changed = false;
			fullscreen = false;
			offlineMode = false;
			answerMode = true;
			baseData = <![CDATA[
            <M lbl="From A to B" w="100" icon="a12">
                <M lbl="Simple" w="80" icon="a12">
                    <A lbl="Simple" w="80" id="9" txt="SMPL" mc="a12" icon="a12"/>
                </M>
                <M lbl="Bold" w="80" icon="b12">
                    <A lbl="Bold" w="80" id="10" txt="BLD" mc="b12" icon="b12"/>
                </M>
                <M lbl="Process" w="80" icon="b12">
                    <A lbl="Process" w="80" id="13" txt="PRC" mc="p12" icon="b12"/>
                </M>
                <M lbl="State" w="80" icon="s12">
                    <A lbl="State" w="80" id="14" txt="STT" mc="s12" icon="s12"/>
                </M>
            </M>
            <M lbl="From C to B" w="100" icon="a32">
                <A lbl="Message" w="110" id="19" txt="MSG" mc="a32"icon="a32"/>
            </M>
            <M lbl="Blocks" w="80">
                <B lbl="A" w="110" id="bla" txt="Block A"/>
                <B lbl="B" w="110" id="blb" txt="Block B Block B Block B"/>
                <B lbl="C" w="110" id="blc" txt="Block C Block C Block C Block C Block C Block C "/>
            </M>
            <BLOCKS>
                <BLOCK lbl="Block type1" x="100" y="100" w="100" h="30" c="0x027BF4" />
                <BLOCK lbl="Block type2" x="300" y="100" w="100" h="30" c="0x027BF4" />
                <BLOCK lbl="Block type3" x="500" y="100" w="100" h="30" c="0x027BF4" />
            </BLOCKS>
            <LINES y="150" x1="150" x2="350" x3="550"/>
			]]>;
			baseAnswer = '[(100|700|102|103)|(200|300|105)]';
/*			
			baseData = '';
			baseAnswer = '';//*/
			baseQuest = 'WTF?';
			init();
        } 
		public function init(){
			dbgTF.appendText('\ninit');
			try{
				uniqueId = ExternalInterface.objectID;
				dbgTF.appendText('\nuniqueId:'+uniqueId);
			}catch (err:Error) {
				dbgTF.appendText('\nuniqueId error');
				return;
			}
			if(uniqueId == null){
				dbgTF.appendText('\nOfflineMode');
				offlineMode = true;
				trace('OFFLINE MODE ' + offlineMode);
			}

			menu = new Menu();
			dbgTF.visible = false;
			zoom.visible = false;
			zoomBgd.visible = false;
			doneSign.visible = false;
			workspace = new SWorkspace();
			workspace.x = 153;
			workspace.visible = true;
			bgd = new Background();
			bgd.x = 153
			addChild(workspace);
			addChild(menu);
			addChild(bgd);
			swapChildren(tmpBgd, bgd);
			swapChildren(workspace, zoom);
			swapChildren(workspace, zoomBgd);
			tmpBgd.visible = false;
			if (!offlineMode) {
				ExternalInterface.addCallback("js_onGetCheck", js_onGetCheck);
				ExternalInterface.call('as_ready', uniqueId);
			}
			
//			traceDisplayList(this);
			addEventListener(MenuEvent.ANSWER_CLICK, answerClickHnd);
			addEventListener(DbgEvent.TRACE, dbgTraceHnd);
			addEventListener(Event.ENTER_FRAME, enterFrameHnd);
			checkBtn.addEventListener(MouseEvent.CLICK, checkHnd);
			workspace.addEventListener(Event.CHANGE, changeHnd);
//			questTF.addEventListener(Event.CHANGE, changeHnd);
			zoom.button.addEventListener(MouseEvent.CLICK, zoomBtn_clickHnd);
			getData();
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
		
		private function getData(){
//			dbgTF.appendText('\ngetData');
			var data:Object = new Object();
			var xml:XMLList;
			if(offlineMode){
				xml = new XMLList(baseData);
				data.currentAnswer = '()';
				data.finish = false;
				data.bgdURL = '';
				data.restart = false;
			}else{
				//var flashvars:Object = LoaderInfo(this.root.loaderInfo).parameters;
				//i cannt send bgdUrl via flashvars it converts "+" to " "
				data = ExternalInterface.call('as_getData', uniqueId);
				xml = new XMLList(data.xml);
			}
			this.dispatchEvent( new DbgEvent(DbgEvent.TRACE, xml) );
			menu.init(xml);
			menu.answerMode = true;
			workspace.relations = menu.getItemsRelations();
			var dataArr:Array = xmlToArray(xml);
			if(data.currentAnswer){
				workspace.init(dataArr, data.currentAnswer);
			}else{
				workspace.init(dataArr);
			}
			if(data.finish == 1){
				dbgTF.appendText('\nFINISHED');
				finished = true;
			}
			if(data.bgdURL){
				bgd.loadFile(data.bgdURL);
				bgd.contentLoaderInfo.addEventListener(Event.COMPLETE, bgdImgLoaded);
			}
			checkBtn.visible = true;
		}
		public function js_onGetCheck(obj:Object){
			//obj.finish ['yes','no']
			//obj.result [true, array like (1,0,0,0,1,0,0,0)]
			checkBtn.enabled = true;
			if(obj.finish == 1){
				finished = true;
				workspace.showErrors(obj.result, obj.finish == 1);
				return;
			}
			workspace.showErrors(obj.result);
			return 1;
		}
		private function xmlToArray(xml:XMLList){
			var subnode:XML;
			var x0,y0:Number;
			var arr:Array = new Array();
			arr['blocks'] = new Array();
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
							a['w']=Number(subnode.attribute('w'));
							a['h']=Number(subnode.attribute('h'));
							a['lbl']=String(subnode.attribute('lbl'));
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
						arr['blocks'].push(a);
					}
				}
				if (node.name() == 'LINES') {
					a = new Array();
					arr['y'] = Number(node.attribute('y'));
					arr['x1'] = Number(node.attribute('x1'));
					arr['x2'] = Number(node.attribute('x2'));
					arr['x3'] = Number(node.attribute('x3'));
				}
			}
			return arr;
		}

		private function answerClickHnd(e:MenuEvent){
			if(_finished) return;
			trace('answerClickHnd');
			switch(e.target.type) {
				case MItem.TYPE_ARROW:
					workspace.setArrow(e.target.value);
					changed = true;
				break;
				case MItem.TYPE_BLOCK:
					workspace.setBlock(e.target.value);
					changed = true;
				break;
			}
		}
		private function checkHnd(e:MouseEvent){
			dbgTF.appendText('\ncheckBtnHnd');
			checkBtn.enabled = false;
			ExternalInterface.call('as_check', uniqueId, workspace.getAnswerSting());
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
		private function dbgTraceHnd(e:DbgEvent){
			trace('DBG');
			dbgTF.appendText('\n'+String(e.params));
		}
		
		private function enterFrameHnd(e:Event) {
			checkBtn.visible = !_finished;
			//trace('Enter frame');
		}
		
		private function set finished(b:Boolean) {
			_finished = b;
			workspace.disabled = b;
			doneSign.visible = b;
			checkBtn.visible = !b;
		}
	}
}