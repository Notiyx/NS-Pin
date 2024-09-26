Config = {}


Config.MaxFailed = 3

Config.MaxFailedTimer = 60 -- secondes

Config.Color = { -- Color of the UI {R, G, B, A}
    ContainerColor = {24, 24, 24, 0.2},
    KeyBackgroundColor = {50, 55, 25, 0.2},
    BorderKeyColor = {255, 255, 255, 0.3},
    KeyHover = {255, 255, 255, 0.3},
    ColorKey = {255, 255, 255, 0.3},

    --------Circle-----------
    CircleComplete = {74, 144, 226, 1.0},
    CircleBorderComplete = {36, 136, 161, 1.0},
    CircleErrorBorder = {255, 0, 0, 1.0},
    CircleSuccessBorder = {0, 255, 0, 1.0},

    TextColor = {224, 224, 224, 1.0},
}

Config.Sounds = {
    KeySounds = {
        Enabled = false,
        Volume = 1.0,
    },
    ErrorSounds = {
        Enabled = false,
        Volume = 0.1,
    },
    SuccessSounds = {
        Enabled = true,
        Volume = 0.1,
    },
}

Config.Notification = function(message)
    ESX.ShowNotification(message)
end