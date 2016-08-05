

-- ####################################core################################
local frame = CreateFrame("FRAME");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("GUILDBANKFRAME_OPENED"); 
frame:RegisterEvent("GUILDBANKFRAME_CLOSED");
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
 L["totalpaid"] = "Gesamt an Gilde gezahlt:";
 else
 L["taxreset"] = "Still-to-be-paid taxes reset!";
 L["currentrate"] = "Taxrate:";
 L["taxtopay"] = "To be paid at";
 L["gold"] = " Gold";
 L["nothing"] = "NOTHING";
 L["newrate"] = "New taxrate:";
 L["ratefail"] = "The rate has to be a number between 0 and 100!!";
 L["totalpaid"] = "Paid to guild in total: ";
end
-- ##########################################################################################

function janolehuebner_GuildTax_topay()
local newgold = GetMoney() 

	
	local dif = newgold - lastgold

         if dif > 0 then
			local taxresult = dif * (taxrate/100)
			
			local topay = ceil(taxresult)
			return topay/10000;
	      else
		  return 0;
			
		 end


end



local function eventHandler(self, event, ...)
     
	 
	if event == "PLAYER_ENTERING_WORLD" then
        if lastgold == nil then
		  lastgold = GetMoney()
        end
		if totalgold == nil then
		  totalgold = 0
        end
		 if taxrate == nil then
         
		  taxrate = 10
        end
		janolehuebner_GuildTax_updateUI("LOADED");

    end


    if event == "GUILDBANKFRAME_OPENED" then	

	local newgold = GetMoney() 

	local dif = newgold - lastgold
         if dif > 0 then
			local taxresult = dif * (taxrate/100)
			
		
			local topay = ceil(taxresult)

			DepositGuildBankMoney(topay)
	        totalgold = totalgold + topay
		

			
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
 elseif msg == 'total' then
 print( L["totalpaid"].." "  .. totalgold/10000 .. L["gold"]  );
  elseif msg == 'topay' then
 	local tp=janolehuebner_GuildTax_topay()
	if tp == 0 then
	print (L["taxtopay"] .. " " .. taxrate .. "%: ".. L["nothing"]);
	else
	print (L["taxtopay"] .. " " .. taxrate .. "%:  ".. tp/10000 .. " ".. L["gold"] )
	end
	
	 elseif msg == 'open' then
	janolehuebner_GuildTax_updateUI("OPEN");
	
 else

 local check = tonumber(msg)
             if type( check ) == "number" and check >= 0 and check <= 100 then
			taxrate = check
			 print(L["newrate"] .." ".. taxrate.."%");
	         else
	          print (L["ratefail"])
	         end

 
 
 end
 janolehuebner_GuildTax_updateUI("CONSOLE");
end
SlashCmdList["SETTAX"] = handler; 


