# lightroom-xmp-export

This Lightroom plugin will extend the XMP files written by Digikam with the data from the Lightroom database.

This is particularly useful to transfer metadata of video files, since Lightroom doesn't write XMP files for them.

The following metadata is supported:
- keywords
- city
- province/state
- location
- country (the country code needs to be set in Lightroom though to be imported correctly in Digikam)

# Author

Olivier Croquette ocroquette@free.fr

See also https://ocroquette.wordpress.com/migrating-from-lightroom-6-to-digikam-7/

# Versions used for development

- Lightroom 6.14
- Digikam 7.1

# Instructions

1. in Digikam, enable the creation of XMP files:
   Preferences / Metadata / Sidecards / Write to sidecar files
   Enable "Read from sidecar files"
   Enable "Write to sidecar files"
   "Write to XMP sidecar for read-only items only" should be sufficient
1. in Digikam, make sure that all metadata gets exported:
   Preferences / Metadata / Behavior
   Check all checkboxes in "Write This Information to the Metadata"
1. in Digikam, add the tag "PLACEHOLDER_TAG" you want to add keywords from Lightroom to
   The PLACEHOLDER_TAG must be at the root of the tags
1. in Digikam, select the relevant files, and trigger:
   Item / Write Metadata to Selected Files
   That will write XMP sidecar files, even for videos
1. in Lightroom install the plugin XmpExport plugin using the Plugin Manager
1. in Lightroom, select the relevant files, and select in the menu:
   File / Plug-in Extras / XMP Export
   This will update the XMP sidecar files with the keywords from Lightroom
   The progress can be seen by running the following command in the Terminal:
        tail -f ~/Documents/XmpExport.log
        (Press CTRL-C to stop)
1. In Digikam, trigger
   Item / Read Metadata from Selected Files
   That will read the XMP files back into Digikam, with the information from Lightroom.

# Optional clean up
* remove the "PLACEHOLDER_TAG" from the files in Digikam
* restore the original Digikam preferences (no sidecar files)
* delete the XMP files from the file system
