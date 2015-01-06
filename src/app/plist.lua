function getPlistDict(fileName)
    local plistFile = cc.FileUtils:getInstance():fullPathForFilename(fileName)
    print(plistFile)
    local dict = cc.FileUtils:getInstance():getValueMapFromFile(plistFile) --<array>
    --local dict = cc.FileUtils:getInstance():getValueMapFromFile(plistFile)  --<dict>
    return dict
end
function getVersion()
    
    dict = getPlistDict("xxxx.plist")  --local version = tonumber(dict["Version"])  --一维
    local version = tonumber(dict[2]["Version"]) --多维
    return version
end

