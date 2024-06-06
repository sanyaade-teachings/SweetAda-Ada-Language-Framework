
#
# Remove a set of (virtual) symbolic/soft links.
#
# Copyright (C) 2020-2024 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 .. n = destination filename list
# $n+1    = mandatory "-o" switch to separate destinations and targets
# $n+2 .. = target filename list
#
# The two lists must have the same length.
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

$scriptname = $MyInvocation.MyCommand.Name

################################################################################
# ExitWithCode()                                                               #
#                                                                              #
################################################################################
function ExitWithCode
{
  param($exitcode)
  $host.SetShouldExit($exitcode)
  exit $exitcode
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# parse command line arguments
$argsindex = 0
$destinationindex = 0
$targetindex = 0
$ndestination = 0
$ntarget = 0
while ($argsindex -lt $args.length)
{
  if ($args[$argsindex] -eq "-o")
  {
    $targetindex = $argsindex + 1
  }
  else
  {
    if ($targetindex -gt 0)
    {
      $ntarget++
    }
    else
    {
      $ndestination++
    }
  }
  $argsindex++
}
if ($ndestination -ne $ntarget)
{
  Write-Host "$($scriptname): *** Error: wrong filelist specification."
  ExitWithCode 1
}

while ($ntarget -gt 0)
{
  $remove = $false
  $destination = $args[$destinationindex]
  $target = $args[$targetindex]
  if (Test-Path $destination)
  {
    $destination_mtime = (Get-Item $destination).LastWriteTime
    $target_mtime = (Get-Item $target).LastWriteTime
    if ($destination_mtime -gt $target_mtime)
    {
      Write-Host "file [installed/symlinked] `"$($destination)`" has timestamp more recent than file [origin] `"$($target)`""
      while ($true)
      {
        $answer = Read-Host "[u]pdate or [r]emove: "
        if ($answer -eq "u")
        {
          Move-Item -Path $destination -Destination $target -Force
          break
        }
        elseif ($answer -eq "r")
        {
          $remove = $true
          break
        }
      }
    }
    else
    {
      $remove = $true
    }
    if ($remove)
    {
      Remove-Item -Path $destination -Force -ErrorAction Ignore
    }
  }
  $destinationindex++
  $targetindex++
  $ntarget--
}

ExitWithCode 0

