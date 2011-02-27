package com.vango.performanceui.controller.signals
{
	import org.osflash.signals.Signal;

	/**
	 * @author James
	 */
	public class TestProgressSignal extends Signal
	{
		public function TestProgressSignal()
		{
			super(int, Number);
		}
	}
}
