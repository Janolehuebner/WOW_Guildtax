local addonName, addonTable = ...
-- ###########################################  ui #########################


UILocalizationTable = setmetatable({}, {__index=defaultFunc});

 UIL = UILocalizationTable;
if GetLocale() == "deDE" then
 UIL["cancel"] = "Abbrechen";
 UIL["reset"] = "Steuern zurücksetzen";
 UIL["apply"] = "Übernehmen";
 UIL["curentTX"] = "Aktuelle Steuerrate:";
 UIL["topay"] = "Zu bezahlen: ";
 UIL["ratefail"] = "Die Rate muss eine Zahl zwischen 0 und 100 sein!";
 else
 
 UIL["cancel"] = "Cancel";
 UIL["reset"] = "Reset taxes";
 UIL["apply"] = "Apply";
 UIL["curentTX"] = "Current taxrate: ";
 UIL["topay"] = "To pay: ";
 UIL["ratefail"] = "The rate has to be a number between 0 and 100!!";
end


function janolehuebner_GuildTax_topay()
local newgold = GetMoney() ;

	
	local dif = newgold - lastgold;

         if dif > 0 then
			local taxresult = dif * (taxrate/100);
			
			local topay = ceil(taxresult);
			return topay/10000;
	      else
		  return 0;
			
		 end


end



function janolehuebner_GuildTax_updateUI(event)
if event == "OPEN" then
Guiltax_MainWindow:Show();
end

	Guiltax_taxEDI:SetText(format("%d",taxrate));
	Guiltax_MainWindow.label:SetText(UIL["topay"]..janolehuebner_GuildTax_topay().." Gold");
	Guiltax_MainWindow.label2:SetText("Total:"..totalgold/10000 .." Gold");
if event == "TEXTBOX" then
	print(UIL["curentTX"]..taxrate.."%");
end	
end

local function reset_OnClick()
lastgold = GetMoney();
janolehuebner_GuildTax_updateUI("RESET");
end



local mainwindow = CreateFrame("FRAME","Guiltax_MainWindow",UIParent,"BasicFrameTemplateWithInset");
-- -------make dragable---
mainwindow:SetMovable(true)
mainwindow:EnableMouse(true)
mainwindow:RegisterForDrag("LeftButton")
mainwindow:SetScript("OnDragStart", mainwindow.StartMoving)
mainwindow:SetScript("OnDragStop", mainwindow.StopMovingOrSizing)
-- -----------------------
mainwindow.title=mainwindow:CreateFontString(nil, "OVERLAY");
mainwindow.title:SetFontObject("GameFontHighlight");
mainwindow.title:SetPoint("LEFT",mainwindow.TitleBg,"LEFT",5,0);
mainwindow.title:SetText("GUILDTAX");


mainwindow:RegisterEvent("PLAYER_MONEY");
mainwindow:SetSize(210,125);
mainwindow:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",0,500);
mainwindow:SetScript("OnEvent", function(self,event,...)
janolehuebner_GuildTax_updateUI(event);
end);

local reset = CreateFrame("Button","Guiltax_resetBTN",mainwindow,"GameMenuButtonTemplate"); --frameType, frameName, frameParent, frameTemplate  
reset:SetSize(150,20);  
reset:SetPoint("Center",mainwindow,"BOTTOM",0,25);
reset:SetText(UIL["reset"]);
reset:SetScript("OnClick", function(self)
reset_OnClick();
end);



local tax = CreateFrame("EditBox","Guiltax_taxEDI",mainwindow,"InputBoxTemplate"); --frameType, frameName, frameParent, frameTemplate    
tax:SetSize(25,20);
tax:SetPoint("LEFT",mainwindow,"LEFT",160,25);
tax:SetAutoFocus(false);


tax.label=tax:CreateFontString(nil, "OVERLAY");
tax.label:SetFontObject("GameFontHighlight");
tax.label:SetPoint("Left",tax,"Left",-150,0);
tax.label:SetText(UIL["curentTX"]);
tax.label:SetTextHeight(14);

tax.percent=tax:CreateFontString(nil, "OVERLAY");
tax.percent:SetFontObject("GameFontHighlight");
tax.percent:SetPoint("Left",tax,"Left",26,0);
tax.percent:SetText("%");
tax.percent:SetTextHeight(13);

tax:SetScript("OnEnterPressed", function(self)
local check=tax:GetNumber();
if type( check ) == "number" and check >= 0 and check <= 100 then
taxrate = check;
tax:ClearFocus();
janolehuebner_GuildTax_updateUI("TEXTBOX");

else
print(UIL["ratefail"]);

end


end);

mainwindow.label=mainwindow:CreateFontString(nil, "OVERLAY");
mainwindow.label:SetFontObject("GameFontHighlight");
mainwindow.label:SetPoint("LEFT",mainwindow,"LEFT",10,5);
mainwindow.label:SetTextHeight(13);

mainwindow.label2=mainwindow:CreateFontString(nil, "OVERLAY");
mainwindow.label2:SetFontObject("GameFontHighlight");
mainwindow.label2:SetPoint("LEFT",mainwindow,"LEFT",10,-15);
mainwindow.label2:SetTextHeight(13);


-- ###################################################################################





