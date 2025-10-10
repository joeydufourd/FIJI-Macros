file = File.openDialog("Choose an image file");

run("Bio-Formats Importer", "open=[" + file + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

run("Split Channels");

nC = nImages;
print("Detected " + nC + " channels.");

titleArray = newArray(nC);
for (c = 1; c <= nC; c++) {
    selectImage(c);
    titleArray[c-1] = getTitle();
}

ch1 = getNumber("Enter first channel to align:", 1);
ch2 = getNumber("Enter second channel to align:", 2);

if (ch1 > nC || ch2 > nC) {
    showMessage("Error", "Invalid channel numbers. There are only " + nC + " channels.");
    exit();
}

stack1 = titleArray[ch1 - 1];
stack2 = titleArray[ch2 - 1];

if (nC >= 2) {
    print("Running MultiStackReg between " + stack1 + " and " + stack2);
    run("MultiStackReg",
        "stack_1=" + stack1 + " action_1=Align file_1=[] " +
        "stack_2=" + stack2 + " action_2=[Align to First Stack] file_2=[] transformation=[Rigid Body]");
} else {
    print("Not enough channels for MultiStackReg");
}

mergeArgs = "";
for (c = 0; c < nC; c++) {
    mergeArgs = mergeArgs + "c" + (c+1) + "=" + titleArray[c] + " ";
}
mergeArgs = mergeArgs + "create";
print("Merging with args: " + mergeArgs);
run("Merge Channels...", mergeArgs);

format = getString("Choose format to save montage (tif, png, jpg):", "tif");
outBase = File.getParent(file) + File.separator + File.getNameWithoutExtension(file) + "-Aligned";

if (format == "tif" || format == "tiff")
    saveAs("Tiff", outBase + ".tif");
else if (format == "png")
    saveAs("PNG", outBase + ".png");
else if (format == "jpg" || format == "jpeg")
    saveAs("Jpeg", outBase + ".jpg");
else
    showMessage("Error", "Unknown format: " + format + "\nValid options: tif, png, jpg");

waitForUser("Finished!\nMontage saved to:\n" + outBase + "." + format + "\n\nPlease cite my GitHub.");
run("Close All");
