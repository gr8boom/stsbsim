package ru.sotsbi.u.adminka.data {
	import ru.sotsbi.u.adminka.ui.answer.AError;
	
    public class AnswerList extends Object {
 
        private var _list:Array;
		private var _nBlocks:uint;
 
        public function AnswerList(s:String = '', nBlocks:uint = 0) {
			_list = new Array();
			_nBlocks = nBlocks;
			var from:int = 0;
			var to:int = 0;
			var quot:Boolean = false;
			var answId:int = 0;
			var br:int = 0;
			var brRnd:int = 0;
			var answ:String = '';
			var l:int = s.length;
			for(var i:int = 0; i < l; i++){
				if(s.charAt(i)=='"'){
					quot = !quot;
					answ+= '"';
				}
				if(quot) continue;
				
				switch(s.charAt(i)){
					case '(':
						brRnd++;
					break;
					case ')':
						brRnd--;
						if(brRnd<0){
							throw new AError(') without ( at pos='+i);
							return;
						}
					break;
					case '[':
						if(i != 0){
							throw new AError('[ not at 0 position, pos='+i);
							return;
						}
						br = 1;
						from = 1;
					break;
					case ']':
						if(br != 1){
							throw new AError('] without [ at pos='+i);
							return;
						}
						if(i != l-1){
							throw new AError('] is not at the end of string, at pos='+i);
							return;
						}
					//!!! no break, go down
					case '|':
						if(brRnd == 0){
							answ = s.substr(from,i-from);
							addAnswer(answId, answ, _nBlocks);
							answId++;
							from = i+1;
						}
					break;
				}
			}//*/
        }
		
		public function getAnswer(n:uint) {
			return _list[n];
		}
 		public function addAnswer(n:uint, s:String, nBlocks:uint) {
			var answer = new Answer(s, nBlocks);
			_list.splice(n, 0, answer);
			return answer;
		}
 
 		public function removeAnswer(n:uint){
			_list.splice(n,1);
		}
		
		public function toString() {
			var arr:Array = new Array();
			var l:uint = _list.length;
			for (var i:uint = 0; i < l; i++) {
				arr.push(_list[i].toString());
			}
			return '['+arr.join('|')+']';
		}
		
 		public function get length(){
			return _list.length;
		}
 
    }
 
}