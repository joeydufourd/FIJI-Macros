# FIJI-Macros 🔬

A collection of custom **Fiji (ImageJ)** macros to automate common microscopy image workflows: merging / montage / format conversion / projection, etc.

---

## Overview

FIJI-Macros is a lightweight suite of ImageJ macros that simplify repetitive image processing tasks, especially for multi-channel microscopy data.  
Use cases include:

- Converting image formats (TIF / PNG / ND2 / CZI → JPG)  
- Generating maximum intensity projections in batch  
- Building per-channel montage images  
- And more to come…

Each macro is standalone and designed for easy modification and extension.

---

## Dependencies

Some macros require specific Fiji plugins to function correctly.  
Make sure these are available in your Fiji installation:

| Plugin | Purpose | Installation |
|--------|----------|---------------|
| **Bio-Formats Importer** | Opens `.dv`, `.lif`, `.czi`, `.nd2`, and other proprietary microscopy formats | Usually preinstalled in Fiji. If missing, enable **Bio-Formats** under *Help → Update → Manage update sites*. |
| **MultiStackReg** | Performs channel and stack alignment (used in alignment macros) | If missing, add the update site: **MultiStackReg** under *Help → Update → Manage update sites*, then restart Fiji. |
| **TurboReg** | Backend for MultiStackReg (handles the actual transformations) | Installed automatically with Fiji, might need to enable **BIG-EPFL** under *Help → Update → Manage update sites*. |

To verify installation, check under **Plugins → Registration** that both *TurboReg* and *MultiStackReg* appear.


---

## Macros Included

Here’s a breakdown of the scripts currently in the repo:

| Macro file | Purpose | Key features / notes |
|------------|---------|------------------------|
| `TIF_PNG_GIF_ND2_CZI-to_JPG.ijm` | Format conversion | Takes a folder of various image formats and batch-converts to JPG. |
| `Batch-MaxIntensityProjection.ijm` | Batch projection | Automatically opens images, does maximum intensity projection, saves output.  |
| `Montage Builder per Channel  (X rows).ijm` | Montage builder | Splits channels, merges, makes montage per channel plus composite with chosen rows. |
| `Auto Align channels.ijm` | Channel alignment | Automatically imports multi-channel images, splits channels, lets the user choose which channels to align using **MultiStackReg**, aligns them via rigid-body registration, merges all channels back into a single composite, and saves the aligned image in the chosen format. |

You can open each macro in Fiji’s macro editor to view or modify the logic (e.g. LUT assignment, scale bar, saving options).

---

## Installation / Setup

1. Clone or download this repository.  
2. In Fiji, go to **Plugins → Macros → Install…**, then select one of the `.ijm` files.  
3. The macro will appear in the **Plugins / Macros** menu.  
4. Adjust parameters (e.g. scale bar length) when prompted by the macro dialogs.

Tip: keep backups of raw images. Test on a small sample first.

---

## Usage Examples

### Format conversion

Open `TIF_PNG_GIF_ND2_CZI-to-JPG.ijm` via **Plugins → Macros → Run…**  
The macro will convert all supported formats to JPG.

### Montage & Projection

Run `Montage Builder per Channel (1 row).ijm`.  
You will be asked to choose an image, then set scalebar size. The macro splits channels, applies color, merges, stacks, and builds a montage (including composite).  
After finishing, it prompts for save format (tif/png/jpg).

![Montage Builder per Channel example](./assets/example1.jpg)

---

## Contributing

- Feel free to open issues for bug reports or feature requests.  
- For new macros or enhancements, fork the repo, make your changes, and submit a pull request.  
- Please include sample images / test data when possible.

---

## License

This project is licensed under the **MIT License** — see [LICENSE](./LICENSE) for details.

---

## Acknowledgements / Citation

If you use these macros in a publication or pipeline, please cite this GitHub repository.  
Optionally: include author name, year, and link (e.g. _“We used the Fiji-Macros toolkit by Joey Dufourd (2025) 'link to the repository'”_).

---

