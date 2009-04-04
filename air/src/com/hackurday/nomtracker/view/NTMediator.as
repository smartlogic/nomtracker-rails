package com.hackurday.nomtracker.view {
	
	import com.hackurday.nomtracker.NTFacade;
	import com.hackurday.nomtracker.view.events.SessionEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * NT mediator.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class NTMediator extends Mediator {
	   
		/* --- Variables --- */
		
		public static const NAME:String = "NTMediator";
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		/**
		 * Constructor.
		 *
		 * @param viewComponent view component for mediator
		 */
		public function NTMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		override public function handleNotification(note:INotification):void {
			switch( note.getName() ) {
				case NTFacade.ENTER_IDLE:
					app.currentState = NTFacade.STATE_IDLE;
					break;
				
				case NTFacade.ENTER_LOGIN:
					app.currentState = NTFacade.STATE_LOGIN;
					break;
			}
		}

		override public function listNotificationInterests():Array {
			return [
				NTFacade.ENTER_IDLE,
				NTFacade.ENTER_LOGIN
			];
		}
		
		override public function onRegister():void {
			app.addEventListener(SessionEvent.LOGOUT, onLogout);
		}
		
		/* === Functions === */
		
		/* --- Event Handlers --- */
		
		private function onLogout(evt:SessionEvent):void {
			trace("[NTMediator::onLogout]");
			sendNotification(NTFacade.LOGOUT);
		}
		
		/* === Event Handlers === */
		
		/* --- Public Accessors --- */
		
		public function get app():NomTracker { return viewComponent as NomTracker; }
		
		/* === Public Accessors === */
		
	}
	
}
