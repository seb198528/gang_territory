let currentZoneId = null;

// Réception des messages NUI
window.addEventListener('message', (event) => {
    const data = event.data;
    
    if (data.action === "OPEN_MENU") {
        document.getElementById('menu').classList.remove('hidden');
        document.getElementById('zone-name').textContent = data.zone.name || 'Territoire';
        document.getElementById('current-gang').textContent = data.zone.gang || 'Inconnu';
        currentZoneId = data.zone.id;
    } else if (data.action === "PLAY_SOUND") {
        const audio = document.getElementById('custom-sound');
        audio.src = data.file;
        audio.play().catch(e => console.warn("Son bloqué:", e));
    }
});

// Fermer le menu
document.getElementById('close-btn').addEventListener('click', () => {
    fetch('https://gang_territory/closeMenu', { method: 'POST' });
    document.getElementById('menu').classList.add('hidden');
});

// Lancer la capture
document.getElementById('capture-btn').addEventListener('click', () => {
    if (currentZoneId) {
        fetch('https://gang_territory/startCapture', {
            method: 'POST',
            body: JSON.stringify({ zoneId: currentZoneId })
        });
        document.getElementById('menu').classList.add('hidden');
    }
});

// Fermer avec ÉCHAP
document.addEventListener('keyup', (e) => {
    if (e.key === 'Escape') {
        fetch('https://gang_territory/closeMenu', { method: 'POST' });
        document.getElementById('menu').classList.add('hidden');
    }
});