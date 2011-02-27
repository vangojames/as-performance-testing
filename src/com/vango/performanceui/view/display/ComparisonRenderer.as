package com.vango.performanceui.view.display
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.vango.performance.vo.TestResultSet;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;


	/**
	 * @author James
	 */
	public class ComparisonRenderer extends LiquidComponent
	{
		//{	Properties
		
		/**
		 * Determines whether this is an odd or even coloured renderer
		 */
		public function get isOdd():Boolean { return _isOdd; }
		public function set isOdd(value:Boolean):void
		{
			_isOdd = value;
		}
		private var _isOdd:Boolean;
		
		/**
		 * The id of the renderer
		 */
		public function get id():int { return _id; }
		private var _id:int;
		
		/**
		 * The signal that dispatches when the item is selected
		 */
		public function get selectTestSignal():ISignal { return _selectTestSignal; }
		private var _selectTestSignal:Signal = new Signal();
		
		/**
		 * Determines whether this is comparing or not
		 */
		public function get isComparing():Boolean { return _compareCB.selected; }
		public function set isComparing(value:Boolean):void
		{
			_compareCB.selected = value;
		}
		
		/**
		 * Handles dispatching comparison events
		 */
		public function get compareSignal():Signal { return _compareSignal; }
		private var _compareSignal:Signal = new Signal();
		
		//}
		
		//{	Fields
		
		private var _mainContainer:HBox;
		private var _placeLabel:Label;
		private var _testLabel:Label;
		private var _speedLabel:Label;
		private var _speedIncreaseLabel:Label;
		private var _compareCB:CheckBox;
		private var _bg:Sprite;
		private var _isSelected:Boolean;
		private var _enabled:Boolean = true;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Sets the data on the renderer
		 */
		public function setData(place:int, testResult:TestResultSet, nextName:String, speedIncrease:Number, isTie:Boolean, isLastPlace:Boolean):void
		{
			this._id = testResult.testId;
			_placeLabel.text = "PLACE " + place.toString();
			_testLabel.text = testResult.testName + " (ID " + id.toString() + ")";
			_speedLabel.text = "~ " + testResult.meanTestTime.toPrecision(3) + "ms";
			if (!isLastPlace)
			{
				if (!isTie) _speedIncreaseLabel.text = (speedIncrease * 100).toPrecision(3) + "% faster than " + nextName;
				else _speedIncreaseLabel.text = "NO CHANGE IN SPEED BETWEEN THIS AND " + nextName;
			}
			else _speedIncreaseLabel.text = "-";
			doDraw();
		}
		
		/**
		 * Sets to selected
		 */
		public function select():void
		{
			_isSelected = true;
			TweenLite.to(_bg, 0.3, {colorTransform:{tint:0, tintAmount:0.3}});
		}
		
		/**
		 * Sets to deselected
		 */
		public function deselect():void
		{
			_isSelected = false;
			TweenLite.to(_bg, 0.3, {colorTransform:{tint:0, tintAmount:0}});
		}
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class
		 */
		override protected function init():void
		{
			TweenPlugin.activate([TintPlugin, ColorTransformPlugin]);
			
			// set the button mode
			buttonMode = true;
			
			// add the background
			_bg = new Sprite();
			addChild(_bg);
			
			// create and add containers
			_mainContainer = new HBox(this, 5, 5);
			_mainContainer.spacing = 15;
			
			// create and add labels
			_placeLabel = new Label(_mainContainer, 0, 0, "");
			_placeLabel.textField.textColor = 0x0000FF;
			
			_testLabel = new Label(_mainContainer, 0, 0, "Test : ?");
			var tf:TextFormat = _testLabel.textField.defaultTextFormat;
			tf.bold = true;
			_testLabel.textField.defaultTextFormat = tf;
			_speedLabel = new Label(_mainContainer, 0, 0, "");
			_speedIncreaseLabel = new Label(_mainContainer, 0, 0, "");
			_compareCB = new CheckBox(_mainContainer,0,0,"Compare",onCompareClick);
			isComparing = true;
			
			doDraw();
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseHandler);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseHandler);
			addEventListener(MouseEvent.CLICK, onMouseHandler);
			
			super.init();
		}
		
		/**
		 * Draws the component
		 */
		override protected function doDraw():void
		{
			// redraw everything
			_testLabel.draw();
			_testLabel.x = 5;
			_placeLabel.draw();
			_speedLabel.draw();
			_speedIncreaseLabel.draw();
			_compareCB.draw();

			_mainContainer.draw();
			
			var g:Graphics = _bg.graphics;
			g.clear();
			g.beginFill(isOdd ? 0xE2DDB5 : 0xCDC9A5, 1);
			g.drawRect(0, 0, width, height + 5);
			g.endFill();
			
//			graphics.lineStyle(1,0);
//			graphics.moveTo(0,0);
//			graphics.lineTo(width, 0);
//			graphics.moveTo(0,height);
//			graphics.lineTo(width, height);
		}
		
		//}
		
		//{	Handlers
		
		/**
		 * Handles mouse over and out events
		 */
		private function onMouseHandler(event:MouseEvent):void
		{
			// override if the checkbox was clicked
			if (event.target == _compareCB) return;
			if (!_enabled || _isSelected) return;
			
			switch(event.type)
			{
				case MouseEvent.MOUSE_OVER:
					TweenLite.to(_bg, 0.3, {colorTransform:{tint:0, tintAmount:0.3}});
					break;
				case MouseEvent.MOUSE_OUT:
					TweenLite.to(_bg, 0.3, {colorTransform:{tint:0, tintAmount:0}});
					break;
				case MouseEvent.CLICK:
					_selectTestSignal.dispatch();
					break;
			}
		}
		
		/**
		 * Handles comparison clicks
		 */
		private function onCompareClick(event:Event):void
		{
			compareSignal.dispatch(isComparing);
		}
		
		//}
	}
}
