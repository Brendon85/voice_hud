window.addEventListener('message', function (event) {
	if (event.data.show == false) {
		document.body.style.opacity = 0.0;
	} else {
		document.body.style.opacity = 1.0;
	}
    
	if (event.data.action == "updatespeech") {
        if (event.data.micEnabled) {
            if (event.data.speaking) {
                document.getElementById('barIcon').src = "img/Mic-Hud-Green.png";
            } else {
                document.getElementById('barIcon').src = "img/Mic-Hud.png";
            }
        }
	}
	
	if (event.data.action == "updateStatusHud") {
        if (event.data.voiceRange) {
			if (!event.data.micEnabled) {
                document.getElementById('barIcon').src = "img/Mic-Hud-Mute.png";
                $("#varVoice small").text(event.data.voiceRange);
				$("#varTemp small").text(event.data.temp);
			} else {
                document.getElementById('barIcon').src = "img/Mic-Hud.png";
				$("#varVoice small").text(event.data.voiceRange);
			}
        }
	}
});
