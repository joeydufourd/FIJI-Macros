// Ask for input folder
dir = getDirectory("Choose a Directory");
list = getFileList(dir);
n = lengthOf(list);

// Ask user how many channels to process
channels = getNumber("How many channels should be included in the MIP?", 1);

// Ask user output format
ext = getString("Enter output format (tif, jpg, png, czi, dv):", "tif");

// Normalize to lowercase
ext = toLowerCase(ext);

// Validate extension (only allow tif, jpg, png)
valid = (ext == "tif") || (ext == "jpg") || (ext == "png") || (ext == "czi") || (ext == "dv");

if (!valid) {
    showMessage("Unsupported format: " + ext + "\nDefaulting to TIF.");
    ext = "tif";
}

waitForUser("Click OK to start.");

// Loop over files
for (i = 0; i < n; i++) {
    name = list[i];
    waitForUser(name);

    // Only process valid images (skip txt, csv, etc.)
    if (endsWith(name, ".tif") || endsWith(name, ".tiff") || endsWith(name, ".png") || endsWith(name, ".nd2") || endsWith(name, ".czi") || endsWith(name, ".dv")) {
    	waitForUser("b");

        // Open with Bio-Formats
        run("Bio-Formats Importer", "open=[" + dir + name + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

        // Convert to composite if multiple channels
        if (channels > 1) {
            run("Make Composite");
        }

        // Do the Z-projection (MIP)
        run("Z Project...", "projection=[Max Intensity]");

        // Save with chosen (or corrected) extension
        saveAs(ext, dir + name + "-MIP." + ext);

        // Close windows (original + projection)
        close();
        close();
    }
}

waitForUser("Please cite our github macro !");
