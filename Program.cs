// system session
using System;
using System.Diagnostics;

/////////////////////////////
// AZRESOURCELAUNCHER v1.0 //
/////////////////////////////

// windows-compatible version

Thread.Sleep(1000);

Console.WriteLine("Is it the first time you run this app in the current environment?");
Console.WriteLine("Would you like to do initial setup? (y/n)");
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
string line02 = Console.ReadLine();
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

if( line02=="y" ){
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
    else{
        Thread.Sleep(1000);
    }
    
Console.WriteLine("Choose flow");
Console.WriteLine("Basic or Scenarios");
#pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
string flow1 = Console.ReadLine();
#pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

if( (flow1=="Basic") || (flow1=="basic") ){
    // User is prompted to choose resource of interest
    Console.WriteLine("How can I help? Choose a resource from");
    Console.WriteLine("VM or AKS");
    #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
    string line03 = Console.ReadLine();
    #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

    // if VM, select OS version
    if( (line03=="VM") || (line03=="vm") ){
        Console.WriteLine("Which OS version? Choose from");
        Console.WriteLine("Ubuntu2204 Windows11 WindowsServer2022");
        #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
        string line04 = Console.ReadLine();
        #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

    /*
    switch (line04)
    {
        case "ubuntu":
        case "ubuntu2204";
        case "Ubuntu2204";
            // Run azvm-ubuntu2204ssh.ps1
            using Process winazvmubuntu2204ssh = new();
            winazvmubuntu2204ssh.StartInfo.FileName = "powershell";
            winazvmubuntu2204ssh.StartInfo.Arguments = ".\\pwshjobs\\azvm-ubuntu2204ssh.ps1";
            winazvmubuntu2204ssh.StartInfo.UseShellExecute = true;
            // winazvmubuntu2204ssh.StartInfo.RedirectStandardOutput = true;
            winazvmubuntu2204ssh.Start();
            // Console.WriteLine(azvmubuntu2204ssh.StandardOutput.ReadToEnd());
            winazvmubuntu2204ssh.WaitForExit();
            break;
        case "Windows11":
        case "windows11";
        case "windows";
            // Run azvm-windows11.ps1
            using Process winazvmwindows11 = new();
            winazvmwindows11.StartInfo.FileName = "powershell";
            winazvmwindows11.StartInfo.Arguments = ".\\pwshjobs\\azsvm-windows11.ps1";
            winazvmwindows11.StartInfo.UseShellExecute = true;
            // winazvmwindows11.StartInfo.RedirectStandardOutput = true;
            winazvmwindows11.Start();
            // Console.WriteLine(winazvmwindows11.StandardOutput.ReadToEnd());
            winazvmwindows11.WaitForExit();
            break;
        case "WindowsServer2022":
        case "WindowsServer":
        case "windowsserver";
            using Process winazvmwindowsserver2022 = new();
            winazvmwindowsserver2022.StartInfo.FileName = "powershell";
            winazvmwindowsserver2022.StartInfo.Arguments = ".\\pwshjobs\\azvm-windowsserver2022.ps1";
            winazvmwindowsserver2022.StartInfo.UseShellExecute = true;
            // winazvmwindowsserver2022.StartInfo.RedirectStandardOutput = true;
            winazvmwindowsserver2022.Start();
            // Console.WriteLine(winazvmwindowsserver2022.StandardOutput.ReadToEnd());
            winazvmwindowsserver2022.WaitForExit();
            break;
        default:
            Console.WriteLine("Invalid entry. Try again");
            break;
    }
    */


        // if Ubuntu2204
        if( (line04=="Ubuntu2204") || (line04=="ubuntu") || (line04=="ubuntu2204") ){
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
        // if Windows11
        else if( (line04=="windows11") || (line04=="Windows11") || (line04=="windows") ){
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
        // if WindowsServer2022
        else if( (line04=="WindowsServer2022") || (line04=="windowsserver") || (line04=="windowsserver2022") ){
            using Process winazvmwindowsserver2022 = new();
            winazvmwindowsserver2022.StartInfo.FileName = "powershell";
            winazvmwindowsserver2022.StartInfo.Arguments = ".\\pwshjobs\\azvm-windowsserver2022.ps1";
            winazvmwindowsserver2022.StartInfo.UseShellExecute = true;
            // winazvmwindowsserver2022.StartInfo.RedirectStandardOutput = true;
            winazvmwindowsserver2022.Start();
            // Console.WriteLine(winazvmwindowsserver2022.StandardOutput.ReadToEnd());
            winazvmwindowsserver2022.WaitForExit();
            }
            else{
                Console.WriteLine("Invalid entry. Try again");
            }
        }
    // if AKS, select Networking Options
    else if( (line03=="AKS") || (line03=="aks") ){
        Console.WriteLine("Please select AKS networking options. Choose from");
        Console.WriteLine("kubenet or azurecni");
        #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
        string line05 = Console.ReadLine();
        #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

        // kubenet or azurecni
        // if kubenet,
        if( line05=="kubenet" ){
            // select if loadbalancer or udr
            Console.WriteLine("Please select the outbound type. Choose from");
            Console.WriteLine("loadbalancer or udr");
            #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string line06 = Console.ReadLine();
            #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

            // if loadbalancer
            if( (line06=="loadbalancer") || (line06=="lb") ){
                // Run azaks-public-kubenet-lb.ps1
                using Process winazakspublickubenetlb = new();
                winazakspublickubenetlb.StartInfo.FileName = "powershell";
                winazakspublickubenetlb.StartInfo.Arguments = ".\\pwshjobs\\azaks-public-kubenet-lb.ps1";
                winazakspublickubenetlb.StartInfo.UseShellExecute = true;
                // winazakspublickubenetlb.StartInfo.RedirectStandardOutput = true;
                winazakspublickubenetlb.Start();
                // Console.WriteLine(winazakspublickubenetlb.StandardOutput.ReadToEnd());
                winazakspublickubenetlb.WaitForExit();

                Thread.Sleep(1000);
            }
                // if udr
                else if( (line06=="udr") || (line06=="userdefinedroutes") ){
                    // Run azaks-public-kubenet-udr.ps1
                    using Process winazakspublickubenetudr = new();
                    winazakspublickubenetudr.StartInfo.FileName = "powershell";
                    winazakspublickubenetudr.StartInfo.Arguments = ".\\pwshjobs\\azaks-public-kubenet-udr.ps1";
                    winazakspublickubenetudr.StartInfo.UseShellExecute = true;
                    // winazakspublickubenetudr.StartInfo.RedirectStandardOutput = true;
                    winazakspublickubenetudr.Start();
                    // Console.WriteLine(winazakspublickubenetudr.StandardOutput.ReadToEnd());
                    winazakspublickubenetudr.WaitForExit();
                    Thread.Sleep(1000);
                }
                else{
                    Console.WriteLine("Invalid entry. Try again");
                }
            }
        // if azurecni
        // select if loadbalancer or udr
        else if( (line05=="azurecni") || (line05=="azure") || (line05=="AzureCNI") ){

            Console.WriteLine("Please select the outbound type. Choose from"); Console.WriteLine("loadbalancer or udr");
            #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
            string line07 = Console.ReadLine();
            #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.

            // if loadbalancer
            if( (line07=="loadbalancer") || (line07=="lb") ){
                // Run azaks-public-azurecni-lb.ps1
                using Process winazakspublicazurecnilb = new();
                winazakspublicazurecnilb.StartInfo.FileName = "powershell";
                winazakspublicazurecnilb.StartInfo.Arguments = ".\\pwshjobs\\azaks-public-azurecni-lb.ps1";
                winazakspublicazurecnilb.StartInfo.UseShellExecute = true;
                // winazakspublicazurecnilb.StartInfo.RedirectStandardOutput = true;
                winazakspublicazurecnilb.Start();
                // Console.WriteLine(winazakspublicazurecnilb.StandardOutput.ReadToEnd());
                winazakspublicazurecnilb.WaitForExit();
                Thread.Sleep(1000);
            }
                // if udr
            else if( (line07=="udr") || (line07=="userdefinedrouting") ){
                // Run azaks-public-azurecni-udr.ps1
                using Process winazakspublicazurecniudr = new();
                winazakspublicazurecniudr.StartInfo.FileName = "powershell";
                winazakspublicazurecniudr.StartInfo.Arguments = ".\\pwshjobs\\azaks-public-azurecni-udr.ps1";
                winazakspublicazurecniudr.StartInfo.UseShellExecute = true;
                // winazakspublicazurecniudr.StartInfo.RedirectStandardOutput = true;
                winazakspublicazurecniudr.Start();
                // Console.WriteLine(winazakspublicazurecniudr.StandardOutput.ReadToEnd());
                winazakspublicazurecniudr.WaitForExit();
                Thread.Sleep(1000);
            }
            else{
                Console.WriteLine("Invalid entry. Try again");
            }
        }
        else{
            Console.WriteLine("Invalid entry. Try again");
        }
    }
    else{
        Console.WriteLine("Invalid entry. Try again");
    }
}
else if( (flow1=="Scenarios") || (flow1=="scenarios") ){

/*
    // Console.WriteLine("This section is with work in progress...");
    Console.WriteLine(" ");
    Console.WriteLine("Choose from the scenarios below:");
    Console.WriteLine(" ");
    Console.WriteLine("aksKubenetUdrFw");
    Console.Write(" -> AKS cluster with kubenet CNI and userDefinedRouting outbound type via Azure Firewall");
    Console.WriteLine(" ");Console.WriteLine(" ");

    Console.WriteLine("aksKubenetUdrFw-private");
    Console.Write(" -> Private AKS cluster with kubenet CNI and userDefinedRouting outbound type via Azure Firewall");

    Console.WriteLine(" ");Console.WriteLine(" ");

    Console.WriteLine("aksAzureCniUdrFw");
    Console.Write(" -> AKS cluster with azure CNI and userDefinedRouting outbound type via Azure Firewall");

    Console.WriteLine(" ");Console.WriteLine(" ");

    Console.WriteLine("aksAzureCniUdrFw-private");
    Console.Write(" -> Private AKS cluster with azure CNI and userDefinedRouting outbound type via Azure Firewall");

    Console.WriteLine(" ");Console.WriteLine(" ");

*/
    string[] winScenario = new string[4];
    winScenario[0]="aksKubenetUdrFw";
    winScenario[1]="aksKubenetUdrFw-private";
    winScenario[2]="aksAzureCniUdrFw";
    winScenario[3]="aksAzureCniUdrFw-private";

    string [] winScenarioDescription = new string[4];
    winScenarioDescription[0]="AKS cluster with kubenet CNI and userDefinedRouting outbound type via Azure Firewall";
    winScenarioDescription[1]="Private AKS cluster with kubenet CNI and userDefinedRouting outbound type via Azure Firewall";
    winScenarioDescription[2]="AKS cluster with azure CNI and userDefinedRouting outbound type via Azure Firewall";
    winScenarioDescription[3]="Private AKS cluster with azure CNI and userDefinedRouting outbound type via Azure Firewall";

    // Print the scenarios and their description in a 2-column format
    foreach (string scenario in winScenario){
        Thread.Sleep(200);
        if (scenario == "aksKubenetUdrFw"){
            Console.WriteLine($"{scenario}\t\t\t{winScenarioDescription[0]}");
        }
        else if (scenario == "aksKubenetUdrFw-private"){
            Console.WriteLine($"{scenario}\t\t{winScenarioDescription[1]}");
        }
        else if (scenario == "aksAzureCniUdrFw"){
            Console.WriteLine($"{scenario}\t\t{winScenarioDescription[2]}");
        }
        else if(scenario == "aksAzureCniUdrFw-private"){
            Console.WriteLine($"{scenario}\t{winScenarioDescription[3]}");           
        }
        else {
            Console.WriteLine ("");
        }
    }

    Console.WriteLine("What will it be?");
    #pragma warning disable CS8600 // Converting null literal or possible null value to non-nullable type.
    string scen1 = Console.ReadLine();
    #pragma warning restore CS8600 // Converting null literal or possible null value to non-nullable type.
        
    if( scen1=="aksKubenetUdrFw" ){
        // Run azaksKubenetUdrFw.ps1        
        using Process azaksKubenetUdrFw = new();
        azaksKubenetUdrFw.StartInfo.FileName = "powershell";
        azaksKubenetUdrFw.StartInfo.Arguments = ".\\pwshjobs\\azaksKubenetUdrFw.ps1";
        azaksKubenetUdrFw.StartInfo.UseShellExecute = true;
        // azaksKubenetUdrFw.StartInfo.RedirectStandardOutput = true;
        azaksKubenetUdrFw.Start();
        // Console.WriteLine(azaksKubenetUdrFw.StandardOutput.ReadToEnd());
        azaksKubenetUdrFw.WaitForExit();
    }
    else if( (scen1=="aksKubenetUdrFw-private") || (scen1=="aksKubenetUdrFwprivate") ){
        // Run azaksKubenetUdrFw-private.ps1        
        using Process aksKubenetUdrFwprivate = new();
        aksKubenetUdrFwprivate.StartInfo.FileName = "powershell";
        aksKubenetUdrFwprivate.StartInfo.Arguments = ".\\pwshjobs\\azaksKubenetUdrFw-private.ps1";
        aksKubenetUdrFwprivate.StartInfo.UseShellExecute = true;
        // aksKubenetUdrFwprivate.StartInfo.RedirectStandardOutput = true;
        aksKubenetUdrFwprivate.Start();
        // Console.WriteLine(aksKubenetUdrFwprivate.StandardOutput.ReadToEnd());
        aksKubenetUdrFwprivate.WaitForExit();
    }
    else if( scen1=="aksAzureCniUdrFw" ){
        // Run aksAzureCniUdrFw.ps1        
        using Process aksAzureCniUdrFw = new();
        aksAzureCniUdrFw.StartInfo.FileName = "powershell";
        aksAzureCniUdrFw.StartInfo.Arguments = ".\\pwshjobs\\aksAzureCniUdrFw.ps1";
        aksAzureCniUdrFw.StartInfo.UseShellExecute = true;
        // aksAzureCniUdrFw.StartInfo.RedirectStandardOutput = true;
        aksAzureCniUdrFw.Start();
        // Console.WriteLine(aksAzureCniUdrFw.StandardOutput.ReadToEnd());
        aksAzureCniUdrFw.WaitForExit();
    }
    else if( (scen1=="aksAzureCniUdrFw-private") || (scen1=="aksAzureCniUdrFwprivate") ){
        // Run aksAzureCniUdrFw-private.ps1        
        using Process aksAzureCniUdrFwprivate = new();
        aksAzureCniUdrFwprivate.StartInfo.FileName = "powershell";
        aksAzureCniUdrFwprivate.StartInfo.Arguments = ".\\pwshjobs\\aksAzureCniUdrFw-private.ps1";
        aksAzureCniUdrFwprivate.StartInfo.UseShellExecute = true;
        // aksAzureCniUdrFw-private.StartInfo.RedirectStandardOutput = true;
        aksAzureCniUdrFwprivate.Start();
        // Console.WriteLine(aksAzureCniUdrFw-private.StandardOutput.ReadToEnd());
        aksAzureCniUdrFwprivate.WaitForExit();
    }
    else {
        Console.WriteLine("Invalid entry. Try again");
    }
}
else{
    Console.WriteLine("Invalid entry. Try again");
}

// The following line causes CS1009.  
//    string filename = "c:\myFolder\myFile.txt";
      // Try one of the following lines instead.  
      // string filename = "c:\\myFolder\\myFile.txt";  
      // string filename = @"c:\myFolder\myFile.txt";  