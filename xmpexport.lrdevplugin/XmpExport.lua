local LrLogger = import 'LrLogger'

-- To monitor progress, run the following command in the terminal:
--     tail -f ~/Document/XmpExport.log
local myLogger = LrLogger( 'XmpExport' )
myLogger:enable( "logfile" )

local function outputToLog( message )
    myLogger:trace( message )
end

local function updateXmpFiles()

    local LrTasks = import 'LrTasks'
    
    LrTasks.startAsyncTask(function()
        outputToLog( "XmpExport started" )

        local LrApplication = import 'LrApplication'
        local LrDialogs = import 'LrDialogs'
        local catalog = LrApplication.activeCatalog()
        local photos = catalog:getTargetPhotos()

        for photo_i, photo in ipairs(photos) do
            -- Expect a file called <original_name>.xmp
              local path = photo:getRawMetadata("path")
            
            outputToLog( "Processing: " .. path )
              
              xmp_path = path .. ".xmp"
            
              local file = io.open(xmp_path, "r")
              
              if not file then
                outputToLog( "WARNING: XMP file does not exist: " .. xmp_path )
              else
                 local arr = {}
                 local in_section = false
                 local found_placeholder = false
                 
                 -- Store all lines from the original XMP file in the table "arr"
                 -- with the addition of the keywords from Lightroom
                
                for line in file:lines() do
                    -- outputToLog( line )
                    table.insert (arr, line)
                    
                    -- We don't parse the XML file, instead we expect the following block:
                    --    <digiKam:TagsList>
                    --        <rdf:li>PLACEHOLDER_TAG</rdf:li>
                    --    </digiKam:TagsList>
                    -- We will add the Lightroom keywords after the placeholder.
                    if string.match(line, "<digiKam:TagsList>") then
                        in_section = true
                    end
                    if string.match(line, "</digiKam:TagsList>") then
                        in_section = false
                    end
                    if string.match(line, "<rdf:li>PLACEHOLDER_TAG</rdf:li>") and in_section then
                        found_placeholder = true
                        local keywords = photo:getRawMetadata("keywords")
                          -- Create a string representing the hierarchy of the keywords, for instance:
                          -- Animal/Mammal/Dog/Terrier
                        for keyword_i, keyword in ipairs(keywords) do
                            local keyword_fullpath = keyword:getName()
                            keyword = keyword:getParent()
                            while keyword do
                                keyword_fullpath = keyword:getName() .. "/" .. keyword_fullpath
                                keyword = keyword:getParent()
                            end
                            table.insert (arr, "<rdf:li>" .. keyword_fullpath .. "</rdf:li>")
                          end
                    end
                end
                file:close()
                if found_placeholder then
                    -- Overwrite the XMP file with our additions
                    file = io.open(xmp_path, "w")
                    for line_i, line in ipairs(arr) do
                        file:write(line .. "\n")
                    end            
                    file:close()
                else
                    outputToLog( "WARNING: PLACEHOLDER_TAG was not found in " .. xmp_path )
                end
            end
        end
        LrDialogs.message( "XMP Export", "Finished! Check log in ~/Documents/XmpExport.log", "info" )
        outputToLog( "XmpExport ended" )
    end )
end

updateXmpFiles()
