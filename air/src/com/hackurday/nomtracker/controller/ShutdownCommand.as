package com.hackurday.nomtracker.controller {
	
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;
	
	/**
	 * Shutdown command.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class ShutdownCommand extends AsyncMacroCommand {
	   
		override protected function initializeAsyncMacroCommand():void {
			trace('[ShutdownCommand::initializeAsyncMacroCommand]');
			addSubCommand(LogoutCommand);
			addSubCommand(ExitApplicationCommand);
		}	
		
	}
	
}
