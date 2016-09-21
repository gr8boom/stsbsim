package ru.sotsbi.u.adminka.data {
 
    import flash.events.*;
    import flash.net.*;
 
    public class DataLoader extends EventDispatcher {
 
        private var _xml:XML;
 
        public function DataLoader(src:String) {
            var loader:URLLoader = new URLLoader(new URLRequest(src));
            loader.addEventListener(Event.COMPLETE, onXmlLoad);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onXmlError);
        }
 
        private function onXmlLoad(e:Event):void {
            _xml = new XML(e.target.data);
            dispatchEvent(new Event(Event.COMPLETE));
        }
 
        private function onXmlError(e:IOErrorEvent):void {
            trace("Проблема с загрузкой XML файла: " + e.text);
        }
 
    }
 
}