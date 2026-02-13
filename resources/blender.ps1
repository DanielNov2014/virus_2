# GDI1.PS1 - The "Blender" Effect
# Fixed: Corrected C# comments to prevent compilation errors.

$code = @"
using System;
using System.Runtime.InteropServices;

public class GDI {
    [DllImport("user32.dll")] public static extern IntPtr GetDC(IntPtr hwnd);
    [DllImport("user32.dll")] public static extern int ReleaseDC(IntPtr hwnd, IntPtr hdc);
    [DllImport("gdi32.dll")] public static extern bool BitBlt(IntPtr hdcDest, int nXDest, int nYDest, int nWidth, int nHeight, IntPtr hdcSrc, int nXSrc, int nYSrc, uint dwRop);
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern int GetSystemMetrics(int nIndex);

    public const int SM_CXVIRTUALSCREEN = 78;
    public const int SM_CYVIRTUALSCREEN = 79;
    public const uint SRCCOPY = 0x00CC0020;
    public const uint SRCPAINT = 0x00EE0086; // Adds colors (Brightens)
    public const uint SRCAND = 0x008800C6;   // Multiplies colors (Darkens)
}
"@

# 1. Load GDI (We use -PassThru to ensure it loaded correctly, though not strictly required)
Add-Type -TypeDefinition $code -ErrorAction Stop

# 2. Set DPI Aware
[GDI]::SetProcessDPIAware()

$hdc = [GDI]::GetDC([IntPtr]::Zero)
$w = [GDI]::GetSystemMetrics(78) # Virtual Width
$h = [GDI]::GetSystemMetrics(79) # Virtual Height
$rand = New-Object Random

Write-Host "BLENDER EFFECT ACTIVE... Press Ctrl+C to stop." -ForegroundColor Magenta

try {
    while($true) {
        # Generate tiny offsets (-3 to +3 pixels)
        $dx = $rand.Next(-3, 4)
        $dy = $rand.Next(-3, 4)

        # 50% chance to just Smear (Move pixels)
        # 50% chance to Blend (Combine colors)
        if ($rand.Next(0, 2) -eq 0) {
            # THE SMEAR: Copies the screen slightly offset onto itself
            [void][GDI]::BitBlt($hdc, $dx, $dy, $w, $h, $hdc, 0, 0, 0x00CC0020) # SRCCOPY
        }
        else {
            # THE BLEND: Mathematically mixes the colors
            $op = if ($rand.Next(0, 2) -eq 0) { 0x00EE0086 } else { 0x008800C6 }
            [void][GDI]::BitBlt($hdc, $dx, $dy, $w, $h, $hdc, 0, 0, $op)
        }
        
        # Optional: Add a tiny sleep if it consumes too much CPU
        # Start-Sleep -Milliseconds 5
    }
}
finally {
    [GDI]::ReleaseDC([IntPtr]::Zero, $hdc)
    Write-Host "Effect Stopped."
}