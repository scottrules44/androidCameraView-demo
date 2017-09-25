local androidCameraView = require "plugin.androidCameraView"

local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
bg:setFillColor( .5,0.5 )

local title = display.newText( "Android CameraView", display.contentCenterX, 30, native.systemFontBold, 20 )
if (system.getInfo("environment") == "simulator") then
   print("please build for android device to test") 
else
    local function displayCamera(  )
        local myView = androidCameraView.newView({x = display.contentCenterX, y= display.contentCenterY, width =200, height = 200})
        timer.performWithDelay( 5000, function ( )
            myView:destroy()
            local myView = androidCameraView.newView({x = display.contentCenterX, y= display.contentCenterY, width =200, height = 200, frontCamera = true})
        end )
        
    end
    if (tonumber(system.getInfo("androidApiLevel"))>= 23) then
        local grantedPermissions = system.getInfo( "grantedAppPermissions" )

        for i = 1,#grantedPermissions do

            if ( "Camera" == grantedPermissions[i] ) then
                displayCamera(  )
                break
            end
        end
        local function appPermissionsListener( event )
            for k,v in pairs( event.grantedAppPermissions ) do
                if ( v == "Camera" ) then
                    displayCamera(  )
                    
                end
            end
        end
         
        local options =
        {
            appPermission = "Camera",
            urgency = "Critical",
            listener = appPermissionsListener,
            rationaleTitle = "Camera access required",
            rationaleDescription = "Camera access is required for preview. Re-request now?",
            settingsRedirectTitle = "Alert",
            settingsRedirectDescription = "Camera access is required for preview, this app cannot properly function. Please grant camera access within Settings."
        }
        native.showPopup( "requestAppPermission", options )
    else
        displayCamera(  )
    end
end
