// AZRESOURCELAUNCHER v1.0 //

// system session
using System;
using System.Diagnostics;

// Storing
string? readResult;
string menuSelection = "";

/*
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
string readResult = Console.ReadLine();
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.
*/

do
{
    Console.Clear();

    Console.WriteLine("Welcome to the AZREZ app. Here's the main menu:");
    Console.WriteLine();
    Console.WriteLine(" 1. If your Azure account and subscription are not already set in your console, perform initial setup (Windows)");
    Console.WriteLine(" 2. Create a basic Azure VM");
    Console.WriteLine(" 3. Create a basic AKS cluster");
    Console.WriteLine(" 4. See AKS scenarios");
    Console.WriteLine(" 5. See Azure Arc scenarios");
    Console.WriteLine();
    Console.WriteLine("Enter your selection number (or type Exit to exit the program)");

    readResult = Console.ReadLine();
    if (readResult != null)
    {
        // This is so that we only work with lowercase inputs
        // This makes the selection easier to match the control flow
        menuSelection = readResult.ToLower();
    }

    switch (menuSelection){

        case "1": // 

            {
            Console.WriteLine("Then let's do the initial setup.");
            // if yes, run azsetup.ps1
            using Process winazsetup = new();
            winazsetup.StartInfo.FileName = "powershell";
            winazsetup.StartInfo.Arguments = "Start-Process -FilePath .\\pwshjobs\\azsetup.ps1";
            winazsetup.StartInfo.UseShellExecute = true;
            // winazsetup.StartInfo.RedirectStandardOutput = true;
            winazsetup.Start();
            // Console.WriteLine(winazsetup.StandardOutput.ReadToEnd());
            winazsetup.WaitForExit();
            }

        break;

        case "2":

            Console.WriteLine("Choose from: Ubuntu2204 Windows11 WindowsServer2022");
            #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string basicVM = Console.ReadLine();
            #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.
            
            switch (basicVM)
            {
                case "ubuntu":
                case "ubuntu2204":
                case "Ubuntu2204":
                {
                    // Run azvm-ubuntu2204ssh.ps1
                    using Process winazvmubuntu2204ssh = new();
                    winazvmubuntu2204ssh.StartInfo.FileName = "powershell";
                    winazvmubuntu2204ssh.StartInfo.Arguments = ".\\pwshjobs\\azvm-ubuntu2204ssh.ps1";
                    winazvmubuntu2204ssh.StartInfo.UseShellExecute = true;
                    // winazvmubuntu2204ssh.StartInfo.RedirectStandardOutput = true;
                    winazvmubuntu2204ssh.Start();
                    // Console.WriteLine(azvmubuntu2204ssh.StandardOutput.ReadToEnd());
                    winazvmubuntu2204ssh.WaitForExit();
                }
                break;

                case "Windows11":
                case "windows11":
                case "windows":
                {
                    // Run azvm-windows11.ps1
                    using Process winazvmwindows11 = new();
                    winazvmwindows11.StartInfo.FileName = "powershell";
                    winazvmwindows11.StartInfo.Arguments = ".\\pwshjobs\\azsvm-windows11.ps1";
                    winazvmwindows11.StartInfo.UseShellExecute = true;
                    // winazvmwindows11.StartInfo.RedirectStandardOutput = true;
                    winazvmwindows11.Start();
                    // Console.WriteLine(winazvmwindows11.StandardOutput.ReadToEnd());
                    winazvmwindows11.WaitForExit();
                }
                    break;

                case "WindowsServer2022":
                case "WindowsServer":
                case "windowsserver":
                {
                    using Process winazvmwindowsserver2022 = new();
                    winazvmwindowsserver2022.StartInfo.FileName = "powershell";
                    winazvmwindowsserver2022.StartInfo.Arguments = ".\\pwshjobs\\azvm-windowsserver2022.ps1";
                    winazvmwindowsserver2022.StartInfo.UseShellExecute = true;
                    // winazvmwindowsserver2022.StartInfo.RedirectStandardOutput = true;
                    winazvmwindowsserver2022.Start();
                    // Console.WriteLine(winazvmwindowsserver2022.StandardOutput.ReadToEnd());
                    winazvmwindowsserver2022.WaitForExit();
                }
                    break;

                default:
                    Console.WriteLine("Invalid entry. Try again");
                    break;
            }

        break;

        case "3":
        break;

        case "4":
        break;

        case "5":
        Console.WriteLine("This section is under construction...");
        break;

        default:
        Console.WriteLine("Invalid entry. Try again");
        break;

    }

} while (menuSelection != "exit");