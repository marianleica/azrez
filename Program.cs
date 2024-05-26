// AZRESOURCELAUNCHER v1.1 //

// system session
using System;
using System.Diagnostics;

// Variables for storing data
string? readResult;
string menuSelection = "";
string os = Environment.OSVersion.ToString(); // Get OS informaiton

do
{
    Console.Clear();

    // Show the current OS version
    // For MacOS it shows "Unix"
    Console.WriteLine($"OS identified: "+ os);

    Console.WriteLine("Welcome to the AZREZ app! Here's the main menu:");
    Console.WriteLine();
    Console.WriteLine(" 1. Perform initial setup, if your Azure account and subscription are not already set in your console");
    Console.WriteLine(" 2. Create a basic Azure VM");
    Console.WriteLine(" 3. Create a basic AKS cluster");
    Console.WriteLine(" 4. See AKS scenarios");
    Console.WriteLine(" 5. See Azure Arc scenarios");
    Console.WriteLine(" 6. Clean the azrez resource group");
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

        case "1": {

            Thread.Sleep(5000);

            if (os.Contains("Windows")){

                Console.WriteLine("Performing initial setup for Windows OS.");
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
            else if (os.Contains("Unix")){

                Console.WriteLine("Performing initial setup for Unix OS.");
                // if yes, run azsetup.sh
                using Process unixsetup = new();
                unixsetup.StartInfo.FileName = "sh";
                unixsetup.StartInfo.Arguments = "./azjobs/azsetup-macos.sh";
                unixsetup.StartInfo.UseShellExecute = true;
                // unixsetup.StartInfo.RedirectStandardOutput = true;
                unixsetup.Start();
                // Console.WriteLine(unixsetup.StandardOutput.ReadToEnd());
                unixsetup.WaitForExit();

            }
            else {

                Console.WriteLine("Performing initial setup for Linux OS.");
                // if yes, run azsetup.sh
                using Process unixsetup = new();
                unixsetup.StartInfo.FileName = "sh";
                unixsetup.StartInfo.Arguments = "./azjobs/azsetup-linux.sh";
                unixsetup.StartInfo.UseShellExecute = true;
                // unixsetup.StartInfo.RedirectStandardOutput = true;
                unixsetup.Start();
                // Console.WriteLine(unixsetup.StandardOutput.ReadToEnd());
                unixsetup.WaitForExit();

            }
        }
        Thread.Sleep(1000);
        break;

        case "2":

            Console.WriteLine("Enter your selection number: ");
            Console.WriteLine(" 1. Ubuntu2204");
            Console.WriteLine(" 2. Windows11");
            Console.WriteLine(" 3. WindowsServer2022");
            #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string basicVM = Console.ReadLine();
            #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

            if (os.Contains("Windows")){

                switch (basicVM)
                {
                    case "1":
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

                    case "2": {
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

                    case "3": {
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

                    default: Console.WriteLine("Invalid entry. Try again"); break;
                }
            }
            else {
                switch (basicVM)
                {
                    case "1":
                    {
                        // Run azvm-ubuntu2204ssh.sh
                        using Process unixazvmubuntu2204ssh = new();
                        unixazvmubuntu2204ssh.StartInfo.FileName = "sh";
                        unixazvmubuntu2204ssh.StartInfo.Arguments = "./azjobs/azvm-ubuntu2204ssh.sh";
                        unixazvmubuntu2204ssh.StartInfo.UseShellExecute = true;
                        // unixazvmubuntu2204ssh.StartInfo.RedirectStandardOutput = true;
                        unixazvmubuntu2204ssh.Start();
                        // Console.WriteLine(azvmubuntu2204ssh.StandardOutput.ReadToEnd());
                        unixazvmubuntu2204ssh.WaitForExit();
                    }
                    break;

                    case "2":
                    {
                        // Run azvm-windows11.sh
                        using Process unixazvmwindows11 = new();
                        unixazvmwindows11.StartInfo.FileName = "sh";
                        unixazvmwindows11.StartInfo.Arguments = "./azjobs/azsvm-windows11.sh";
                        unixazvmwindows11.StartInfo.UseShellExecute = true;
                        // unixazvmwindows11.StartInfo.RedirectStandardOutput = true;
                        unixazvmwindows11.Start();
                        // Console.WriteLine(winazvmwindows11.StandardOutput.ReadToEnd());
                        unixazvmwindows11.WaitForExit();
                    }
                    break;

                    case "3":
                    {
                        using Process unixazvmwindowsserver2022 = new();
                        unixazvmwindowsserver2022.StartInfo.FileName = "sh";
                        unixazvmwindowsserver2022.StartInfo.Arguments = "./azjobs/azvm-windowsserver2022.sh";
                        unixazvmwindowsserver2022.StartInfo.UseShellExecute = true;
                        // unixazvmwindowsserver2022.StartInfo.RedirectStandardOutput = true;
                        unixazvmwindowsserver2022.Start();
                        // Console.WriteLine(unixazvmwindowsserver2022.StandardOutput.ReadToEnd());
                        unixazvmwindowsserver2022.WaitForExit();
                    }
                    break;

                    default:
                    Console.WriteLine("Invalid entry. Try again");
                    break;
                }
        }
        Thread.Sleep(2000);
        break;

        case "3": {

            Console.WriteLine("Choose the CNI option. Enter your selection number: ");
            Console.WriteLine(" 1. Kubenet (default)");
            Console.WriteLine(" 2. Azure CNI (advanced)");
            #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string basicAKS = Console.ReadLine();
            #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

            if (os.Contains("Windows")){

                switch (basicAKS)
                {
                    case "1": {
                        // Run azaks-public-kubenet-lb.ps1
                        using Process winazakspublickubenetlb = new();
                        winazakspublickubenetlb.StartInfo.FileName = "powershell";
                        winazakspublickubenetlb.StartInfo.Arguments = ".\\pwshjobs\\azaks-public-kubenet-lb.ps1";
                        winazakspublickubenetlb.StartInfo.UseShellExecute = true;
                        // winazakspublickubenetlb.StartInfo.RedirectStandardOutput = true;
                        winazakspublickubenetlb.Start();
                        // Console.WriteLine(winazakspublickubenetlb.StandardOutput.ReadToEnd());
                        winazakspublickubenetlb.WaitForExit();
                    } break;

                    case "2": {
                        // Run azaks-public-azurecni-lb.ps1
                        using Process winazakspublicazurecnilb = new();
                        winazakspublicazurecnilb.StartInfo.FileName = "powershell";
                        winazakspublicazurecnilb.StartInfo.Arguments = ".\\pwshjobs\\azaks-public-azurecni-lb.ps1";
                        winazakspublicazurecnilb.StartInfo.UseShellExecute = true;
                        // winazakspublicazurecnilb.StartInfo.RedirectStandardOutput = true;
                        winazakspublicazurecnilb.Start();
                        // Console.WriteLine(winazakspublicazurecnilb.StandardOutput.ReadToEnd());
                        winazakspublicazurecnilb.WaitForExit();
                    } break;

                    default: Console.WriteLine("Invalid entry. Try again"); break;
                }
            }
            else {

                switch (basicAKS)
                {
                    case "1": {
                        // Run azaks-public-kubenet-lb.sh
                        using Process unixazakspublickubenetlb = new();
                        unixazakspublickubenetlb.StartInfo.FileName = "sh";
                        unixazakspublickubenetlb.StartInfo.Arguments = "./azjobs/azaks-public-kubenet-lb.sh";
                        unixazakspublickubenetlb.StartInfo.UseShellExecute = true;
                        // unixazakspublickubenetlb.StartInfo.RedirectStandardOutput = true;
                        unixazakspublickubenetlb.Start();
                        // Console.WriteLine(unixazakspublickubenetlb.StandardOutput.ReadToEnd());
                        unixazakspublickubenetlb.WaitForExit();
                    }
                    break;

                    case "2": {
                        // Run azaks-public-azurecni-lb.sh
                        using Process unixazakspublicazurecnilb = new();
                        unixazakspublicazurecnilb.StartInfo.FileName = "sh";
                        unixazakspublicazurecnilb.StartInfo.Arguments = "./azjobs/azaks-public-azurecni-lb.sh";
                        unixazakspublicazurecnilb.StartInfo.UseShellExecute = true;
                        // unixazakspublicazurecnilb.StartInfo.RedirectStandardOutput = true;
                        unixazakspublicazurecnilb.Start();
                        // Console.WriteLine(unixazakspublicazurecnilb.StandardOutput.ReadToEnd());
                        unixazakspublicazurecnilb.WaitForExit();
                    }
                    break;

                    default: Console.WriteLine("Invalid entry. Try again"); break;
                }
            }
        }
        Thread.Sleep(1000);
        break;
        
        case "4": {
            Console.WriteLine("This section is under construction...");
            Thread.Sleep(1000);
        }
        break;

        case "5": {
            Console.WriteLine("This section is under construction...");
            Thread.Sleep(1000);
        }
        break;

        case "6": {
            Console.WriteLine("This section is under construction...");
            Thread.Sleep(1000);
        }
        break;

        default: {
        Console.WriteLine("Bye :)");
        }
        break;
    }

} while (menuSelection != "exit");