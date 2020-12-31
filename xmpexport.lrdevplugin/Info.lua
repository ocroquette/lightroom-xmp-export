--[[----------------------------------------------------------------------------

See XmpExport.lua for more information
------------------------------------------------------------------------------]]

return {
	
	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 1.3, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'fr.free.ocroquette.xmpexport',

	LrPluginName = LOC "$$$/XmpExport/PluginName=XMP Export",
	
	-- Add the menu item to the File menu.
	
	LrExportMenuItems = {
		title = "XMP Export",
		file = "XmpExport.lua",
	},

	-- Add the menu item to the Library menu.
	
	LrLibraryMenuItems = {
	    {
		    title = LOC "$$$/XmpExport/CustomDialog=Export XMP",
		    file = "ExportXmp.lua",
		},
	},
	VERSION = { major=1, minor=0, revision=0, build=1, },
}


	
