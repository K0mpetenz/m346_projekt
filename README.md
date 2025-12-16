# Nextcloud – Automatisierte Cloud-Installation

Dieses Repository enthält die Projektarbeit aus dem Modul 346.
Ziel des Projekts war es, Nextcloud in einer Cloud-Umgebung zu installieren und die Installation möglichst zu automatisieren.

---

## Projektidee

Nextcloud wird auf zwei Servern betrieben:
- **Webserver**: Apache, PHP und Nextcloud
- **Datenbankserver**: MariaDB

Die Installation und Grundkonfiguration erfolgen über Skripte, damit der Service reproduzierbar aufgesetzt werden kann.

---

## Repository-Inhalt

| Datei | Beschreibung |
|------|-------------|
| `ec2_ini.sh` | Initialisierung des Webservers (Apache, PHP und Nextcloud) |
| `db_ini.txt` | Einrichtung der Datenbank |
| `nc_ini.txt` | Nextcloud-spezifische Konfiguration |
| `DokumentationLorinJANBEN.md` | Projektdokumentation inkl. Tests & Reflexion |
| `README.md` | Projektübersicht |

---

## Voraussetzungen

- AWS Account
- Zwei EC2-Instanzen (Webserver & Datenbankserver)
- Ubuntu Server
- SSH-Zugriff
- Git

---

## Installation (Kurzüberblick)

1. EC2-Instanzen erstellen (Webserver & Datenbankserver)
2. Datenbank-Skript auf dem DB-Server ausführen
3. Webserver-Skript auf dem Webserver ausführen
4. Nextcloud im Browser über die IP des Webservers aufrufen

---

## Aktueller Stand

Die Grundinstallation des Webservers und der Datenbank funktioniert.
Nextcloud lässt sich starten und aufrufen, jedoch ist die Installation **noch nicht vollständig automatisiert**.
Einzelne Schritte müssen aktuell manuell überprüft oder nachjustiert werden.

Das Projekt zeigt den geplanten Aufbau und die Automatisierungsidee, auch wenn die Umsetzung noch nicht in allen Punkten abgeschlossen ist.

---

## Tests

Folgende Tests wurden durchgeführt:
- Apache-Webserver läuft
- Datenbank ist erreichbar
- Verbindung zwischen Webserver und Datenbank wurde getestet
- Nextcloud-Weboberfläche ist erreichbar

---

## Team

- **Lorin Frei** – Dokumentation & Nextcloud
- **Ben Kälin** – AWS & Infrastruktur
- **Jan Dörig** – Datenbank

---

## Hinweis

Dieses Projekt dient zu Lernzwecken im Rahmen der Ausbildung und ist nicht für den produktiven Einsatz vorgesehen.
