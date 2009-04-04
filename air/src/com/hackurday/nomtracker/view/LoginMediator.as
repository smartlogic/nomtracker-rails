package com.hackurday.nomtracker.view {
	
	import com.hackurday.nomtracker.NTFacade;
	import com.hackurday.nomtracker.view.components.Loginview;
	
	import flash.events.MouseEvent;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.statemachine.StateMachine;
	
	/**
	 * Login mediator.
	 *
	 * @langversion ActionScript 3.0
	 * @author Justin Brown &lt;justin&#64;smartlogicsolutions.com&gt;
	 * @date 04/04/2009
	 * @version 0.1
	 */
	public class LoginMediator extends Mediator {
	   
		/* --- Variables --- */
		
		public static const NAME:String = "LoginMediator";
		
		/* === Variables === */
		
		/* --- Constructor --- */
		
		/**
		 * Constructor.
		 *
		 * @param viewComponent view component for mediator
		 */
		public function LoginMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}
		
		/* === Constructor === */
		
		/* --- Functions --- */
		
		override public function handleNotification(note:INotification):void {
			switch( note.getName() ) {
				case NTFacade.ENTER_LOGIN:
					loginView.loginButton.enabled = true;
					break;
				
				case NTFacade.ENTER_TRY_LOGIN:
					loginView.loginButton.enabled = false;
					break;
			}
		}

		override public function listNotificationInterests():Array {
			return [
				NTFacade.ENTER_LOGIN,
				NTFacade.ENTER_TRY_LOGIN
			];
		}
		
		override public function onRegister():void {
			loginView.loginButton.addEventListener(MouseEvent.CLICK, onLoginClick);
		}
		
		/* === Functions === */
		
		/* --- Event Handlers --- */
		
		private function onLoginClick(evt:MouseEvent):void {
			trace("[LoginMediator::onLoginClick]");
			var credentials:Object = 
				{
					login: loginView.usernameTextInput.text,
					password: loginView.passwordTextInput.text 
				};
				
			sendNotification(StateMachine.ACTION, credentials, NTFacade.ACTION_TRY_LOGIN);
		}
		
		/* === Event Handlers === */
		
		/* --- Public Accessors --- */
		
		public function get loginView():Loginview { return viewComponent as Loginview; }
		
		/* === Public Accessors === */
		
	}
	
}
