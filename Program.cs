// AZRESOURCELAUNCHER v1.1 //
// system session
using System;
using System.Diagnostics;

// Variables for the console title
string? applicationName = "azrez";
string? applicationVersion = "v1.05";
Console.Title=$"{applicationName} - {applicationVersion}";

// Variables for the app menu
string? readResult; // Non-nullable string variable
string menuSelection = "";
string os = Environment.OSVersion.ToString(); // Get OS information

do
{
    Console.Clear();
    Console.WriteLine("Welcome to the AZREZ app! Here's the main menu:");
    Console.WriteLine();
    Console.WriteLine(" 1. Perform initial setup (blank env)");
    Console.WriteLine(" 2. Create a basic Azure VM");
    Console.WriteLine(" 3. Create a basic AKS cluster");
    Console.WriteLine(" 4. See Azure Containers scenarios");
    Console.WriteLine(" 5. See Azure Arc scenarios");
    Console.WriteLine(" 6. Clean the azrez resource group");
    Console.WriteLine();

    // Show the current OS version
    // For MacOS it shows "Unix"
    Console.WriteLine($"Your OS: "+ os);
    Console.Write("Enter your selection number (or type Exit to exit the program): ");

    readResult = Console.ReadLine();
    if (readResult != null)
    {
        // This is so that we work only with lowercase inputs
        // This makes the selection easier to match the control flow
        menuSelection = readResult.ToLower();
    }

    // int option = Convert.ToInt32(menuSelection);

    switch (menuSelection){

        case "1": {

            Thread.Sleep(5000);
            Console.Clear();            

            if (os.Contains("Windows")){
                Console.WriteLine("Performing initial setup for Windows OS.");
                // if yes, run azsetup.ps1
                using Process winazsetup = new();
                winazsetup.StartInfo.FileName = "powershell";
                winazsetup.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\azsetup.ps1";
                winazsetup.StartInfo.UseShellExecute = true;
                // winazsetup.StartInfo.RedirectStandardOutput = true;
                winazsetup.Start();
                // Console.WriteLine(winazsetup.StandardOutput.ReadToEnd());
                winazsetup.WaitForExit();
            }
            else {
                Console.WriteLine("Only Windows OS clients are supported");
            }
        }
        Thread.Sleep(1000);
        break;

        case "2":

            Console.Clear();
            Console.WriteLine("The Azure VM OS options are the following:");
            Console.WriteLine(" 1. Ubuntu2204");
            Console.WriteLine(" 2. Windows11");
            Console.WriteLine(" 3. WindowsServer2022");
            Console.Write("Enter your selection number: ");
            string? basicVM = Console.ReadLine();

            if (os.Contains("Windows")){
                switch (basicVM)
                {
                    case "1":
                    {
                        // Run azvm-ubuntu2204ssh.ps1
                        using Process winazvmubuntu2204ssh = new();
                        winazvmubuntu2204ssh.StartInfo.FileName = "powershell";
                        winazvmubuntu2204ssh.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\azvm-ubuntu2204ssh.ps1";
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
                        winazvmwindows11.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\azvm-windows11.ps1";
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
                        winazvmwindowsserver2022.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\azvm-windowsserver2022.ps1";
                        winazvmwindowsserver2022.StartInfo.UseShellExecute = true;
                        // winazvmwindowsserver2022.StartInfo.RedirectStandardOutput = true;
                        winazvmwindowsserver2022.Start();
                        // Console.WriteLine(winazvmwindowsserver2022.StandardOutput.ReadToEnd());
                        winazvmwindowsserver2022.WaitForExit();
                    }
                    break;

                    default: Console.WriteLine("Invalid entry. Try again."); break;
                }
            }
            else {
                Console.WriteLine("Only Windows OS clients are supported");
            }
        Thread.Sleep(2000);
        break;

        case "3": {

            Console.Clear();
            Console.WriteLine("Choose the CNI option for the AKS cluster from: Enter your selection number: ");
            Console.WriteLine(" 1. Kubenet (default)");
            Console.WriteLine(" 2. Azure CNI (advanced)");
            Console.Write("Enter your selection number: ");
            string? basicAKS = Console.ReadLine();

            if (os.Contains("Windows")){

                switch (basicAKS)
                {
                    case "1": {
                        // Run azaks-public-kubenet-lb.ps1
                        using Process winazakspublickubenetlb = new();
                        winazakspublickubenetlb.StartInfo.FileName = "powershell";
                        winazakspublickubenetlb.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\azaks-public-kubenet-lb.ps1";
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
                        winazakspublicazurecnilb.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\azaks-public-azurecni-lb.ps1";
                        winazakspublicazurecnilb.StartInfo.UseShellExecute = true;
                        // winazakspublicazurecnilb.StartInfo.RedirectStandardOutput = true;
                        winazakspublicazurecnilb.Start();
                        // Console.WriteLine(winazakspublicazurecnilb.StandardOutput.ReadToEnd());
                        winazakspublicazurecnilb.WaitForExit();
                    } break;

                    default: Console.WriteLine("Invalid entry. Try again."); break;
                }
            }
            else {
                Console.WriteLine("Only Windows OS clients are supported");
            }
        }
        Thread.Sleep(1000);
        break;
        
        case "4": {

            Console.Clear();
            string[] scenACT = new string[4];
            scenACT[0]=" 1. aksKubenetUdrFw";
            scenACT[1]=" 2. aksKubenetUdrFw-private";
            scenACT[2]=" 3. aksAzureCniUdrFw";
            scenACT[3]=" 4. aksAzureCniUdrFw-private";

            string [] scenACTDescription = new string[4];
            scenACTDescription[0]="AKS cluster with kubenet CNI and userDefinedRouting outbound type via Azure Firewall";
            scenACTDescription[1]="Private AKS cluster with kubenet CNI and userDefinedRouting outbound type via Azure Firewall";
            scenACTDescription[2]="AKS cluster with azure CNI and userDefinedRouting outbound type via Azure Firewall";
            scenACTDescription[3]="Private AKS cluster with azure CNI and userDefinedRouting outbound type via Azure Firewall";

            Console.WriteLine("The available AKS scenarios are the following:");

            // Print the scenarios and their description in a 2-column format
            foreach (string scenario in scenACT){
                Thread.Sleep(100);
                switch (scenario){

                    case " 1. aksKubenetUdrFw":
                    Console.WriteLine($"{scenario}\t\t{scenACTDescription[0]}");
                    break;

                    case " 2. aksKubenetUdrFw-private":
                    Console.WriteLine($"{scenario}\t{scenACTDescription[1]}");
                    break;

                    case " 3. aksAzureCniUdrFw":
                    Console.WriteLine($"{scenario}\t\t{scenACTDescription[2]}");
                    break;

                    case " 4. aksAzureCniUdrFw-private":
                    Console.WriteLine($"{scenario}\t{scenACTDescription[3]}"); 
                    break;

                    default:
                    Console.WriteLine(""); break;

                }
            }

            Console.Write("Enter your selection number: ");
            string? scenarioACT = Console.ReadLine();

            switch (scenarioACT){

                case "1": {
                    if (os.Contains("Windows")){
                        // Run azaksKubenetUdrFw.ps1        
                        using Process azaksKubenetUdrFw = new();
                        azaksKubenetUdrFw.StartInfo.FileName = "powershell";
                        azaksKubenetUdrFw.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\azaksKubenetUdrFw.ps1";
                        azaksKubenetUdrFw.StartInfo.UseShellExecute = true;
                        // azaksKubenetUdrFw.StartInfo.RedirectStandardOutput = true;
                        azaksKubenetUdrFw.Start();
                        // Console.WriteLine(azaksKubenetUdrFw.StandardOutput.ReadToEnd());
                        azaksKubenetUdrFw.WaitForExit();
                    }
                    else {
                        Console.WriteLine("Only Windows OS clients are supported");
                    }
                }
                break;

                case "2": {

                    if (os.Contains("Windows")){
                        // Run azaksKubenetUdrFw-private.ps1        
                        using Process azaksKubenetUdrFwprivate = new();
                        azaksKubenetUdrFwprivate.StartInfo.FileName = "powershell";
                        azaksKubenetUdrFwprivate.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\azaksKubenetUdrFw-private.ps1";
                        azaksKubenetUdrFwprivate.StartInfo.UseShellExecute = true;
                        // azaksKubenetUdrFwprivate.StartInfo.RedirectStandardOutput = true;
                        azaksKubenetUdrFwprivate.Start();
                        // Console.WriteLine(azaksKubenetUdrFwprivate.StandardOutput.ReadToEnd());
                        azaksKubenetUdrFwprivate.WaitForExit();
                    }
                    else {
                        Console.WriteLine("Only Windows OS clients are supported");
                    }
                }
                break;

                case "3": {
                    if (os.Contains("Windows")){
                        // Run aksAzureCniUdrFw.ps1     
                        using Process azaksAzureCniUdrFw = new();
                        azaksAzureCniUdrFw.StartInfo.FileName = "powershell";
                        azaksAzureCniUdrFw.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\aksAzureCniUdrFw.ps1";
                        azaksAzureCniUdrFw.StartInfo.UseShellExecute = true;
                        // azaksAzureCniUdrFw.StartInfo.RedirectStandardOutput = true;
                        azaksAzureCniUdrFw.Start();
                        // Console.WriteLine(azaksAzureCniUdrFw.StandardOutput.ReadToEnd());
                        azaksAzureCniUdrFw.WaitForExit();
                    }
                    else {
                        Console.WriteLine("Only Windows OS clients are supported");
                    }
                }
                break;

                case "4": {
                    if (os.Contains("Windows")){
                        // Run aksAzureCniUdrFw-private.ps1     
                        using Process azaksAzureCniUdrFwprivate = new();
                        azaksAzureCniUdrFwprivate.StartInfo.FileName = "powershell";
                        azaksAzureCniUdrFwprivate.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\aksAzureCniUdrFw-private.ps1";
                        azaksAzureCniUdrFwprivate.StartInfo.UseShellExecute = true;
                        // azaksAzureCniUdrFwprivate.StartInfo.RedirectStandardOutput = true;
                        azaksAzureCniUdrFwprivate.Start();
                        // Console.WriteLine(azaksAzureCniUdrFwprivate.StandardOutput.ReadToEnd());
                        azaksAzureCniUdrFwprivate.WaitForExit();
                    }
                    else {
                        Console.WriteLine("Only Windows OS clients are supported");
                    }
                }
                break;

                default:
                Console.WriteLine("Invalid entry. Try again.");
                break;

            }
            Thread.Sleep(2000);
        }
        break;

        case "5": {
            Console.Clear();
            string[] scenARC = new string[4];
            scenARC[0]=" 1. aksArc";
            scenARC[1]=" 2. aksArcAppServiceExt";
            scenARC[2]=" 3. aksArcAppServiceExtWebApp";
            scenARC[3]=" 4. upstreamKubernetes";

            string [] scenARCDescription = new string[4];
            scenARCDescription[0]="Basic AKS cluster onboarded to Azure Arc";
            scenARCDescription[1]="Basic AKS cluster onboarded to Azure Arc with the AppService extension";
            scenARCDescription[2]="Basic AKS cluster onboarded to Azure Arc with the AppService extension and webapp on it";
            scenARCDescription[3]="Basic upstream Kubernetes cluster on Azure VMs";

            Console.WriteLine("The available AKS scenarios are the following:");

            // Print the scenarios and their description in a 2-column format
            foreach (string scenario in scenARC){
                Thread.Sleep(100);
                switch (scenario){

                    case " 1. aksArc":
                    Console.WriteLine($"{scenario}\t\t\t{scenARCDescription[0]}");
                    break;

                    case " 2. aksArcAppServiceExt":
                    Console.WriteLine($"{scenario}\t\t{scenARCDescription[1]}");
                    break;

                    case " 3. aksArcAppServiceExtWebApp":
                    Console.WriteLine($"{scenario}\t{scenARCDescription[2]}");
                    break;

                    case " 4. upstreamKubernetes-infraOnly":
                    Console.WriteLine($"{scenario}\t\t{scenARCDescription[3]}"); 
                    break;

                    default:
                    Console.WriteLine(""); break;

                }
            }

            Console.Write("Enter your selection number: ");
            string? scenarioARC = Console.ReadLine();

            switch (scenarioARC){

                case "1": {
                    if (os.Contains("Windows")){
                        // Run aksArc.ps1        
                        using Process aksArc = new();
                        aksArc.StartInfo.FileName = "powershell";
                        aksArc.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\aksArc.ps1";
                        aksArc.StartInfo.UseShellExecute = true;
                        // aksArc.StartInfo.RedirectStandardOutput = true;
                        aksArc.Start();
                        // Console.WriteLine(aksArc.StandardOutput.ReadToEnd());
                        aksArc.WaitForExit();
                    }
                    else {
                        Console.WriteLine("Only Windows OS clients are supported");
                    }
                }
                break;

                case "2": {

                    if (os.Contains("Windows")){
                        // Run aksArcAppServiceExt.ps1        
                        using Process aksArcAppServiceExt = new();
                        aksArcAppServiceExt.StartInfo.FileName = "powershell";
                        aksArcAppServiceExt.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\aksArcAppServiceExt.ps1";
                        aksArcAppServiceExt.StartInfo.UseShellExecute = true;
                        // aksArcAppServiceExt.StartInfo.RedirectStandardOutput = true;
                        aksArcAppServiceExt.Start();
                        // Console.WriteLine(aksArcAppServiceExt.StandardOutput.ReadToEnd());
                        aksArcAppServiceExt.WaitForExit();
                    }
                    else {
                        Console.WriteLine("Only Windows OS clients are supported");
                    }
                }
                break;

                case "3": {

                    if (os.Contains("Windows")){
                        // Run aksArcAppServiceExtWebApp.ps1     
                        using Process aksArcAppServiceExtWebApp = new();
                        aksArcAppServiceExtWebApp.StartInfo.FileName = "powershell";
                        aksArcAppServiceExtWebApp.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\aksArcAppServiceExtWebApp.ps1";
                        aksArcAppServiceExtWebApp.StartInfo.UseShellExecute = true;
                        // aksArcAppServiceExtWebApp.StartInfo.RedirectStandardOutput = true;
                        aksArcAppServiceExtWebApp.Start();
                        // Console.WriteLine(aksArcAppServiceExtWebApp.StandardOutput.ReadToEnd());
                        aksArcAppServiceExtWebApp.WaitForExit();
                    }
                    else {
                        Console.WriteLine("Only Windows OS clients are supported");
                    }                }
                break;

                case "4": {
                    if (os.Contains("Windows")){
                        // Run upstreamKubernetes.ps1     
                        using Process upstreamKubernetes = new();
                        upstreamKubernetes.StartInfo.FileName = "powershell";
                        upstreamKubernetes.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\upstreamKubernetes-infra.ps1";
                        upstreamKubernetes.StartInfo.UseShellExecute = true;
                        // upstreamKubernetes.StartInfo.RedirectStandardOutput = true;
                        upstreamKubernetes.Start();
                        // Console.WriteLine(upstreamKubernetes.StandardOutput.ReadToEnd());
                        upstreamKubernetes.WaitForExit();
                    }
                    else {
                        Console.WriteLine("Only Windows OS clients are supported");
                    }                }
                break;

                default:
                Console.WriteLine("Invalid entry. Try again.");
                break;

            }

            Thread.Sleep(2000);
        }
        break;

        case "6": {
            
            if (os.Contains("Windows")){
                // Run azgroup-delete.ps1        
                using Process azgroupdelete = new();
                azgroupdelete.StartInfo.FileName = "powershell";
                azgroupdelete.StartInfo.Arguments = @"-File C:\azrez\pwshjobs\\azgroup-delete.ps1";
                azgroupdelete.StartInfo.UseShellExecute = true;
                // azgroupdelete.StartInfo.RedirectStandardOutput = true;
                azgroupdelete.Start();
                // Console.WriteLine(azgroupdelete.StandardOutput.ReadToEnd());
                azgroupdelete.WaitForExit();
            }
            else {
                Console.WriteLine("Only Windows OS clients are supported");
            }
            Thread.Sleep(2000);
        }
        break;

        default: {
        Console.WriteLine("Bye :)");
        }
        break;
    }
} while (menuSelection != "exit");