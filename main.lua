function love.load()
    love.window.setTitle("Reconhecimento de Sons")
    love.window.setMode(800, 600)

    font = love.graphics.newFont(30)
    love.graphics.setFont(font)

    words = {
        { word = "Gato",     sound = "sounds/cat.ogg",  icon = "icons/cat.png" },
        { word = "Cachorro", sound = "sounds/dog.ogg",  icon = "icons/dog.png" },
        { word = "Pássaro",  sound = "sounds/bird.ogg", icon = "icons/bird.png" },
        { word = "Carro",    sound = "sounds/car.ogg",  icon = "icons/car.png" }
    }

    -- Load audio and images
    for i, w in ipairs(words) do
        w.audio = love.audio.newSource(w.sound, "static")
        w.iconImage = love.graphics.newImage(w.icon)
    end

    -- Counters
    score = 0
    round = 1

    -- First round
    nextRound()
end

function nextRound()
    -- Random word
    correctWord = words[love.math.random(#words)]
    correctWord.audio:play()

    -- Shuffle options
    options = { correctWord.word }
    while #options < 3 do
        local randomWord = words[love.math.random(#words)].word
        if not contains(options, randomWord) then
            table.insert(options, randomWord)
        end
    end
    shuffle(options)
end

function love.draw()
    love.graphics.printf("Ouça o som e clique na palavra correta!", 0, 50, love.graphics.getWidth(), "center")
    love.graphics.printf("Pontuação: " .. score, 0, 500, love.graphics.getWidth(), "center")

    local screenWidth = love.graphics.getWidth()
    local optionWidth = 300
    local iconSize = 50
    local spacing = 20

    -- Center
    local startX = (screenWidth - (iconSize + spacing + optionWidth)) / 2

    for i, word in ipairs(options) do
        -- Find the wordData for the current word
        local wordData = nil
        for _, w in ipairs(words) do
            if w.word == word then
                wordData = w
                break
            end
        end

        if wordData then
            local yPos = 150 + i * 100 -- Adjust the Y position for each word

            -- Icon
            love.graphics.draw(wordData.iconImage, startX, yPos, 0, 0.08, 0.08)

            -- Text and rectangle
            love.graphics.rectangle("line", startX + iconSize + spacing, yPos, optionWidth, 50)
            love.graphics.printf(word, startX + iconSize + spacing, yPos + 10, optionWidth, "center")
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        for i, word in ipairs(options) do
            if x >= 100 and x <= 500 and y >= 150 + i * 100 and y <= 200 + i * 100 then
                if word == correctWord.word then
                    score = score + 1
                else
                    score = score - 1
                end
                nextRound()
                break
            end
        end
    end
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = love.math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

function contains(tbl, item)
    for _, v in ipairs(tbl) do
        if v == item then
            return true
        end
    end
    return false
end
