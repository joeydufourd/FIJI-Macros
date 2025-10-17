
file = File.openDialog("Choose an image file");
barLength = getNumber("Scalebar length (µm):", 10);
run("Bio-Formats Importer", "open=[" + file + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

// Get dimensions
getDimensions(width, height, channels, slices, frames);

// Enforce multi-channel
if (channels <= 1) {
    showMessage("Error", "This macro requires an image with more than 1 channel.");
    exit();
}

run("Split Channels");
nC = nImages;

// Process each channel: MIP if >1 slice
for (c = 1; c <= nC; c++) {
    selectImage(c);
    getDimensions(w, h, ch, sl, fr);
    
    if (sl > 1) {
        run("Z Project...", "projection=[Max Intensity]");
        rename("C" + c + "_MIP");
        close();
    } else {
        rename("C" + c + "_MIP");
    }
    
    channelName = getMetadata("Channel " + (c-1) + " Name");
    if (channelName == "") channelName = "C" + c;

            // Colorize channels
    if (c == 1) {
        run("Red");
    } else if (c == 2) {
        run("Green");
    } else if (c == 3) {
        run("Blue");
    } else if (c == 4) {
        run("Magenta");
    }
    //run("RGB Color");
    
    // Add text overlay at top center
    //Overlay.clear();
    //setFont("SansSerif", 24, "antialiased");
    //xPos = w/2 - (lengthOf(channelName) * 7); // rough centering
    //yPos = 20;
    //Overlay.drawString(channelName, xPos, yPos);
    //run("Flatten"); // burn overlay into image
    //rename("C" + c + "_MIP");
    
    }

args = "";
for (c = 1; c <= nC; c++) {
    args = args + "c" + c + "=C" + c + "_MIP ";
}
args = args + "create keep";   // always add 'create' at the end

run("Merge Channels...", args + " create keep");
run("Make Composite");
run("Flatten");
rename("Composite_MIP");

selectWindow("C1_MIP");
getVoxelSize(pixelWidth, pixelHeight, pixelDepth, unit);

// Fallback if no calibration
if (unit == "pixel" || pixelWidth == 1.0) {
    pixelWidth = getNumber("No scale in metadata. Enter pixel size (µm/pixel):", 0.1);
    unit = "µm";
}

//run("Set Scale...", "distance=1 known=" + pixelWidth + " pixel=1 unit=" + unit);
//run("Scale Bar...", "width=" + barLength + " height=4 font=24 color=White background=None location=[Lower Right] bold overlay");

// Stack all MIPs
run("Images to Stack", "name=Channel_MIPs use");
run("Make Montage...", "columns=" + floor((nC+1)/2) + " rows=2 scale=1 border=2");

// Add scalebar directly to the montage
run("RGB Color"); // ensure montage is RGB so colors are preserved
getVoxelSize(pixelWidth, pixelHeight, pixelDepth, unit);
if (unit == "pixel" || pixelWidth == 1.0) {
    pixelWidth = getNumber("No scale in metadata. Enter pixel size (µm/pixel):", 0.1);
    unit = "µm";
}
run("Set Scale...", "distance=1 known=" + pixelWidth + " pixel=1 unit=" + unit);
run("Scale Bar...", "width=" + barLength + " height=4 font=24 color=White background=None location=[Lower Right] bold");
run("Flatten");
rename("Final_Montage");

format = getString("Choose format to save montage (tif, png, jpg):", "tif");

outBase = File.getParent(file) + File.separator + File.getNameWithoutExtension(file) + "-MIP-montage";

if (format == "tif" || format == "tiff") {
    saveAs("Tiff", outBase + ".tif");
} else if (format == "png") {
    saveAs("PNG", outBase + ".png");
} else if (format == "jpg" || format == "jpeg") {
    saveAs("Jpeg", outBase + ".jpg");
} else {
    showMessage("Error", "Unknown format: " + format + "\nValid options: tif, png, jpg");
}

waitForUser("Finished!\nMontage saved to:\n" + outBase + "." + format + "\n\nPlease cite my GitHub.");
run("Close All");
