package ru.sotsbi.u.adminka.ui{
	import fl.controls.Button;
	import flash.text.TextFormat;
	
	public class FuturaButton extends Button {
		public function FuturaButton() {
			trace('field'+textField);
			textField.embedFonts = true;
			var fmt:TextFormat = textField.getTextFormat();
			fmt.font = 'a_FuturaRound';
			fmt.align = 'left';
			textField.setTextFormat(fmt);
			textField.embedFonts = true;
			trace('Format'+fmt);
			trace(textField.text);
		}
		public function get text() {
			return '';
		}
	}
}