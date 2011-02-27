package com.vango.performanceui.view.display
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.ProgressBar;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author James
	 */
	public class StatusView extends LiquidComponent
	{
		//{	Properties
		
		/**
		 * The name of the current test
		 */
		public function get currentTestName():String { return _currentTestName; }
		public function set currentTestName(value:String):void
		{
			_currentTestName = value;
			updateProgress();
		}
		private var _currentTestName:String;
		
		/**
		 * The overall progress of the test
		 */
		public function get overallProgress():Number { return _overallProgress; }
		public function set overallProgress(value:Number):void
		{
			_overallProgress = value;
			updateProgress();
		}
		private var _overallProgress:Number;
		
		/**
		 * The signal that dispatches when run is clicked
		 */
		public function get runSignal():ISignal { return _runSignal; }
		private var _runSignal:Signal = new Signal();
		
		//}
		
		//{	Fields
		
		private var _container:VBox;
		private var _statusContainer:Sprite;
		private var _statusLabel:Label;
		private var _progressContainer:HBox;
		private var _progressBar:ProgressBar;
		private var _progressLabel:Label;
		private var _runTestButton:PushButton;
		
		//}
		
		//{	Private Methods
		
		/**
		 * Initialises the class
		*/
		protected override function init():void
		{
			// create container and update spacing
			_container = new VBox(this);
			_container.spacing = 0;
			
			// create status label
			_statusContainer = new Sprite();
			_container.addChild(_statusContainer);
			_statusLabel = new Label(_statusContainer, 0, 0, "Not testing");
			_runTestButton = new PushButton(_statusContainer, 0, 0, "Run tests", onRunClick);
			_runTestButton.draw();
			_statusLabel.draw();
			
			_runTestButton.visible = true;
			_statusLabel.visible = false;
			
			// create progress bar and progress label
			_progressContainer = new HBox(_container, 0, 0);
			_progressBar = new ProgressBar(_progressContainer, 0, 5);
			_progressBar.value = 0;
			_progressBar.draw();
			_progressLabel = new Label(_progressContainer, 0, 0, "0.00% Complete");
			_progressLabel.draw();
			_progressContainer.draw();
			
			// redraw
			_container.draw();
			
			super.init();
		}
		
		/**
		 * Updates the label
		 */
		private function updateProgress():void
		{
			_statusLabel.visible = true;
			_runTestButton.visible = false;
			_statusLabel.text = currentTestName;
			_progressBar.value = overallProgress;
			_progressLabel.text = (overallProgress * 100).toPrecision(3) + "% Complete";
			doDraw();
		}
		
		/**
		 * Does the draw 
		 */
		override protected function doDraw():void
		{
			_progressBar.width = width - Math.max(85, _progressLabel.width - _progressContainer.spacing);
			_progressBar.draw();
			_progressContainer.draw();
		}
		
		/**
		 * Handles run click
		 */
		private function onRunClick(event:MouseEvent):void
		{
			_runSignal.dispatch();
		}
		
		//}
	}
}
