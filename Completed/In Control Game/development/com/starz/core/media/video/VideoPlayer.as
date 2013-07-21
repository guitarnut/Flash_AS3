/*

v1.0 Supports single videos.  Future versions will include the option to send a playlist.
var video : VideoPlayer = new VideoPlayer();
			
this.addChild(video);
video.sizeVideo(400, 300);
video.addControls();
video.setVideoPath("http://www.starz.com/videos/Ratatouille.flv");

 */

package com.starz.core.media.video {
	import com.starz.core.media.video.components.VideoMenu;
	import com.starz.core.media.video.components.VideoProgressBar;
	import com.starz.core.media.video.events.VideoControlEvent;
	import com.starz.core.media.video.vo.VideoVO;
	import com.starz.core.utils.DrawRectangle;

	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * @author rhenley
	 */
	public class VideoPlayer extends Sprite {
		private static const BUFFER_TIME : Number = 10;

		private var _netConnection : NetConnection;
		private var _netStream : NetStream;
		private var _video : Video;
		private var _client : Object;
		private var _videoPlaylist : Array;
		private var _playlistCount : Number;
		private var _videoPath : String;
		private var _videoDuration : Number;
		private var _soundTransform : SoundTransform;
		private var _videoFile : VideoVO;
		private var _videoMenu : VideoMenu;
		private var _videoProgress : VideoProgressBar;
		private var _bufferIcon : BufferIcon;
		private var _playButton : PlayButton;
		private var _videoBackground : VideoBackground;
		private var _fullscreenBG : Sprite;

		public function VideoPlayer(videoPlaylist : Array = null) : void {
			//If an array of videos are passed, we'll store them here
			if(videoPlaylist)_videoPlaylist = videoPlaylist;
			init();
		}

		private function init() : void {
			_video = new Video();
			_video.smoothing = true;
			addChild(_video);
			
			_bufferIcon = new BufferIcon();
			
			createNetConnection();
			createNetStream();
			attachNetStream();
			getMetaData();
		}

		private function createNetConnection() : void {
			_netConnection = new NetConnection();
			_netConnection.connect(null);
		}

		private function createNetStream() : void {
			_netStream = new NetStream(_netConnection);
			_netStream.bufferTime = BUFFER_TIME;
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
		}

		private function attachNetStream() : void {
			_video.attachNetStream(_netStream);
		}

		public function sizeVideo(videoWidth : Number, videoHeight : Number) : void {
			_video.width = videoWidth;
			_video.height = videoHeight;
			
			_videoBackground = new VideoBackground();
			_videoBackground.width = videoWidth;
			_videoBackground.height = videoHeight;
			addChildAt(_videoBackground, 0);
		}

		public function setVideoPath(videoPath : String) : void {
			_videoPath = videoPath;
		}

		private function netStatus(event : NetStatusEvent) : void {
			switch (event.info.code) {
				case "NetStream.Play.Start":
					addEventListener(Event.ENTER_FRAME, updateLoadProgress);
					_videoMenu.activateSeekbar();
					addEventListener(Event.ENTER_FRAME, updateSeekbar);
					addEventListener(Event.ENTER_FRAME, updateTime);
					addChild(_bufferIcon);
					break;
				case "NetStream.Play.Stop":
					removeChild(_bufferIcon);
					_netStream.pause();
					_netStream.seek(0);
					_videoMenu.resetMenu();
					break;
				case "NetStream.Buffer.Empty":
					addChild(_bufferIcon);
					break;
				case "NetStream.Buffer.Full":
					removeChild(_bufferIcon);
					break;
			}
		}

		public function addControls(defaultControls : Boolean = true, controlSet : Sprite = null) : void {
			//This function is optional.  If no controls are specified, the player will use the default video controls.
			if(defaultControls) {
				_videoProgress = new VideoProgressBar();
				_videoProgress.y = _video.height - _videoProgress.height;
				_videoProgress.width = _video.width;
				
				_videoMenu = new VideoMenu();
				_videoMenu.y = _video.height - _videoMenu.height - _videoProgress.height;
				_videoMenu.x = _video.width / 2;
				_videoMenu.controlBackground.width = _video.width;
				_videoMenu.controlBackground.x = -(_video.width / 2);
				_videoMenu.controlBackground.alpha = .7;
				
				addChild(_videoMenu);
				addChild(_videoProgress);
				addEventListener(MouseEvent.MOUSE_MOVE, showControls);
				addControlEvents();
			}
		}

		private function addControlEvents() : void {
			_videoMenu.addEventListener(VideoControlEvent.PLAY_CLICKED, playVideo);
			_videoMenu.addEventListener(VideoControlEvent.PAUSE_CLICKED, pauseVideo);
			_videoMenu.addEventListener(VideoControlEvent.STOP_CLICKED, stopVideo);
			_videoMenu.addEventListener(VideoControlEvent.NEXT_CLICKED, nextVideo);
			_videoMenu.addEventListener(VideoControlEvent.PREVIOUS_CLICKED, previousVideo);
			_videoMenu.addEventListener(VideoControlEvent.FULLSCREEN_CLICKED, fullscreenClicked);
			_videoMenu.addEventListener(VideoControlEvent.SEEK, seekVideo);
			_videoMenu.addEventListener(VideoControlEvent.VOLUME_CLICKED, adjustVolume);
		}

		private function showControls(event : MouseEvent) : void {
			_videoMenu.show();
		}

		private function createPlayButton() : void {
			_playButton = new PlayButton();
			_playButton.mouseChildren = false;
			_playButton.buttonMode = true;
			_playButton.x = _video.width / 2;
			_playButton.y = _video.height / 2 - 10;
			_playButton.addEventListener(MouseEvent.MOUSE_DOWN, playVideo);
			addChild(_playButton);
		}

		private function showPlayButton() : void {
			_playButton.visible = true;
		}

		private function hidePlayButton() : void {
			_playButton.visible = false;
		}

		private function updateLoadProgress(event : Event) : void {
			_videoProgress.progressBar.scaleX = _netStream.bytesLoaded / _netStream.bytesTotal;
			if(_netStream.bytesLoaded == _netStream.bytesTotal) {
				removeEventListener(Event.ENTER_FRAME, updateLoadProgress);
			}
		}

		private function updateSeekbar(event : Event) : void {
			_videoMenu.updateSeekbar(_netStream.time / _videoDuration);
		}

		private function updateTime(event : Event) : void {
			_videoMenu.updateTime(_netStream.time);
		}

		public function play(videoPath : String) : void {
			_netStream.play(videoPath);
		}

		private function playVideo(event : * = null) : void {
			if(_netStream.time == 0)_netStream.play(_videoPath);
			if(_netStream.time > 0)_netStream.resume();
			if(_playButton.visible)hidePlayButton();
		}

		private function pauseVideo(event : VideoControlEvent) : void {
			_netStream.pause();
		}

		private function stopVideo(event : VideoControlEvent) : void {
			_netStream.pause();
			_netStream.seek(0);
		}

		private function fullscreenClicked(event : VideoControlEvent) : void {
			if(stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
				_fullscreenBG = DrawRectangle(stage.stageWidth * 2, stage.stageHeight * 2, 0x000000, 1);
				_fullscreenBG.x = -stage.stageWidth / 2; 
				_fullscreenBG.y = -stage.stageHeight / 2;
				addChildAt(_fullscreenBG, 0);
			} else if (stage.displayState == StageDisplayState.FULL_SCREEN) {
				stage.displayState = StageDisplayState.NORMAL;
				removeChild(_fullscreenBG);
			}
		}

		private function nextVideo(event : VideoControlEvent) : void {
		}

		private function previousVideo(event : VideoControlEvent) : void {
		}

		private function seekVideo(event : VideoControlEvent) : void {
			_netStream.seek(Math.round(_videoDuration * event.data.position));
		}

		private function adjustVolume(event : VideoControlEvent) : void {
			_soundTransform = new SoundTransform();
			_soundTransform.volume = event.data.newVolume;
			_netStream.soundTransform = _soundTransform;
		}

		public function show() : void {
			this.visible = true;
		}

		public function hide() : void {
			this.visible = false;
		}

		private function getMetaData() : void {
			_client = new Object();
			_client.onMetaData = onMetaData;
			_netStream.client = _client;
		}

		private function onMetaData(data : Object) : void {
			_videoDuration = data.duration;
			//data.width;
			//data.audiodelay;
			//data.canSeekToEnd;
			//data.height;
			//data.cuePoints;
			//data.audiodatarate;
			//data.videodatarate;
			//data.framerate;
			//data.videocodecid;
			//data.audiocodecid;
		}
	}
}
