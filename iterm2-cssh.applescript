-- Launche multiple SSH session
-- using iTerm2

-- retrieve command line arguments
on run argv
	
	-- compute command line arguments
	log argv
	log (count argv)
	
	-- set the command variable
	set theCommand to ""
	
	-- set the servers variable
	set theServers to ""
	
	-- compute command line arguments
	repeat with arg in argv
		set theArgs to split(arg, "=")
		
		if (count theArgs) is equal to 2 then
			set theKey to item 1 of theArgs
			
			-- set theCommand
			if theKey is equal to "command" then
				set theCommand to item 2 of theArgs
			end if
			
			-- set theServers
			if theKey is equal to "servers" then
				set serverList to split(item 2 of theArgs, ",")
			end if
		end if
	end repeat
	
	-- set the number of servers
	set numServers to count serverList
	
	-- Number of horizontal splits
	set numHorizontal to (round (numServers / 2)) + 1
	
	-- created panel
	set createdPanel to 1
	
	-- open iTerm
	tell application "iTerm"
		activate
		set myterm to (make new terminal)
		tell myterm
			launch session "distantssh"
			
			-- create the horizontal panels
			repeat with theIncrementValue from 1 to numHorizontal
				if theIncrementValue is not equal to numHorizontal then
					tell i term application "System Events" to keystroke "d" using command down
					set createdPanel to createdPanel + 1
				end if
			end repeat
			
			-- go back to the first pannel
			-- and split it vertically
			repeat with theIncrementValue from 1 to createdPanel
				tell i term application "System Events" to keystroke "]" using {command down}
				tell i term application "System Events" to keystroke "d" using {command down, shift down}
				set createdPanel to createdPanel + 1
			end repeat
			
			repeat with theIncrementValue from 1 to createdPanel
				if theIncrementValue is less than or equal to (count serverList) then
					set theChoice to item theIncrementValue of serverList
					tell item theIncrementValue of sessions to write text "echo 'SESSION '" & theChoice
				else
					tell i term application "System Events" to keystroke "w" using {command down}
				end if
			end repeat
			
			-- open ssh sessions
			repeat with theIncrementValue from 1 to (count serverList)
				set theChoice to item theIncrementValue of serverList
				tell item theIncrementValue of sessions to write text "ssh " & theChoice
			end repeat
			
			
			
			-- send command to all 
			-- open panes
			if (theCommand is not equal to "") then
				-- wait for 4 seconds 
				-- for connections to be open and ready
				delay 4
				--
				tell i term application "System Events" to keystroke "I" using {command down, shift down}
				tell i term application "System Events" to keystroke return
				
				-- launch htop
				tell the last session
					write text "htop"
				end tell
				
			end if
			
			
		end tell
		
	end tell
	
end run

-- split function

to split(someText, delimiter)
	set AppleScript's text item delimiters to delimiter
	set someText to someText's text items
	set AppleScript's text item delimiters to {""} --> restore delimiters to default value
	return someText
end split