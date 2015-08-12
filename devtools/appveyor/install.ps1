# Sample script to install Miniconda under Windows
# Authors: Olivier Grisel, Jonathan Helmus and Kyle Kastner, Robert McGibbon
# License: CC0 1.0 Universal: http://creativecommons.org/publicdomain/zero/1.0/

$MINICONDA_URL = "http://repo.continuum.io/miniconda/"


function DownloadMiniconda ($python_version, $platform_suffix) {
    $webclient = New-Object System.Net.WebClient
    if ($python_version -match "3.4") {
        $filename = "Miniconda3-latest-Windows-" + $platform_suffix + ".exe"
    } else {
        $filename = "Miniconda-latest-Windows-" + $platform_suffix + ".exe"
    }
    $url = $MINICONDA_URL + $filename

    $basedir = $pwd.Path + "\"
    $filepath = $basedir + $filename
    if (Test-Path $filename) {
        Write-Host "Reusing" $filepath
        return $filepath
    }

    # Download and retry up to 3 times in case of network transient errors.
    Write-Host "Downloading" $filename "from" $url
    $retry_attempts = 2
    for($i=0; $i -lt $retry_attempts; $i++){
        try {
            $webclient.DownloadFile($url, $filepath)
            break
        }
        Catch [Exception]{
            Start-Sleep 1
        }
   }
   if (Test-Path $filepath) {
       Write-Host "File saved at" $filepath
   } else {
       # Retry once to get the error message if any at the last try
       $webclient.DownloadFile($url, $filepath)
   }
   return $filepath
}


function InstallMiniconda ($python_version, $architecture, $python_home) {
    Write-Host "Installing Python" $python_version "for" $architecture "bit architecture to" $python_home
    if (Test-Path $python_home) {
        Write-Host $python_home "already exists, skipping."
        return $false
    }
    if ($architecture -match "32") {
        $platform_suffix = "x86"
    } else {
        $platform_suffix = "x86_64"
    }

    $filepath = DownloadMiniconda $python_version $platform_suffix
    Write-Host "Installing" $filepath "to" $python_home
    $install_log = $python_home + ".log"
    $args = "/S /D=$python_home"
    Write-Host $filepath $args
    Start-Process -FilePath $filepath -ArgumentList $args -Wait -Passthru
    if (Test-Path $python_home) {
        Write-Host "Python $python_version ($architecture) installation complete"
    } else {
        Write-Host "Failed to install Python in $python_home"
        Get-Content -Path $install_log
        Exit 1
    }
}


function InstallCondaPackages ($python_home, $spec) {
    $conda_path = $python_home + "\Scripts\conda.exe"
    $args = "install --yes " + $spec
    Write-Host ("conda " + $args)
    Start-Process -FilePath "$conda_path" -ArgumentList $args -Wait -Passthru
}

function UpdateConda ($python_home) {
    $conda_path = $python_home + "\Scripts\conda.exe"
    Write-Host "Updating conda..."
    $args = "update --yes conda"
    Write-Host $conda_path $args
    Start-Process -FilePath "$conda_path" -ArgumentList $args -Wait -Passthru
}

function InstallMissingHeaders () {
    # Visual Studio 2008 is missing stdint.h, but you can just download one
    # from the web.
    # http://stackoverflow.com/questions/126279/c99-stdint-h-header-and-ms-visual-studio
    $webclient = New-Object System.Net.WebClient

    $include_dirs = @("C:\Program Files\Microsoft SDKs\Windows\v7.0\Include",
                      "C:\Program Files\Microsoft SDKs\Windows\v7.1\Include",
                      "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\include",
                      "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\include")

    Foreach ($include_dir in $include_dirs) {
    $urls = @(@("http://msinttypes.googlecode.com/svn/trunk/stdint.h", "stdint.h"),
             @("http://msinttypes.googlecode.com/svn/trunk/inttypes.h", "inttypes.h"))

    Foreach ($i in $urls) {
        $url = $i[0]
        $filename = $i[1]

        $filepath = "$include_dir\$filename"
        if (Test-Path $filepath) {
            Write-Host $filename "already exists in" $include_dir
            continue
        }

        Write-Host "Downloading remedial " $filename " from" $url "to" $filepath
        $retry_attempts = 2
        for($i=0; $i -lt $retry_attempts; $i++){
            try {
                $webclient.DownloadFile($url, $filepath)
                break
            }
            Catch [Exception]{
                Start-Sleep 1
            }
       }

       if (Test-Path $filepath) {
           Write-Host "File saved at" $filepath
       } else {
           # Retry once to get the error message if any at the last try
           $webclient.DownloadFile($url, $filepath)
       }
    }
    }
}

function main () {
    InstallMiniconda $env:PYTHON_VERSION $env:PYTHON_ARCH $env:PYTHON
    UpdateConda $env:PYTHON
    InstallCondaPackages $env:PYTHON "conda-build pip anaconda-client six jinja2"
    InstallMissingHeaders
}

main
