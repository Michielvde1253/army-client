package {
	import com.dchoc.graphics.DCResourceManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.FullScreenEvent;
	import flash.utils.getTimer;
	import game.gui.popups.PopUpManager;
	import game.isometric.elements.Element;
	import game.net.ErrorObject;
	import game.net.MyServer;
	import game.states.FSMState;
	import game.states.GameLoadingFirst;
	import game.states.GameLoadingSecond;
	import game.states.GameState;
	import game.states.StateMachine;
	CONFIG::USE_DISCORD_RPC {
		import fi.joniaromaa.adobeair.discordrpc.*;
	}
	public class GameMain extends Sprite {


		private var mGameTime: Number;

		private var mStateMachine: StateMachine;

		private var gameState: GameState;

		private var mLogicError: ErrorObject;

		private var secondLoading: FSMState;

		private var initialLoading: FSMState;

		CONFIG::USE_DISCORD_RPC {
			private var discordRpc: DiscordRpc;
		}

		private var RPC: * = {};

		private var messages: Array = [];

		private var messages_big: Array = [];

		public function GameMain() {
			super();
			this.runUnitTests();
			this.mStateMachine = new StateMachine(this);
			this.gameState = new GameState(this.mStateMachine);
			this.resetGame();
			addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, this.keyUp, false, 0, true);
			stage.addEventListener(Event.RESIZE, this.windowResized);
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, this.windowResized);
			CONFIG::USE_DISCORD_RPC {
				this.discordRpc = new DiscordRpc();
			}
			this.setDiscordStatus({});
		}

		private function keyDown(param1: KeyboardEvent): void {
			this.gameState.keyDown(param1);
		}

		private function keyUp(param1: KeyboardEvent): void {
			this.gameState.keyUp(param1);
		}

		private function windowResized(param1: Event): void {
			this.gameState.reactToFullscreen();
		}

		private function onEnterFrame(param1: Event): void {
			var _loc2_: int = getTimer() - this.mGameTime;
			if (_loc2_ > 0) {
				this.logicUpdate(_loc2_);
			}
		}

		public function resetGame(): void {
			if (Config.RESTART_STATUS == 0) {
				Config.RESTART_STATUS = -1;
				PopUpManager.resetAllPopup();
				DCResourceManager.getInstance().unsetResources();
				this.gameState.removeNative();
			}
			this.mStateMachine = null;
			this.gameState = null;
			this.secondLoading = null;
			this.initialLoading = null;
			Element.counter = 0;
			GameState.needToUpdatePermanentHFE = false;
			GameState.mObjectCounter = 0;
			GameState.updateUserDataFlag = false;
			this.mStateMachine = new StateMachine(this);
			this.gameState = new GameState(this.mStateMachine);
			this.secondLoading = new GameLoadingSecond(this.mStateMachine, stage, this.gameState);
			this.initialLoading = new GameLoadingFirst(this.mStateMachine, stage, this.secondLoading, this.gameState);
			this.mStateMachine.changeState(this.initialLoading);
			this.mGameTime = getTimer();
		}

		private function logicUpdate(param1: int): void {
			var server: MyServer;
			var errorType: String = null;
			var currentState: FSMState = null;
			var errorMessage: String = null;
			var errorCode: String = null;
			var codeStartIndex: int = 0;
			var errorService: String = null;
			var matchPattern: RegExp = null;
			var result: Array = null;
			var i: int = 0;
			var serviceIndex: int = 0;
			var deltaTime: int = param1;
			this.mGameTime += deltaTime;
			server = this.gameState.mServer;
			if (server) {
				server.update();
			}
			if (Config.USE_LOGIC_UPDATE_TRY_CATCH && !this.mLogicError) {
				try {
					this.mStateMachine.logicUpdate(deltaTime);
				} catch (e: Error) {
					try {
						errorType = null;
						currentState = mStateMachine.getCurrentState();
						if (currentState is GameLoadingFirst) {
							errorType = "First Loading " + GameLoadingFirst(currentState).getLoadingPercent() + "%";
						} else if (currentState is GameLoadingSecond) {
							errorType = "Second Loading " + GameLoadingSecond(currentState).getLoadingPercent() + "%";
						} else if (currentState is GameState) {
							if (GameState.mInstance.mScene == null) {
								errorType = "CreatingScene";
							} else {
								errorType = "InGame";
							}
						}
						errorMessage = null;
						if (e.getStackTrace()) {
							errorMessage = "Update exception:" + e + " \nST:" + e.getStackTrace() + " \nErrorType:" + errorType;
						} else {
							errorMessage = "Update exception:" + e + " \nST:null" + " \nName:" + e.name + " \nMessage:" + e.message + " \nErrorType:" + errorType;
						}
						if (errorType != "InGame") {
							errorMessage += "\n" + GameState.mInstance.getUserStateSummary();
						}
						errorCode = null;
						codeStartIndex = -1;
						if (e.getStackTrace() != null) {
							codeStartIndex = int(e.getStackTrace().indexOf("#"));
						}
						if (e.getStackTrace() != null && codeStartIndex > -1) {
							errorCode = String(e.getStackTrace().substr(codeStartIndex + 1, 4));
						}
						errorService = null;
						if (e.getStackTrace() != null) {
							matchPattern = /at(.*)\(\)/gi;
							result = matchPattern.exec(e.getStackTrace());
							i = 0;
							while (result != null) {
								i++;
								errorService = String(result[i]);
								if (errorService.substr(0, 5) != "flash") {
									result = null;
								} else {
									result = matchPattern.exec(e.getStackTrace());
								}
							}
						}
						if (errorService) {
							serviceIndex = errorService.indexOf("::");
							if (serviceIndex > -1) {
								errorService = errorService.substr(serviceIndex + 2);
							}
						}
					} catch (e: Error) {}
				}
			} else {
				this.mStateMachine.logicUpdate(deltaTime);
			}
		}

		public function runUnitTests(): void {}

		public function getRandomElementOf(array: Array): String {
			var idx: int = Math.floor(Math.random() * array.length);
			return array[idx];
		}

		private function setDiscordStatus(param1: Object): void {
			CONFIG::USE_DISCORD_RPC {
				var now: Date = null;
				var epoch: Number = NaN;
				var RPC: * = undefined;
				now = new Date();
				epoch = Math.round(now.valueOf() / 1000);

				this.messages.push("Chilling on ")
				this.messages.push("Sleeping on ")
				this.messages.push("Fighting on ")
				this.messages.push("Sitting on ")
				this.messages.push("Attacking on ")
				this.messages.push("Driving on ")
				this.messages.push("Killing tanks on ")
				this.messages.push("Shooting rockets on ")
				this.messages.push("Bullying Tubmann on ");

				this.messages_big.push("Destroying the Crimson Empire")
				this.messages_big.push("AYO THEY ADDED DESERT (hype)")
				this.messages_big.push("Has 10.000.000 Gold")
				this.messages_big.push("'Where did my water pack go????'")
				this.messages_big.push("Playing the game in portrait mode")
				this.messages_big.push("NOOOO I forgot to save the game :(")
				this.messages_big.push("Playing a silly Facebook game")
				this.messages_big.push("Almost out of energy :(")

				this.discordRpc.init("1232767781611634760");
				this.RPC.StartTime = epoch;
				this.RPC.State = this.getRandomElementOf(this.messages) + "Homeland";
				this.RPC.Details = this.getRandomElementOf(this.messages_big)
				this.RPC.LargeImage = "big_logo"
				this.RPC.LargeImageDescription = "Army Attack"
				this.RPC.SmallImage = null;
				this.RPC.SmallImageDescription = null;
				this.RPC.PartyId = null;
				this.RPC.PartySize = 0;
				this.RPC.PartyCape = 0;
				this.RPC.JoinSecret = null;
				this.RPC.SpectatorSecret = null;
				this.discordRpc.updatePresence(this.RPC.State, this.RPC.Details, this.RPC.StartTime, this.RPC.EndTime, this.RPC.LargeImage, this.RPC.LargeImageDescription, this.RPC.SmallImage, this.RPC.SmallImageDescription, this.RPC.PartyId, this.RPC.PartySize, this.RPC.PartyCape, this.RPC.JoinSecret, this.RPC.SpectatorSecret);
			}
		}
		public function changeDiscordMap(param1: String): void {
			CONFIG::USE_DISCORD_RPC {
				this.RPC.State = this.getRandomElementOf(this.messages) + param1;
				this.RPC.Details = this.getRandomElementOf(this.messages_big)
				this.discordRpc.updatePresence(this.RPC.State, this.RPC.Details, this.RPC.StartTime, this.RPC.EndTime, this.RPC.LargeImage, this.RPC.LargeImageDescription, this.RPC.SmallImage, this.RPC.SmallImageDescription, this.RPC.PartyId, this.RPC.PartySize, this.RPC.PartyCape, this.RPC.JoinSecret, this.RPC.SpectatorSecret);
			}
		}
	}
}