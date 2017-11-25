
function payFirearmsLicense()
		GUNserver.payFirearmsLicense()
		TestDone = true
	end

function vRPgun.startTheory()
	openGui()
	Menu.hidden = not Menu.hidden
end

function vRPgun.setLicense(license)
	TestDone = license
end