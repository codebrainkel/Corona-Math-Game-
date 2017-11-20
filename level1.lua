local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

local currentLevel = 1
local currentScore = 0
local highScore = composer.getVariable( "highScore" )
local correctAnswers = 0
local incorrectAnswers = 0

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create( event )
	
	local sceneGroup = self.view

	local highScoreDisplayOptons = {
        text = 'Highscore:'..highScore,
		x = 110,
		y = 25,
		fontSize = 20, 
		align = "left"
	}
	
	local highScoreDisplay = display.newText( highScoreDisplayOptons );

	local scrollViewOptons = {
        top = 50,
        left = 0,
        width = 768,
        height = 976,
        scrollWidth = 768,
        scrollHeight = 1024,
		hideScrollBar = true, 
		isBounceEnabled = false
    }
 
-- Create the widget
	local scrollView = widget.newScrollView(scrollViewOptons)
 
-- Create a image and insert it into the scroll view
	local background = display.newImageRect( "assets/bg.jpg", 1500, 2200 )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX - 340
	background.y = 0 + display.screenOriginY

	local button = display.newCircle( 100, 100, 30 )
	button:setFillColor( 0.5 )
	
	scrollView:insert( background )
	scrollView:insert( button )

	function spawnQuestionWindow() 
		-- lock scrolling on our main window..
		scrollView:setIsLocked( true )

		local firstNumber = math.floor(math.random() * 20);
		local secondNumber = math.floor(math.random() * 20);

		-- create a new group for our question panel
		local questionPanel = display.newGroup()
		
		-- create our background for the panel
		local questionBackground = display.newImageRect( "assets/panel.png", 700, 350)
		questionBackground.x = display.contentCenterX
		questionBackground.y = display.contentCenterY

		-- create our question 
		local questionTextOptions = {
			text = firstNumber..' + '..secondNumber..' =',
			x = display.contentCenterX,
			y = display.contentCenterY - 100,
			fontSize = 50, 
			align = "center",
			font =  native.systemFont
		}

		local questionText = display.newText( questionTextOptions)
		questionText:setTextColor( 0, 0, 0 )

		local answerInput = native.newTextField( display.contentCenterX, display.contentCenterY, 500, 50 )
		answerInput.inputType = "number"
		answerInput.align = "center"
		

		-- add question elements to the question panel group
		questionPanel:insert( questionBackground )
		questionPanel:insert( questionText )
		questionPanel:insert( answerInput )

		-- add our group to our scrollable game map
		scrollView:insert( questionPanel )
		transition.from( questionPanel, { time=1200, y=-300, alpha=0, transition=easing.inOutBack } )

		local function closeQuestionWindow()
			questionPanel:remove( answerInput )
			transition.to( questionPanel, { time=1200, y=-300, alpha=0, transition=easing.inOutBack } )
			
			local function removePanel() 
				scrollView:remove( questionPanel )
			end

			timer.performWithDelay( 1200, removePanel )

			scrollView:setIsLocked( false )
		end

		questionPanel:addEventListener( "touch", closeQuestionWindow )

	end 

	button:addEventListener( "touch", spawnQuestionWindow )

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene