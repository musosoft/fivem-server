var currShow = false,
    gearReady = false,
    elmGear = document.getElementById('gearStats');

window.addEventListener('message', function(e) {
    var isShow = e.data.isShow,
        speed = e.data.speed,
        gear = e.data.gear,
        maxGear = e.data.maxGear,
        hasBelt = e.data.hasBelt,
        beltOn = e.data.beltOn,
        hasCruise = e.data.hasCruise,
        cruiseStatus = e.data.cruiseStatus,
        carHealth = e.data.carHealth,
        carFuel = e.data.carFuel,
        isHide = e.data.isHide,
        engineStatus = e.data.engineStatus,
        streetName = e.data.streetName;

    if(isShow == true && isHide == false) {
        this.document.getElementById('allELM').style.animation = "";
        this.document.getElementById('allELM').style.display = "block";
        //if(isEnable == true) this.document.getElementById('allELM').style.display = "block"
        //else if(isEnable == false) this.document.getElementById('allELM').style.display = ""

        if(currShow == false) {
            currShow = true;
            gearReady = false;
            //insertGear(maxGear);
        }

        this.document.getElementById('yeetHealth').style.width = carHealth + "%";
        this.document.getElementById('yeetFuel').style.width = carFuel + "%";
        this.document.getElementById('numSpeed').innerHTML = speed;
        this.document.getElementById('gearNum').innerHTML = gear;
        this.document.getElementById('placeName').innerHTML = streetName;

        /*var gearList = elmGear.getElementsByTagName('span');
        if(gearReady == true) {
            for(var i = 0; i <= (gearList.length - 1); i++) {
                gearList[i].classList.remove('active');
            }
            try {
                gearList[gear - 1].classList.add('active');
            } catch (error) {
                gearList[0].classList.add('active');
            }
        }*/

        if(hasBelt) {
            this.document.getElementById('belt').style.display = ""
            document.getElementById('txtNotice').style.display = "";
        } else {
            this.document.getElementById('belt').style.display = "none"
            document.getElementById('txtNotice').style.display = "none";
            document.getElementById('mainGUI').style.height = "39px";
        }

        if(beltOn && hasBelt) {
            document.getElementById('mainGUI').style.height = "39px";
            document.getElementById('txtNotice').style.display = "none";
            //document.getElementById('txtNotice').innerHTML = 'PRESS <span style="color: rgba(255, 255, 255, 1)">B</span> TO RELEASE THE SEATBELT.';
            document.getElementById('belt').classList.add('active');
            document.getElementById('belt').getElementsByTagName('p')[0].innerHTML = "ON";
            document.getElementById('belt').getElementsByTagName('p')[0].style.paddingLeft = "7px";
        } else if(!beltOn && hasBelt) {
            document.getElementById('mainGUI').style.height = "";
            document.getElementById('txtNotice').style.display = "";
            //document.getElementById('txtNotice').innerHTML = 'PRESS <span style="color: rgba(255, 255, 255, 1)">B</span> TO USE THE SEATBELT.';
            document.getElementById('belt').classList.remove('active');
            document.getElementById('belt').getElementsByTagName('p')[0].innerHTML = "OFF";
            document.getElementById('belt').getElementsByTagName('p')[0].style.paddingLeft = "";
        }

        if(hasCruise) {
            this.document.getElementById('cruise').style.display = ""
        } else {
            this.document.getElementById('cruise').style.display = "none"
        }

		if(cruiseStatus && hasCruise) {
            document.getElementById('cruise').classList.add('active');
            document.getElementById('cruise').getElementsByTagName('p')[0].innerHTML = "ON";
            document.getElementById('cruise').getElementsByTagName('p')[0].style.paddingLeft = "10px";
        } else if(!cruiseStatus && hasCruise) {
            document.getElementById('cruise').classList.remove('active');
            document.getElementById('cruise').getElementsByTagName('p')[0].innerHTML = "OFF";
            document.getElementById('cruise').getElementsByTagName('p')[0].style.paddingLeft = "";
        }

		if(engineStatus) {
            document.getElementById('engine').classList.add('active');
            document.getElementById('engine').getElementsByTagName('p')[0].innerHTML = "ON";
            document.getElementById('engine').getElementsByTagName('p')[0].style.paddingLeft = "3px";
        } else {
            document.getElementById('engine').classList.remove('active');
            document.getElementById('engine').getElementsByTagName('p')[0].innerHTML = "OFF";
            document.getElementById('engine').getElementsByTagName('p')[0].style.paddingLeft = "";
        }

        //if(turnLeft) document.getElementById('arrLeft').classList.add('active'); else document.getElementById('arrLeft').classList.remove('active');
        //if(turnRight) document.getElementById('arrRight').classList.add('active'); else document.getElementById('arrRight').classList.remove('active');
    } else {
        if (currShow == true) {
            currShow = false;
            this.document.getElementById('allELM').style.animation = "fadeOutDown .5s forwards";
            setTimeout(() => {
                this.document.getElementById('allELM').style.display = "";
            }, 500);
        }
    }
})

async function insertGear(amount) {
    gearReady = false;
    elmGear.innerHTML = "";
    elmGear.style.width = (amount * 13) + 'px';
    elmGear.style.marginLeft = ((6 - amount) * 14) + 'px';
    for(var i = 0; i <= (amount - 1); i++) {
        await sleep(100);
        var spanG = document.createElement('span');
        spanG.innerHTML = (i + 1);
        elmGear.appendChild(spanG);
    }
    gearReady = true;
}

function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}