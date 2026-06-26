# PS-Modules (EduTeams / HelloID)

Helper functies voor PowerShell scripts binnen het EduTeams ecosysteem.

---

## 🚀 Wat is dit?

PS-Modules is een verzameling herbruikbare PowerShell functies die gebruikt worden binnen HelloID scripting voor EduTeams.

De module biedt gestandaardiseerde helpers voor o.a.:

- Logging
- Microsoft Graph interactie
- Teams en groepen beheer
- Foutafhandeling

---

## 🎯 Waarom bestaat dit?

HelloID scripts voor EduTeams bevatten vaak terugkerende logica zoals:

- Teams provisioning
- Entra ID groepen beheren
- Lifecycle (create, update, restore)

PS-Modules voorkomt duplicatie en zorgt voor:

- Consistent gedrag
- Betere onderhoudbaarheid
- Minder complexe scripts

---

## 🧠 Wanneer gebruik je dit?

Gebruik deze module als je:

- HelloID PowerShell scripts schrijft
- Werkt met EduTeams provisioning
- Consistente logging en foutafhandeling wilt
- Graph / Teams acties wilt standaardiseren

---

## ⚡ Quick start

```powershell
Import-Module PS-Modules

Write-Log "Start provisioning"

New-EduTeam -Name $teamName
```

## 📘 Meer achtergrond

Voor een bredere uitleg over EduTeams, architectuur en ontwerpkeuzes:

👉 [EduTeams artikelen op mysite.prjv.nl](https://mysite.prjv.nl/category/eduteam)

## 📖 Volledige documentatie

Zoek je een volledige functionele referentie van alle beschikbare functies:

👉 Zie [README_manual.md](./README_manual.md)