local characterIndex = {}
local character = {}
local characterPart = {}
local CharactersAPI = {}
local updateFuncs = {
  name = function(char)
    nameplate.ALL:setText(char.name)
  end,
  part = function(char)
    for fek, you in pairs(characterPart) do
      you:setVisible(false)
    end
    local part = characterPart[char.index]
    if part then
      part:setVisible(true)
      if char.texture then
        part:setPrimaryTexture("custom",char.texture)
        part:setUVPixels(char.UV)
      end
      part:setScale(char.size or vec(1,1,1))
    end
    vanilla_model.PLAYER:setVisible(not part)
  end,
  size = function(char)
    characterPart[char.index]:setScale(char.size or vec(1,1,1))
  end,
  texture = function(char)
    characterPart[char.index]:setPrimaryTexture("custom",char.texture)
  end,
  mark = function(char)
    avatar:setColor(char.mark or deffal)
  end,
  UV = function(char)
    characterPart[char.index]:setUVPixels(char.size or vec(1,1,1))
  end
}

local function updateChar(index,char)
  updateFuncs[index](char)
end

local character_functions = {
  setName = function(self, str)
  local ID = self.index
  self.name = str
  if ID == character.current then
    updateChar("name",self)
  end
  return self
end,
setModel = function(self, modelpart)
  local ID = self.index
  characterPart[ID] = modelpart
  if ID == character.current then
    updateChar("part",self)
  end
  return self
end,
setSize = function(self, sz)
  local ID = self.index
  self.size = type(sz) == "number" and vec(sz,sz,sz) or sz
  if ID == character.current then
    updateChar("size",self)
  end
  return self
end,
setTexture = function(self, texture)
  local ID = self.index
  self.texture = texture
  if ID == character.current then
    updateChar("texture",self)
  end
  return self
end,
setUV = function(self, UV)
  local ID = self.index
  self.UV = UV
  if ID == character.current then
    updateChar("UV",self)
  end
  return self
end,
setMarkColor = function(self, color)
  local ID = self.index
  self.mark = vectors.hexToRGB(color)
  if ID == character.current then
    updateChar("mark",self)
  end
  return self
end,
setCharacter = function(self)
  local ID = self.index
  CharactersAPI.setCharacter(ID)
  return self
end
}

local deffal = vectors.hexToRGB(avatar:getColor() or "#4c8cff")
local characterCount = 0
local wwit = "#ffffff"

local function setMark(char)
  avatar:setColor(char.mark or deffal)
end

local character_metatable = {
  __index = character_functions,
  __type = "Character"
}
function CharactersAPI.newCharacter(index)
  if index == nil then
    index = index or characterCount + 1
  else
    index = index
  end
  if not characterIndex[index] then characterCount = characterCount + 1 end
  characterIndex[index] = index
  character[index] = {}
  local char = character[index]
  char.index = index
  setmetatable(char, character_metatable)
  return char,index
end
function CharactersAPI.getCharacters()
  return character
end
function CharactersAPI.getCharacter(index)
  return character[index]
end
function CharactersAPI.setCharacter(index)
  if index == character.current then return end
  local char = character[index] or {}
  character.current = index
  local part = characterPart[index]
  updateChar("name",char)
  for fek, you in pairs(characterPart) do
    you:setVisible(false)
  end
  updateChar("part",char)
  setMark(char)
end
function CharactersAPI.amount()
  return characterCount
end
function CharactersAPI.setDefaultMark(col)
  deffal = col
  setMark(character.current)
end
function CharactersAPI.getParts()
  return characterPart
end
return CharactersAPI
