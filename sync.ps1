# Creates junctions in Dota Addon folders back to the relevant folders in this directory

$ErrorActionPreference = "Stop"

function New-Junction {
    param (
        $Source,
        $Dest
    )

    Write-Host "Creating junction from '$Source' to '$Dest'"

    if (-Not (Test-Path $Source -PathType Container)) {
        throw [System.IO.DirectoryNotFoundException] "$Source not found or is not a directory."
    }

    $juncDir = Split-Path $Dest
    $juncName = Split-Path $Dest -Leaf
    Write-Host "Junction directory: $juncDir"
    Write-Host "Junction name: $juncName"

    if (-Not (Test-Path $juncDir -PathType Container)) {
        throw [System.IO.DirectoryNotFoundException] "$juncDir not found or is not a directory."
    }

    if (Test-Path $Dest) {
        throw [System.IO.DirectoryNotFoundException] "$Dest may already exist"
    }

    Push-Location $juncDir
    New-Item -ItemType Junction -Name $juncName -Value $Source
    Pop-Location
}

$projectName = "barebones"
$dotaDir = "E:\SteamLibrary\steamapps\common\dota 2 beta" # todo - fetch this from steam

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath
$projectDir = $scriptDir
Push-Location $projectDir

Write-Host "Deploying Addon: $projectName"
Write-Host "From: $projectDir"
Write-Host "To: $dotaDir"

$gameDirRel = Join-Path "game\dota_addons" $projectName
$contentDirRel = Join-Path "content\dota_addons" $projectName

$gameDirSource = Join-Path $projectDir $gameDirRel
$contentDirSource = Join-Path $projectDir $contentDirRel

$gameDirDest = Join-Path $dotaDir $gameDirRel
$contentDirDest = Join-Path $dotaDir $contentDirRel

New-Junction -Source $gameDirSource -Dest $gameDirDest
New-Junction -Source $contentDirSource -Dest $contentDirDest

Pop-Location