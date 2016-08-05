local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("PLAYER_ENTERING_WORLD"); -- Fired when saved variables are loaded
frame:RegisterEvent("GUILDBANKFRAME_OPENED"); -- Fired when saved variables are loaded
frame:RegisterEvent("GUILDBANKFRAME_CLOSED"); -- Fired when saved variables are loaded
-- #########################################################################################
local function defaultFunc(L, key)
 return key;
end
MyLocalizationTable = setmetatable({}, {__index=defaultFunc});

local L = MyLocalizationTable;
if GetLocale() == "deDE" then
 L["taxreset"] = "Zu zahlende Steuern zurückgesetzt!";
 L["currentrate"] = "Steuerrate:";
 L["taxtopay"] = "Zu bezahlen bei";
 L["gold"] = " Gold";
 L["nothing"] = "NICHTS";
 L["newrate"] = "Neue Steuerrate:";
 L["ratefail"] = "Die Rate muss eine Zahl zwischen 0 und 100 sein!";
 else
 L["taxreset"] = "Still-to-be-paid taxes reset!";
 L["currentrate"] = "Taxrate:";
 L["taxtopay"] = "To be paid at";
 L["gold"] = " Gold";
 L["nothing"] = "NOTHING";
 L["newrate"] = "New taxrate:";
 L["ratefail"] = "The rate has to be a number between 0 and 100!!";
 
end
-- ##########################################################################################
local function eventHandler(self, event, ...)
     
	 
	if event == "PLAYER_ENTERING_WORLD" then
        if lastgold == nil then
  
		  lastgold = GetMoney()
        end
		 if taxrate == nil then
         
		  taxrate = 10
        end

    end


    if event == "GUILDBANKFRAME_OPENED" then	

	local newgold = GetMoney() 

	local dif = newgold - lastgold
         if dif > 0 then
			local taxresult = dif * (taxrate/100)
			
		
			local topay = ceil(taxresult)

			DepositGuildBankMoney(topay)
	
		

			
		 end

		


    end
	
	if event == "GUILDBANKFRAME_CLOSED" then	
		lastgold =  GetMoney()
	end
end


frame:SetScript("OnEvent", eventHandler);

SLASH_SETTAX1 = '/settax';
local function handler(msg, editbox)
 if msg == 'reset' then
  print( L["taxreset"]);
  lastgold = GetMoney()
 elseif msg == 'getrate' then
 print( L["currentrate"].." "  .. taxrate.."%");
  elseif msg == 'topay' then
 	local newgold = GetMoney() 

	
	local dif = newgold - lastgold

         if dif > 0 then
			local taxresult = dif * (taxrate/100)
			
			local topay = ceil(taxresult)
			print (L["taxtopay"] .. " " .. taxrate .. "%:  ".. topay/10000 .. " ".. L["gold"] )
	      else
		  print (L["taxtopay"] .. " " .. taxrate .. "%: ".. L["nothing"] )
			
		 end
 else

 local check = tonumber(msg)
             if type( check ) == "number" and check >= 0 and check <= 100 then
			taxrate = check
			 print(L["newrate"] .." ".. taxrate.."%");
	         else
	          print (L["ratefail"])
	         end

 
 
 end
end
SlashCmdList["SETTAX"] = handler; -- Also a valid assignment strategy