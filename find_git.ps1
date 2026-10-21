$paths = @(
    "C:\Program Files\Git\cmd\git.exe",
    "C:\Program Files\Git\bin\git.exe",
    "C:\Program Files (x86)\Git\cmd\git.exe",
    "C:\Users\Administrator\AppData\Local\Programs\Git\cmd\git.exe",
    "C:\Users\Administrator\AppData\Local\GitHubDesktop\bin\github.bat"
)
foreach ($p in $paths) {
    if (Test-Path $p) {
        Write-Output ("Found: " + $p)
    }
}

$dirs = @("C:\Program Files", "C:\Program Files (x86)", "C:\Users\Administrator\AppData\Local\Programs")
foreach ($d in $dirs) {
    if (Test-Path $d) {
        $found = Get-ChildItem -Path $d -Filter "git.exe" -Recurse -Depth 3 -ErrorAction SilentlyContinue
        foreach ($f in $found) {
            Write-Output ("Found via search: " + $f.FullName)
        }
    }
}
