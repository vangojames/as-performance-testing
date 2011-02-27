package com.vango.performanceui.view.display
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.VBox;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.vango.performance.vo.TestConfiguration;

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
	public class TestRenderer extends LiquidComponent
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
		 * The signal that dispatches when the compare checkbox updates
		 */
		public function get compareSelectSignal():ISignal { return _compareSelectSignal; }
		private var _compareSelectSignal:Signal = new Signal();
		
		/**
		 * Determines whether this is comparing or not
		 */
		public function get isComparing():Boolean { return _compareCB.selected; }
		public function set isComparing(value:Boolean):void
		{
			_compareCB.selected = value;
		}
		
		//}
		
		//{	Fields
		
		private var _mainContainer:VBox;
		private var _labelContainer:Sprite;
		private var _controlsContainer:Sprite;
		private var _progContainer:HBox;
		
		private var _testLabel:Label;
		private var _statusLabel:Label;
		private var _progBar:ProgressBar;
		private var _progLabel:Label;
		private var _compareCB:CheckBox;
		private var _bg:Sprite;
		private var _isSelected:Boolean;
		private var _enabled:Boolean;
		
		//}
		
		//{	Constants
		
		private const WAITING_COLOUR:uint = 0xCDC5BF;
		private const RUNNING_COLOUR:uint = 0xFF6103;
		private const COMPLETE_COLOUR:uint = 0x385E0F;
		
		//}
		
		//{	Public Methods
		
		/**
		 * Sets the data on the renderer
		 */
		public function setData(data:TestConfiguration):void
		{
			_id = data.id;
			_testLabel.text = data.name + " (ID " + data.id.toString() + ")";
			doDraw();
		}
		
		/**
		 * Updates the progress for the test
		 */
		public function setProgress(progress:Number):void
		{
			_progBar.value = progress;
			_progLabel.text = (progress * 100).toPrecision(3) + "%";
			if (progress < 1)
			{
				_statusLabel.text = "Running";
				_statusLabel.textField.textColor = RUNNING_COLOUR;
			}
			else
			{
				_statusLabel.text = "Complete";
				_statusLabel.textField.textColor = COMPLETE_COLOUR;
				_enabled = true;
				buttonMode = true;
				_progBar.visible = false;
				_compareCB.visible = true;
			}
			
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
			
			// add the background
			_bg = new Sprite();
			addChild(_bg);
			
			// create and add containers
			_mainContainer = new VBox(this, 5, 5);
			_labelContainer = new Sprite();
			_mainContainer.addChild(_labelContainer);
			_controlsContainer = new Sprite();
			_mainContainer.addChild(_controlsContainer);
			
			// create and add labels
			_testLabel = new Label(_labelContainer, 0, 0, "Test : ?");
			var tf:TextFormat = _testLabel.textField.defaultTextFormat;
			tf.bold = true;
			_testLabel.textField.defaultTextFormat = tf;
			
			_statusLabel = new Label(_labelContainer, 0, 0, "waiting");
			_statusLabel.textField.textColor = WAITING_COLOUR;
			
			// create and add progress bar and check box
			_progContainer = new HBox(_controlsContainer);
			_progBar = new ProgressBar(_progContainer,0,5);
			_progLabel = new Label(_progContainer,0,0,"0.00%");
			_compareCB = new CheckBox(_controlsContainer,0,0,"Compare", onCompareClick);
			_compareCB.visible = false;
			
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
			_statusLabel.draw();
			_testLabel.x = 5;
			_statusLabel.x = width - _statusLabel.width - 10;

			_progBar.width = width - _progLabel.width - 10 - _progContainer.spacing;
			_progBar.draw();
			_progContainer.draw();
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
		 * Handles compare clicks
		 */
		private function onCompareClick(event:Event):void
		{
			_compareSelectSignal.dispatch(_compareCB.selected);
		}
		
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
		
		//}
	}
}
