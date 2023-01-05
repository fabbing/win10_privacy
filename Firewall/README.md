# Windows Firewall configuration and hardening

The firewall is set to block outgoing connections by default.

Blocking Windows services using the firewall rules being (purposely?) broken, a trick is used to achieve it.
`svchost.exe` outgoing connections  are disabled in the firewall, and a hardlink `svchost-net.exe` is created for `svchost.exe`. 
Windows services granted network permission are to be reconfigured to use the `svchost-net.exe` rather than `svchost.exe`, and a rule allowing (some) outgoing connection to `svchost-net.exe` is added to the firewall.
Reconfiguring Windows services is necessary after updated are applied reseting services configuration.

## Create svchost.exe hardlink
As an administrator:
```
powershell.exe -ExecutionPolicy ByPass .\create_svchost_hardlink.ps1
```

## Reconfiguring Windows Update services
```
powershell.exe -ExecutionPolicy ByPass .\fw-win-update.ps1
```


# Protecting the firewall configuration

The firewall configuration is achieved using the standard interface and exported as GPO.
The GPO is imported, and local rules evaluation is disabled to protect against applications	thinking it's tolerated to add their own rule to the firewall.

## Configuration
- Start the Microsoft Management Console (`mmc`)
  - Add the Windows Defender Firewall snap-in
- Configure the firewall
  - Windows Defender Firewall Properties > {Domain,Private,Public} > Outbound connections > Block
  - Disable irrelevant inbound rules
  - Disable irrelevant outbound rules
  - Add an outbound rule for `svchost-net.exe` (`%SystemRoot%\System32\svchost-net.exe`)
- Action > Export Policy

## Importing the Firewall policy as GPO
- Open the Local Group Policy Editor (`gpedit.msc`)
- Computer Configuration > Windows Settings > Security Settings > Windows Defender Firewall
- Action > Import Policy
- Protect the rules against local modifications
  - Windows Defender Firewall Properties > {Domain,Private,Public} > Settings
  - Apply local firewall rules: No
  - Apply local connection security rules: No

Further rules have to be created directly through the Group Policy Editor.