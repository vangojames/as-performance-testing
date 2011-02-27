package com.vango.performanceui.controller.signals
{
	import org.osflash.signals.Signal;

	/**
	 * @author James
	 */
	public class OverallTestProgressSignal extends Signal
	{
		public function OverallTestProgressSignal()
		{
			super(String, Number);
		}
	}
}
