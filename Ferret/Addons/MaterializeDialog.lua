MaterializeDialog = Addon:extend()

function MaterializeDialog:new(ferret)
    MaterializeDialog.super.new(self, "MaterializeDialog", ferret)
end

function MaterializeDialog:yes() yield('/callback MaterializeDialog true 0') end

function MaterializeDialog:no() yield('/callback MaterializeDialog true 1') end
