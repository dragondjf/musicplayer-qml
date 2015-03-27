import QtQuick 2.4

Item {

    property var playlistNavgationBar
    property var playlistDetailBox
    property var currentPlaylistName: ''

    function init() {
        if (ConfigWorker.lastPlaylistName == "favorite"){
            playlistNavgationBar.starDelegate.state = 'Checked'
        }else if(ConfigWorker.lastPlaylistName == "temporary"){
            playlistNavgationBar.temporaryDelegate.state = 'Checked'
        }else{
            for (var i = 0 ; i< PlaylistWorker.playlistNames.length; i++){
                if (PlaylistWorker.playlistNames[i].name == ConfigWorker.lastPlaylistName){
                    playlistNavgationBar.customPlaylistView.currentIndex = i;
                    return
                }
            }
        }
        currentPlaylistName = ConfigWorker.lastPlaylistName
    }

    function playMusicByUrl(url) {
        if (url.indexOf('http') != -1){
            Web360ApiWorker.playMediaByUrl(url);
        }else{
            MediaPlayer.playLocalMedia(url);
        }
    }

    Binding { 
        target: playlistNavgationBar.customPlaylistView
        property: 'model'
        value: PlaylistWorker.playlistNames
    }

    Binding {
        target: playlistDetailBox.playlistView
        property: 'model'
        value:{
            if (currentPlaylistName) {
                var medias = PlaylistWorker.getMediasByName(currentPlaylistName);
                return medias
            }
        }
    }

    Binding {
        target: playlistDetailBox.titleText
        property: 'text'
        value: {
            if (playlistDetailBox.playlistView.model) {
                var model = playlistDetailBox.playlistView.model;
                return I18nWorker.song + '   (' + model.length +')'
            }
        }
    }

    Connections {
        target: playlistDetailBox.playlistView

        onPlayMusicByUrl: {
            MediaPlayer.setPlaylistByName(currentPlaylistName);
            playMusicByUrl(url);

            if (MediaPlayer.playlist.name == 'favorite'){
                playlistNavgationBar.starDelegate.state = 'Active'
                playlistNavgationBar.temporaryDelegate.state = '!Checked'

            }else if(MediaPlayer.playlist.name == 'temporary'){
                playlistNavgationBar.starDelegate.state = '!Checked'
                playlistNavgationBar.temporaryDelegate.state = 'Active'
            }else{

            }
        }

        onModelChanged: {
            playlistDetailBox.playlistView.currentIndex = -1;
        }
    }

    Connections {
        target: playlistNavgationBar

        onAddPlaylistName:{
            PlaylistWorker.createPlaylistByName(name);
            if (playlistNavgationBar.starDelegate.state == "Active"){
                
            }else{
                playlistNavgationBar.starDelegate.state = '!Checked'
            }
            if (playlistNavgationBar.temporaryDelegate.state == "Active"){
                
            }else {
                playlistNavgationBar.temporaryDelegate.state = '!Checked'
            }
        }

        onPlaylistNameChanged: {
            var nameId;
            if (name == I18nWorker.favorite){
                nameId = "favorite";
            }else if (name == I18nWorker.temporary){
                nameId = "temporary";
            }else{
                nameId = name;
            }

            currentPlaylistName = nameId;

            if (MediaPlayer.playlist.name == currentPlaylistName){
                playlistDetailBox.playlistView.currentIndex = MediaPlayer.playlist.currentIndex;
                playlistDetailBox.playlistView.currentItem.state = "Active";
            }
        }
    }

    Component.onCompleted: {
        init()
    }
}