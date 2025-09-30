file1 = getDirectory("Choose a Directory");
list1 = getFileList(file1);
n1 = lengthOf(list1);

waitForUser("Click ok.");

for (i = 0; i < n1; i++) {
    name = list1[i];
    
    // Only process if file has a valid image extension
    if (endsWith(name, ".tif") || endsWith(name, ".tiff") ||
    endsWith(name, ".png") || endsWith(name, ".gif") ||
    endsWith(name, ".nd2") || endsWith(name, ".czi")) {
        
        run("Bio-Formats Importer", "open=[" + file1 + name + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        saveAs("JPG", file1 + name + "-jpg");
        close();
    }
}
	  waitForUser("Please cite our github macro !");