# Windows 10 configuration for privacy

GPO generated from the (quite outdated) guide from ANSSI: [Restreindre la collecte de données sous Windows 10](https://www.ssi.gouv.fr/entreprise/guide/restreindre-la-collecte-de-donnees-sous-windows-10/).
GPO are exported as text to be easily examined.

# Applying the configuration

## Install Local Group Policy Editor (LGPO)
Download LGPO from the Microsoft Security Compliance Toolkit at https://www.microsoft.com/en-us/download/details.aspx?id=55319

## Importing the GPO

### Build a `registry.pol` from the LGPO text files
- Machine GPO
```
LGPO.exe /r [path]\machine.lgpo /w [path]\Machine\registry.pol
```
- User GPO
```
LGPO.exe /r [path]\user.lgpo /w [path]\User\registry.pol
```

### Apply the policies
- Apply machine GPO
```
LGPO.exe /m [path]\Machine\registry.pol
```
- Apply user GPO
```
LGPO.exe /u [path]\User\registry.pol
```

# Re-constructing the GPO files

Creating and exporting GPO from the ANSSI guide.

- Use the Local Group Policy Editor (`gpedit.msc`) to create the GPO from the ANSSI guide
- As an administrator, use the Local Group Policy Object Utility (`LGPO.exe`) to create a backup from the local policy
```
LGPO.exe /b "[path]\Export" /n ANSSI
```
- Export the backup to a text file (parsing the `registry.pol`)
  - Machine GPO
```
LGPO.exe /parse /m "[path]\Export\...\DomainSysvol\GPO\Machine\registry.pol" >machine.lgpo
```
  - User GPO
```
LGPO.exe /parse /u "[path]\Export\...\DomainSysvol\GPO\User\registry.pol" >user.lgpo
```