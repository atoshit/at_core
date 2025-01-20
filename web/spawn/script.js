let isSpawning = false;
const clickSound = new Audio('sounds/click.mp3');
clickSound.volume = 0.1;

function initializeUI(serverName, playerName) {
    return new Promise((resolve) => {
        document.querySelector('.server-name').textContent = serverName;
        document.querySelector('.player-name').textContent = playerName;
        
        setTimeout(() => {
            const preloader = document.querySelector('.preloader');
            preloader.classList.add('fade-out');
            
            document.querySelector('.container').style.display = 'flex';
            resolve();
        }, 500);
    });
}

window.addEventListener('message', async function(event) {
    const data = event.data;
    
    if (data.type === 'showSpawnUI') {
        const preloader = document.querySelector('.preloader');
        preloader.classList.remove('fade-out');
        preloader.style.removeProperty('opacity');
        preloader.style.removeProperty('visibility');
        
        await initializeUI(data.serverName, data.playerName);
    }
    
    if (data.type === 'hideSpawnUI') {
        document.querySelector('.welcome-card').classList.add('hide');
        setTimeout(() => {
            document.querySelector('.container').style.display = 'none';
            document.querySelector('.welcome-card').classList.remove('hide');
        }, 500);
    }
});

document.getElementById('spawnButton').addEventListener('click', function() {
    if (isSpawning) return;
    
    clickSound.currentTime = 0;
    clickSound.play().catch(function(error) {
        console.log("Sound play failed:", error);
    });
    
    isSpawning = true;
    this.classList.add('loading');
    
    fetch(`https://${GetParentResourceName()}/spawnPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    }).catch(err => console.error(err));
    
    setTimeout(() => {
        isSpawning = false;
        this.classList.remove('loading');
    }, 2000);
});