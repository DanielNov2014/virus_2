# RUN AS ADMINISTRATOR
# Optimized for maximum speed and "Melt" intensity.

$code = @"
using System;
using System.Runtime.InteropServices;

public class GDI {
    [DllImport("user32.dll")] public static extern IntPtr GetDC(IntPtr hwnd);
    [DllImport("user32.dll")] public static extern int ReleaseDC(IntPtr hwnd, IntPtr hdc);
    [DllImport("gdi32.dll")] public static extern bool BitBlt(IntPtr hdcDest, int nXDest, int nYDest, int nWidth, int nHeight, IntPtr hdcSrc, int nXSrc, int nYSrc, uint dwRop);
    [DllImport("gdi32.dll")] public static extern bool StretchBlt(IntPtr hdcDest, int nXDest, int nYDest, int nWidth, int nHeight, IntPtr hdcSrc, int nXSrc, int nYSrc, int nWidthSrc, int nHeightSrc, uint dwRop);
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern int GetSystemMetrics(int nIndex);
}
"@

Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
[GDI]::SetProcessDPIAware()

$hdc = [GDI]::GetDC([IntPtr]::Zero)
$w = [GDI]::GetSystemMetrics(78) # Virtual Width
$h = [GDI]::GetSystemMetrics(79) # Virtual Height
$rand = New-Object Random

Write-Host "OVERDRIVE MODE: MELTING SCREEN..." -ForegroundColor Red
Write-Host "Press Ctrl+C to stop."

try {
    while($true) {
        # --- THE MELT EFFECT (High Speed) ---
        # We pick a random X coordinate and "drag" a column down by 20 pixels
        $x = $rand.Next(0, $w)
        $columnWidth = $rand.Next(50, 200)
        
        # This copies a column and pastes it slightly lower, creating the melt
        [void][GDI]::BitBlt($hdc, $x, 15, $columnWidth, $h, $hdc, $x, 0, 0x00CC0020) # SRCCOPY

        # --- THE B&W THRESHOLD FLICKER ---
        # Every few frames, we force a high-contrast bitwise operation
        if ($rand.Next(0, 5) -eq 1) {
            $rx = $rand.Next(0, $w)
            $ry = $rand.Next(0, $h)
            # Using SRCAND (0x008800C6) makes everything darker/higher contrast
            [void][GDI]::BitBlt($hdc, $rx, $ry, 400, 400, $hdc, $rx, $ry, 0x008800C6)
        }

        # --- THE DISTORTION ---
        # Occasionally stretch a part of the screen to make it look "glitchy"
        if ($rand.Next(0, 10) -eq 1) {
            [void][GDI]::StretchBlt($hdc, $rand.Next(0, 10), $rand.Next(0, 10), $w - 20, $h - 20, $hdc, 0, 0, $w, $h, 0x00CC0020)
        }

        # NO SLEEP = MAXIMUM SPEED
        # If it's TOO fast and crashes, add: Start-Sleep -Milliseconds 1
    }
}
finally {
    [GDI]::ReleaseDC([IntPtr]::Zero, $hdc)
    Write-Host "GDI Released. Use Win+Ctrl+Shift+B to reset screen." -ForegroundColor Green
}