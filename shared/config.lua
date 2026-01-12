Config = {}

Config.Framework = 'QBCore'

-- Webhook Discord (optionnel)
Config.DiscordWebhook = "https://discord.com/api/webhooks/VOTRE_WEBHOOK_ICI"

-- Réputation
Config.Reputation = {
    enabled = true,
    lossPerSecond = 2,
    min = -1000,
    max = 1000
}

-- PNJ hostiles
Config.HostileNPCs = {
    enabled = true,
    spawnDelay = 15000, -- 15 sec
    model = "g_m_mexgoon_01",
    weapon = "WEAPON_PISTOL",
    count = 3
}

-- Sons personnalisés
Config.GangSounds = {
    ballas = "sounds/ballas_alert.mp3",
    vagos = "sounds/vagos_alert.mp3",
    families = "sounds/families_alert.mp3"
}

-- Alarme visuelle
Config.InvasionAlert = {
    enabled = true,
    duration = 60000, -- 60 sec
    flashColor = {255, 0, 0}, -- Rouge
    flashInterval = 300
}

-- Zones statiques
Config.Zones = {
    {
        id = 1,
        name = "Territoire Ballas",
        gang = "ballas",
        type = "circle",
        center = vector3(-700.0, -800.0, 30.0),
        radius = 150.0,
        minZ = 25.0,
        maxZ = 40.0
    },
    {
        id = 2,
        name = "Zone Vagos",
        gang = "vagos",
        type = "rectangle",
        coords = { x1 = 1200.0, y1 = -1500.0, x2 = 1400.0, y2 = -1300.0 },
        minZ = 28.0,
        maxZ = 45.0
    }
}

-- Capture
Config.Capture = {
    timeToCapture = 60000, -- 60 sec
    cooldownAfterCapture = 300000 -- 5 min
}

-- Admin
Config.AdminGroups = { "admin", "mod" }